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

docker run --privileged -i --rm -v $(pwd):/mnt urpylka/img-tool:0.7.1 /bin/bash - << EOF
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
IMAGE_SOURCE="https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2020-08-24/2020-08-20-raspios-buster-arm64-lite.zip"

###################################################################################################

LOAD \${IMAGE_SOURCE}

# It makes a free space (changing size of the image to 4GB)
SIZE 4000000000

COPY '/make-once.sh' '/root/'
EXEC '/make-init.sh' "\${PROJECT}" "\${IMAGE_VERSION}" "\${IMAGE_SOURCE}"
EXEC '/make-install.sh'

COPY '/network/interfaces.conf' '/etc/network/interfaces'
COPY '/network/iptables.sh' '/root/'
COPY '/network/hostapd.conf' '/etc/hostapd/hostapd.conf'
COPY '/network/dnsmasq.conf' '/etc/dnsmasq.conf'

EXEC '/make-setup.sh'

SIZE \$(SIZE | grep "IMG_MIN_SIZE" | cut -b 15-)

###################################################################################################
EOF
