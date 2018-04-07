#!/bin/bash
set -e

mkdir -p ../build
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
	# Stage 1
	cp ../chroot/stage-1.sh debian-fresh
	chroot debian-fresh/ ./stage-1.sh
	rm debian-fresh/stage-1.sh
fi

rm -rf debian

cp -r debian-fresh debian

cp -r ../chroot debian

# Stage 2
echo "Installing dependencies."
chroot debian/ ./chroot/stage-2.sh

echo "Applying overlay fs"
cp -r ../root-fs/* debian

# Stage 3
echo "Running fs prepare"
chroot debian/ ./chroot/stage-3.sh

rm -rf debian/chroot
