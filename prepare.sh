#!/bin/bash

set -e
set -x

sudo -v
while true; do sudo -n true; sleep 60; kill -0 \"$$\" || exit; done 2>/dev/null & 

mkdir -p build

cd scripts

./setup-root-fs.sh
sudo ./make-sd-card.sh
./linux-dtbs.sh
sudo ./debian.sh