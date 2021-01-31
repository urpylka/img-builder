#! /usr/bin/env bash

# TODO: do changies before the networking service

get_md5() {
    md5sum ${1} 2>/dev/null | awk '{print $1}'
}

echo "> OpenVPN configuration"

SERVICE_OVPN=theimage
PATH_BOOT_OVPN=/boot/img-builder/openvpn.conf
PATH_TRGT_OVPN=/etc/openvpn/client/${SERVICE_OVPN}.conf

MD5_DFLT_OVPN=bde4551474bb03805d8a543939568fd0
MD5_BOOT_OVPN=$(get_md5 ${PATH_BOOT_OVPN})
MD5_TRGT_OVPN=$(get_md5 ${PATH_TRGT_OVPN})

if [[ ${MD5_BOOT_OVPN} == ${MD5_DFLT_OVPN} ]]; then
    echo "> Change ${PATH_BOOT_OVPN}"
    # systemctl disable openvpn-client@${SERVICE_OVPN} 2>/dev/null
elif  [[ ${MD5_BOOT_OVPN} == ${MD5_TRGT_OVPN} ]] && [[ -f ${PATH_BOOT_OVPN} ]]; then
    echo "> Starting openvpn-client@${SERVICE_OVPN} service"
    systemctl start openvpn-client@${SERVICE_OVPN}
else
    echo "> Starting openvpn-client@${SERVICE_OVPN} service"
    cp -f ${PATH_BOOT_OVPN} ${PATH_TRGT_OVPN}
    systemctl start openvpn-client@${SERVICE_OVPN}
    # systemctl enable openvpn-client@${SERVICE_OVPN}
    # where ${SERVICE_OVPN}.conf in /etc/openvpn/client/
fi

echo "> Networking configuration"

PATH_BOOT_NTWR=$(cat /boot/img-builder/theimage.conf | grep "image_interfaces" | awk -F ': ' '{print $2}')
PATH_TRGT_NTWR=/etc/network/interfaces

MD5_DFLT_NTWR=9534ea70afa6cd08850e4ea8472e6536
MD5_BOOT_NTWR=$(get_md5 ${PATH_BOOT_NTWR})
MD5_TRGT_NTWR=$(get_md5 ${PATH_TRGT_NTWR})

if [[ -f ${PATH_BOOT_NTWR} ]] && [[ ${MD5_BOOT_NTWR} != ${MD5_TRGT_NTWR} ]]; then
    cp -f ${PATH_BOOT_NTWR} ${PATH_TRGT_NTWR}
    NEED_RESTART_NTWR=yes
else
    echo "> Nothing to do for 'interfaces'"
fi

if [[ "${NEED_RESTART_NTWR}" == "yes" ]]; then
    echo "> It needs to be restarted"
    # systemctl restart networking
fi
