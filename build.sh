#! /usr/bin/env bash

#
# The script builds a preconfigured Raspberry Pi image.
#
# Copyright (C) 2020 Artem Smirnov <urpylka@gmail.com>
#
# Distributed under MIT License (available at https://opensource.org/licenses/MIT).
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#

[[ $(git status | tail -n 1) == "nothing to commit, working tree clean" ]] \
    || (echo "Commit all changies or stash it and try again."; exit 1)  \
    && docker run --privileged -i --rm -v $(pwd):/mnt urpylka/img-tool:0.7.2 /bin/bash - << EOF
set -e # Exit immidiately on non-zero result
source img-tool

###################################################################################################

# Directories inside docker container
MNT_DIR="/mnt"
IMAGES_DIR="\${MNT_DIR}/images"; [[ ! -d \${IMAGES_DIR} ]] && mkdir \${IMAGES_DIR}
ASSETS_DIR="\${MNT_DIR}/assets"

COPY() { img-tool \${IMAGE_PATH} copy \${ASSETS_DIR}\${@:1}; }
EXEC() { img-tool \${IMAGE_PATH} exec \${ASSETS_DIR}\${@:1}; }
SIZE() { img-tool \${IMAGE_PATH} size \${@:1}; }
LOAD() { img-tool \${IMAGE_PATH} load \${@:1}; }

PROJECT="${PROJECT:-"theimage"}"
IMAGE_VERSION="${IMAGE_VERSION:-"\$(get_repo_ver \${MNT_DIR})"}"

IMAGE_NAME="\${PROJECT}-\${IMAGE_VERSION}.img"
IMAGE_PATH="\${IMAGES_DIR}/\${IMAGE_NAME}"
IMAGE_SOURCE="https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-11-08/2021-10-30-raspios-bullseye-armhf-lite.zip"

###################################################################################################

LOAD \${IMAGE_SOURCE}

# It makes a free space (changing size of the image to 4GB)
SIZE 4000000000

COPY '/make-once.sh' '/root/'
EXEC '/make-init.sh' "\${PROJECT}" "\${IMAGE_VERSION}" "\${IMAGE_SOURCE}"
EXEC '/make-install.sh'

COPY '/network/update_openvpn.service' '/lib/systemd/system/'
COPY '/network/update_openvpn.sh' '/root/'
COPY '/network/interfaces-client.conf' '/boot/img-builder/interfaces.d/client.uncommentme'
COPY '/network/interfaces-router.conf' '/boot/img-builder/interfaces.d/router'
COPY '/network/openvpn.conf' '/boot/img-builder/'
COPY '/network/hostapd.conf' '/boot/img-builder/'
COPY '/network/dnsmasq.conf' '/boot/img-builder/'
COPY '/network/wpa_supplicant.conf' '/boot/img-builder/'

EXEC '/make-setup.sh'

SIZE \$(SIZE | grep "IMG_MIN_SIZE" | cut -b 15-)

###################################################################################################
EOF
