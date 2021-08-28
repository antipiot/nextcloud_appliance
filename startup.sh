#!/bin/sh

# Jonas Sauge
# Settings

username=nextcloud
http=80
https=443
dbusername=nextcloud
dbname=nextcloud
dbhostname=db
mysqlrootpwd=$(LC_ALL=C tr -dc 'A-Za-z0-9!#%&\()*+,-./:;<=>?@[\]^_{}~' </dev/urandom | head -c 20)
mysqlnextcloudpwd=$(LC_ALL=C tr -dc 'A-Za-z0-9!#%&\()*+,-./:;<=>?@[\]^_{}~' </dev/urandom | head -c 20)

## Starting Nextcloud Installation
# Creating environnment and variables

useradd $username
gid=$(id -g $username)
uid=$(id -u $username)

rootdatafolder=/mnt/nextcloud
mkdir $rootdatafolder
mkdir $rootdatafolder/database
chown -R $uid:$gid $rootdatafolder



# Starting mysql container
docker run -d --name $dbhostname --restart unless-stopped --user $uid:$gid -v $rootdatafolder/database:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=$mysqlrootpwd -e MYSQL_DATABASE=$dbname -e MYSQL_USER=$dbusername -e MYSQL_PASSWORD=$mysqlnextcloudpwd mariadb:10.5 --transaction-isolation=READ-COMMITTED --binlog-format=ROW
# Starting nextcloud container
docker run -d --name=nextcloud --restart unless-stopped -p $https:443 --link $dbhostname -e PUID=$uid -e PGID=$gid -e TZ=Europe/Geneva -v $rootdatafolder/config:/config -v $rootdatafolder/data:/data linuxserver/nextcloud
# Starting updater container
docker run -d --name watchtower --restart=unless-stopped -e WATCHTOWER_SCHEDULE="0 0 4 * * *" -e WATCHTOWER_CLEANUP="true" -e TZ="Europe/paris" -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
echo "Database user: $dbusername
Database password: $mysqlnextcloudpwd
Database name: $dbname
Database hostname: $dbhostname
Database root password: $mysqlrootpwd" > $rootdatafolder/credentials.txt

rm -f $0
