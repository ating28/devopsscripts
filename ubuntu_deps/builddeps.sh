#!/bin/bash

# Run script as root/sudo

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
