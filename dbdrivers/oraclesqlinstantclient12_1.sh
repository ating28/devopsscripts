#!/bin/bash

# Run script as root/sudo

# Build Deps
apt-get clean -y && apt-get update -y
apt-get install -y curl wget apt-transport-https nano unzip

# Oracle Instantclient
cd /tmp
wget https://s3.amazonaws.com/stuff-for-devops/dbdrivers/instantclient-basic-linux.x64-12.2.0.1.0.zip
wget https://s3.amazonaws.com/stuff-for-devops/dbdrivers/instantclient-jdbc-linux.x64-12.2.0.1.0.zip
wget https://s3.amazonaws.com/stuff-for-devops/dbdrivers/instantclient-odbc-linux.x64-12.2.0.1.0.zip
wget https://s3.amazonaws.com/stuff-for-devops/dbdrivers/instantclient-sdk-linux.x64-12.2.0.1.0.zip
apt-get install -y --no-install-recommends libaio1
unzip instantclient-basic-*
unzip instantclient-jdbc-*
unzip instantclient-odbc-*
unzip instantclient-sdk-*
mkdir -p /opt/oracle/
mv instantclient_12_2 /opt/oracle/
rm *.zip
cd /opt/oracle/instantclient_12_2
ln -s /opt/oracle/instantclient_12_2/libclntsh.so.12.1 /opt/oracle/libclntsh.so
ln -s /opt/oracle/instantclient_12_2/libocci.so.12.1 /opt/oracle/libocci.so
ln -s /opt/oracle/instantclient_12_2/libociei.so /opt/oracle/libociei.so
ln -s /opt/oracle/instantclient_12_2/libnnz12.so /opt/oracle/libnnz12.so
ln -s /opt/oracle/instantclient_12_2/odbc8.jar /opt/oracle/odbc8.jar
ln -s /opt/oracle/instantclient_12_2/orai18n.jar /opt/oracle/orai18n.jar

echo "export ORACLE_BASE=/usr/lib/instantclient_12_2" >> /home/$USER/.bashrc
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/oracle/instantclient_12_2" >> /home/$USER/.bashrc
echo "export TNS_ADMIN=/opt/oracle/instantclient_12_2" >> /home/$USER/.bashrc
echo "export ORACLE_HOME=/opt/oracle/instantclient_12_2" >> /home/$USER/.bashrc

printf '
[Oracle 12.2 ODBC driver]
Description=Oracle ODBC driver for Oracle 12.2
Driver = /opts/oracle/ojdbc8.jar

[Oracle 12.2 JDBC driver]
Description=Oracle JDBC driver for Oracle 12.2
Driver = /opts/oracle/orai18n.jar

' >> /etc/odbcinst.ini
