#!/bin/sh

# Jonas Sauge

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
mysqlnextcloudpwd=test
#mysqlrootpwd=$(LC_ALL=C tr -dc 'A-Za-z0-9!#%&\()*+,-./:;<=>?@[\]^_{}~' </dev/urandom | head -c 20)
#mysqlnextcloudpwd=$(LC_ALL=C tr -dc 'A-Za-z0-9!#%&\()*+,-./:;<=>?@[\]^_{}~' </dev/urandom | head -c 20)


# Starting mysql container
docker run -d --name $dbhostname --restart unless-stopped --user $uid:$uid -v $rootfolder/database:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=$mysqlrootpwd -e MYSQL_DATABASE=$dbname -e MYSQL_USER=$nextcloud -e MYSQL_PASSWORD=$mysqlnextcloudpwd mysql:5.7 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
# Starting nextcloud container
docker run -d --name=nextcloud --restart unless-stopped -p $https:443 --link $dbhostname -e PUID=$uid -e PGID=$gid -e TZ=Europe/Geneva -v $rootdatafolderc/config:/config -v $rootdatafolder/data:/data linuxserver/nextcloud
# Starting updater container
docker run -d --name watchtower --restart=unless-stopped -e WATCHTOWER_SCHEDULE="0 0 4 * * *" -e WATCHTOWER_CLEANUP="true" -e TZ="Europe/paris" -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
echo "Database user: $dbusername \ 
Database password: $mysqlnextcloudpwd \ 
Database hostname: $dbhostname \ 
Database name: $dbname \ 
Database hostname: $dbhostname \ 
Database root password: $mysqlrootpwd" > $rootfolder/credentials.txt

rm -f $0
