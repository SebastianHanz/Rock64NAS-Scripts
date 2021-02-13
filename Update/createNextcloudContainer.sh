#!/bin/bash
#Variablen und Pfade
SRC_SETTINGS="/home/scripts/Settings.txt"

if [ ! -f "$SRC_SETTINGS" ]; then
    echo Konnte $SRC_SETTINGS nicht finden!
    echo Programm wird geschlossen
    echo Finish!
    exit
fi

HOSTNAME=HOSTNAME=$(egrep -w "HOSTNAME" $SRC_SETTINGS)
HOSTNAME=${HOSTNAME##*=}

#Zeitzone TZ
TZ=TZ=$(egrep -w "TZ" $SRC_SETTINGS)
TZ=${TZ##*=}

#Nextcloud
DIR_NEXTCLOUD=$(egrep -w "DIR_NEXTCLOUD" $SRC_SETTINGS)
DIR_NEXTCLOUD=${DIR_NEXTCLOUD##*=}

#NextcloudData
DIR_NEXTCLOUDDATA=$(egrep -w "DIR_NEXTCLOUDDATA" $SRC_SETTINGS)
DIR_NEXTCLOUDDATA=${DIR_NEXTCLOUDDATA##*=}

#Create new docker container with custom settings
docker run -d \
--name=Nextcloud \
--hostname $HOSTNAME \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=$TZ \
-p 81:80/tcp \
-p 444:443/tcp \
-v "/$DIR_NEXTCLOUD:/config:rw" \
-v "/$DIR_NEXTCLOUDDATA:/data:rw" \
--restart always \
linuxserver/nextcloud:arm32v7-latest

echo 'Starting up Nextcloud container '
exit
