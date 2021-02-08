#!/bin/bash
#  This scripts installs an actual version of libseccomp2 which has a bug before
#  Without this fix, Nextcloud-Containers >20.0.4 will not work and also don't show errors in log
#  https://docs.linuxserver.io/faq#my-host-is-incompatible-with-images-based-on-ubuntu-focal-and-alpine-3-13
YELLOW="\[\033[1;33m\]" # Yellow
RED="\[\033[1;31m\]"    # Red
ENDCOLOR="\033[0m"

cd /
echo -e $YELLOW"Downloade libseccomp2..."$ENDCOLOR
wget http://ftp.us.debian.org/debian/pool/main/libs/libseccomp/libseccomp2_2.5.1-1_armhf.deb

echo -e $YELLOW"Installiere libsecomp2 v.2.5.1-1_armhf..."$ENDCOLOR
sudo dpkg -i libseccomp2_2.5.1-1_armhf.deb

echo -e $YELLOW"Entferne Installer..."$ENDCOLOR
rm libseccomp2_2.5.1-1_armhf.deb

echo -e $YELLOW"Finish!"$ENDCOLOR
exit
