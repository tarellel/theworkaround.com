---
layout: post
title: "Enhancing SSH Security"
date: 2016-11-11 21-11-22
description: ""
tags: [security, ssh, terminal]
comments: false
---
With the whole security/privacy revolution rolling throughout the internet, it has recently come to my attention
that specific services are being heavily focused on, while others are completely neglected.
When securing your server and it's services you need to attempt to secure the whole stack rather than a few specific services.
For example lets take a look at web servers, they're full of new ideas and
technology, innovative, and always changing. And recently the world was recently introduced to [Lets Encrypt](https://letsencrypt.org/)
which makes them and your data a magnitude of times more secure using HTTPS (when properly configured).

Another very important service that I'd like you to really think about is SSH.
It's another service that we use for tons of uses, but you don't think "Does it need secured",
because everyone automatically seems to assume that it's hardened by default.
But in my own words, I'd say "It's easy to use by default, but not necessarily ready for use".

I'm going to assume you've already hardened your SSH config with the basic settings (disable root login, AllowUsers, AllowGroups, MaxRetries, Fail2ban, LoginGraceTime, etc.) There's tons of variable configurations to setup, one place I would suggest starting at would be [Securing and Optimizing Linux](http://tldp.org/LDP/solrhe/Securing-Optimizing-Linux-RH-Edition-v1.3/chap15sec122.html) to get a basic configuration setup.

Now lets get to the main topic of this post, enhanced security.
Lately, I’ve seen quite a bit of talk suggesting everyone disable password
authentication and only using key and/or certificate encryptions to secure SSH connections.
I mean, really how probable is it that someone will be able to generate your exact ssh-key similar to the one below?

```shell
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4MCqOxhfmNP/uv8sl5EYSIqQSGuV4v17B50xMWXMcwTJrriOi9W6nNfxF8wu/i2HB1/nUUuSu+ZxQdYaD2cRkelzSGcq191z+b8lNY2lz+bxB547H465U5EQPlxJ5w7WU6QOV1hrZ7quWh/GYrDnU1aZrhEQ++EV5chQIUxoP3YgBSSb8D5Bpns9gR0IZVtlEqhF8eyCypZSiyKumQxK8e/W8Y8iHWCtRfvZbh+bnemCkHrXI/xc+CuCY9TQmWZkwFfTRBJQo3pmoRSZAZpqwYSl1kySrasw771rfy2rowFiCogkBYu2W9FTR2kMwB4btBrpA4Af97AjxwzkHyXUt sample_user@gmail.com
```

Well, lets take a look how vulnerable your keys actually are.
If you're like the vast majority of developers just using a `id_rsa.pub` or `id_dsa.pub` key for the vast majority of your logins and connections, than you may already be an easy target. You may be asking, how and why? Well let's take a look at some keys people use with github.
If for example you use Github, or a number of services your public key is already out in the open. This is mainly for system wide user verification purposes. For example lets take a moment to look at user [GrahamCampbell’s publickey](https://github.com/GrahamCampbell.keys), now is his key is available what about [everyone else's](https://gist.github.com/paulmillr/2657075/). If you still don't trust me try it out with your own profile/username [https://github.com/username.keys](https://github.com/username.keys). Now tell me, how many services do you actually user ur id_rsa key with? If your using this one key for DigitalOcean, GitHub, Google Cloud, AWS, your companies servers, your local NAS, vagrant/Docker and who knows what else, than your services are ready for the taking. Now the simple questions is: How can we fix this?
Well, to begin we can begin by using the [ssh_config](https://linux.die.net/man/5/ssh_config) file '~/.ssh/config'.
This allows us to assign the appropriate keys to be used when trying to access specific services/addresses.
This is part of the security method known as "security by obscurity", you reduce the amount of parameters an attacker can access
by making things more complicated. If someone managers to get ahold of one of your keys, they won't have access to every single web service you use.

An example of how of how you can specify ssh to connect to specific services:
```shell
Host github.com
  user sample_user
  HostName github.com
  IdentityFile ~/.ssh/github_rsa
  IdentitiesOnly yes

Host digitalocean.com
  HostName digitalocean.com
  IdentityFile ~/.ssh/digitalocean_key
  IdentitiesOnly yes

And the list goes on...
```

Another step in order to make things a bit more complicated is to add a password to your SSH-keys.

```shell
ssh-keygen -t rsa -q -N 'sample_password' -f ~/.ssh/sample_id -C "sample_user@gmail.com"
```

You probably know by now, that by adding a password to your keys can be a pain in the butt.
Because every time you connect to a service or do a push request, etc. it'll ask you for that crazy password you used `XL7pa5wnV/nQgUqi5mf7oQ6uG0hk5NwGh+5OYU+Mu6`. Well you can solve this by using a service such as [keychain](http://www.funtoo.org/Keychain) and/or using your ssh-agent with the [ssh-add](https://linux.die.net/man/1/ssh-add) command.
If configured properly, they require to only input the password once person login session.
So in other words, you won't have to re-input your crazy password until your next reboot.


### Newer Key types
Another very important thing to look as is your key encryption method if your still using id_dsa and/or id_rsa, please update to using [Ed25519](https://ed25519.cr.yp.to/) immediately. I admit, some services like GitHub and DigitalOcean may have issues when with this encryption type, but if your connecting to ssh I'd highly suggest it.
I'm no Cryptologist and I can't tell you how and why a shorter key is more secure, other than it uses Elliptic curve cryptography methods.
But at the moment ED25519 is the recommended standard and as we know the higher the bit length and more rounds we encrypt the key, the more secure it'll be.

```shell
ssh-keygen -o -a 100 -b 4096 -t ed25519 -q -f ~/.ssh/dev_key -N 'sample_password123' -C 'sample_user'

# ~/.ssh/dev_key
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCz0L+cnm3RSHawNK/h7hkCs7ZQIeeAyjKs4S+tHnPF sample_user
```


### Duel Method Authentication
Another enhancement you may wish to add to your SSH connections is requiring two forms of authentication.
This a technique in which you can also require a two methods of encryption in order to connect to the server (publickey and password).
In other words if a hacker “somehow” manages to get ahold of your publickey or your password, you’re server won’t be completely vulnerable to be victimized. Now let me warn you, this may cause issues with Capistrano, Ansible, Vagrant, or various other services.
Because the majority of them attempt to authenticate with the server by password or by publickey and not both.
But if that's not that case and you're really wanting to secure your SSH connections, this can be achieved with ease.
This is because we'll be using [PAM](https://www.kernel.org/pub/linux/libs/pam/whatispam.html) which should be fairly straight forward because most modern Linux installations have various PAM modules installed by default. This can be achieved by changing your AuthenticationMethods used in /etc/ssh/sshd_config to something similar to the following:

```config
AuthenticationMethods publickey,keyboard-interactive:pam
```

In other words, in order to connect the the specified server you will be required
to supply the proper publickey as well a valid password.
It also helps to enforce higher levels of encryption, using modern cyphers, and locking down specific users and/or groups.
If you're looking to properly secure your SSH server, I suggest you begin is by taking a very thorough look at Mozilla's [OpenSSH Guidelines](https://wiki.mozilla.org/Security/Guidelines/OpenSSH).

### Important
___Please note___ that the methods suggested for securing your SSH in this post
are not the only methods required in order to properly secure your SSH server.
They mostly consist of method to enhance existing security methods for your SSH connections.

### References
 - [Mozilla SSH Guidelines](https://wiki.mozilla.org/Security/Guidelines/OpenSSH)
