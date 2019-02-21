#!/bin/bash

# Run script as root/sudo

# Build Deps
apt-get clean -y && apt-get update -y
apt-get install -y curl wget apt-transport-https nano unzip

# MS SQL Server Drivers
cd /tmp && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/microsoft-prod.list
apt-get update -y
ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql17
# optional: for bcp and sqlcmd
ACCEPT_EULA=Y apt-get install -y --no-install-recommends mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> /home/$USER/.bashrc
# optional: for unixODBC development headers
apt-get install -y --no-install-recommends unixodbc-dev
# Don't think we need these below
    # Create links to the static library names the MSSQL driver depends on
    # ln -s libcrypto.so.1.0.0 /lib/x86_64-linux-gnu/libcrypto.so.10
    # ln -s libssl.so.1.0.0 /lib/x86_64-linux-gnu/libssl.so.10
    # ln -s libodbcinst.so.2 /usr/lib/x86_64-linux-gnu/libodbcinst.so.1

# Get JDBC Driver
cd /opt/microsoft && mkdir -p msjdbcsql7 && cd msjdbcsql7
wget https://github.com/Microsoft/mssql-jdbc/releases/download/v7.2.1/mssql-jdbc-7.2.1.jre8.jar
    
printf '
[ODBC Driver 17 for SQL Server]
Description=Microsoft ODBC Driver 17 for SQL Server
Driver=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.2.so.0.1
Threading=1
UsageCount=1

[JDBC Driver 7 for SQL Server]
Description=Microsoft JDBC Driver 7 for SQL Server
Driver=/opt/microsoft/msjdbcsql7/mssql-jdbc-7.2.1.jre8.jar
' >> /etc/odbcinst.ini
