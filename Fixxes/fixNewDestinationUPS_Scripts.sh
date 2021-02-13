#!/bin/bash
# This script will reconfigure the UPS-Service to match the new UPS-Scripts-path
# from /home/scripts to /home/scripts/System/UPS

# Copy new Services to Systemd location
cp ../etc/systemd/system/REBOOT_AN_USV.service /etc/systemd/system/REBOOT_AN_USV.service
cp ../etc/systemd/system/SHUTDOWN_AN_USV.service /etc/systemd/system/SHUTDOWN_AN_USV.service

# Enabling new Services
echo -e "Enabling new services..."
systemctl enable REBOOT_AN_USV.service
systemctl enable SHUTDOWN_AN_USV.service

echo -e "Finish!"
