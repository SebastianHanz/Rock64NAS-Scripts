# Rock64NAS-Scripts    
# Scripts für den Rock64NAS
Verzeichnis für diese Repository: "/home/scripts"
## SETTINGS


Bevor automatisierte Scripts auf deinem Server ausgeführt werden können, musst du die "#Settings.txt" in Settings.txt umbenennen und an deine Systemvariablen anpassen. 

    mv /home/scripts/#Settings.txt /home/scripts/Settings.txt
    nano /home/scripts/Settings.txt

Beachte die Hinweise in dieser Datei, damit alle Pfade und Variablen richtig angelegt werden können.
Wenn die Datei abgeändert ist, speichere diese mit "STRG+X" und bestätige das ganze mit "y" und ENTER.
Die Systemvariablen sind jetzt definiert und können hier später wieder geändert werden. Um die Pfadangaben zu überprüfen, führe das checkSettings-Script aus:

    /home/scripts/Backup/checkSettings.sh

Über die Konsole wird der interpretierte Inhalt der Settings.txt ausgegeben. Überprüfe hier, ob alle Variablen korrekt sind, denn so wie hier angezeigt wird der Server mit diesen arbeiten.
***

## BACKUP

Um ein automatisiertes Backup auszuführen, starte das Backup-Script ein erstes Mal.

    /home/scripts/Backup/start_backup.sh -h

Die Help-Page zeigt dir die Möglichkeiten dieses Scripts.

### Beispiel für ein Vollbackup, welches zu einem einzigen Archiv gepackt wird
    /home/scripts/Backup/start_backup.sh -all -zip

### Beispiel für ein Teilbackup des AppData-Ordners, bspw. vor einem Nextcloud-Update
    /home/scripts/Backup/start_backup.sh -appdata
***

## Fixxes

Wenn Funktionen des Servers aufgrund fehlender Libraries oder Inkompatibilitäten nicht richtig oder garnicht funktionieren, stelle ich hier scripts bereit, die diese Funktion wiederherstellen oder erst ermöglichen

* ADDED: Script zur Aktualisierung von libseccomp2 auf eine neue Version
damit Nextcloud-Container 
'>20.0.4' lauffähig sind

***

## System

Die System-Scripts verwalten einige Serverspezifische Systemaufgaben und beinhalten auch nützliche Systemtools.
***    
### Das Aufräum-Script `cleanup.sh`.     
Entfernt nicht mehr benötigte temporäre Dateien, caches und nicht mehr benötigte Software automatisch (Nutzerzustimmung über Konsole möglich)

Beispiel für eine einfache Systemreinigung (Apt-cache, apt-clean, apt-autoremove)

    /home/scripts/System/cleanup.sh

Sollen ebenfalls alte Log-Dateien entfernt werden, so muss der Parameter -l übergeben werden. Beachte, dass hierbei zwar Speicherplatz frei wird, diagnosen über vergangene Systemprobleme können dann aber nichtmehr anhand der Log-Dateien gemacht werden. Ebenso ist das folgende Script "findBadAccess.sh" nur noch für die Analyse der aktuellen auth.log anwendbar (kürzlich geschehene Logins).

    /home/scripts/System/cleanup.sh -l
***
### Das Failed-Logins Diagnose-Script `findBadAccess.sh`
Dieses Script durchsucht die Logdatei(en) nach fehlgeschlagenen Loginversuchen in SSH oder OMV-WebGui und listet diese mit zugehöriger IP-Adresse und user auf. Sollten hier Unregelmäßigkeiten erkennbar sein, können notwendige Absicherungsschritte eingeleitet werden (Ports sperren, Firewall...)

    /home/scripts/System/findBadAccess.sh
***
### HDD's bei Laune halten mit `keep_HDD_alive.sh`
Weil bei manchen Festplattenherstellern der Energiesparmodus nicht oder nur schwierig deaktiviert werden kann, wird hier eine einfache Bschäftigungsmethode für die 24/7 HDDs kreiert.
Ein einfacher Zeitstempel jede Minute in eine Textdatei in einem Verzeichnis deiner Wahl genügt, dass die Festplatten sich nicht automatisch abschalten. Zudem lässt sich sehr einfach analysieren wann der Server ansgeschaltet war, oder ab wann dieser nicht mehr erreichbar war bei einem Systemabsturz etc. __Dieses Script muss über die OMV-GUI über eine geplante Aufgabe jede Minute ausgeführt werden.__