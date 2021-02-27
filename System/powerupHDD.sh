#!/bin/bash

# Mounting HDD/Raid-System
echo -e "Mounting HDD/Raid.."
mount -a
echo -e "Mounted."

# Starting all OMV-Services which operate with or on HDDs
echo -e "Starting system-services..."
service minidlna start
service proftpd start
service smbd start
echo -e "All necessary services started! \n"

# Starting all necessary Docker-Containers
echo -e "Starting Docker-Containers"
docker start NextcloudDB
docker start Nextcloud
docker start Nextcloud_TestEnv
docker start NextcloudDB_TestEnv
echo -e "All necessary containers started! \n"
echo -e "Finish!"
exit
