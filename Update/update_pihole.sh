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
DIR_APPDATA=$(egrep -w "SRC_APPDATA" $SRC_SETTINGS)
DIR_APPDATA=${SRC_APPDATA##*=}

#Pihole
DIR_PIHOLE=$(egrep -w "DIR_PIHOLE" $SRC_SETTINGS)
DIR_PIHOLE=${DIR_PIHOLE##*=}

#Backup-Scripts
DIR_BACKUPSCRIPTS=$(egrep -w "DIR_BACKUPSCRIPTS" $SRC_SETTINGS)
DIR_BACKUPSCRIPTS=${DIR_BACKUPSCRIPTS##*=}

#Update-Scripts
DIR_UPDATESCRIPTS=$(egrep -w "DIR_UPDATESCRIPTS" $SRC_SETTINGS)
DIR_UPDATESCRIPTS=${DIR_UPDATESCRIPTS##*=}

pullNewestPiHole() {
	echo -e "\nDownloade nun das aktuelle PiHole Image!\n"
	docker pull docker.io/pihole/pihole:dev-armhf
	return $?
}

createPiHole() {
	sleep 2
	echo -e Halte PiHole an
	docker stop pihole

	sleep 2
	echo -e Loesche alten PiHole-Docker-Container
	docker rm pihole

	sleep 2
	echo -e "Erstelle neuen Pihole-Container mit Settings aus der Settings.txt\n"
	cd /
	cd /$DIR_UPDATESCRIPTS/
	./createPiHoleContainer.sh
}

#Falls keine URL angegeben, welcher Parameter denn dann?
if [ "$1" = "" ]; then
	echo -e "\n Keine Parameter angegeben! \n"
	echo -e "Finish!"
	exit
elif [ "$1" = "-c" ]; then #Nur Container updaten
	#Abfrage ob Backup gemacht werden soll
	echo -e Die Dateien liegen nun bereit zum Update. Soll ein Backup des AppData-Ordners gemacht werden?
	read -p "Gebe JA, NEIN, oder QUIT ein:" ANSWER

	if [ "$ANSWER" = "JA" ]; then
		cd /$DIR_BACKUPSCRIPTS/
		./start_backup.sh -appdata
		cd /
	elif [ "$ANSWER" = "NEIN" ]; then
		echo -e " Fahre ohne Backup fort!\n"
	else
		echo -e "Finish!"
		exit
	fi

	echo -e "\nEs wird versucht das PiHole-Image zu updaten\n"
	pullNewestPiHole
	retval=$?
	if [ "$retval" = "2" ]; then
		echo -e "Der Container wurde erfolgreich heruntergeladen!\n Der Container wird nun neu erstellt!"
		createPiHole
	elif [ "$retval" = "0" ]; then
		echo -e "\nDer Container ist bereits aktuell!\n\nMoechstest du den Container trotzdem neu aufsetzen?"
		read -p " Antworte mit JA oder NEIN: " ASK
		if [ "$ASK" = "JA" ]; then
			createPiHole

			# This will maybe be a future feature but not working in docker containers in the moment
			# docker exec pihole /opt/pihole/update.sh

			echo -e "Finish!"
			exit
		else
			echo -e "Finish!"
			exit
		fi
	else
		echo Huuuch, jetz hatz was gegeebe...Scheinbar hat der Download nicht geklappt!
	fi
	echo -e "Finish!"
	exit
fi

cd /
echo -e "\n Raeume alte Docker Images auf...\n"
docker image prune -f
sleep 5
echo -e "Finish!"
exit
