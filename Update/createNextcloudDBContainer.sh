#!/bin/bash
#Variablen und Pfade
SRC_SETTINGS="/home/scripts/Settings.txt"
HOSTNAME=HOSTNAME=$(egrep -w "HOSTNAME" $SRC_SETTINGS)
HOSTNAME=${HOSTNAME##*=}

#Zeitzone TZ
TZ=TZ=$(egrep -w "TZ" $SRC_SETTINGS)
TZ=${TZ##*=}

#MYSQLPASSWORD
MYSQLPASSWORD=MYSQLPASSWORD=$(egrep -w "MYSQLPASSWORD" $SRC_SETTINGS)
MYSQLPASSWORD=${MYSQLPASSWORD##*=}


#AppData
SRC_APPDATA=$(egrep -w "SRC_APPDATA" $SRC_SETTINGS)
SRC_APPDATA=${SRC_APPDATA##*=}

docker run -d \
  --name=NextcloudDB \
  --hostname $HOSTNAME \
  -e PUID=1000 \
  -e PGID=100 \
  -e TZ=$TZ \
  -e MYSQL_ROOT_PASSWORD=$MYSQLPASSWORD \
  -p 3306:3306/tcp \
  -v "/$SRC_APPDATA/NextcloudDB:/config:rw" \
   --restart always \
  linuxserver/mariadb:latest
  
  printf 'Starting up NextcloudDB container '
