#!/bin/bash

# Run script as root/sudo

# Build Deps
apt-get clean -y && apt-get update -y
apt-get install -y curl wget apt-transport-https nano unzip

# Teradata JDBC/ODBC                                                                                                                   # TD
mkdir /opt/terajdbc && cd /tmp
wget https://s3.amazonaws.com/domino-dell-packages/tdodbc1620__ubuntu_indep.16.20.00.18-1.tar.gz
wget https://s3-us-west-2.amazonaws.com/cs-dell/teradata/terajdbc4.jar -O /opt/teradata/jdbc/terajdbc4.jar
wget https://s3-us-west-2.amazonaws.com/cs-dell/teradata/tdgssconfig.jar -O /opt/teradata/jdbc/tdgssconfig.jar
tar -xf tdodbc1620__ubuntu_indep.16.20.00.18-1.tar.gz
apt-get -f install -y --no-install-recommends lib32stdc++6 lib32gcc1 libc6-i386
cd /tmp/tdodbc1620 && dpkg -i tdodbc1620-16.20.00.18-1.noarch.deb

printf '
[Teradata Database ODBC Driver 16.20]
Description=Teradata Database ODBC Driver 16.20
Driver=/opt/teradata/client/ODBC_64/lib/tdataodbc_sb64.so
# Note: Currently, Data Direct Driver Manager does not support Connection Pooling feature.

[Teradata Database JDBC Driver 4]
Description=Teradata Database JDBC Driver 4
Driver=/opt/teradata/jdbc/terajdbc4.jar

' >> /etc/odbcinst.ini
