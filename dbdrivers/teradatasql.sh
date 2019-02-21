#!/bin/bash

# Run script as root/sudo

# Build Deps
apt-get clean -y && apt-get update -y
apt-get install -y curl wget apt-transport-https nano unzip

# Teradata ODBC                                                                                                                   # TD
cd /tmp
wget https://s3.amazonaws.com/domino-dell-packages/tdodbc1620__ubuntu_indep.16.20.00.18-1.tar.gz
tar -xf tdodbc1620__ubuntu_indep.16.20.00.18-1.tar.gz
apt-get -f install -y --no-install-recommends lib32stdc++6 lib32gcc1 libc6-i386
cd /tmp/tdodbc1620 && dpkg -i tdodbc1620-16.20.00.18-1.noarch.deb

# Teradata JDBC
mkdir -p /opt/teradata/jdbc
wget https://s3-us-west-2.amazonaws.com/cs-dell/teradata/terajdbc4.jar -O /opt/teradata/jdbc/terajdbc4.jar
wget https://s3-us-west-2.amazonaws.com/cs-dell/teradata/tdgssconfig.jar -O /opt/teradata/jdbc/tdgssconfig.jar

# Aster ODBC and JDBC
cd /tmp && mkdir /opt/teradata/aster
wget https://s3.amazonaws.com/stuff-for-devops/dbdrivers/AsterClients__linux_x8664.07.00.00.00-r63672.tar
tar -xvzf Aster*.tar
mv /tmp/stage/home/beehive/clients-linux64 /tmp/aster
rm /tmp/aster/clients-linux64/*.tar.gz
mv aster /opt/teradata/
rm -rf stage *.tar

printf '
[Teradata ODBC Driver 16.20]
Description=Teradata Database ODBC Driver 16.20
Driver=/opt/teradata/client/ODBC_64/lib/tdataodbc_sb64.so
# Note: Currently, Data Direct Driver Manager does not support Connection Pooling feature.

[Teradata JDBC Driver 4]
Description=Teradata Database JDBC Driver 4
Driver=/opt/teradata/jdbc/terajdbc4.jar

[Aster ODBC Driver]
Driver=/opt/teradata/aster/clients-odbc-linux64/unixODBC/lib/libAsterDriver.so
IconvEncoding=UCS-4LE

[Aster JDBC Driver]
Description=Aster JDBC Driver
Driver=/opt/teradata/aster/noarch-aster-jdbc-driver.jar

' >> /etc/odbcinst.ini
