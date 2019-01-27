#!/bin/bash

# Run script as root/sudo

# Build Deps
apt-get clean -y && apt-get update -y
apt-get install -y curl wget apt-transport-https nano unzip

# Postgresql Client
echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/postgres.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update && apt-get install -y postgresql-10 postgresql-client-10 postgresql-contrib-10
