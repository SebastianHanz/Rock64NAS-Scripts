#!/bin/bash

# DOCKER
# Stopping all necessary Docker-Containers
echo -e "Stopping Docker-Containers"
docker stop Nextcloud
docker stop NextcloudDB
docker stop Nextcloud_TestEnv
docker stop NextcloudDB_TestEnv
echo -e "All necessary containers stopped! \n"

# SERVICED
# Stopping all OMV-Services which operate with or on HDDs
echo -e "Stopping system-services..."
service minidlna stop
service proftpd stop
service smbd stop
echo -e "All necessary services stopped! \n"

sleep 30 # Wait for system to get ready

# UNMOUNTING FILESYSTEM
# Unmounting HDD/Raid-System
echo -e "Unmounting HDD/Raid.."
umount /dev/md127
umount /dev/md127
echo -e "Unmounted. All done!"

# END
echo -e "Finish!"
exit
