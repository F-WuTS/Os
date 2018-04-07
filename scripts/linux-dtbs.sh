#!/bin/bash

set -e

mkdir -p ../build
cd ../build

[[ -d wallaby-linux ]] || git clone https://github.com/F-WuTS/wallaby-linux.git --depth=1

mkdir -p linux/boot

cd wallaby-linux

# Remove .git folder to prevent dirty kernel names
[[ -d build ]] || rm -rf .git

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dtbs -j8

cp -r arch/arm/boot/dts/am335x-pepper*.dt* ../linux/boot
