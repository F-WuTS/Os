#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	exit
fi

apt-get update
apt-get install curl -y

# git-lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

dpkg --add-architecture armhf
apt-get update && apt-get upgrade -y
apt-get install crossbuild-essential-armhf bc git dosfstools kpartx \
	debootstrap qemu-user-static git-lfs -y
