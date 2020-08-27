#! /usr/bin/env bash

set -e

# "uname -r" returns "4.9.93-linuxkit-aufs"
LINUX_HEADERS="4.19.97-v7+"

apt install -y \
    git \
    dkms \
    build-essential \
    bc \
    libelf-dev \
    linux-headers-${LINUX_HEADERS} \
    && echo "Everything was installed!" \
    || (echo "Some packages wasn't installed!"; exit 1)

cd /root
git clone https://github.com/aircrack-ng/rtl8812au -b v5.2.20
cd rtl8812au

wget "https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source" -O /usr/bin/rpi-source
chmod 755 /usr/bin/rpi-source

# PROCESSOR_TYPES_NAMES = [1='BCM2835', 2='BCM2836', 3='BCM2837', 4='BCM2711']
rpi-source --processor 3

sed -i 's/CONFIG_PLATFORM_I386_PC = y/CONFIG_PLATFORM_I386_PC = n/g' Makefile
sed -i 's/CONFIG_PLATFORM_ARM64_RPI = n/CONFIG_PLATFORM_ARM64_RPI = y/g' Makefile

make
make install

./dkms-install.sh

# https://github.com/svpcom/rtl8812au
# https://github.com/aircrack-ng/rtl8812au
