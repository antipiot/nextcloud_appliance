#!/bin/sh

# Jonas Sauge

## Installing sources, dependencies and updating host
# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Setup Stable Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker along network tools


apt update -y
apt install -y net-tools gnupg2 curl ca-certificates docker-ce docker-ce-cli containerd.io
apt dist-update -y

## Starting Nextcloud Installation
# Creating environnmente variables
uid=0 
gid=0
rootfolder=/root/nextcloud
http=80
https=443
dbusername=nextcloud
dbname=nextcloud
dbhostname=db
# mysqlrootpwd=$(LC_ALL=C tr -dc 'A-Za-z0-9!#%&\()*+,-./:;<=>?@[\]^_{}~' </dev/urandom | head -c 20)
# mysqlnextcloudpwd=$(LC_ALL=C tr -dc 'A-Za-z0-9!#%&\()*+,-./:;<=>?@[\]^_{}~' </dev/urandom | head -c 20)
mysqlrootpwd=test
mysqlnextcloudpwd=test

# Starting mysql container
#docker run -d --name $dbhostname --user $uid:$uid -v $rootfolder/database:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=$mysqlrootpwd -e MYSQL_DATABASE=$dbname -e MYSQL_USER=$nextcloud -e MYSQL_PASSWORD=$mysqlnextcloudpwd mysql:5.7 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
# Starting nextcloud container
#docker run -d -p $https:443 -p $http:80 --name=nextcloud --link $dbhostname --restart unless-stopped -e TZ=Europe/Geneva -v $rootdatafolder/nextcoud/config:/config -v $rootdatafolder/nextcoud/data:/data -e MYSQL_DATABASE=$dbname -e MYSQL_HOST=$dbhostname-e MYSQL_USER=$nextcloud -e MYSQL_PASSWORD=$mysqlnextcloudpwd linuxserver/nextcloud
# Starting updater container
# docker run -d --name watchtower --restart=unless-stopped -e WATCHTOWER_SCHEDULE="0 0 4 * * *" -e WATCHTOWER_CLEANUP="true" -e TZ="Europe/paris" -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
echo "Credentials:
Database hostname: $dbhostname
Database user: $dbusername
Database password: $mysqlnextcloudpwd
Database root password: $mysqlrootpwd" > $rootfolder/credentials.txt

