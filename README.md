# build-openwrt for Raspberry Pi Compute Module 4

I want to run OpenWRT on my travel router, based on a Raspberry Pi CM4 module.
Since the drivers needed are not supported by OpenWRT, I need to build my own image from source.
It makes sense for me to build the image through a CI/CD pipeline, so I can easily update the image.
Also, other people might benefit from this aproach.

## Hardware

| Hardware                           ****                                                                                | description                                                                  |
| ---------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| [Raspberry Pi Compute Module 4](https://www.raspberrypi.com/products/compute-module-4/?variant=raspberry-pi-cm4002008) | Quad core Cortex-A72 (ARM v8) 64-bit SoC @ 1.5GHz, 2GB RAM & 8GB EMC storage |
| [Waveshare CM4-DUAL-ETH-MINI](https://www.waveshare.com/wiki/CM4-DUAL-ETH-MINI/)                                       | A CM4 baseboard with dual Gigabit Ethernet ports                             |


## Build options I'm using for for OpenWRT

### Pi Compute Module 4

After executing `make menuconfig` I selected the following options for `Pi-CM4-DUAL-ETH-MINI.config`:

- Target System -> Broadcom BCM27xx
- Subtarget -> BCM2711
- Target Images -> tar.gz
- Target Image -> Root filesystem partition size (MiB): 1024
- Luci -> Collections -> luci
- Luci -> Applications -> wireguard
- Kernel modules -> USB Support -> kmod-usb-core
- Kernel modules -> USB Support -> kmod-usb-hid
- Kernel modules -> USB Support -> kmod-usb-net
- Kernel modules -> USB Support -> kmod-usb-net-rtl8152
- Kernel modules -> USB Support -> kmod-usb2
- Kernel modules -> USB Support -> kmod-usb2-pci
- Kernel modules -> USB Support -> kmod-usb3

### create diffconfig

```bash
# Write the changes to diffconfig
./scripts/diffconfig.sh > diffconfig
```

### Using diff file

```bash
# Write changes to .config
cp diffconfig .config
 
# Expand to full config
make defconfig
```
