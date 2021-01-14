#!/bin/bash
### BEGIN INIT INFO
# Provides:          SHUTDOWN_AN_USV
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Sendet USV, dass Server nun herunterfaehrt
### END INIT INFO

python /home/scripts/SHUTDOWN_AN_USV.py

