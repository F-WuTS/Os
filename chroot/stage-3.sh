#!/bin/bash

set -e

cd /var/0s/source

cd harrogate
npm install
gulp compile

cd ..

cd c0re
# Fix Click encoding error
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
pipenv install --system

systemctl enable c0re
systemctl enable harrogate
systemctl enable hostname
systemctl enable reset_coproc
systemctl enable setup_sound
systemctl enable startup_sound
systemctl enable x11