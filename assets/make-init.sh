#! /usr/bin/env bash

set -e # Exit immidiately on non-zero result

[[ -z ${1} ]] && (echo "Wasn't set the project name"; exit 1)
[[ -z ${2} ]] && (echo "Wasn't set the version"; exit 1)
[[ -z ${3} ]] && (echo "Wasn't set the original url"; exit 1)

echo "> Putting image information"
cat >> "/boot/img-builder/theimage.conf" << EOF
image_project=${1}
image_version={2}
image_original=${3%.*}
image_interfaces=/boot/img-builder/interfaces-router.conf
image_id=TEMP
EOF

echo "> Writing magic script to /etc/rc.local"
MAGIC_SCRIPT="sudo /root/make-once.sh; sudo sed -i '/sudo \\\/root\\\/make-once.sh/d' /etc/rc.local && sudo reboot"
sed -i "19a${MAGIC_SCRIPT}" /etc/rc.local
