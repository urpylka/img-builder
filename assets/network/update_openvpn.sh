#! /usr/bin/env bash

# TODO: do changies before the networking service

get_md5() {
    md5sum ${1} 2>/dev/null | awk '{print $1}'
}

SERVICE_OVPN=theimage
PATH_BOOT_OVPN=/boot/img-builder/openvpn.conf
PATH_TRGT_OVPN=/etc/openvpn/client/${SERVICE_OVPN}.conf

MD5_DFLT_OVPN=bde4551474bb03805d8a543939568fd0
MD5_BOOT_OVPN=$(get_md5 ${PATH_BOOT_OVPN})
MD5_TRGT_OVPN=$(get_md5 ${PATH_TRGT_OVPN})

if [[ ${MD5_BOOT_OVPN} != ${MD5_DFLT_OVPN} ]]; then
    echo "> Copying OpenVPN conf file ${PATH_BOOT_OVPN} to ${PATH_TRGT_OVPN}"
    cp -f ${PATH_BOOT_OVPN} ${PATH_TRGT_OVPN}
    echo "> Starting openvpn-client@${SERVICE_OVPN} service"
    systemctl start openvpn-client@${SERVICE_OVPN}
else
    echo "> If you wanna use OpenVPN, change ${PATH_BOOT_OVPN}"
fi
