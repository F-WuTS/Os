#!/bin/bash

set -e
set -x

sudo -v
while true; do sudo -n true; sleep 60; kill -0 \"$$\" || exit; done 2>/dev/null & 

mkdir -p mnt
mkdir -p mnt/boot
mkdir -p mnt/rootfs

echo "Mounting 0s"
sudo kpartx -a build/0s.img

cd mnt

sudo mount /dev/mapper/loop0p1 boot
sudo mount /dev/mapper/loop0p2 rootfs

sleep 1

echo "Copying bootloader"
sudo cp ../boot/* boot
echo "Copying Debian"
sudo cp -rp ../build/debian/* rootfs
echo "Copying dtbs"
sudo cp -r ../build/linux/* rootfs

sleep 1

sudo umount boot
sudo umount rootfs

sleep 1

cd ..

echo "Unmounting 0s"
sudo kpartx -d build/0s.img
sudo kpartx -d /dev/loop0
sudo losetup -d /dev/loop0