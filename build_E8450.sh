#!/bin/bash

OUTPUT="$(pwd)/images"
BUILD_VERSION="21.02.6"
BOARD_NAME="mediatek"
BOARD_SUBNAME="mt7622"
BUILDER="https://downloads.openwrt.org/releases/22.03.5/targets/mediatek/mt7622/openwrt-imagebuilder-22.03.5-mediatek-mt7622.Linux-x86_64.tar.xz"
BASEDIR=$(realpath "$0" | xargs dirname)

# download image builder
if [ ! -f "${BUILDER##*/}" ]; then
	wget "$BUILDER"
	tar xJvf "${BUILDER##*/}"
fi

[ -d "${OUTPUT}" ] || mkdir "${OUTPUT}"

cd openwrt-*/

# clean previous images
make clean

make image  PROFILE="linksys_e8450-ubi" \
           PACKAGES="block-mount kmod-fs-ext4 kmod-usb-storage blkid mount-utils swap-utils e2fsprogs fdisk luci dnsmasq bash" \
           FILES="${BASEDIR}/files/" \
           BIN_DIR="$OUTPUT"
