#!/bin/sh

# Jonas Sauge

## Installing sources, dependencies and updating host
# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
apt update -y
apt install -y docker-ce docker-ce-cli containerd.io

wget -O /root/startup.sh https://raw.githubusercontent.com/antipiot/nextcloud_appliance/main/startup.sh

echo "@reboot bash /root/startup.sh" >> /etc/crontab
echo "@reboot bash /root/startup.sh" >> /root/test.txt

