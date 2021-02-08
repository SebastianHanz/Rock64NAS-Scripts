#!/bin/bash
#  This scripts installs an actual version of libseccomp2 which has a bug before
#  Without this fix, Nextcloud-Containers >20.0.4 will not work and also don't show errors in log
#  https://docs.linuxserver.io/faq#my-host-is-incompatible-with-images-based-on-ubuntu-focal-and-alpine-3-13

cd /
echo -e "Downloade libseccomp2..."
wget http://ftp.us.debian.org/debian/pool/main/libs/libseccomp/libseccomp2_2.5.1-1_armhf.deb

echo -e "Installiere libsecomp2 v.2.5.1-1_armhf..."
sudo dpkg -I libseccomp2_2.5.1-1_armhf.deb

echo -e "Finish!"
exit
