#!/bin/bash
set -e

cd ../build

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

echo "Delete debian-fresh if you interrupted the initial download."

if [ ! -d debian-fresh ]; then
	echo "Initial download, this will take a while."
	debootstrap --foreign --verbose --arch=armhf stretch ./debian-fresh
	mkdir -p debian-fresh/usr/bin
	cp /usr/bin/qemu-arm-static debian-fresh/usr/bin
	
	echo "Stage 1"
	cp ../chroot/stage-1.sh debian-fresh
	chroot debian-fresh/ ./stage-1.sh
	rm debian-fresh/stage-1.sh
fi

rm -rf debian

cp -r debian-fresh debian

cp -r ../chroot debian

echo "Stage 2"
chroot debian/ ./chroot/stage-2.sh

echo "Applying overlay fs"
cp -r ../root-fs/* debian

echo "Stage 3"
chroot debian/ ./chroot/stage-3.sh

rm -rf debian/chroot
