.PHONY: all setup build
all: build combine

setup:
	./scripts/setup-host.sh

.ONESHELL:
build: 
	set -e

	mkdir -p build

	cd scripts

	./setup-root-fs.sh
	sudo ./make-sd-card.sh
	./linux-dtbs.sh
	sudo ./debian.sh

.ONESHELL:
combine:
	set -e

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