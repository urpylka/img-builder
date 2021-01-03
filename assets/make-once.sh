#! /usr/bin/env bash

set -e # Exit immidiately on non-zero result

PROJECT=$(cat /etc/builder | grep "image project" | awk -F ': ' '{print $2}')
HOSTNAME="${PROJECT}-$(head -c 100 /dev/urandom | xxd -ps -c 100 | sed -e "s/[^0-9]//g" | cut -c 1-4)"
HOSTNAME=$(echo ${HOSTNAME} | tr '[:upper:]' '[:lower:]')

echo "> Setting up hostname to ${HOSTNAME}"
hostnamectl set-hostname ${HOSTNAME}
sed -i 's/127\.0\.1\.1.*/127.0.1.1\t'${HOSTNAME}' '${HOSTNAME}'.local/g' /etc/hosts
# .local (mdns) hostname added to make it accesable when wlan and ethernet interfaces are down

# TODO: Add 'change wifi-password' to /etc/motd

echo "> Turning on sshd"
# touch /boot/ssh
/usr/bin/raspi-config nonint do_ssh 0

echo "> Turning on I2C"
/usr/bin/raspi-config nonint do_i2c 0

echo "> Turning on SPI"
/usr/bin/raspi-config nonint do_spi 0

echo "> Turning on raspicam"
/usr/bin/raspi-config nonint do_camera 0

echo "> Turning on UART and switching off console there"
/usr/bin/raspi-config nonint do_serial 2

echo "> Disabling bluetooth on the serial port"
# https://scribles.net/disabling-bluetooth-on-raspberry-pi/
/usr/bin/raspi-config nonint set_config_var dtoverlay pi3-disable-bt /boot/config.txt
systemctl disable hciuart.service

echo "> Turning on v4l2 driver"
[[ `grep -q "^bcm2835-v4l2" /etc/modules` ]] || printf "bcm2835-v4l2\n" >> /etc/modules;

echo "> Removing once-script"
rm /root/make-once.sh
