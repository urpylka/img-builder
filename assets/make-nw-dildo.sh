#! /bin/bash

set -e

# SETUP ON ORANGE
# http://ua3nbw.ru/all/podnyat-tochku-dostupa-wifi-na-orange-pi/
# https://orangepi.su/content.php?p=160&c=Podnyat%20tochku%20dostupa%20WIFI%20na%20Orange%20Pi
# https://github.com/urpylka/create_ap
# https://mjdm.ru/forum/viewtopic.php?t=3598
# https://serverdoma.ru/viewtopic.php?t=990

apt update
apt install dkms usb-modeswitch dnsmasq hostapd bridge-utils openvpn -y

SCRIPT="sudo /root/iptables-dildo.sh"
sed -i "20a${SCRIPT}" /etc/rc.local

systemctl disable wpa_supplicant
systemctl disable dhcpcd

mkdir /var/log/dnsmasq
touch /var/log/dnsmasq/dnsmasq.leases

# Unblock wlan0
# rfkill unblock 0

# systemctl enable ovpn.service
# used: systemctl enable openvpn-client@<name>
# where <name>.conf in /etc/openvpn/client

# # git clone https://github.com/oblique/create_ap
# git clone https://github.com/urpylka/create_ap
# cd create_ap
# make install
# # nano /etc/create_ap.conf

# mv /etc/create_ap.conf /etc/create_ap.conf.ORIG

# cat << EOF >> /etc/create_ap.conf
# CHANNEL=4
# GATEWAY=192.168.12.1
# WPA_VERSION=1+2
# ETC_HOSTS=0
# DHCP_DNS=gateway
# NO_DNS=0
# HIDDEN=0
# MAC_FILTER=0
# MAC_FILTER_ACCEPT=/etc/hostapd/hostapd.accept
# ISOLATE_CLIENTS=0
# SHARE_METHOD=nat
# IEEE80211N=0
# IEEE80211AC=0
# HT_CAPAB='[HT40+]'
# VHT_CAPAB=
# DRIVER=nl80211
# NO_VIRT=0
# COUNTRY=
# FREQ_BAND=2.4
# NEW_MACADDR=
# DAEMONIZE=0
# NO_HAVEGED=0
# WIFI_IFACE=wlan0
# INTERNET_IFACE=eth0
# SSID=home
# PASSPHRASE=orangepi
# USE_PSK=0
# EOF
