#!/bin/bash
FILE=/srv/dev-disk-by-label-WDRed_4TB_RAID
router="10.8.0.1"
interface="tun0"

ping -w 300 -c 1 ${router} > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Halte OpenVPN an"
	pgrep openvpn | xargs sudo kill -9
    echo "Restart VPN-Connection"
    sudo openvpn /etc/openvpn/client.ovpn &
	date >> $FILE/VPN_Reconnect.txt
	exit
else
	echo "VPN-Verbindung besteht, kein Reconnect notwendig!"      
	exit	
fi
