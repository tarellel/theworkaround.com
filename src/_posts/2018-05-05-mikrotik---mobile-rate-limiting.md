---
layout: post
title: "MikroTik - Mobile Rate-Limiting"
date: 2018-05-05 20-05-16
description: ""
tags: [mikrotik, networking, routers]
comments: true
---

![](/images/posts/mikrotik.png){: .img-fluid .w-3/12 }

### A Brief Intro
I've been using Mikrotik routers for about a year now and I've had nothing but an amazing experience thus far.
I haven't taken any of the [certification](https://mikrotik.com/training/) training courses (MTCNA, MTCRE, MTCWE) for the Mikrotik routers and thus far all my learning has been hands more of a hands on experience and following the RouterOS [documentation](https://wiki.mikrotik.com/wiki/Manual:TOC).

The main reason I got into was Mikrotik routers, was when I started at my current position a little over a year go I was expected to "make some magic happen". You see I work a nonprofit that occupies several buildings all interconnected, with the internet piped through a fiber line. I knew there was issues after my first couple of days, because they were using a consumer grade NetGear ([NightHawk x10](https://www.netgear.com/landings/ad7200/)) router to try and support everything. There's generally anywhere between 30-70 people in the building at any time; and considering everyone has a laptop or 2, a VoIP Phone, a cellphone, some have PC's, and some people even have various smart devices connected as well. This was by far, way to many devices for the basic hone grade router to manage. And the network congestion was terrible; calls were always dropping, active IP addresses were being reassigned, your Upload and Download rates were absolutely terrible.

I has never seen anything like it and I was definitely out of my scope of knowledge. I'm a web developer, not a networking administrator. But this issue with working at a nonprofit if options are limited and as the IT guy I'm expected to solve a large amount of issues at any given time. To help resolve this issue I contacted an acquaintance of mine manages the networking infrastructure of a chain of convenience stores, rest stores, and office buildings within the area.

He recommended I use MikroTik routers because their cheap, highly efficient, easy to learn, and you don't have to pay any crazy licensing fees. So my first introduction to the router was jumping straight into using out of the [CCR1016-12G](https://mikrotik.com/product/CCR1016-12G) Cloud-Core Router. And I've have had nothing but excellent results with it, thus far.

-----

### Now To the Issue
Across the facility here are is a large number of devices assigned static IP addresses; ie. printers, VoIP phones, and several special purpose devices. Now we always have people coming from all over for meetings, training, consultation, etc. So in any one day you may have a few hundred devices connect to the network. And having a huge wireless network with a plethora of devices always connecting to the network can be a nightmare. To ensure a quality network experience, I reduced DHCP lifespans to 10 minutes this removes devices from the DHCP table after a short amount of time. I also setup a rollover subnet, so when the basic subnet chain was full it starts assigning IP addresses to a secondary subnet. I also have a default rate-limit (Queues) for when a new device connects to the network.

Now one of the biggest issues we have is people using a ton of bandwidth on social media. Part of the problem is; we have several people who do marketing, advertising, and outreach across various social media mediums including but not limited to facebook, twitter, youtube, and few others. But we all known, people like to stream videos, baseball games, concerts, and tons of high bandwidth streams with their phones when visiting these sites.

To counter this, I decided it'd be a good idea to specifically rate-limit/set Queue speeds for mobile devices. This isn't a fool proof method, but it does tend to catch about 99% of all mobile devices that connect to the network. It compares the devices $hostname to a regular expression list of mobile device manufacturers.
To setup up the regular expression you goto: IP>Firewall> [Tab] layer7 Protocols, you'll than create a new Firewall L7 protocol and label it `mobileDevices` with the following regex.
```javascript
^.*(android|ANDROID|AppleWatch|BLACKBERRY|Galaxy|HTC|Huaweu|iPhone|iPhne|Moto|SAMSUNG|Xperia).*$
```

You'll now create a scheduler by going to System>Scheduler and clicking the blue plus button. I went conservatively assigned it to loop through every 5 minutes, if you're in a pretty busy office I'd say you may even want to do 2 minute intervals. I'd also say part of this script is unnecessary, but I decided to reassign the queue limits to non mobile devices just for secondary measures. And the second loop in the script is because I have various VIP devices that need higher bandwidth limits than the rest of the network. So they are specifically assigned static IP address with their queue limits. Like I said, about half this script isn't necessary, but I implemented it in just to take precautions.

```javascript
/queue simple remove [/queue simple find]
:global layer7 [/ ip firewall layer7-protocol find name="mobileDevices"]
:global mobileDevices [/ ip firewall layer7-protocol get $layer7 regexp]
:global mobileLimit "1024k/1024k"
:global pcLimit "3M/5M"
// if the specified device's IP address is being assigned with DHCP
:foreach i in=[/ip dhcp-server lease find dynamic=yes] do={
  :local ipAddr [/ip dhcp-server lease get $i address];
  :local hostname [/ip dhcp-server lease get $i host-name];
  :local macAddress [/ip dhcp-server lease get $i mac-address]
  :local queueName "Client - $macAddress"

  :if ($hostname ~ $mobileDevices= true) do={
    // if the device has been found to be a mobile device, reduce it's bandwidth - $mobileLimit
    /queue simple add name="$queueName" comment="$hostname" target="$ipAddr" max-limit="$mobileLimit"
  } else={
    // otherwise set the devices bandwidth limits to the default bandwidth limits - $pcLimit
    /queue simple add name="$queueName" comment="$hostname" target="$ipAddr" max-limit="$pcLimit"
  }
}

// If device is connected with a static IP address or not using DHCP to assign it's IP
:foreach i in=[/ip dhcp-server lease find dynamic=no] do={
  :local ipAddr [/ip dhcp-server lease get $i address];
  :local hostname [/ip dhcp-server lease get $i host-name];
  :local macAddress [/ip dhcp-server lease get $i mac-address]
  :local queueName "Client - $macAddress"
  :local vipLimit "10M/10M"

  // hostnames for VIP devices in which to have a high bandwidth limit - $vipLimit
  :if ($hostname = "VIPdesktops" || $hostname = "VIPlaptops" || $hostname = "VIPdevice") do={
    /queue simple add name="$queueName" comment="$hostname" target="$ipAddr" max-limit="$vipLimit"
  } else={
    // otherwise set the devices bandwidth limits to the default bandwidth limits - $pcLimit
    /queue simple add name="$queueName" comment="$hostname" target="$ipAddr" max-limit="$pcLimit"
  }
}
```

This isn't a fool proof method, but it does catch the vast majority of mobile devices. This is because by default their devices are labeled with their specific manufacturer as part of the device name. And for the most rarely does anyone ever rename their devices hostname. While watching the network traffic, I can say I've only saw a handful of mobile devices that haven't been labeled with either Samsung, Iphone, or Galaxy.

~ **Note:** This may not be the best or the most effective script for what I wanted to achieve, but it accomplished what I needed to do. And it's been tested and proven to work effectively for exactly what I needed.

##### UPDATED: <small class="text-muted">5/31/18</small>
After updating our Routers' packages and routerboad to v6.42.3, I begun having issues with the script showing above.
So I removed the Layer7 and revamped the script to use it hostname matches through a variable string. The new revision appears to run a bit faster than the previous version and in my opinion, it seems to be a bit easier to read.

```javascript
/queue simple remove [/queue simple find]
:global mobileDevices "android|ANDROID|AppleWatch|BLACKBERRY|Galaxy|HTC|Huawei|iPad|iPhone|iphone|iPhne|Moto|SAMSUNG|Unknown|Xperia"
:global mobileLimit "1024k/1024k"
:global pcLimit "2M/5M"

:global vipDevices "VIPdesktops|VIPlaptops|VIPdevice|VIPservers|MikroTik|CapAC"
:global vipLimit "10M/10M"

/ip dhcp-server lease {
  :foreach i in=[find (dynamic && status="bound")] do={
    :local activeAddress [get $i active-address]
    :local activeMacAddress [get $i active-mac-address]
    :local macAddress [get $i mac-address]
    :local hostname [get $i host-name]
    :local ipAddr [get $i address]
    :local queueName "Client - $macAddress"

    :if ($hostname ~ $mobileDevices= true) do={
      /queue simple add name="$queueName" comment="$hostname" target="$ipAddr" max-limit="$mobileLimit"
    } else={
      /queue simple add name="$queueName" comment="$hostname" target="$ipAddr" max-limit="$pcLimit"
    }
  }

  :foreach i in=[find (!dynamic && status="bound")] do={
    :local activeAddress [get $i active-address]
    :local activeMacAddress [get $i active-mac-address]
    :local macAddress [get $i mac-address]
    :local hostname [get $i host-name]
    :local ipAddr [get $i address]
    :local queueName "Client - $macAddress"

   :if ($hostname ~ $vipDevices= true) do={
     /queue simple add name="$queueName" comment="$hostname" target="$ipAddr" max-limit="$vipLimit"
   } else={
     /queue simple add name="$queueName" comment="$hostname" target="$ipAddr" max-limit="$pcLimit"
   }
  }
}
```
