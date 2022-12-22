#!/bin/bash

echo building OpenWRT ${version} ...

# download OpenWRT source
git clone https://git.openwrt.org/openwrt/openwrt.git -b ${version} /openwrt
# update and install feeds
./scripts/feeds update -a
./scripts/feeds install -a

# build all targets
for config in /targets/*; do
    echo "building ${config} ..."
    # sleep for readablity
    sleep 5
    cp ${config} /openwrt/.config
    make -j$(nproc) download # V=s
    make -j$(nproc) # V=s
    echo "build ${config} done"
done

# remove packages to save space & copy all images to /output
rm -rf /openwrt/bin/targets/*/packages/
cp -r /openwrt/bin/targets/* /output/
