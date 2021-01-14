#!/bin/bash

router="172.10.10.1"
interface="eth0"

ping -w 30 -c 1 ${router} > /dev/null 2>&1
if [ $? -ne 0 ]; then
        echo "Restart ${interface}"
        ifdown ${interface}
        ifup ${interface}
fi
