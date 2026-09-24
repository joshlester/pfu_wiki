
---
created: 2024-08-15T11:27:47 (UTC +10:00)
tags: []
source: https://linuxtldr.com/deploy-portainer-on-podman/
author: Linux TLDR
---

# How to Deploy Portainer with Podman on Linux

> ## Excerpt
> Discover how easy it is to deploy your favorite container management tool, Portainer, with Podman on Linux with this quick guide.

---
[Podman](https://linuxtldr.com/installing-podman/) is a fantastic Docker alternative, yet challenges arise when attempting to utilize Docker images in Podman, particularly those only compatible with Docker like Portainer.

-   [What is the Difference Between Docker and Podman (Final Verdict)](https://linuxtldr.com/podman-vs-docker/)

Yet, there is a certain way by which you can easily use Docker images like Portainer on the Podman (the main topic of this article).

If you’re not familiar with Portainer, you can read our article on “[Portainer Server on Linux](https://linuxtldr.com/installing-portainer-server/)“, but for a quick overview, it’s a web-based GUI application that simplifies the deployment, management, and monitoring of containerized applications.

So, let’s keep aside all the things and focus on our main topic: how to deploy Portainer on Podman in Linux.

## Tutorial Details

<table><tbody><tr><td>Description</td><td>Portainer Server on Podman</td></tr><tr><td>Difficulty Level</td><td>Moderate</td></tr><tr><td><a href="https://linuxtldr.com/root-account/" target="_blank" rel="noreferrer noopener">Root</a> or <a href="https://linuxtldr.com/add-user-to-sudo-group/" target="_blank" rel="noreferrer noopener">Sudo</a> Privileges</td><td>No</td></tr><tr><td>OS Compatibility</td><td>Ubuntu, Manjaro, Fedora, etc.</td></tr><tr><td>Prerequisites</td><td><a href="https://linuxtldr.com/installing-podman/" target="_blank" rel="noreferrer noopener">Podman</a></td></tr><tr><td>Internet Required</td><td>Yes</td></tr></tbody></table>

The Portainer can be easily deployed on Podman with a few modifications in the command, but before showcasing that, make sure that Podman is installed and running on your Linux system.

So to correctly setup the Portainer with Podman to manage your Podman, follow the below steps one by one.

### Step 1: Pulling the Official Portainer Image

1\. If you haven’t already, install Podman on your Linux system by executing:

```
$ sudo apt install podman                                                                             #For Debian 11+ or Ubuntu 20.10+
$ sudo dnf install podman                                                                             #For Fedora
$ sudo yum install podman                                                                           #For CentOS
$ sudo pacman -S podman                                                                           #For Arch or Manjaro
$ sudo zypper install podman                                                                      #For OpenSUSE
$ sudo emerge app-containers/podman                                                   #For Gentoo
$ sudo apk add podman                                                                                #For Alpine Linux
$ brew install podman                                                                                   #For Homebrew
```

2\. Once the installation is complete, pull the latest official Portainer Community Edition image by running:

```
$ podman pull docker.io/portainer/portainer-ce
```

Output:

![pulling portainer image on podman](How%20to%20Deploy%20Portainer%20with%20Podman%20on%20Linux/pulling-portainer-image-on-podman-1024x528.webp)

3\. To verify the image was successfully pulled, run:

```
$ podman images
```

Output:

![verifying portainer image pulled in podman](How%20to%20Deploy%20Portainer%20with%20Podman%20on%20Linux/verifying-portainer-image-pulled-in-podman-1024x162.webp)

Now that the image is pulled, there are two ways to run Portainer with Podman: either as root or rootless (recommended). Let’s get started.

### Step 2.1: Deploying the Portainer Server on Podman with Root

1\. Begin by activating the Podman socket at system level through this [systemctl command](https://linuxtldr.com/systemctl-command/):

```
$ sudo systemctl enable --now podman.socket
```

Output:

![running podman service at system level](How%20to%20Deploy%20Portainer%20with%20Podman%20on%20Linux/running-podman-service-at-system-level-1024x108.webp)

2\. Run the Portainer in a Podman root environment by running:

```
$ podman run -d -p 9443:9443 --privileged -v /run/podman/podman.sock:/var/run/docker.sock:Z docker.io/portainer/portainer-ce
```

Output:

![running portainer on podman in root environment](How%20to%20Deploy%20Portainer%20with%20Podman%20on%20Linux/running-portainer-on-podman-in-environment-1024x160.webp)

That’s it. Now you can [check out this section](https://linuxtldr.com/deploy-portainer-on-podman/#accessing-portainer) to continue.

### Step 2.2: Deploying the Portainer Server on Podman without Root

1\. To run the Portainer server on Podman in a rootless environment, you have to enable the Podman socket for your user by running:

```
$ systemctl --user enable --now podman.socket
```

Output:

![running podman service at user level](How%20to%20Deploy%20Portainer%20with%20Podman%20on%20Linux/running-podman-service-at-user-level-1024x155.webp)

2\. Run the Portainer in a Podman rootless environment by running:

```
$ podman run -d -p 9443:9443 -p 8000:8000 --security-opt label=disable --name=portainer --restart=always -v /run/user/$(id -u)/podman/podman.sock:/var/run/docker.sock:Z -v portainer_data:/data  docker.io/portainer/portainer-ce
```

Output:

![running portainer on podman in rootless environment](How%20to%20Deploy%20Portainer%20with%20Podman%20on%20Linux/running-portainer-on-podman-in-rootless-environment-1024x207.webp)

### Step 3: Verifying the Portainer Container Status

When you launch the Portainer on Podman, you can verify the container is running with the following command:

```
$ podman ps
```

Output:

![verifying the status of portainer](How%20to%20Deploy%20Portainer%20with%20Podman%20on%20Linux/verifying-the-status-of-portainer-1024x171.webp)

Additionally, when Portainer launched, it also created a volume, which is verifiable by executing:

```
$ podman volume ls
```

Output:

![verifying the portainer volume](How%20to%20Deploy%20Portainer%20with%20Podman%20on%20Linux/verifying-the-portainer-volume-1024x177.webp)

The Portainer will use this volume to ensure persistent data storage across reboots.

### Step 4: Accessing the Portainer

To open the Portainer web interface, just launch your preferred web browser, such as [Chrome](https://linuxtldr.com/installing-google-chrome/) or [Firefox](https://linuxtldr.com/installing-firefox/), on the same machine or a device connected to the same network and navigate to “_https://IP-ADDRESS:9443_” (where IP-ADDRESS represents the IP address of your Linux instance running Portainer).

⚠️

Make sure to include “**https**“, or else you might encounter the “Client sent an HTTP request to an HTTPS server.” screen.

When accessing Portainer for the first time, you may encounter an insecure SSL warning. Just follow the instructions displayed in the image below.

![portainer insecure ssl warning message](How%20to%20Deploy%20Portainer%20with%20Podman%20on%20Linux/portainer-insecure-ssl-warning-message-1024x768.webp)

Next, a user configuration screen will appear. From here, you have to type an admin username and then add and verify a password for the new user.

Lastly, you can uncheck the telemetry data and continue by clicking the “**Create User**” button, which will take you to the Portainer UI.

![configuring portainer on podman](How%20to%20Deploy%20Portainer%20with%20Podman%20on%20Linux/configuring-portainer-on-podman-1024x765.webp)

Here, you can add new environments or immediately begin by clicking “**Get Started**“.

![portainer home screen running on podman](How%20to%20Deploy%20Portainer%20with%20Podman%20on%20Linux/portainer-home-screen-running-on-podman-1024x765.webp)

After clicking “**Get Started**“, you’ll see the local environment listed in the Portainer UI.

![environments in portainer running on podman](How%20to%20Deploy%20Portainer%20with%20Podman%20on%20Linux/environments-in-portainer-running-on-podman-1024x770.webp)

That’s it; now you can easily manage Podman using the Portainer UI.

## Final Word

I hope you’ll find this article valuable. If there are additional tools in your Podman setup exclusively available for Docker, please share them in the comments.

Till then, peace!
