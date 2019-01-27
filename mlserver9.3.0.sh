#!/bin/bash

# Run script as root/sudo
# Optinonally use grep -v '# R$' for example to filter out R, Python or Server specific packages if you don't need those

# ML SERVER 9.3.0 INSTALL
####################################################################################

# Paths
echo "export LD_LIBRARY_PATH=/opt/microsoft/mlserver/9.3.0/runtime/R/lib:$LD_LIBRARY_PATH" >> /home/$USER/.bashrc   # R
echo "export PATH=$PATH:/opt/microsoft/mlserver/9.3.0/runtime/python/bin/" >> /home/$USER/.bashrc                   # Python
echo "export PATH=$PATH:/opt/microsoft/mlserver/9.3.0/runtime/R/bin/" >> /home/$USER/.bashrc                        # R

# Build Deps
apt-get -y update
apt-get install -y apt-transport-https wget

# PPA Setup
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ xenial main" | tee /etc/apt/sources.list.d/azure-cli.list
wget https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O /tmp/prod.deb
dpkg -i /tmp/prod.deb
rm -f /tmp/prod.deb
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
  # One above works. One below from microsoft doesn't.
  #  apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
apt-get -y update

# R Stuff

apt-get install -y microsoft-r-open-foreachiterators-3.4.3  # R
apt-get install -y microsoft-r-open-mkl-3.4.3               # R
apt-get install -y microsoft-r-open-mro-3.4.3               # R
apt-get install -y microsoft-mlserver-packages-r-9.3.0      # R
apt-get install -y microsoft-mlserver-mml-r-9.3.0           # R
apt-get install -y microsoft-mlserver-mlm-r-9.3.0           # R
R CMD javareconf # R

# Python Stuff
apt-get install -y microsoft-mlserver-python-9.3.0          # Python
apt-get install -y microsoft-mlserver-packages-py-9.3.0     # Python
apt-get install -y microsoft-mlserver-mml-py-9.3.0          # Python
apt-get install -y microsoft-mlserver-mlm-py-9.3.0          # Python

# Other Stuff
apt-get install -y azure-cli=2.0.26-1~xenial
apt-get install -y dotnet-runtime-2.0.0
apt-get install -y microsoft-mlserver-adminutil-9.3.0       # Server
apt-get install -y microsoft-mlserver-config-rserve-9.3.0 
apt-get install -y microsoft-mlserver-computenode-9.3.0     # Server
apt-get install -y microsoft-mlserver-webnode-9.3.0         # Server

# Activate
/opt/microsoft/mlserver/9.3.0/bin/R/activate.sh

# List installed packages as a verification step
apt list --installed | grep microsoft

# Choose a package name and obtain verbose version information
dpkg --status microsoft-mlserver-packages-r-9.3.0           # R
dpkg --status microsoft-mlserver-packages-py-9.3.0          # Python

# Make ML Server Python the Default Python/R
echo 'alias python=mlserver-python' >> /home/$USER/.bashrc  # Python
echo 'alias python3=mlserver-python' >> /home/$USER/.bashrc # Python
echo 'alias R=Revo64' >> /home/$USER/.bashrc                # R
source /home/$USER/.bashrc

# Cleanup
apt-get clean -y && apt-get autoremove -y
