#!/bin/bash

#Settings for further cleanup optim.
#OLDCONF=$(dpkg -l | grep "^rc" | awk '{print $2}')
#CURKERNEL=$(uname -r | sed 's/-*[a-z]//g' | sed 's/-386//g')
#LINUXPKG="linux-(image|headers|ubuntu-modules|restricted-modules)"
#METALINUXPKG="linux-(image|headers|restricted-modules)-(generic|i386|server|common|rt|xen)"
#OLDKERNELS=$(dpkg -l | awk '{print $2}' | grep -E $LINUXPKG | grep -vE $METALINUXPKG | grep -v $CURKERNEL)

#echo $OLDCONF
#echo $CURKERNEL
#echo $LINUXPKG
#echo $METALINUXPKG
#echo $OLDKERNELS

YELLOW="\[\033[1;33m\]" # Yellow
RED="\[\033[1;31m\]"    # Red
ENDCOLOR="\033[0m"

if [ $USER != root ]; then
    echo -e $RED"Error: Du musst root sein"
    echo -e $YELLOW"Exiting..."$ENDCOLOR
    exit 0
fi

echo -e $YELLOW"Leere apt cache..."$ENDCOLOR
apt-get clean

echo -e $YELLOW"Entferne alle nicht mehr verwendete Pakete..."$ENDCOLOR
apt-get autoremove

if [ "$1" = "-l" ]; then
    echo -e $YELLOW"Entferne alte Logdateien..."$ENDCOLOR
    rm /var/log/*.gz >/dev/null 2>&1
    rm /var/log/*.log.* >/dev/null 2>&1
else
    echo -e $YELLOW"Finish!"$ENDCOLOR
    exit
fi
echo -e $YELLOW"Finish!"$ENDCOLOR
exit
