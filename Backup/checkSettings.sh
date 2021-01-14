#!/bin/bash
DATE=$(date +%d-%m-%Y-%H%M%S)
SRC_SETTINGS="/home/scripts/Settings.txt"
#echo $(pwd)

echo ""
echo "      _______. _______ .___________..___________. __  .__   __.   _______      _______.  "
echo "     /       ||   ____||           ||           ||  | |  \ |  |  /  _____|    /       |  "
echo "    |   (---- |  |__    ---|  |----  ---|  |---- |  | |   \|  | |  |  __     |   (----  "
echo "     \   \    |   __|      |  |         |  |     |  | |  .    | |  | |_ |     \   \      "
echo " .----)   |   |  |____     |  |         |  |     |  | |  |\   | |  |__| | .----)   |   "
echo " |_______/    |_______|    |__|         |__|     |__| |__| \__|  \______| |_______/    "
echo "                                                                                     "


echo Server Settings:
#Server Settings
SERVER_IP=SERVER_IP=$(egrep -w "SERVER_IP" $SRC_SETTINGS)
SERVER_IP=${SERVER_IP##*=}
echo SERVER_IP: $SERVER_IP

#Hostname des Rock
HOSTNAME=HOSTNAME=$(egrep -w "HOSTNAME" $SRC_SETTINGS)
HOSTNAME=${HOSTNAME##*=}
echo Hostname: $HOSTNAME

#Zeitzone TZ
TZ=TZ=$(egrep -w "TZ" $SRC_SETTINGS)
TZ=${TZ##*=}
echo TZ: $TZ

#MYSQLPASSWORD
MYSQLPASSWORD=MYSQLPASSWORD=$(egrep -w "MYSQLPASSWORD" $SRC_SETTINGS)
MYSQLPASSWORD=${MYSQLPASSWORD##*=}
echo MYSQLPASSWORD: $MYSQLPASSWORD

#PIHOLEPASSWORD
PIHOLEPASSWORD=PIHOLEPASSWORD=$(egrep -w "PIHOLEPASSWORD" $SRC_SETTINGS)
PIHOLEPASSWORD=${PIHOLEPASSWORD##*=}
echo PIHOLEPASSWORD: $PIHOLEPASSWORD

echo
echo Globale Pfade
#Data
DIR_DATA=$(egrep -w "DIR_DATA" $SRC_SETTINGS)
DIR_DATA=${DIR_DATA##*=}
echo Data: $DIR_DATA

#Nextcloud
DIR_NEXTCLOUD=$(egrep -w "DIR_NEXTCLOUD" $SRC_SETTINGS)
DIR_NEXTCLOUD=${DIR_NEXTCLOUD##*=}
echo Nextcloud: $DIR_NEXTCLOUD

#NextcloudData
DIR_NEXTCLOUDDATA=$(egrep -w "DIR_NEXTCLOUDDATA" $SRC_SETTINGS)
DIR_NEXTCLOUDDATA=${DIR_NEXTCLOUDDATA##*=}
echo NextcloudData: $DIR_NEXTCLOUDDATA

#Backup-Scripts
DIR_BACKUPSCRIPTS=$(egrep -w "DIR_BACKUPSCRIPTS" $SRC_SETTINGS)
DIR_BACKUPSCRIPTS=${DIR_BACKUPSCRIPTS##*=}
echo Backup-Scripts: $DIR_BACKUPSCRIPTS

#Pihole
DIR_PIHOLE=$(egrep -w "DIR_PIHOLE" $SRC_SETTINGS)
DIR_PIHOLE=${DIR_PIHOLE##*=}
echo Pihole: $DIR_PIHOLE

#Temp
DIR_TEMP=$(egrep -w "DIR_TEMP" $SRC_SETTINGS)
DIR_TEMP=${DIR_TEMP##*=}
echo Temp: $DIR_TEMP

#Update-Scripts
DIR_UPDATESCRIPTS=$(egrep -w "DIR_UPDATESCRIPTS" $SRC_SETTINGS)
DIR_UPDATESCRIPTS=${DIR_UPDATESCRIPTS##*=}
echo Update-Scripts: $DIR_UPDATESCRIPTS


echo
echo Backup-Quellen
#AppData
SRC_APPDATA=$(egrep -w "SRC_APPDATA" $SRC_SETTINGS)
SRC_APPDATA=${SRC_APPDATA##*=}
echo AppData: $SRC_APPDATA


#ioBroker
SRC_IOBROKER=$(egrep -w "SRC_IOBROKER" $SRC_SETTINGS)
SRC_IOBROKER=${SRC_IOBROKER##*=}
echo IOBroker: $SRC_IOBROKER

#OMVBACKUP
SRC_OMVBACKUP=$(egrep -w "SRC_OMVBACKUP" $SRC_SETTINGS)
SRC_OMVBACKUP=${SRC_OMVBACKUP##*=}
echo OMVBACKUP: $SRC_OMVBACKUP

#SCRIPTS
SRC_SCRIPTS=$(egrep -w "SRC_SCRIPTS" $SRC_SETTINGS)
SRC_SCRIPTS=${SRC_SCRIPTS##*=}
echo Scripts: $SRC_SCRIPTS


echo
echo Backup-Ziele
#Backupordner
DEST_BACKUP=$(egrep -w "DEST_BACKUP" $SRC_SETTINGS)
DEST_BACKUP=${DEST_BACKUP##*=}
echo Backupordner: $DEST_BACKUP

DEST_APPDATA=$(egrep -w "DEST_APPDATA" $SRC_SETTINGS)
DEST_APPDATA=${DEST_APPDATA##*=}
echo Backup AppData: $DEST_APPDATA

DEST_ARCHIVES=$(egrep -w "DEST_ARCHIVES" $SRC_SETTINGS)
DEST_ARCHIVES=${DEST_ARCHIVES##*=}
echo Backup Archives: $DEST_ARCHIVES

DEST_IOBROKER=$(egrep -w "DEST_IOBROKER" $SRC_SETTINGS)
DEST_IOBROKER=${DEST_IOBROKER##*=}
echo Backup IOBroker: $DEST_IOBROKER

DEST_OMVBACKUP=$(egrep -w "DEST_OMVBACKUP" $SRC_SETTINGS)
DEST_OMVBACKUP=${DEST_OMVBACKUP##*=}
echo Backup OMVBACKUP: $DEST_OMVBACKUP

DEST_SCRIPTS=$(egrep -w "DEST_SCRIPTS" $SRC_SETTINGS)
DEST_SCRIPTS=${DEST_SCRIPTS##*=}
echo Backup Scripts: $DEST_SCRIPTS
echo
echo Ende Settings-Check
exit







