#!/bin/bash

# MOUNTING FILESYSTEM
# Mounting HDD/Raid-System
echo -e "Mounting HDD/Raid.."
mount -a
echo -e "Mounted. Wait for system to get ready..."

sleep 30 # Wait for system to get ready

# SERVICES
# Starting all OMV-Services which operate with or on HDDs
echo -e "Starting system-services..."
service minidlna start
service proftpd start
service smbd start
echo -e "All necessary services started! \n"

# DOCKER
# Starting all necessary Docker-Containers
echo -e "Starting Docker-Containers"
docker start NextcloudDB # Nextcloud Database
sleep 10                 # Wait for DB-Ready
docker start Nextcloud   # Nextcloud

echo -e "All necessary containers started! \n"

# END
echo -e "Finish!"
exit
