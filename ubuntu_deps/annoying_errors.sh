#!/bin/bash

# Some ubuntu Config
echo "export TERM=xterm-256color" >> /home/ubuntu/.bashrc
echo "export DEBIAN_FRONTEND=noninteractive" >> /home/ubuntu/.bashrc
echo "Chicago/USA" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX && dpkg-reconfigure locales
apt-get update
cd /tmp && . /etc/os-release

# Fix annoying "writing more than expected" error with apt/apt-get when using corporate proxy
echo "Acquire::http::Pipeline-Depth 0;" > /etc/apt/apt.conf.d/99fixbadproxy
echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf.d/99fixbadproxy
echo "Acquire::BrokenProxy true;" >> /etc/apt/apt.conf.d/99fixbadproxy
apt-get update -o Acquire::CompressionTypes::Order::=gz
echo "Acquire::http::proxy \"$http_proxy\";" > /etc/apt/apt.conf
echo "Acquire::https::proxy \"$https_proxy\";" >> /etc/apt/apt.conf
echo "Acquire::ftp::proxy \"$http_proxy\";" >> /etc/apt/apt.conf
apt-get clean && apt-get update

# Annoying but benign: "W: mdadm: /etc/mdadm/mdadm.conf defines no arrays."
mkdir -p /etc/mdadm
touch /etc/mdadm/mdadm.conf
echo "ARRAY <ignore> devices=/dev/sda" >> /etc/mdadm/mdadm.conf
