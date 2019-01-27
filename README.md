# DevOpsScripts
Linux Bash scripts for installing and configging things

## How to use them

Let's just cut right to the important stuff, then you can read my long-winded diatribe about Docker below.

**NOTE:** Root user is assumed for all of these code snippets because that is the default when building a docker image. If you aren't using docker or have another situation, you'll need to prepend ```sudo``` to each of the commands.

1. Whether in a Docker build or any other Ubuntu/Linux situation, first make sure you have git installed:

```apt-get update -y && apt-get install -y git```

I would also include other common build dependencies like ```wget curl apt-transport-https``` etc, but if required those are installed in each of these scripts.

2. In your install script or Dockerfile, git clone this repo to a temporary folder. Of course, this will require internet access or a proxy if you're inside of a corporate network. But so will all of the installs anyway, so that's assumed.

```
cd /tmp
git clone https://github.com/nreith/devopsscripts.git
```

3. cd and chmod all the scripts, then run the ones you want

```
cd devopsscripts/
chmod +x *
./name_of_script.sh
```

4. Options

To make these scripts a tad more flexible in a lazy way, I have appended comments to lines that could easily be filtered out with grep. For example, with the ml server script, if you only want to install R and not python, you could do the following:

```
cd /tmp/devopsscripts
grep -v "python" install_mlserver9.3.0.sh > myscript.sh
chmod +x myscript.sh
./myscript.sh
```
Not super complex, but I'm trying to save time here and it's better than manually commenting out lines in the file.

5. Layer cleanup for Docker builds

If you are actually using docker, I highly recommend running something like this for layer cleanup at the end of each RUN chunk to clear temporary and unneccessary files and save space.

```
RUN \
a bunch \
&& of Linux \
&& stuff installed \
&& here \
#
# Layer Cleanup
&& rm -rf /tmp/* \
&& apt-get autoremove -y \
&& apt-get autoclean -y \
&& rm -rf /var/lib/apt/lists/*
```

## What are these scripts for?

I wrote these scripts primarily for modular use in installing and configging commonly used things for Data Science in Docker (ubuntu:16.04), but they will work on any Ubuntu 16.04 based system. When it comes to Docker bases, I prefer phusion/baseimage:latest over vanilla Ubuntu 16.04, as it's Ubuntu slimmed down and optimized for running in containers. Check out their Git repo [here](https://github.com/phusion/baseimage-docker) and their dockerhub images [here](https://hub.docker.com/r/phusion/baseimage/)

In my experience, I have found that Dockerfiles and the entire process of building Docker images is rather error prone and annoying. Things that normally just work in Linux (Ubuntu) sometimes don't work in a dockerfile at build time. Builds fail due to weird glitches or syntax things with dockerfile language, which is just silly wrappers around bash scripting. Other times they fail due to network/proxy/firewall issues especially in a corporate environment. Or you may be constrained to using a specific older version of docker, as is often my case, due to some other software that leverages docker, or production stability needs. So the new docker feature that would fix your woes isn't available to you.

## Why not just do XYZ with Docker?

**Short answer:** "Ain't nobody got time for that shiz."

**Long answer:** Docker has lots of great advantages. But can you imagine the annoyance of having your builds fail and your older dockerfiles no longer work because suddenly blank lines/white space is not allowed between your lines of executable code? That happened in just the past year, and I was required to use two different versions of docker with different syntax in dev/prod. Then there's the issue of having to very carefully craft your Dockerfile with && and \ to join a ton of things into one long RUN statement so you can save layers and space. Multi-stage builds can help with this, but they're really friggin complicated, and require making very sure you're careful to copy all of the files you need from image A into image B, without accidentally over-writing the same file in inmage B when you really should be appending/combining the two.

**Another answer:** Docker isn't meant for managing installations, package versions, dependencies and the rest. Bash and apt-get are the tools that do this well, so why not just use them.

**My philosophy on micro docker images:** I know the theory behind minimalistic docker images and reproducible dockerfiles. But my use case for data science development work necessitates some huge docker images with a ton of things installed that will work for a variety of users who don't want to mess around with docker. In production of course, that's another conversation. So I don't want to have to manage a dockerfile that is one long script of 1500 lines where a single missing \ could break the whole thing. In every other programming language, we make things modular, so here I do too. They are still reproducible because I made sure any large files are hosted somewhere public, and this git repo is public and so anyone can use these scripts in their docker builds, or other installs.

**Versioning:** If you want a specific snapshot of these scripts at a certain point in time, fork the repo at that point and label it with a date or version. You can then be sure to use the same scripts. In the future, if there are significant changes, I might consider releases. But be aware anytime you rebuild a docker image, new versions of things will appear for everything you are installing anyway, even if you're using the same install script.
