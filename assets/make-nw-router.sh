#! /bin/bash

set -e

# SETUP ON ORANGE
# http://ua3nbw.ru/all/podnyat-tochku-dostupa-wifi-na-orange-pi/
# https://orangepi.su/content.php?p=160&c=Podnyat%20tochku%20dostupa%20WIFI%20na%20Orange%20Pi
# https://github.com/urpylka/create_ap
# https://mjdm.ru/forum/viewtopic.php?t=3598
# https://serverdoma.ru/viewtopic.php?t=990

apt update
apt install -y \
    dkms \
    net-tools \
    usb-modeswitch \
    dnsmasq hostapd bridge-utils openvpn \
    xl2tpd \
    strongswan

SCRIPT="sudo /root/iptables-router.sh"
sed -i "20a${SCRIPT}" /etc/rc.local

systemctl disable wpa_supplicant
systemctl disable dhcpcd

mkdir /var/log/dnsmasq
touch /var/log/dnsmasq/dnsmasq.leases

systemctl enable dnsmasq
systemctl enable hostapd
systemctl enable openvpn

# Unblock wlan0
# rfkill unblock 0

# systemctl enable ovpn.service
# used: systemctl enable openvpn-client@<name>
# where <name>.conf in /etc/openvpn/client

# для l2tpd нужна ядерная поддержка
# https://habr.com/en/post/189462/
# здесь то что нужно https://github.com/alardus/candybox
# https://homenet.beeline.ru/index.php?/topic/311442-raspberry-pi-l2tp-beeline/
