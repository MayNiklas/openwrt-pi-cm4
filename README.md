# OpenWrt for Raspberry Pi Compute Module 4

I want to run OpenWrt on my travel router, based on a Raspberry Pi CM4 module.
Since some drivers needed are not supported by OpenWrt, I need to build my own image from source.
It makes sense for me to build the image through a CI/CD pipeline, so I can easily update the image.
Also, other people might benefit from this aproach.

## Hardware

| Hardware                                                                                                               | description                                                                  |
| ---------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| [Raspberry Pi Compute Module 4](https://www.raspberrypi.com/products/compute-module-4/?variant=raspberry-pi-cm4002008) | Quad core Cortex-A72 (ARM v8) 64-bit SoC @ 1.5GHz, 2GB RAM & 8GB EMC storage |
| [Waveshare CM4-DUAL-ETH-MINI](https://www.waveshare.com/wiki/CM4-DUAL-ETH-MINI/)                                       | A CM4 baseboard with dual Gigabit Ethernet ports                             |

## Image building

Note: When building locally, you need to have a few dependencies installed on your system.
On Ubuntu, you can install them with:

```bash
sudo apt install build-essential clang flex g++ gawk gcc-multilib gettext git libncurses5-dev libssl-dev python3-distutils rsync unzip gzip zlib1g-dev file wget
```

### Prepare the OpenWrt source code

```bash
# choose a version from https://github.com/openwrt/openwrt/tags
export version=v22.03.3

# clone the source code
echo "Checkout OpenWrt version $version"
git clone --branch $version https://github.com/openwrt/openwrt.git 

# change into the source code directory
cd openwrt

# update & install feeds
./scripts/feeds update -a
./scripts/feeds install -a
```

### Choose build options

```bash
# execute in OpenWrt root directory
make menuconfig
```

### Create diffconfig from .config

```bash
# write the changes to diffconfig
./scripts/diffconfig.sh > diffconfig
```

### Use diffconfig to create .config

```bash
# expand to full config
make defconfig
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
- Target Image -> Root filesystem partition size (MiB): 3968

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
- Luci -> Protocols -> luci-proto-wireguard
- Network -> VPN -> openvpn-openssl
- Network -> VPN -> wireguard-tools
- Utilities -> openssl-util

> Copy the resulting .config & diffconfig file into the targets directory and commit them to the repository. Once the CI/CD pipeline is triggered, it will use the .config & diffconfig file to build the image.
