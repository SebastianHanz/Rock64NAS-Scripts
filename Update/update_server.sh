#!/bin/bash
apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get clean
#apt-get update && apt-get –yes –force-yes –fix-missing –auto-remove –allow-unauthenticated –show-upgraded –option DPkg::Options::=“–force-confold” dist-upgrade
echo Finish!
