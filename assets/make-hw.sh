#! /usr/bin/env bash

set -e # Exit immidiately on non-zero result

##################################################
# Configure hardware interfaces
##################################################

echo "Turn on sshd"
touch /boot/ssh
# /usr/bin/raspi-config nonint do_ssh 0

echo "GPIO enabled by default"

echo "Turn on I2C"
/usr/bin/raspi-config nonint do_i2c 0

echo "Turn on SPI"
/usr/bin/raspi-config nonint do_spi 0

echo "Turn on raspicam"
/usr/bin/raspi-config nonint do_camera 0

echo "Turn on UART"
# Temporary solution
# https://github.com/RPi-Distro/raspi-config/pull/75
/usr/bin/raspi-config nonint do_serial 1
/usr/bin/raspi-config nonint set_config_var enable_uart 1 /boot/config.txt
/usr/bin/raspi-config nonint set_config_var dtoverlay pi3-disable-bt /boot/config.txt
systemctl disable hciuart.service

# After adding to Raspbian OS
# https://github.com/RPi-Distro/raspi-config/commit/d6d9ecc0d9cbe4aaa9744ae733b9cb239e79c116
#/usr/bin/raspi-config nonint do_serial 2

echo "Turn on v4l2 driver"
[[ `grep -q "^bcm2835-v4l2" /etc/modules` ]] || printf "bcm2835-v4l2\n" >> /etc/modules;
