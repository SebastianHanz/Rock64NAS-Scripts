#!/bin/bash
#SRC_SETTINGS muss immer zuerst angegeben werden!
SRC_SETTINGS="/home/scripts/Settings.txt"

#Verarbeite uebergebene Patameter
URL=$1 #Nehme Download-URL fuer Nextcloud-Paket entgegen incl. zu installierender Version
URL_SHA256=$URL.sha256
ZIPNAME=${URL##*/} #nextcloud-18.0.4.zip
NAME=${ZIPNAME%%.zip*} #nextcloud-18.0.4
SOLLVERSION=${NAME##*-} #18.0.4

#TempOrdner definieren
DIR_TEMP=$(egrep -w "DIR_TEMP" $SRC_SETTINGS)
DIR_TEMP=${DIR_TEMP##*=}/NextcloudDownloads

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

#Installierte Nextcloud-Version herausfinden
SRC_INSTALLEDVERSION="/$DIR_NEXTCLOUD/www/nextcloud/version.php"		#Beispiel:
INSTALLEDVERSION=$(egrep -w "OC_VersionString" $SRC_INSTALLEDVERSION)	#$OC_VersionString = '18.0.4';
INSTALLEDVERSION=${INSTALLEDVERSION##*" "} 	#'18.0.4';
INSTALLEDVERSION=${INSTALLEDVERSION%%;*}   	#'18.0.4'
INSTALLEDVERSION=${INSTALLEDVERSION//"'"}	#18.0.4

#SubRoutinen
checkCHECKSUM()
{

  if [ ! -f "./$ZIPNAME.sha256" ]; then
		wget $URL_SHA256
		echo -e "\nChecksumme heruntergeladen!\n"
  fi
  
  echo -e Vergleiche nun die Checksummen!
  FILE_SHA=$(cat /$DIR_TEMP/$ZIPNAME.sha256)
  FILE_SHA=${FILE_SHA%% *}
  echo -e "SOLL: $FILE_SHA"
  
  ZIP_SHA=$(sha256sum /$DIR_TEMP/$ZIPNAME)
  ZIP_SHA=${ZIP_SHA%% *}
  echo -e "IST:  $ZIP_SHA"
  
  if [ "$FILE_SHA" = "$ZIP_SHA" ]; then
	echo -e Die Checksummen sind identisch!
	return 0
  else
	echo -e "\n Die Checksumen stimmen nicht überein! Es liegt wohl eine falsche Datei vor!\n ABBRUCH\n"
	return -1
	echo Finish!
	exit
  fi
}

pullNewestNextcloud(){
echo -e "\nDownloade nun das aktuelle Nextcloud Image!\n"
docker pull linuxserver/nextcloud:latest
return $?
}

createNextcloud(){
sleep 2
echo -e Halte Nextcloud an
docker stop Nextcloud

sleep 2
echo -e Lösche alten Nextcloud-Docker-Container
docker rm Nextcloud

sleep 2
echo -e "Erstelle neuen Nextcloud-Container mit Settings aus der Settings.txt\n"
cd /
cd /$DIR_UPDATESCRIPTS/
./createNextcloudContainer.sh
}


#Lege Downloadordner für Nextcloud-Dateien an falls nicht vorhanden
if [ ! -d "$DIR_TEMP" ]; then
	cd /
	mkdir $DIR_TEMP
	cd /
	echo -e "Der Downloadordner für Nextcloud wurde angelegt!\n"
fi

#Wechsle in den Downloadordner
cd /$DIR_TEMP

#Ueberrüfe ob eine URL mit angegeben wurde
if [[ $URL == *"https://download.nextcloud.com/server/releases"* ]]; then #Wenn URL enthält
  echo -e "\n URL ist plausibel!\n Lade das angegebene Archiv und dessen Checksumme herunter!\n"
  cd /
  cd $DIR_TEMP
  
	  #Vergleiche zu installierende Version mit installierter Version
	if [[ "$SOLLVERSION" == "$INSTALLEDVERSION" ]]; then
		echo -e "\n Du hast diese Version bereits installiert! \n Installierte Version: $INSTALLEDVERSION \n Gewuenschte Version : $SOLLVERSION \n"
		echo -e " Die Installation wird abgebrochen! \n"
		echo Finish!
		exit
	else
		echo -e "\n Installierte Version: $INSTALLEDVERSION\n Gewuenschte Version : $SOLLVERSION\n"
	fi
  
  #Wenn Datei nicht bereits vorhanden, dann...
  if [ ! -f "./$ZIPNAME" ]; then
	  echo -e Lade aktuelles Archiv herunter!
	  wget $URL #https://download.nextcloud.com/server/releases/nextcloud-18.0.4.zip
	  echo -e Archiv geladen! Lade jetzt die Checksumme!
	  checkCHECKSUM
  else
	  echo -e Die Update-Datei ist bereits vorhanden!
	  checkCHECKSUM
  fi
else

#Falls keine URL angegeben, welcher Parameter denn dann?
if [ "$1" = "" ]; then
	echo -e "\n Keine Parameter angegeben! Bitte gebe als Parameter den offiziellen Downloadlink von Nextcloud zur ZIP-Datei ein.\n"
	echo Finish!
	exit
elif [ "$1" = "-c" ];then #Nur Container updaten
	echo -e "\nEs wird versucht das Nextcloud-Image zu updaten\n"
	pullNewestNextcloud
	retval=$?
	if [ "$retval" = "2" ]; then
		echo -e "Der Container wurde erfolgreich heruntergeladen!\n Der Container wird nun neu erstellt!"
		createNextcloud
	elif [ "$retval" = "0" ]; then
		echo -e "\nDer Container ist bereits aktuell!\n\nMoechstest du den Container trotzdem neu aufsetzen?"
		read -p " Antworte mit JA oder NEIN: " ASK
		if [ "$ASK" = "JA" ]; then
			createNextcloud
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

#Abfrage ob Backup gemacht werden soll
echo -e "\n Die Dateien liegen nun bereit zum Update. Soll ein Backup des AppData-Ordners gemacht werden?\n "
read -p "Gebe JA, NEIN, oder QUIT ein:" ANSWER


if [ "$ANSWER" = "JA" ]; then
	cd /$DIR_BACKUPSCRIPTS/
	./start_backup.sh -appdata
	cd /$DIR_TEMP
elif [ "$ANSWER" = "NEIN" ]; then
	echo -e " Fahre ohne Backup fort!\n"
else
echo Finish!
exit
fi

#Rufe die Pull-Routine auf
pullNewestNextcloud
createNextcloud
echo -e "\n Warte 30 Sekunden bis Container gestartet\n"
sleep 30
echo -e "\n Stoppe den Nextcloud-Container erneut\n"
docker stop Nextcloud

cd /$DIR_TEMP
unzip -bo ./$ZIPNAME  -d /$SRC_APPDATA/Nextcloud/www/
docker start Nextcloud
echo -e "\n Warte 30 Sekunden bis Container gestartet\n"
sleep 30

echo -e "\n Starte nun das automatische Upgradeprogramm innerhalb des Containers!\n Das kann ein paar Minuten dauern.\n"
docker exec Nextcloud sudo -u abc php /config/www/nextcloud/occ upgrade

echo -e "\n Das Update ist nun fertig!\n Sollen die heruntergeladenen Dateien in /$DIR_TEMP/ entfernt werden?\n"
read -p " Gebe JA, NEIN, oder QUIT ein:" ANSWER

if [ "$ANSWER" = "JA" ] || [ "$ANSWER" = "ja" ] ; then
	rm ./$ZIPNAME*
elif [ "$ANSWER" = "NEIN" ]; then
	echo Finish!
	exit
else
echo Finish!
exit
fi

cd /
echo -e "\n Raeume alte Dockerimages auf...\n"
docker image prune -f
echo Finish!
exit





























#unzip ./nextcloud-18.0.4.zip -d ./test