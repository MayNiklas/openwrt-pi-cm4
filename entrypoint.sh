#!/bin/bash

echo building OpenWRT ${version} ...

# download OpenWRT source
git clone https://git.openwrt.org/openwrt/openwrt.git -b ${version} /openwrt
# update and install feeds
./scripts/feeds update -a
./scripts/feeds install -a

### build BCM2711 ###
echo "building Broadcom BCM2711..."
cp /targets/Broadcom\ BCM27xx/BCM2711/diffconfig /openwrt/.config
# Apply changes
make defconfig
make -j$(nproc) download V=s
make -j$(nproc) V=s

# remove packages to save space & copy all images to /output
rm -rf /openwrt/bin/targets/*/packages/
cp -r /openwrt/bin/targets/* /output/
