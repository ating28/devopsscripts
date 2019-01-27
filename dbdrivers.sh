#!/bin/bash

# Run script as root/sudo
# Optionally use grep -v '# MSSQL$' for example to remove MSSQL, TD, ORACLE or POSTGRES

# DB DRIVERS INSTALL
####################################################################################

# Build Deps
apt-get clean -y
apt-get update -y
apt-get install -y curl wget apt-transport-https nano unzip

# MS SQL Server Drivers                                                                                            # MSSQL
cd /tmp && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -                                  # MSSQL
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list     # MSSQL
apt-get update -y                                                                                                  # MSSQL
ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql17                                               # MSSQL
# optional: for bcp and sqlcmd                                                                                     # MSSQL
ACCEPT_EULA=Y apt-get install -y --no-install-recommends mssql-tools                                               # MSSQL
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> /home/$USER/.bashrc                                             # MSSQL
# optional: for unixODBC development headers                                                                       # MSSQL
apt-get install -y --no-install-recommends unixodbc-dev                                                            # MSSQL
# Don't think we need these below                                                                                  # MSSQL
    # Create links to the static library names the MSSQL driver depends on                                         # MSSQL
    # ln -s libcrypto.so.1.0.0 /lib/x86_64-linux-gnu/libcrypto.so.10                                               # MSSQL
    # ln -s libssl.so.1.0.0 /lib/x86_64-linux-gnu/libssl.so.10                                                     # MSSQL
    # ln -s libodbcinst.so.2 /usr/lib/x86_64-linux-gnu/libodbcinst.so.1                                            # MSSQL

# Teradata JDBC/ODBC                                                                                                                   # TD
mkdir /opt/terajdbc && cd /tmp                                                                                     # TD
wget https://s3.amazonaws.com/domino-dell-packages/tdodbc1620__ubuntu_indep.16.20.00.18-1.tar.gz                   # TD
wget https://s3-us-west-2.amazonaws.com/cs-dell/teradata/terajdbc4.jar -O /opt/teradata/jdbc/terajdbc4.jar         # TD
wget https://s3-us-west-2.amazonaws.com/cs-dell/teradata/tdgssconfig.jar -O /opt/teradata/jdbc/tdgssconfig.jar     # TD
tar -xf tdodbc1620__ubuntu_indep.16.20.00.18-1.tar.gz                                                              # TD
apt-get -f install -y --no-install-recommends lib32stdc++6 lib32gcc1 libc6-i386                                    # TD
cd /tmp/tdodbc1620 && dpkg -i tdodbc1620-16.20.00.18-1.noarch.deb                                                  # TD

# Oracle Instantclient                                                                                             # ORACLE
cd /tmp                                                                                                            # ORACLE
wget https://s3-us-west-2.amazonaws.com/domino-deployment/2016/02/22/instantclient-basic-linux.x64-12.1.0.2.0.zip  # ORACLE
wget https://s3-us-west-2.amazonaws.com/domino-deployment/2016/02/22/instantclient-sdk-linux.x64-12.1.0.2.0.zip    # ORACLE
apt-get install -y --no-install-recommends libaio1                                                                 # ORACLE
unzip instantclient-basic-*                                                                                        # ORACLE
unzip instantclient-sdk-*                                                                                          # ORACLE
mkdir -p /opt/oracle/                                                                                              # ORACLE
mv instantclient_12_1 /opt/oracle/                                                                                 # ORACLE
cd /opt/oracle/instantclient_12_1                                                                                  # ORACLE
ln -s /opt/oracle/instantclient_12_1/libclntsh.so.12.1 /opt/oracle/libclntsh.so && \                               # ORACLE
ln -s /opt/oracle/instantclient_12_1/libocci.so.12.1 /opt/oracle/libocci.so && \                                   # ORACLE
ln -s /opt/oracle/instantclient_12_1/libociei.so /opt/oracle/libociei.so && \                                      # ORACLE
ln -s /opt/oracle/instantclient_12_1/libnnz12.so /opt/oracle/libnnz12.so                                           # ORACLE
echo "export ORACLE_BASE=/usr/lib/instantclient_12_1" >> /home/$USER/.bashrc                                       # ORACLE
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/instantclient_12_1" >> /home/$USER/.bashrc                  # ORACLE
echo "export TNS_ADMIN=/usr/lib/instantclient_12_1" >> /home/$USER/.bashrc                                         # ORACLE
echo "export ORACLE_HOME=/usr/lib/instantclient_12_1" >> /home/$USER/.bashrc                                       # ORACLE

# Postgresql Client                                                                                                # POSTGRES
echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/postgres.list       # POSTGRES
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -                               # POSTGRES
apt-get update && apt-get install -y postgresql-10 postgresql-client-10 postgresql-contrib-10                      # POSTGRES

# odbcinst.ini
printf '
[FreeTDS]
UsageCount=2
' > /etc/odbcinst.ini

printf '
[ODBC Driver 17 for SQL Server]
Description=Microsoft ODBC Driver 17 for SQL Server
Driver=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.2.so.0.1
Threading=1
UsageCount=1
' >> /etc/odbcinst.ini                                                                                             # MSSQL

printf '
[Teradata Database ODBC Driver 16.20]
Description=Teradata Database ODBC Driver 16.20
Driver=/opt/teradata/client/ODBC_64/lib/tdataodbc_sb64.so
# Note: Currently, Data Direct Driver Manager does not support Connection Pooling feature.

[Teradata Database JDBC Driver 4]
Description=Teradata Database JDBC Driver 4
Driver=/opt/teradata/jdbc/terajdbc4.jar
' >> /etc/odbcinst.ini                                                                                             # TD

printf '
[Oracle 12.1 JDBC driver]
Description=Oracle JDBC driver for Oracle 12.1
Driver = /opts/oracle/instantclient_12_1/ojdbc7.jar
' >> /etc/odbcinst.ini                                                                                             # ORCLE

# Cleanup
apt-get clean -y && apt-get autoremove -y
rm -rf /tmp/*
