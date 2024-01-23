#!/bin/bash

temp=$( realpath "$0"  )
CURRENT_DIR=$(dirname "$temp")

echo "Installing required fonts"
set  -euo pipefail
I1FS=$'\n\t'
mkdir -p /tmp/adodefont
cd /tmp/adodefont
wget -q --show-progress -O source-code-pro.zip https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip
unzip -q source-code-pro.zip -d source-code-pro
fontpath=/usr/share/fonts/opentype/source-code-pro/
sudo mkdir -p $fontpath
sudo cp -v source-code-pro/*/OTF/*.otf $fontpath
fc-cache -f
rm -rf source-code-pro{,.zip}

## copy MeslolLGS fonts to system
sudo cp -a ${CURRENT_DIR}/../fonts /usr/share/fonts/truetype/meslolgs

## clean cache
fc-cache -f -v


echo "All rerquired fonts installed"