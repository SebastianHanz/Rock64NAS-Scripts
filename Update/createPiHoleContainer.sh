#!/bin/bash
#Variablen und Pfade
SRC_SETTINGS="/home/scripts/Settings.txt"
HOSTNAME=HOSTNAME=$(egrep -w "HOSTNAME" $SRC_SETTINGS)
HOSTNAME=${HOSTNAME##*=}

#Server Settings
SERVER_IP=SERVER_IP=$(egrep -w "SERVER_IP" $SRC_SETTINGS)
SERVER_IP=${SERVER_IP##*=}
echo $SERVER_IP ü

#Zeitzone TZ
TZ=TZ=$(egrep -w "TZ" $SRC_SETTINGS)
TZ=${TZ##*=}

#Pihole
DIR_PIHOLE=$(egrep -w "DIR_PIHOLE" $SRC_SETTINGS)
DIR_PIHOLE=${DIR_PIHOLE##*=}

#PIHOLEPASSWORD
PIHOLEPASSWORD=PIHOLEPASSWORD=$(egrep -w "PIHOLEPASSWORD" $SRC_SETTINGS)
PIHOLEPASSWORD=${PIHOLEPASSWORD##*=}

cd ~
docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp \
    -p 1080:80/tcp \
    -p 1443:443/tcp \
    -e TZ="$TZ" \
    -e WEBPASSWORD="$PIHOLEPASSWORD" \
    -v "/$DIR_PIHOLE/:/etc/pihole/:rw" \
    -v "/$DIR_PIHOLE/DNSmasq/:/etc/dnsmasq.d/:rw" \
	-e DNS1="127.0.0.1" \
	-e DNS2="1.1.1.1" \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=always \
    --hostname "$HOSTNAME" \
    -e VIRTUAL_HOST="pinet.net" \
    -e PROXY_LOCATION="pi.net" \
    -e ServerIP="$SERVER_IP" \
    pihole/pihole:dev-armhf
  
  echo -e "\nStarting up PiHole container\n"
