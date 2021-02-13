#!/bin/bash
#Pfad zu Settings-Datei muss immer angegeben werden und stimmen!
SRC_SETTINGS="/home/scripts/Settings.txt"

#SCRIPTS
SRC_SCRIPTS=$(egrep -w "SRC_SCRIPTS" $SRC_SETTINGS)
SRC_SCRIPTS=${SRC_SCRIPTS##*=}

DOWNLOADS=/tmp/Github-Download
mkdir $DOWNLOADS
cd $DOWNLOADS

echo Lade aktuelle GitHub-Repo herunter
git clone https://github.com/SebastianHanz/Rock64NAS-Scripts/ ./

chmod -R +x ./*
rm ./Update/update_scripts_Repository.sh
cp -r ./* /$SRC_SCRIPTS
rm -r $DOWNLOADS

echo Finish!
