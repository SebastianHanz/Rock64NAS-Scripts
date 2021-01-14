#!/bin/bash
#SRC_SETTINGS muss immer zuerst angegeben werden!
SRC_SETTINGS="/home/scripts/Settings.txt"

#AppData
SRC_APPDATA=$(egrep -w "SRC_APPDATA" $SRC_SETTINGS)
SRC_APPDATA=${SRC_APPDATA##*=}


#Backup-Scripts
DIR_BACKUPSCRIPTS=$(egrep -w "DIR_BACKUPSCRIPTS" $SRC_SETTINGS)
DIR_BACKUPSCRIPTS=${DIR_BACKUPSCRIPTS##*=}

#Update-Scripts
DIR_UPDATESCRIPTS=$(egrep -w "DIR_UPDATESCRIPTS" $SRC_SETTINGS)
DIR_UPDATESCRIPTS=${DIR_UPDATESCRIPTS##*=}



pullNewestNextcloudDB(){
echo -e "\nDownloade nun das aktuelle Nextcloud Image!\n"
docker pull linuxserver/mariadb:latest
return $?
}

createNextcloudDB(){
sleep 2
echo -e Halte NextcloudDB an
docker stop Nextcloud
iobroker stop
docker stop NextcloudDB

sleep 2
echo -e Lösche alten NextcloudDB-Docker-Container
docker rm NextcloudDB

sleep 2
echo -e "Erstelle neuen NextcloudDB-Container mit Settings aus der Settings.txt\n"
cd /
cd /$DIR_UPDATESCRIPTS/
./createNextcloudDBContainer.sh
docker start Nextcloud
iobroker start
}





#Falls keine URL angegeben, welcher Parameter denn dann?
if [ "$1" = "" ]; then
	echo -e "\n Keine Parameter angegeben! Bitte gebe als Parameter den offiziellen Downloadlink von Nextcloud zur ZIP-Datei ein.\n"
	echo Finish!
	exit
elif [ "$1" = "-c" ];then #Nur Container updaten
	echo -e "\nEs wird versucht das NextcloudDB-Image zu updaten\n"
	pullNewestNextcloudDB
	retval=$?
	
	#Abfrage ob Backup gemacht werden soll
	echo -e "\n Soll ein Backup des AppData-Ordners vor dem Update gemacht werden?\n "
	read -p "Gebe JA, NEIN, oder QUIT ein:" ANSWER


	if [ "$ANSWER" = "JA" ]; then
		cd /$DIR_BACKUPSCRIPTS
		./start_backup.sh -appdata
		cd /
	elif [ "$ANSWER" = "NEIN" ]; then
		echo -e " Fahre ohne Backup fort!\n"
	else
	echo Finish!
	exit
	fi
	
	if [ "$retval" = "2" ]; then
		echo -e "Der Container wurde erfolgreich heruntergeladen!\n Der Container wird nun neu erstellt!"
		createNextcloudDB
	elif [ "$retval" = "0" ]; then
		echo -e "\nDer Container ist bereits aktuell!\n\nMoechstest du den Container trotzdem neu aufsetzen?"
		read -p " Antworte mit JA oder NEIN: " ASK
		if [ "$ASK" = "JA" ]; then
			createNextcloudDB
			echo Finish!
			exit
		else
			echo Finish!
			exit
		fi
	else
		echo Huuuch, jetz hatz was gegeebe...Scheinbar hat der Download nicht geklappt!
	fi
	echo Finish!
	exit
fi
	echo -e "\n Die eingegebene URL passt nicht zu einem  offiziellen Nextcloud-Downloadserver!\n EXIT!\n"
	echo Finish!
	exit
fi




cd /
echo -e "\n Raeume alte Dockerimages auf...\n"
sleep 5
docker image prune -f
sleep 2
echo Finish!
exit





























#unzip ./nextcloud-18.0.4.zip -d ./test