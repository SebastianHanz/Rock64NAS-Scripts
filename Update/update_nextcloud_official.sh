#!/bin/bash
#SRC_SETTINGS muss immer zuerst angegeben werden!
SRC_SETTINGS="/home/scripts/Settings.txt"

if [ ! -f "$SRC_SETTINGS" ]; then
	echo Konnte $SRC_SETTINGS nicht finden!
	echo Programm wird geschlossen
	echo Finish!
	exit
fi

#AppData
SRC_APPDATA=$(egrep -w "SRC_APPDATA" $SRC_SETTINGS)
SRC_APPDATA=${SRC_APPDATA##*=}
echo AppData: $SRC_APPDATA

#Nextcloud
DIR_NEXTCLOUD=$(egrep -w "DIR_NEXTCLOUD" $SRC_SETTINGS)
DIR_NEXTCLOUD=${DIR_NEXTCLOUD##*=}

#Backup-Scripts
DIR_BACKUPSCRIPTS=$(egrep -w "DIR_BACKUPSCRIPTS" $SRC_SETTINGS)
DIR_BACKUPSCRIPTS=${DIR_BACKUPSCRIPTS##*=}

#Update-Scripts
DIR_UPDATESCRIPTS=$(egrep -w "DIR_UPDATESCRIPTS" $SRC_SETTINGS)
DIR_UPDATESCRIPTS=${DIR_UPDATESCRIPTS##*=}

#SubRoutinen
pullNewestNextcloud() {
	echo -e "\nDownloade nun das aktuellste Nextcloud Image\n"
	docker pull linuxserver/nextcloud:arm32v7-latest
	return $?
}

createNextcloud() {
	sleep 2
	echo -e "Halte Nextcloud an\n"
	docker stop Nextcloud

	sleep 2
	echo -e "Lösche alten Nextcloud-Docker-Containe\n"
	docker rm Nextcloud

	sleep 2
	echo -e "Erstelle neuen Nextcloud-Container mit Settings aus der Settings.txt\n"
	cd /
	cd /$DIR_UPDATESCRIPTS/
	./createNextcloudContainer.sh
}

askForBackup() {
	echo -e "\nSoll vor dem Update ein Backup des AppData-Ordners gemacht werden?\n "
	read -p "Gebe JA, NEIN, oder QUIT ein:" ANSWER

	if [ "$ANSWER" = "JA" ]; then
		cd /$DIR_BACKUPSCRIPTS/
		./start_backup.sh -appdata
		cd /$DIR_TEMP
	elif [ "$ANSWER" = "NEIN" ]; then
		echo -e " Fahre ohne Backup fort!\n"
	else
		echo -e "Update abgebrochen\n"
		echo Finish!
		exit
	fi
}

startUpdatingDocker() {
	echo -e "\nEs wird versucht das Nextcloud-Image zu updaten\n"
	pullNewestNextcloud
	retval=$?
	echo -e "Retval= $retval"
	if [ "$retval" = "2" ]; then
		echo -e "Der Container wurde erfolgreich heruntergeladen!\n Der Container wird nun neu erstellt!"
		askForBackup
		createNextcloud
	elif [ "$retval" = "0" ]; then
		echo -e "\nDer Container ist bereits aktuell!\n\nMoechstest du den Container trotzdem neu aufsetzen?"
		read -p " Antworte mit JA oder NEIN: " ASK
		if [ "$ASK" = "JA" ]; then
			askForBackup
			createNextcloud
		else
			echo Finish!
			exit
		fi
	else
		echo Huuuch, jetz hatz was gegeebe...Scheinbar hat der Download nicht geklappt!
	fi
}

startUpdatingNextcloud() {
	echo -e "\n Warte 30 Sekunden bis Container gestartet\n"
	sleep 30

	echo -e "\nStarte offiziellen Nextcloud-Updater...\n"
	docker exec Nextcloud sudo -u abc php /config/www/nextcloud/updater/updater.phar
}

#Parameterauswertung
if [ "$1" = "" ]; then
	echo -e "\n Keine Parameter angegeben! (-c Nur Container updaten; -a Alles updaten (Container, dann Nextcloud-Version)).\n"
	echo Finish!
	exit

elif [ "$1" = "-c" ]; then #Nur Container updaten
	startUpdatingDocker
	echo Finish!
	exit

elif [ "$1" = "-a" ]; then #Alles Updaten
	startUpdatingDocker
	startUpdatingNextcloud

else
	echo -e "\nDer Parameter den du angegeben hast ist mir nicht begannt. Versuch es mit -c Nur Container updaten; -a Alles updaten (Container, dann Nextcloud-Version))."
	echo Finish!
	exit
fi

#Script finalisieren (Cleanup & Exit)
cd /
echo -e "\n Entferne alte Docker-Images...\n"
docker image prune -f
sleep 10

echo Finish!
exit
