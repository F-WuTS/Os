#!/bin/bash

set -e
set -x

# Ensure temp files can be created (apt-key error)
chmod -R 777 /tmp

# Recreate /dev/null
rm -f /dev/null; mknod -m 666 /dev/null c 1 3

# Set password of user 'root' to 'wallaby'
echo "root:wallaby" | chpasswd

echo "Delete debian-fresh if the next step fails, package register is outdated."

# Fix apt-key and enable https transport for apt
apt-get install -y dirmngr apt-transport-https

# Add F-WuTS debian repo
apt-key adv --keyserver pgp.mit.edu --recv-keys 0xE9368D5F3DE2EA910F48AF0412F68D62509CD98B
echo "deb https://f-wuts.github.io/repo stretch main" >> /etc/apt/sources.list

apt-get update

# Don't setup keyboard layout interactively
DEBIAN_FRONTEND=noninteractive apt-get install -y \
	python python3 python3-pip \
	wpasupplicant wireless-tools udhcpd avahi-daemon openssh-server ntp net-tools \
	alsa-utils fontconfig i2c-tools xorg \
	build-essential \
	busybox sudo curl wget nano screen git \
	dbus \
	linux-image-3.18.21-custom linux-headers-3.18.21-custom linux-libc-dev \
	botui libwallaby libbotball

cd /

wget https://deb.nodesource.com/setup_6.x
chmod +x setup_6.x

./setup_6.x
rm setup_6.x
apt-get install nodejs -y
apt-get clean

npm config set unsafe-perm true
npm install -g gulp browserify

pip3 install pipenv