# OpenWrt for Raspberry Pi Compute Module 4

I want to run OpenWrt on my travel router, based on a Raspberry Pi CM4 module.
Since some drivers needed are not supported by OpenWrt, I need to build my own image from source.
It makes sense for me to build the image through a CI/CD pipeline, so I can easily update the image.
Also, other people might benefit from this aproach.

## Hardware

| Hardware                                                                                                               | link to shop                                                                                             | description                                                                  |
| ---------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| [Raspberry Pi Compute Module 4](https://www.raspberrypi.com/products/compute-module-4/?variant=raspberry-pi-cm4002008) | [Berrybase](https://www.berrybase.de/raspberry-pi-compute-module-4-2gb-ram-8gb-flash?c=2410)             | Quad core Cortex-A72 (ARM v8) 64-bit SoC @ 1.5GHz, 2GB RAM & 8GB EMC storage |
| [Waveshare CM4-DUAL-ETH-MINI](https://www.waveshare.com/wiki/CM4-DUAL-ETH-MINI/)                                       | [Berrybase](https://www.berrybase.de/mini-ethernet-base-board-fuer-raspberry-pi-compute-module-4?c=2410) | A CM4 baseboard with dual Gigabit Ethernet ports                             |

## Image building

Note: When building locally, you need to have a few dependencies installed on your system.
On Ubuntu, you can install them with:

```bash
sudo apt install build-essential clang flex g++ gawk gcc-multilib gettext git libncurses5-dev libssl-dev python3-distutils rsync unzip gzip zlib1g-dev file wget
```

On systems with [nix](https://nixos.org/download.html) installed, you can use the development shell to get a shell with all dependencies installed:

```bash
nix develop
```

`nix develop` is a flake command, so you need to have flake support enabled in your nix installation.

### Prepare the OpenWrt source code

```bash
# pull submodules (feel free to update openwrt to a newer version)
git submodule update --init --recursive

# copy diffconfig into the source code directory
cp targets/Broadcom\ BCM2711/diffconfig openwrt/.config

# copy files into the source code directory
cp -r files openwrt/

# change into the source code directory
cd openwrt

# update & install feeds
./scripts/feeds update -a
./scripts/feeds install -a
```

### Use diffconfig to create .config

```bash
# expand diffconfig to full config
make defconfig
```

### Choose build options

```bash
# execute in OpenWrt root directory
make menuconfig
```

### Build images

```bash
make -j$(nproc) download V=s
make -j$(nproc) V=s

ls -al bin/targets/*
```

## Build options I'm using for for OpenWRT

I selected the following options for `Pi-CM4-DUAL-ETH-MINI.config`:

### Target System

- Target System -> Broadcom BCM27xx
- Subtarget -> BCM2711
- Target Images -> tar.gz
- Target Image -> Kernel partition size (MiB): 128
- Target Image -> Root filesystem partition size (MiB): 896

### Kernel modules

- Kernel modules -> Network Devices -> kmod-r8169
- Kernel modules -> USB Support -> kmod-usb2
- Kernel modules -> USB Support -> kmod-usb2-pci
- Kernel modules -> USB Support -> kmod-usb3

### Luci

- Luci -> Collections -> luci
- Luci -> Modules -> Translations -> German (de)
- Luci -> Modules -> Translations -> English (en)
- Luci -> Modules -> Translations -> Spanish (es)
- Luci -> Modules -> Translations -> French (fr)

### VPN support

- Luci -> Applications -> luci-app-openvpn
- Luci -> Applications -> luci-app-wireguard
- Luci -> Protocols -> luci-proto-wireguard
- Network -> VPN -> openvpn-openssl
- Network -> VPN -> wireguard-tools
- Utilities -> openssl-util

### [Smartphone USB tethering](https://openwrt.org/docs/guide-user/network/wan/smartphone.usb.tethering)

- Kernel modules -> USB Support -> kmod-usb-core
- Kernel modules -> USB Support -> kmod-usb-net
- Kernel modules -> USB Support -> kmod-usb-net-cdc-eem
- Kernel modules -> USB Support -> kmod-usb-net-cdc-ether
- Kernel modules -> USB Support -> kmod-usb-net-cdc-ncm
- Kernel modules -> USB Support -> kmod-usb-net-cdc-subset
- Kernel modules -> USB Support -> kmod-usb-net-huawei-cdc-ncm
- Kernel modules -> USB Support -> kmod-usb-net-ipheth
- Kernel modules -> USB Support -> kmod-usb-net-rndis
- Kernel modules -> native Language Support -> kmod-nls-base
- Libaries -> libimobiledevice -> libimobiledevice
- Utilities -> libimobiledevice -> usbmuxd
- Utilities -> usbutils

## Copy config files into this repository

```bash
# convert .config to diffconfig
./scripts/diffconfig.sh > diffconfig

# copy diffconfig & .config into this repository
cp diffconfig .config ../targets/Broadcom\ BCM2711/
```
