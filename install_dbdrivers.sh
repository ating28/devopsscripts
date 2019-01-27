#!/bin/bash

apt-get clean -y
apt-get update -y
apt-get install -y curl wget apt-transport-https nano unzip
# MS SQL SERVER Drivers
#######################

cd /tmp && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
apt-get update -y
ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql17
# optional: for bcp and sqlcmd
ACCEPT_EULA=Y apt-get install -y --no-install-recommends mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> /etc/environment
# optional: for unixODBC development headers
apt-get install -y --no-install-recommends unixodbc-dev
# Don't think we need these below
    # Create links to the static library names the MSSQL driver depends on
    # ln -s libcrypto.so.1.0.0 /lib/x86_64-linux-gnu/libcrypto.so.10
    # ln -s libssl.so.1.0.0 /lib/x86_64-linux-gnu/libssl.so.10
    # ln -s libodbcinst.so.2 /usr/lib/x86_64-linux-gnu/libodbcinst.so.1

# Teradata ODBC Drivers
#######################
mkdir /opt/terajdbc && cd /tmp
wget https://s3.amazonaws.com/domino-dell-packages/tdodbc1620__ubuntu_indep.16.20.00.18-1.tar.gz
wget https://s3-us-west-2.amazonaws.com/cs-dell/teradata/terajdbc4.jar -O /opt/teradata/jdbc/terajdbc4.jar
wget https://s3-us-west-2.amazonaws.com/cs-dell/teradata/tdgssconfig.jar -O /opt/teradata/jdbc/tdgssconfig.jar
tar -xf tdodbc1620__ubuntu_indep.16.20.00.18-1.tar.gz
# Install libstdc++6 package
apt-get -f install -y --no-install-recommends lib32stdc++6 lib32gcc1 libc6-i386
# Install Terdata driver  
cd /tmp/tdodbc1620 && dpkg -i tdodbc1620-16.20.00.18-1.noarch.deb

# Oracle DB Drivers
#######################
# Drivers for Linux
cd /tmp
wget https://s3-us-west-2.amazonaws.com/domino-deployment/2016/02/22/instantclient-basic-linux.x64-12.1.0.2.0.zip
wget https://s3-us-west-2.amazonaws.com/domino-deployment/2016/02/22/instantclient-sdk-linux.x64-12.1.0.2.0.zip
apt-get install -y --no-install-recommends libaio1
unzip instantclient-basic-*
unzip instantclient-sdk-*
mkdir -p /opt/oracle/
mv instantclient_12_1 /opt/oracle/
cd /opt/oracle/instantclient_12_1
ln -s /opt/oracle/instantclient_12_1/libclntsh.so.12.1 /opt/oracle/libclntsh.so && \
ln -s /opt/oracle/instantclient_12_1/libocci.so.12.1 /opt/oracle/libocci.so && \
ln -s /opt/oracle/instantclient_12_1/libociei.so /opt/oracle/libociei.so && \
ln -s /opt/oracle/instantclient_12_1/libnnz12.so /opt/oracle/libnnz12.so
echo "export ORACLE_BASE=/usr/lib/instantclient_12_1" >> /etc/environment
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/instantclient_12_1" >> /etc/environment
echo "export TNS_ADMIN=/usr/lib/instantclient_12_1" >> /etc/environment
echo "export ORACLE_HOME=/usr/lib/instantclient_12_1" >> /etc/environment

# PostgreSQL client
###################
echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/postgres.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update && apt-get install -y postgresql-10 postgresql-client-10 postgresql-contrib-10

# Making sure /etc/odbcinst.ini is created and contains references to applicable drivers above

printf '
[FreeTDS]
UsageCount=2

[ODBC Driver 17 for SQL Server]
Description=Microsoft ODBC Driver 17 for SQL Server
Driver=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.2.so.0.1
Threading=1
UsageCount=1

[Teradata Database ODBC Driver 16.20]
Description=Teradata Database ODBC Driver 16.20
Driver=/opt/teradata/client/ODBC_64/lib/tdataodbc_sb64.so
# Note: Currently, Data Direct Driver Manager does not support Connection Pooling feature.

[Teradata Database JDBC Driver 4]
Description=Teradata Database JDBC Driver 4
Driver=/opt/teradata/jdbc/terajdbc4.jar

[Oracle 12.1 JDBC driver]
Description=Oracle JDBC driver for Oracle 12.1
Driver          = /opts/oracle/instantclient_12_1/ojdbc7.jar
' >> /etc/odbcinst.ini

# Layer Cleanup
rm -rf /tmp/*
apt-get autoremove -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*
