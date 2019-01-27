#!/bin/bash

# Create user
groupadd -g 12574 ubuntu
useradd -u 12574 -g 12574 -m -N -s /bin/bash ubuntu

# ADD SSH start script
mkdir -p /scripts
printf "#!/bin/bash\\nservice ssh start\\n" > /scripts/start-ssh
chmod +x /scripts/start-ssh
echo 'export PYTHONIOENCODING=utf-8' >> /home/$USER/.bashrc
echo 'export LANG=en_US.UTF-8' >> /home/$USER/.bashrc
echo 'export JOBLIB_TEMP_FOLDER=/tmp' >> /home/$USER/.bashrc
echo 'export LC_ALL=en_US.UTF-8' >> /home/$USER/.bashrc

# Intall Notebooks below
