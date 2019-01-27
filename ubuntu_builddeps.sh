#!/bin/bash

# Run script as root/sudo
# Use grep -v '# Java$' if you want to skip installing Java

# Install common builddeps for Ubuntu
apt-get clean -y && apt-get update -y
apt-get install -y --no-install-recommends \
    apt-utils \
    apt-transport-https \
    build-essential \
    curl \
    dialog \
    ed \
    git \
    libzmq3-dev \
    locales \
    nano \
    net-tools \
    nodejs \
    openssh-server \
    python-software-properties \
    software-properties-common \
    tzdata \
    unzip \
    vim \
    wget

# Some ubuntu Config
echo "export TERM=xterm-256color" >> /home/$USER/.bashrc
echo "export DEBIAN_FRONTEND=noninteractive" >> /home/$USER/.bashrc
echo "Chicago/USA" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata
locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX && dpkg-reconfigure locales

# FIX some annoying Ubuntu 16.04 warnings and errors

# Fix "writing more than expected" error with apt/apt-get when using corporate proxy
echo "Acquire::http::Pipeline-Depth 0;" > /etc/apt/apt.conf.d/99fixbadproxy
echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf.d/99fixbadproxy
echo "Acquire::BrokenProxy    true;" >> /etc/apt/apt.conf.d/99fixbadproxy
apt-get update -o Acquire::CompressionTypes::Order::=gz

# Annoying but benign: "W: mdadm: /etc/mdadm/mdadm.conf defines no arrays."
    mkdir -p /etc/mdadm
    touch /etc/mdadm/mdadm.conf
    echo "ARRAY <ignore> devices=/dev/sda" >> /etc/mdadm/mdadm.conf

# Install Java                                                                                                      # Java
add-apt-repository ppa:linuxuprising/java                                                                           # Java
apt-get update -y                                                                                                   # Java
echo oracle-java11-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections      # Java
apt-get install -y --no-install-recommends oracle-java11-installer                                                  # Java
apt-get install oracle-java11-set-default                                                                           # Java  
