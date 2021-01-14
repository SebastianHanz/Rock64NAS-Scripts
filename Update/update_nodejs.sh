#!/bin/bash
echo -e "\n Halte ioBroker an \n"
iobroker stop

echo -e" Initialisiere NodeJS auf Version 12\n"
sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -

sudo apt-get update
echo -e "\nInstalliere NodeJS Version 12\n"

sudo apt-get install -y nodejs

echo -e "\n Starte ioBroker wieder\n"
iobroker start
echo -e "\nAktualisierung abgeschlossen!\n"
echo Finish!
exit

