#!/bin/bash
# This script will fix the IoBroker Errors during updating the Adapters/Host via Update-Script
# Fixxes message: 
# -Package pangocairo was not found in the pkg-config search path.
# No package 'pangocairo' found
# gyp: Call to 'pkg-config pangocairo --libs' returned exit status 1 while in binding.gyp. while trying to load binding.gyp


# Downloading additional packages to complete all depencies for ioBroker
echo -e "\nInstalling additional depencies...\n"
apt update 
apt install -y build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev

echo -e "\nInstalling Canvas via npm\n"
npm install canvas

echo -e "Finish!"
