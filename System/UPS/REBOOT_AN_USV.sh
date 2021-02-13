#!/bin/bash
### BEGIN INIT INFO
# Provides:          REBOOT_AN_USV
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Sendet USV, dass Server nun rebootet
### END INIT INFO

python /home/scripts/System/UPS/REBOOT_AN_USV.py
