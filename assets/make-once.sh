#! /usr/bin/env bash

set -e # Exit immidiately on non-zero result

HOSTNAME='clever-'$(head -c 100 /dev/urandom | xxd -ps -c 100 | sed -e "s/[^0-9]//g" | cut -c 1-4)
NEW_WIFI_PASSWD=${HOSTNAME}
echo "TODO: Add 'change wifi-password' to /etc/motd"

NEW_HOSTNAME=$(echo ${HOSTNAME} | tr '[:upper:]' '[:lower:]')
echo "Setting hostname to ${NEW_HOSTNAME}"
hostnamectl set-hostname ${NEW_HOSTNAME}
sed -i 's/127\.0\.1\.1.*/127.0.1.1\t'${NEW_HOSTNAME}' '${NEW_HOSTNAME}'.local/g' /etc/hosts
# .local (mdns) hostname added to make it accesable when wlan and ethernet interfaces are down

sed -i "s/ssid=HOSTAPD/ssid=${NEW_HOSTNAME}/g" /etc/hostapd/hostapd.conf
sed -i "s/wpa_passphrase=PASSWORD/wpa_passphrase=${NEW_WIFI_PASSWD}/g" /etc/hostapd/hostapd.conf
echo "SSID is set to ${NEW_HOSTNAME}"

echo "Harware setup"
/root/make-hw.sh

echo "Removing init scripts"
rm \
    /root/make-once.sh
    /root/make-hw.sh
