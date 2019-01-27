#!/bin/bash

# Run script as root/sudo

# Install Java
add-apt-repository ppa:linuxuprising/java
apt-get update -y
echo oracle-java11-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get install -y --no-install-recommends oracle-java11-installer
apt-get install oracle-java11-set-default
