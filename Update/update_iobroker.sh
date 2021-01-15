#!/bin/bash
#This script will automatically update your whole ioBroker-System including adapters

echo -e "Stopping ioBroker...\n"
iobroker stop

echo -e"\nUpdating database...\n"
iobroker update

echo -e "\nUpdate ioBroker. This may take a while..\n"
iobroker upgrade self

echo -e "\nUpgrade all updatable adapters\n"
iobroker upgrade

echo -e "\nRestarting ioBroker\n"
iobroker start

echo -e "\nAll done!\n"
echo Finish!
exit