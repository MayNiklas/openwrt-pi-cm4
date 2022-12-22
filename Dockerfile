FROM ubuntu:22.04

ENV TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive

# install tools needed to build OpenWRT
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    clang \
    file \
    g++ \
    gawk \
    gettext \
    git \
    gzip \
    libncurses5-dev \
    libncursesw5-dev \
    libssl-dev \
    python3-distutils \
    rsync \
    unzip \
    wget \
    xsltproc \
    zlib1g-dev

WORKDIR /openwrt

# copy target folder which should be built
COPY targets/ /targets/

# copy entrypoint script
COPY entrypoint.sh /entrypoint.sh

ENV version=v22.03.2

ENTRYPOINT [ "/bin/sh", "/entrypoint.sh" ]
