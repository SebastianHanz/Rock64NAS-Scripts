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

#AppData
SRC_APPDATA=$(egrep -w "SRC_APPDATA" $SRC_SETTINGS)
SRC_APPDATA=${SRC_APPDATA##*=}

#Data
DIR_DATA=$(egrep -w "DIR_DATA" $SRC_SETTINGS)
DIR_DATA=${DIR_DATA##*=}

#Create new docker container with custom settings
docker run -d \
--name=Nextcloud \
--hostname $HOSTNAME \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=$TZ \
-p 81:80/tcp \
-p 444:443/tcp \
-v "/$SRC_APPDATA/Nextcloud:/config:rw" \
-v "/$DIR_DATA/Nextcloud:/data:rw" \
--restart always \
linuxserver/nextcloud:arm32v7-latest

printf 'Starting up Nextcloud container '
