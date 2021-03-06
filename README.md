# Rock64NAS-Scripts    

# Installation
Um diese Repository auf deinen Server zu clonen, gehe wie folget vor: 
   
Schritt 1: __Falls der Ordner /home/scripts noch nicht existiert, lege diesen an:__

    mkdir /home/scripts

Schritt 2: __Wechsle anschließend in dieses Verzeichnis:__

    cd /home/scripts

Schritt 3: __Falls dein scripts-Ordner neu erstellt wurde _und leer ist_, führe folgendes aus, sonst gehe zu Schritt 4:__

    git clone https://github.com/SebastianHanz/Rock64NAS-Scripts/ ./

Schritt 4: __Wenn dein scripts-Ordner _bereits andere Dateien von dir beinhaltet_, dann führe folgendes aus, sonst zu Schritt 5:__

    git clone https://github.com/SebastianHanz/Rock64NAS-Scripts/ /tmp/gitRockNAS && cp -r /tmp/gitRockNAS/* /home/scripts && rm -r /tmp/gitRockNAS

Schritt 5: __Um diese Scripte nun ausführbar zu machen, genügt folgender Befehl:__

    chmod -R +x /home/scripts/*

## Aktualisierung der Repository

Um diese Repo mit deinem Server auch in Zukunft einfach abzugleichen, genügt es das automatisierte `update_scripts_Repository.sh` auszuführen. 

   __ACHTUNG: Falls du außer in Settings.txt selbst Änderungen gemacht hast, werden diese Dateien mit denen von GitHub überschrieben. Falls du eigene Scripte auf Basis meiner verwenden möchtest, dann benenne diese stets um, bspw. indem du `self_` vor den Dateinamen schreibst__

    /home/scripts/Update/update_scripts_Repository.sh
# SETTINGS

Bevor automatisierte Scripts auf deinem Server ausgeführt werden können, musst du die "#Settings.txt" in Settings.txt umbenennen und an deine Systemvariablen anpassen. 

    mv /home/scripts/#Settings.txt /home/scripts/Settings.txt
    nano /home/scripts/Settings.txt

Beachte die Hinweise in dieser Datei, damit alle Pfade und Variablen richtig angelegt werden können.
Wenn die Datei abgeändert ist, speichere diese mit "STRG+X" und bestätige das ganze mit "y" und ENTER.
Die Systemvariablen sind jetzt definiert und können hier später wieder geändert werden. Um die Pfadangaben zu überprüfen, führe das checkSettings-Script aus:

    /home/scripts/Backup/checkSettings.sh

Über die Konsole wird der interpretierte Inhalt der Settings.txt ausgegeben. Überprüfe hier, ob alle Variablen korrekt sind, denn so wie hier angezeigt wird der Server mit diesen arbeiten.
***
# BACKUP

Um ein automatisiertes Backup auszuführen, starte das Backup-Script ein erstes Mal.

    /home/scripts/Backup/start_backup.sh -h

Die Help-Page zeigt dir die Möglichkeiten dieses Scripts.

#### Beispiel für ein Vollbackup, welches zu einem einzigen Archiv gepackt wird
    /home/scripts/Backup/start_backup.sh -all -zip

#### Beispiel für ein Teilbackup des AppData-Ordners, bspw. vor einem Nextcloud-Update
    /home/scripts/Backup/start_backup.sh -appdata
***
# Fixxes

Wenn Funktionen des Servers aufgrund fehlender Libraries oder Inkompatibilitäten nicht richtig oder garnicht funktionieren, stelle ich hier Scripts bereit, die diese Funktion wiederherstellen oder erst ermöglichen

***
# System

Die System-Scripts verwalten einige Serverspezifische Systemaufgaben und beinhalten auch nützliche Systemtools.

## Das Aufräum-Script `cleanup.sh`.     
Entfernt nicht mehr benötigte temporäre Dateien, caches und nicht mehr benötigte Software automatisch (Nutzerzustimmung über Konsole möglich)

Beispiel für eine einfache Systemreinigung (Apt-cache, apt-clean, apt-autoremove)

    /home/scripts/System/cleanup.sh

Sollen ebenfalls alte Log-Dateien entfernt werden, so muss der Parameter -l übergeben werden. Beachte, dass hierbei zwar Speicherplatz frei wird, diagnosen über vergangene Systemprobleme können dann aber nichtmehr anhand der Log-Dateien gemacht werden. Ebenso ist das folgende Script "findBadAccess.sh" nur noch für die Analyse der aktuellen auth.log anwendbar (kürzlich geschehene Logins).

    /home/scripts/System/cleanup.sh -l

## Das Failed-Logins Diagnose-Script `findBadAccess.sh`
Dieses Script durchsucht die Logdatei(en) nach fehlgeschlagenen Loginversuchen in SSH oder OMV-WebGui und listet diese mit zugehöriger IP-Adresse und user auf. Sollten hier Unregelmäßigkeiten erkennbar sein, können notwendige Absicherungsschritte eingeleitet werden (Ports sperren, Firewall...)

    /home/scripts/System/findBadAccess.sh
## HDDs bei Laune halten mit `keep_HDD_alive.sh`
Weil bei manchen Festplattenherstellern der Energiesparmodus nicht oder nur schwierig deaktiviert werden kann, wird hier eine einfache Bschäftigungsmethode für die 24/7 HDDs kreiert.
Ein einfacher Zeitstempel jede Minute in eine Textdatei in einem Verzeichnis deiner Wahl genügt, dass die Festplatten sich nicht automatisch abschalten. Zudem lässt sich sehr einfach analysieren wann der Server ansgeschaltet war, oder ab wann dieser nicht mehr erreichbar war bei einem Systemabsturz etc. __Dieses Script muss über die OMV-GUI über eine geplante Aufgabe jede Minute ausgeführt werden.__

## HDDs aus/einschalten mit `powerdownHDD.sh` und `powerupHDD.sh`
Ermöglicht das einfache ausschalten der Festplatten im RAID-Verbund wenn diese über längere Zeit nicht benötigt werden, andere Funktionen des Servers jedoch erhalten bleiben sollen (ioBroker, PiHole...).  
__powerdownHDD:__ Beendet alle Dienste (Samba, DLNA..) und Container welche auf das RAID zugreifen und hängt die Partition danach aus, damit die Festplatten nicht aufgeweckt werden können. _Der FTP-Adapter in OMV sollte im Idealfall dauerhaft deaktiviert sein_   
__powerupHDD:__ Hängt die Partition wieder ins System ein und startet anschließend alle Dienste und Container welche auf das RAID zugreifen.

***

# Update
Dieses Verzeichnis beinhaltet Update- und Hilfsscripts rund um die Aktualisierung deines Servers und dessen Docker-Container. Wenn die Möglichkeit besteht bereits funktionierende Container über __Portainer__ zu aktualisieren, dann ist dies die vorrangige Variante. Ist Portainer nicht installiert, so können die Docker-Container über die Scripte aktuell gehalten werden. Zum Erstellen der Container werden Pfade und Systemvariablen aus der `Settings.txt` verwendet.

## IoBroker aktualisieren mit `update_iobroker.sh`
Vollständiges Update der IoBroker Base + Aktualisierung aller installierter Adapter.    
   __Achtung: IoBroker wird hierfür angehalten__

    /home/scripts/Update/update_iobroker.sh

## Update Server `update_server.sh`
Das Script verwendet die offizielle [OMV-Update-Routine](https://openmediavault.readthedocs.io/en/latest/various/apt.html?highlight=update) zum aktualisieren der Paketdatenbank und aller anstehenden Softwareupdates.
Zusätzlich wird im Anschluss ein Cleanup ausgeführt.

    /home/scripts/Update/update_server.sh

## Update Nextcloud Docker-Container mit `update_nextcloud_official.sh`
Der offizielle Weg Nextcloud aktuell zuhalten, ist zuerst den Docker-Container auf die aktuelle Version zu bringen und danach die interne Update-Routine auszuführen. Da der interne Updater oft Probleme macht, erledigt dieses Script den kompletten Updatevorgang incl. möglichem Backup zuvor vollständig.

Beispiel: Nur Docker-Container updaten (nur wenn kein Portainer verfügbar)

    /home/scripts/Update/update_nextcloud_official.sh -c

Beispiel: Komplettes Nextcloud-Update (z.B. nach erfolgreichem Docker-Update mit Portainer)

    /home/scripts/Update/update_nextcloud_official.sh -a

## Changelog
* ADDED: 02.07.21 `fixIoBrokerUpdateProblem.sh`. Sollten beim IoBroker-Update via Script oder manuell Fehler auftauchen oder Updates einfach nicht funktionieren, kann dieses Script Abhilfe schaffen

* IMPROVED: 06.03.21 Backup-Script für AppData angepasst: Die Datenbank der Nextcloud wird vor dem Backup mit dem offiziellen SQL-Methode exportiert und im Anschluss gesichert

* ADDED: 03.03.21 `powerdownHDD.sh` und `powerupHDD.sh` in __System__.

* ADDED: 13.02.21 `fixNewDestinationUPS_Scripts.sh`. Script ändert den Pfad der USV-Kommunikationsscripts von /home/scripts nach /home/scripts/System/UPS und passt die Systemservices darauf an. Dieser Fix hat nur kosmetische Zwecke

* ADDED: 09.02.21 `fixNextcloudGreater20.0.4_Problem` zur Aktualisierung von libseccomp2 auf eine neue Version
damit Nextcloud-Container 
'>20.0.4' lauffähig sind