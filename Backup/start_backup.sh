#!/bin/bash
#Pfad zu Settings-Datei muss immer angegeben werden und stimmen!
SRC_SETTINGS="/home/scripts/Settings.txt"
VERSION=2.9a

if [ ! -f "$SRC_SETTINGS" ]; then
	echo Konnte $SRC_SETTINGS nicht finden!
	echo Programm wird geschlossen
	echo Finish!
	exit
fi

DATE=$(date +%d-%m-%Y-%H%M%S)

#Backup-Scripts
DIR_BACKUPSCRIPTS=$(egrep -w "DIR_BACKUPSCRIPTS" $SRC_SETTINGS)
DIR_BACKUPSCRIPTS=${DIR_BACKUPSCRIPTS##*=}

#AppData
SRC_APPDATA=$(egrep -w "SRC_APPDATA" $SRC_SETTINGS)
SRC_APPDATA=${SRC_APPDATA##*=}

#ioBroker
SRC_IOBROKER=$(egrep -w "SRC_IOBROKER" $SRC_SETTINGS)
SRC_IOBROKER=${SRC_IOBROKER##*=}

#OMVBACKUP
SRC_OMVBACKUP=$(egrep -w "SRC_OMVBACKUP" $SRC_SETTINGS)
SRC_OMVBACKUP=${SRC_OMVBACKUP##*=}

#SCRIPTS
SRC_SCRIPTS=$(egrep -w "SRC_SCRIPTS" $SRC_SETTINGS)
SRC_SCRIPTS=${SRC_SCRIPTS##*=}

#Backupordner
DEST_BACKUP=$(egrep -w "DEST_BACKUP" $SRC_SETTINGS)
DEST_BACKUP=${DEST_BACKUP##*=}

#Ziele
DEST_APPDATA=$(egrep -w "DEST_APPDATA" $SRC_SETTINGS)
DEST_APPDATA=${DEST_APPDATA##*=}

DEST_ARCHIVES=$(egrep -w "DEST_ARCHIVES" $SRC_SETTINGS)
DEST_ARCHIVES=${DEST_ARCHIVES##*=}

DEST_IOBROKER=$(egrep -w "DEST_IOBROKER" $SRC_SETTINGS)
DEST_IOBROKER=${DEST_IOBROKER##*=}

DEST_OMVBACKUP=$(egrep -w "DEST_OMVBACKUP" $SRC_SETTINGS)
DEST_OMVBACKUP=${DEST_OMVBACKUP##*=}

DEST_SCRIPTS=$(egrep -w "DEST_SCRIPTS" $SRC_SETTINGS)
DEST_SCRIPTS=${DEST_SCRIPTS##*=}

if [ "$SRC_APPDATA" = "" ] || [ "$SRC_IOBROKER" = "" ] || [ "$SRC_OMVBACKUP" = "" ] || [ "$SRC_SCRIPTS" = "" ] || [ "$DEST_BACKUP" = "" ] || [ "$DEST_APPDATA" = "" ] || [ "$DEST_IOBROKER" = "" ] || [ "$DEST_OMVBACKUP" = "" ] || [ "$DEST_SCRIPTS" = "" ]; then
	echo -e "\n Es stimmt etwas mit deinen Pfaden nicht!\n\n Ueberpruefe deine Pfade mit dem checkSettings.sh-Script!\n"
	echo -e " Soll dieses jetzt ausgefuehrt werden?\n"
	read -p " Gebe JA, NEIN, oder QUIT ein:" ANSWER

	if [ "$ANSWER" = "JA" ]; then
		cd /$DIR_BACKUPSCRIPTS
		./checkSettings.sh
		cd /
	else
		echo Finish!
		exit
	fi
	echo Finish!
	exit
fi

#Finde neueste FSA-Datei im Backupordner
newestOMVBackup=$(cd /$SRC_OMVBACKUP && ls -rt1 | tail -1)

#Schneide ".xxxx" ab
newestOMVBackup=${newestOMVBackup%%.*}

#Definiere alle OMVBACKUP-Dateien
OMVBACKUP=$SRC_OMVBACKUP/$newestOMVBackup.*

#Definiere Zwischenteil des resultierenden Dateinamens für das Archiv. Setzt sich zusammen aus den beinhaltenden Backup-Ordnern
FILENAME=$*                #Summe aller Parameter
FILENAME=${FILENAME//" "/} #Entfernt Leerzeichen

#Definiere Dateigröße der FSA-Datei in OMVBACKUP
cd /
cd /$SRC_OMVBACKUP/
FILESIZE=$(du -h $newestOMVBackup.fsa)
FILESIZE=${FILESIZE%%b*} #Schneide Dateinamen hinter der Größe ab
cd /

#Verzeichnisse anlegen wenn diese noch nicht existieren
if [ ! -d "$DEST_BACKUP" ]; then
	cd / && mkdir "/$DEST_BACKUP/"
	echo Das Backupverzeichnis wurde angelegt
fi

if [ ! -d "$DEST_APPDATA" ]; then
	cd / && mkdir "/$DEST_APPDATA/"
	echo Ordner "AppData" wurde im Backup-Verzeichnis angelegt
fi

if [ ! -d "$DEST_ARCHIVES" ]; then
	cd / && mkdir "/$DEST_ARCHIVES/"
	echo Ordner "Archives" wurde im Backup-Verzeichnis angelegt
fi

if [ ! -d "$DEST_IOBROKER" ]; then
	cd / && mkdir "/$DEST_IOBROKER/"
	echo Ordner "ioBroker" wurde im Backup-Verzeichnis angelegt
fi

if [ ! -d "$DEST_OMVBACKUP" ]; then
	cd / && mkdir "/$DEST_OMVBACKUP/"
	echo Ordner "omvbackup" wurde im Backup-Verzeichnis angelegt
fi

if [ ! -d "$DEST_SCRIPTS" ]; then
	cd / && mkdir "/$DEST_SCRIPTS/"
	echo Ordner "scripts" wurde im Backup-Verzeichnis angelegt
fi

#Kopierroutinen
copyAppData() {
	echo -e "\n################################### AppData #############################################"
	infoTEXT $DEST_APPDATA -appdata
	echo -e "Exportiere Nextcloud-Datenbank in AppData\n"
	docker exec NextcloudDB sh -c "mysqldump -u root -prock64mysql nextcloud > /config/nextcloud-database-backup.sql"

	echo -e "Halte MariaDB  und Nextcloud an\n"
	docker stop Nextcloud
	docker stop NextcloudDB

	#Optionale Testumgebungen stoppen, falls diese laufen
	docker stop Nextcloud_TestEnv
	docker stop NextcloudDB_TestEnv >/dev/null 2>&1

	echo -e "Beginne mit dem Kopiervorgang...Bitte warten\n"
	rsync -ah -P /$SRC_APPDATA /$DEST_APPDATA/backup-appdata-$DATE
	echo "$VERSIONSINFORMATION" >/$DEST_APPDATA/backup-appdata-$DATE/VERSIONSINFO.txt
	echo -e "\nAppData-Backup erfolgreich beendet!\n"

	echo -e "Starte MariaDB und Nextcoud wieder\n"
	docker start NextcloudDB
	sleep 10
	docker start Nextcloud
	sleep 10
}

copyIOBroker() {
	echo -e "\n################################### ioBroker ############################################"
	infoTEXT $DEST_IOBROKER -iobroker
	echo -e "Halte ioBroker an\n"
	iobroker stop

	echo -e "Beginne mit dem Kopiervorgang...Bitte warten\n"
	rsync -ah -P /$SRC_IOBROKER /$DEST_IOBROKER/backup-iobroker-$DATE
	echo "$VERSIONSINFORMATION" >/$DEST_IOBROKER/backup-iobroker-$DATE/VERSIONSINFO.txt
	echo -e "IoBroker-Backup erfolgreich beendet!\n"

	echo -e "Starte ioBroker wieder\n"
	iobroker start
	echo -e "IoBroker-Backup erfolgreich beendet!\n"
}

copyOMVBACKUP() {
	echo -e "\n################################### OMVBACKUP ###########################################"
	infoTEXT $DEST_OMVBACKUP -omvbackup

	echo -e "Beginne mit dem Kopiervorgang...Bitte warten\n"
	cd /$DEST_OMVBACKUP/ && mkdir "./backup-omvbackup-$DATE"
	rsync -ah -P /$SRC_OMVBACKUP/$newestOMVBackup.* /$DEST_OMVBACKUP/backup-omvbackup-$DATE/
	echo "$VERSIONSINFORMATION" >/$DEST_OMVBACKUP/backup-omvbackup-$DATE/VERSIONSINFO.txt
	echo -e "OMVBACKUP-Backup erfolgreich beendet!\n"
}

copyScripts() {
	echo -e "\n################################### Scripts #############################################"
	infoTEXT $DEST_SCRIPTS -scripts

	echo -e "Beginne mit dem Kopiervorgang...Bitte warten\n"
	rsync -ah -P /$SRC_SCRIPTS /$DEST_SCRIPTS/backup-scripts-$DATE
	echo "$VERSIONSINFORMATION" >/$DEST_SCRIPTS/backup-scripts-$DATE/VERSIONSINFO.txt
	echo -e "Scripts-Backup erfolgreich beendet!\n"
}

#Info, welche nach der Eingabe des Backupauftrages mehrerer Ordner zu einem Archiv erscheint.
infoARCHIVES() {
	echo
	echo '#########################################################################################'
	echo ' Dein Backup wird jetzt ins Verzeichnis '$DEST_ARCHIVES 'gesichert!'
	echo ' Dies kann eine Weile dauern! '
	echo ' Bitte lass das Konsolenfenster offen bis das Backup abgeschlossen ist!'
	echo ' Das Archiv wird backup'$FILENAME-$DATE.tar.bz 'heißen.'
	echo '#########################################################################################'
	sleep 5
	echo
	echo 'Starte Archivierung...'
	echo
}

infoTEXT() {

	echo '#########################################################################################'
	echo ' v.'$VERSION
	echo ' Dein Backup wird jetzt ins Verzeichnis '$1' gesichert!'
	echo ' Dies kann eine Weile dauern! '
	echo ' Bitte lass das Konsolenfenster offen bis das Backup abgeschlossen ist!'
	echo ' Die Dateien werden im Ordner 'backup$2-$DATE 'liegen.'
	echo '#########################################################################################'
	sleep 5
	echo
	echo 'Starte Backup...'
	echo
}

#Info welche erscheint, wenn ein -all Backup angefordert wurde
infoALL() {
	echo
	echo '#########################################################################################'
	echo ' Das aktuelle OMVBackup ist: '$newestOMVBackup [$FILESIZE]
	echo '#########################################################################################'
	echo

	if [ "$1" = "-zip" ]; then
		echo ' Es werden ALLE voreingestellten Pfade ins Verzeichnis '$DEST_ARCHIVES 'gesichert!'
		echo ' Die Datei wird backup'$FILENAME-$DATE.tar.bz 'heißen.'
	fi

	if [ "$1" = "-folder" ]; then
		echo ' Es werden ALLE voreingestellten Pfade ins Verzeichnis '$DEST_BACKUP 'gesichert!'
		echo ' Die Dateien werden dort in ihre jeweiligen Unterordner kopiert.'
	fi
	echo
	echo ' Dies kann eine Weile dauern! '
	echo ' Bitte lass das Konsolenfenster offen bis das Backup abgeschlossen ist!'
	echo
	echo '#########################################################################################'
	echo
	if [ "$1" = "-zip" ]; then
		echo
		echo ' Archivierung beginnt jetzt! Leider kann sieht man den Fortschritt nicht...'
		echo ' Eine Meldung informiert dich, wenn das Backup fertig ist.'
		echo
	fi
}

infoOMVBACKUP() {
	echo
	echo '#########################################################################################'
	echo
	echo ' Das aktuelle OMVBackup ist: '$newestOMVBackup [$FILESIZE]
}

helpPage() {
	echo
	echo '############################ Automated Backup Script ####################################'
	echo
	echo ' Die moeglichen Parameter sind:'
	echo ' -all 			Backupt alle voreingestelten Quellen'
	echo ' -appdata	 	Backupt das AppData-Verzeichnis'
	echo ' -iobroker		Backupt das ioBroker-Verzeichnis'
	echo ' -omvbackup		Backupt das OMVBACKUP-Verzeichnis'
	echo ' -scripts		Backupt das Script-Verzeichnis'
	echo
	echo ' Moeglich sind auch Kombinationen, bspw:'
	echo ' "./start_backup.sh -iobroker -appdata" um nur diese beiden zu sichern.'
	echo ' Soll das Backup archiviert werden, so muss der Parameter -zip angegeben werden'
	echo
	echo ' Die Quell- und Zielverzeichnisse werden in der Datei Settings.txt festgelegt'
	echo
	echo '############################  v.'$VERSION' Sebastian Hanz   #############################'
	echo

}

if [[ "$*" == *"-zip"* ]]; then

	case "$1" in
	-all)
		SOURCE="$SRC_APPDATA $SRC_IOBROKER $OMVBACKUP $SRC_SCRIPTS "
		infoALL -zip
		;;
	-iobroker)
		SOURCE="$SRC_IOBROKER "
		infoARCHIVES
		;;
	-appdata)
		SOURCE="$SRC_APPDATA "
		infoARCHIVES
		;;
	-omvbackup)
		SOURCE="$OMVBACKUP "
		infoARCHIVES
		;;
	-scripts)
		SOURCE="$SRC_SCRIPTS "
		infoARCHIVES
		;;
	-zip) ;;

	--help | -h)
		helpPage
		;;
	esac

	case "$2" in
	-iobroker)
		SOURCE+="$SRC_IOBROKER "
		;;
	-appdata)
		SOURCE+="$SRC_APPDATA "
		;;
	-omvbackup)
		SOURCE+="$OMVBACKUP "
		;;
	-scripts)
		SOURCE="$SRC_SCRIPTS "
		;;
	-zip) ;;

	esac

	case "$3" in
	-iobroker)
		SOURCE+="$SRC_IOBROKER "
		;;
	-appdata)
		SOURCE+="$SRC_APPDATA "
		;;
	-omvbackup)
		SOURCE+="$OMVBACKUP "
		;;
	-scripts)
		SOURCE="$SRC_SCRIPTS "
		;;
	-zip) ;;

	esac

	case "$4" in
	-iobroker)
		SOURCE+="$SRC_IOBROKER "
		;;
	-appdata)
		SOURCE+="$SRC_APPDATA "
		;;
	-omvbackup)
		SOURCE+="$OMVBACKUP "
		;;
	-scripts)
		SOURCE="$SRC_SCRIPTS "
		;;
	-zip) ;;

	esac

	case "$5" in
	-iobroker)
		SOURCE+="$SRC_IOBROKER "
		;;
	-appdata)
		SOURCE+="$SRC_APPDATA "
		;;
	-omvbackup)
		SOURCE+="$OMVBACKUP "
		;;
	-scripts)
		SOURCE="$SRC_SCRIPTS "
		;;
	-zip) ;;

	esac

	case "$6" in
	-iobroker)
		SOURCE+="$SRC_IOBROKER "
		;;
	-appdata)
		SOURCE+="$SRC_APPDATA "
		;;
	-omvbackup)
		SOURCE+="$OMVBACKUP "
		;;
	-scripts)
		SOURCE="$SRC_SCRIPTS "
		;;
	-zip) ;;

	esac

	cd /
	read -p "Gib eine Versionsinformation an: " VERSIONSINFORMATION
	echo
	echo "$VERSIONSINFORMATION" >/$DEST_ARCHIVES/backup$FILENAME-$DATE.VERSIONSINFO.txt

	# Halte zuerst alle notwendigen Docker-Container an und mache den MariaDB-Export
	echo -e "Exportiere Nextcloud-Datenbank in AppData\n"
	docker exec NextcloudDB sh -c "mysqldump -u root -prock64mysql nextcloud > /config/nextcloud-database-backup.sql"

	echo -e "Halte MariaDB  und Nextcloud an\n"
	docker stop Nextcloud
	docker stop NextcloudDB

	#Optionale Testumgebungen stoppen, falls diese laufen
	docker stop Nextcloud_TestEnv
	docker stop NextcloudDB_TestEnv >/dev/null 2>&1

	echo -e "Beginne mit dem Kopiervorgang...Bitte warten\n"
	tar -vcjpf $DEST_ARCHIVES/backup$FILENAME-$DATE.tar.bz2 $SOURCE
	echo 'Das Archiv wurde erfolgreich erstellt!'

	echo -e "Starte MariaDB und Nextcoud wieder\n"
	docker start NextcloudDB
	sleep 10
	docker start Nextcloud
	sleep 10

else

	if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$1" = "" ]; then
		helpPage
		echo Finish!
		exit
	fi

	if [[ "$*" == *"-all"* ]]; then
		infoALL -folder
		read -p "Gib eine Versionsinformation an: " VERSIONSINFORMATION
		echo

		copyAppData $VERSIONSINFORMATION
		copyIOBroker $VERSIONSINFORMATION
		copyOMVBACKUP $VERSIONSINFORMATION
		copyScripts $VERSIONSINFORMATION

		echo -e "\nAlle Backups wurden durchgefuehrt!\n"
		echo Finish!
		exit

	else
		#Wenn nicht ZIP und nicht ALL, dann Einzelbackups
		if [[ "$*" == *"-appdata"* ]]; then
			copyAppData
		fi

		if [[ "$*" == *"-iobroker"* ]]; then
			copyIOBroker
		fi

		if [[ "$*" == *"-omvbackup"* ]]; then
			copyOMVBACKUP
		fi

		if [[ "$*" == *"-scripts"* ]]; then
			copyScripts
		fi
	fi
fi
echo Finish!
