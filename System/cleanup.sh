#!/bin/bash

echo -e "\nLeere alte Log-Dateien\n"

rm /var/log/*.gz
rm /var/log/*.1
rm /var/log/*.2
rm /var/log/*.3
rm /var/log/*.4
rm /var/log/*.5

echo -e "\nFertig\n"
echo Finish!
