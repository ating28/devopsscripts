#!/bin/bash

# Run script as root/sudo

# Build Deps
apt-get clean -y && apt-get update -y
apt-get install -y curl wget apt-transport-https nano unzip

# Oracle Instantclient
cd /tmp
wget https://s3-us-west-2.amazonaws.com/domino-deployment/2016/02/22/instantclient-basic-linux.x64-12.1.0.2.0.zip
wget https://s3-us-west-2.amazonaws.com/domino-deployment/2016/02/22/instantclient-sdk-linux.x64-12.1.0.2.0.zip
apt-get install -y --no-install-recommends libaio1
unzip instantclient-basic-*
unzip instantclient-sdk-*
mkdir -p /opt/oracle/
mv instantclient_12_1 /opt/oracle/
cd /opt/oracle/instantclient_12_1
ln -s /opt/oracle/instantclient_12_1/libclntsh.so.12.1 /opt/oracle/libclntsh.so
ln -s /opt/oracle/instantclient_12_1/libocci.so.12.1 /opt/oracle/libocci.so
ln -s /opt/oracle/instantclient_12_1/libociei.so /opt/oracle/libociei.so
ln -s /opt/oracle/instantclient_12_1/libnnz12.so /opt/oracle/libnnz12.so
echo "export ORACLE_BASE=/usr/lib/instantclient_12_1" >> /home/$USER/.bashrc
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/instantclient_12_1" >> /home/$USER/.bashrc
echo "export TNS_ADMIN=/usr/lib/instantclient_12_1" >> /home/$USER/.bashrc
echo "export ORACLE_HOME=/usr/lib/instantclient_12_1" >> /home/$USER/.bashrc

printf '
[Oracle 12.1 JDBC driver]
Description=Oracle JDBC driver for Oracle 12.1
Driver = /opts/oracle/instantclient_12_1/ojdbc7.jar

' >> /etc/odbcinst.ini

# Cleanup
apt-get clean -y && apt-get autoremove -y
rm -rf /tmp/*
