FROM debian:buster

ENV TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -y \
        sudo time git-core subversion build-essential g++ bash make \
        libssl-dev patch libncurses5 libncurses5-dev zlib1g-dev gawk \
        flex gettext wget unzip xz-utils python python-distutils-extra \
        python3 python3-distutils-extra rsync curl libsnmp-dev liblzma-dev \
        libpam0g-dev cpio rsync && \
    apt-get clean

# copy target which should be built
COPY targets/diffconfig /diffconfig

WORKDIR /openwrt
ENV version=v22.03.2

# build OpenWRT
ENTRYPOINT /bin/bash -c "\
    git clone https://git.openwrt.org/openwrt/openwrt.git -b ${version} /openwrt && \
    mv /diffconfig .config && \
    ./scripts/feeds update -a && \
    ./scripts/feeds install -a && \
    echo building OpenWRT ${version} ... && \
    echo building OpenWRT for Broadcom BCM2711... && \
    sleep 10 && \
    make defconfig && \
    make -j$(nproc) download V=s && \
    make -j$(nproc) V=s \
    "
