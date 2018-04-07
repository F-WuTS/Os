#!/bin/bash
set -e

cd ../build

if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	exit
fi

if lsblk | grep -q "loop0"; then 
	echo "loop0 found, trying to unmount automatically"
	kpartx -d /dev/loop0
	losetup -d /dev/loop0
fi

echo "Creating empty image"
dd if=/dev/zero of=0s.img bs=1M count=7500

sync

sleep 1

echo "Mouting empty image"
losetup /dev/loop0 0s.img

# echo "Zeroing empty image (no real reason to do so, still...)"
# dd if=/dev/zero of=/dev/loop0 bs=1024 count=1024

echo "Creating partitions"

# sfdisk was "upgraded" -> tons of flags removed

SIZE=`fdisk -l /dev/loop0 | grep Disk | awk '{print $5}'`
CYLINDERS=`echo $SIZE/255/63/512 | bc`

../hacks/sfdisk --force -D -uS -H 255 -S 63 -C $CYLINDERS /dev/loop0 << EOF
128,130944,0x0C,*
131072,,,-
EOF

# sfdisk --force -u S /dev/loop0 << EOF
# 128,130944,0x0C,*
# 131072,,,-
# EOF

losetup -d /dev/loop0
sync

kpartx -a 0s.img

# Resources don't become avaliable immediately
sleep 1

echo "Creating fs"
mkfs.vfat -F 32 -n "boot" /dev/mapper/loop0p1
mkfs.ext3 -F -L "rootfs" /dev/mapper/loop0p2

# Creating partitions is apperantly async
sleep 1

kpartx -d /dev/loop0
losetup -d /dev/loop0
