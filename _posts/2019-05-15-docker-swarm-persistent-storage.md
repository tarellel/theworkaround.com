---
layout: post
title: "Docker Swarm Persistent Storage"
date: 2019-05-15 19-05-33
description: "Docker-swarm persistent storage using glusterFS (a network filesystem)"
tags: [docker, docker-swarm, gluster, linux]
comments: false
---
Unless you've been living under a rock, you should need no explanation what [Docker](https://www.docker.com/) is.
Using Docker over the last year has drastically improved my deployment ease and with coupled with [GitLab's](https://about.gitlab.com/) CI/CD has made deployment extremely ease. Mind you, not all our applications being deployed have the same requirements, some are extremely simple and others are extraordinarily complex.
So when we start a new project we have a base docker build to begin from and based on the applications requirements we add/remove as needed.

### A little about Docker Swarm

For the large majority of most of our applications, having a volume associated with the deployed containers and storing information is the database fits the applications needs.

In front of all our applications we used to use [Docker Flow Proxy](https://proxy.dockerflow.com/) to quickly integrate our application into our deployed environment and assign it a subdomain based on it's service. For a few months we experienced issues with the proxy hanging up, resources not being cleared, and lots of dropped connections. Since than I have rebuilt our docker infrastructure and now we use [Traefik](https://traefik.io/) for our proxy routing and it has been absolutely amazing! It's extremely fast, very robust and extensible, and easy to manipulate to fit your needs. Heck before even deploying it I was using [docker-compose](https://docs.docker.com/compose/) to  build a local network proxy to ensure it was what we needed. While Traefik was running in compose I was hitting domains such as `http://whoami.localhost/` and this was a great way to learn the basic configuration before pushing it into a staging/production swarm environment. _(That explaing how we got started with Traefik is a whole other post of it's own.)_

Now back to our docker swarm, I know the big thing right now is [Kubernetes](https://kubernetes.io/). But every organization has their specific needs, for their different environments, application, types, and deployment mechanisms. In my opinion the current docker environment we've got running right now is pretty robust. We've got dozens of nodes, a number of deployment environments (cybersec, staging, and production), dozens of applications running at once, and some of then requiring a number of services in order to function properly.

A few of the things that won me over on the docker swarm in the first place is it's load balancing capabilities, it's very fault-tolerant, and the self-healing mechanism that it uses in case a container crashes, a node locks up or drops, or a number of other issues.
_(We've had a number of servers go down due to networking issues or a rack server crapping out and with the docker swarm running you could never even tel we were having issues as an end user to our applications.)_

_(Below is an image showing traffic hitting the swarm. If you have an application replicated upon deployment, traffic will be distributed amongst the nodes to prevent bottle necks.)_{: .small }

![Docker Swarm Traffic](/img/posts/docker-swarm-persistent-storage/SwarmTraffic.svg){: .img-fluid }

### Why would you need persistent storage?

Since the majority of our applications are data orientated, (with most of them hitting several databases in a single request) we hadn't really had to worry about persistent storage.
This is because once we deployed the applications; their volumes held all of their required assets and any data they needed was fetched from the database.

The easiest way to explain volumes, is when a container is deployed to a node (if specified) it will put aside a section of storage specifically for that container.
For example say we have an application called DogTracker the was deployed on node A and B.
This application can create and store files in their volumes on those nodes.
But what happens when there's an issue with the container on node A and the container cycles to node C?
The data created by the container is left in the volume on node A an no longer available, until that applications container cycles back to node A.

And from this arises the problem we began to face. We were starting to develop applications that were starting to require files to be shared amongst each other.
We also have numerous applications that require files to be saved and distributed without them being dumped into the database as a blob.
And these files were required to be available without cycling volumes and/or dumping them into the containers during build time.
And because of this, we needed to be able to have some form of persistent and distributed file storage across our containers.


_(Below is an image showing how a docker swarms volumes are oriented)_{: .small }

![Docker Swarm Diagram](/img/posts/docker-swarm-persistent-storage/DockerSwarm.svg){: .img-fluid }

### How we got around this!

Now in this day an age there's got to be ways to get around this.
There's at least 101 ways to do just about anything and it doesn't always have to be newest shiniest toy everyone's using.
I know saying this while using Docker is kind of a hypocritical statement, but shared file systems have been around for decades.
You've been able to mount network drives, ftp drives, have organizational based shared folders, the list can go on for days.

But the big question is, how do we get a container to mount a local shared folder or distribute volumes across all swarm nodes?
Well, there's a whole list of distributed filesystems and modern storage mechanisms in the [docker documentation](https://docs.docker.com/engine/extend/legacy_plugins/).
Below is a list of the top recommended alternatives I found for [distributed file systems](https://en.wikipedia.org/wiki/Distributed_File_System_(Microsoft)) or [NFS's](https://en.wikipedia.org/wiki/Network_File_System) for the docker stratosphere around container development.

* [Ceph](https://ceph.com/)
* [Convoy](https://github.com/rancher/convoy)
* [RexRay](https://github.com/rexray/rexray)
* [PortWorx](https://portworx.com/use-case/docker-persistent-storage/)
* [StorageOS](https://github.com/pvdbleek/storageos)
* [xtreemfs](http://www.xtreemfs.org/)

I know you're wondering why we didn't use [S3](https://aws.amazon.com/s3/), [DigitalOcean Spaces](https://www.digitalocean.com/products/spaces/), [GCS](https://cloud.google.com/storage/docs/), or some other cloud storage.
But internally we have a finite amount of resources and we can spin up VM's and be rolling in a matter of moments.
Especially considering we have build a number of [Ansible](https://www.ansible.com/) playbooks to quickly provision our servers.
Plus, why throw resources out on the cloud, when it's not needed.
Especially when we can metaphorically create our own network based file system and have our own cloud based storage system.


_(Below is an image showing we want to distribute file system changes)_{: .small }

![](/img/posts/docker-swarm-persistent-storage/DockerSwarm_wStorage.svg){: .img-fluid }

After looking at several methods I settled on [GlusterFS](https://www.gluster.org/) a scalable network filesystem.
Don't get me wrong, a number of the other alternatives are pretty ground breaking and some amazing work as been put into developing them.
But I don't have thousands of dollars to drop on setting up a network file system, that  may or may not work for our needs.
There were also several others that I did look pretty heavily into, such as [StorageOS](https://github.com/pvdbleek/storageos) and [Ceph](https://ceph.com/).
With StorageOS I really liked the idea of a container based file system that stores, synchronizing, and distributes files to all other storage nodes within the swarm.
And it may just be me, but Ceph looked like the prime competitor to Gluster. They both have their [high points](https://technologyadvice.com/blog/information-technology/ceph-vs-gluster/) and seem to work very reliable.
But at the time; it wasn't for me and after using Gluster for a few months, I believe that I made the right choice and it's served it's purpose well.




[![Gluster Ant](/img/posts/docker-swarm-persistent-storage/gluster-ant.png){: .img-fluid .w-25 }](https://www.gluster.org/)


#### Gluster Notes

_(**Note:** The following steps are to be used on a Debian/Ubuntu based install.)_

Documentation for using Gluster can be found on their [docs](https://docs.gluster.org/en/latest/). Their installation instructions are very brief and explain how to install the gluster packages, but they don't go into depth in how to setup a Gluster network. I also suggest thoroughly reading through to documentation to understand Gluster volumes, bricks, pools, etc.

### Installing GlusterFS

To begin you will need to list all of the Docker Swarm nodes you wish to connect in the `/etc/hosts` files of each server.
On linux (Debian/Ubuntu), you can get the current nodes IP Address run the following command `hostname -I | awk '{print $1}'`

_&nbsp;_{: .fa.fa-info-circle } _(The majority of the commands listed below need to be ran on each and every node simultaneously unless specified. To do this I opened a number of terminal tabs and connected to each server in a different tab.)_{: .small }

```config
# /etc/hosts
10.10.10.1 staging1.example.com staging1
10.10.10.2 staging2.example.com staging2
10.10.10.3 staging3.example.com staging3
10.10.10.4 staging4.example.com staging4
10.10.10.5 staging5.example.com staging5
```

```shell
# Update & Upgrade all installed packages
apt-get update && apt-get upgrade -y

# Install gluster dependencies
sudo apt-get install python-software-properties -y
```

Add the GlusterFS [PPA](https://itsfoss.com/ppa-guide/) package the list of trusted packages to install from a community repository.
```shell
sudo add-apt-repository ppa:gluster/glusterfs-3.10;
sudo apt-get update -y && sudo apt-get update
```

Now lets install gluster
```shell
sudo apt-get install -y glusterfs-server attr
```

Now before starting the Gluster service but I had to copy some files into systemd _(you may or may not have to do this)_. But since Gluster was developed by [RedHat](https://www.redhat.com/en/technologies/storage/gluster) primarily for [RedHat](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux) and [CentOS](https://www.centos.org/), I had a few issues starting the system service.
```shell
sudo cp /etc/init.d/glusterfs-server /etc/systemd/system/
```

Let's start and enable the glusterfs system service
```shell
systemctl enable glusterfs-server; systemctl start glusterfs-server
```

This step isn't necessary, but I like to verify that
```shell
# Verify the gluster service is enabled
systemctl is-enabled glusterfs-server
# Check the system service status of the gluster-server
systemctl status glusterfs-server
```

If for some reason you haven't done this yet, each and every node should have it's own ssh key generated.

_(The only reason I can think of why they wouldn't have a different key is if a VM was provisioned and than cloned for similar use across a swarm.)_{: .small }

```shell
# This is to generate a very basic SSH key, you may want to specify a key type such as ED25519 or bit length if required.
ssh-keygen -t rsa
```

Dependant on your Docker Swarm environment and which server you're running as a manager; you'll probably want one of the node managers to also be a gluster node manager as well. I'm going to say server `staging1` is one of our node managers, so on this server we're going to probe all other gluster nodes to add them to the gluster pool. (Probing them essentially is saying this manager is telling all servers on this list to connect to each-other.)
```shell
gluster peer probe staging1; gluster peer probe staging2; gluster peer probe staging3; gluster peer probe staging4; gluster peer probe staging5;
```

It's not required, but probably good practice to ensure all of the nodes have connected to the pool before setting up the file system.
```shell
gluster pool list

# => You should get results similar to the following
UUID					Hostname 	State
a8136a2b-a2e3-437d-a003-b7516df9520e	staging3 	Connected
2a2f93f6-782c-11e9-8f9e-2a86e4085a59	staging2 	Connected
79cb7ec0-f337-4798-bde9-dbf148f0da3b	staging4 	Connected
3cfc23e6-782c-11e9-8f9e-2a86e4085a59	staging5 	Connected
571bed3f-e4df-4386-bd46-3df6e3e8479f	localhost	Connected

# You can also run the following command to another set of results
gluster peer status
```

Now lets create the gluster data storage directories _(**It's very important you do this on every node.** This is because this directory is where all gluster nodes will store the distributed files locally.)_
```shell
sudo mkdir -p /gluster/brick
```

Now lets create a gluster volume across all nodes (again run this on the master node/node manager).
```shell
sudo gluster volume create staging-gfs replica 5 staging1:/gluster/brick staging2:/gluster/brick staging3:/gluster/brick staging4:/gluster/brick staging5:/gluster/brick force
```

The next step is to initialize the glusterFS to begin synchronizing across all nodes.
```shell
gluster volume start staging-gfs
```

This step is also not required, but I prefer to verify the gluster volume replicated across all of the designated nodes.
```shell
gluster volume info
```

No let's ensure we have gluster mount the `/mtn` directory for it's shared directory especially on a reboot. ***(It's important to run these commands on all gluster nodes.)***
```shell
sudo umount /mnt
sudo echo 'localhost:/staging-gfs /mnt glusterfs defaults,_netdev,backupvolfile-server=localhost 0 0' >> /etc/fstab
sudo mount.glusterfs localhost:/staging-gfs /mnt
sudo chown -R root:docker /mnt
```
_(You may have noticed the setting of file permissions using `chown -R root:docker` this is to ensure docker will have read/write access to the files in the specified directory.)_{: .small}

If for some reason you've already deployed your staging gluster-fs and need to remount the staging-gfs volume you can run the following command. Otherwise you should be able to skip this step.
```shell
sudo umount /mnt; sudo mount.glusterfs localhost:/staging-gfs /mnt; sudo chown -R root:docker /mnt
```

Let's list all of our mounted partitions and ensure that the `staging-gfs` is listed.
```shell
df -h

# => staging-gfs should be listed in the partitions/disks listed
localhost:/staging-gfs              63G   13G   48G  21% /mnt
```


Now that all of the work is pretty much done, now comes the fun part lets test to make sure it all works.
Lets `cd` into the `/mnt` directory and create a few files to make sure they will sync across all nodes.
_(I know this is one of the first things I wanted to try out.)_
You can do one of the following commands to generate a random file in the `/mnt` directory.
Now depending on your servers and network connections this should sync up across all nodes almost instantly.
The way I tested this I was in the `/mtn` directory on several nodes in several terminals. And as soon as I issued the command I was running the `ls` command in the other tabs.
And depending on the file size, it may not sync across all nodes instantly, but is at least accessible.

```shell
# This creates a 24MB file full of zeros
dd if=/dev/zero of=output.dat bs=24M  count=1

# Creates a 2MB file of random characters
dd if=/dev/urandom of=output.log bs=1M count=2
```


### Using GlusterFS with Docker

Now that all the fun stuff is done if you have looked at docker [volumes](https://docs.docker.com/storage/volumes/) or [bind](https://docs.docker.com/storage/bind-mounts/) mounts this would probably be a good time.
Usually docker will store a volumes contents in a folder structure similar to the following: `/var/lib/docker/volumes/DogTracker/_data`.

But in your `docker-compose.yml` or `docker-stack.yml` you can specify specific mount points for the docker volumes.
If you look at the following [YAML](https://en.wikipedia.org/wiki/YAML) snippet you will notice I'm saying to store the containers `/opt/couchdb/data` directory on the local mount point `/mnt/staging_couch_db`.

```yml
version: '3.7'
services:
  couchdb:
  image: couchdb:2.3.0
  volumes:
   - type: bind
     source: /mnt/staging_couch_db
     target: /opt/couchdb/data
  networks:
    - internal
  deploy:
    resources:
      limits:
        cpus: '0.30'
        memory: 512M
      reservations:
        cpus: '0.15'
        memory: 256M
```
Now as we had previously demonstrated any file(s) saved, created, and/or deleted in the `/mtn` directory will be synchronized across all of the GlusterFS nodes.

I'd just like to mention this may not work for everyone, but this is the method that worked best for use.
We've been running a number of different Gluster networks for several months now with no issues _thus far_.
