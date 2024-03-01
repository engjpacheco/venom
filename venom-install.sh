#!/bin/bash

# Created By: Javier Pacheco - javier@jpacheco.xyz
# Created On: 28/02/24
# Project: A venom installer bootstrap.

# mkfs.vfat /dev/nvme0n1p1            # Format the boot partition.
mkfs.vfat /dev/sda            # Format the boot partition.
# mkfs.ext4 -L Venom /dev/nvme0n1p5   # Format the root partition.
mkfs.ext4 -L Venom /dev/sda3   # Format the root partition.
# mkswap /dev/nvme0n1p4               # Format the swap partition.
mkswap /dev/sda2              # Format the swap partition.
# swapon /dev/nvme0n1p4               # Enable the swap partition.
swapon /dev/sda2               # Enable the swap partition.

mkdir -pv /mnt/venom/boot               # Create mount directories.
# mount /dev/nvme0n1p5 /mnt/venom         # Mount the root partition.
mount /dev/sda3 /mnt/venom         # Mount the root partition.
# mount /dev/nvme0n1p1 /mnt/venom/boot/   # Mount the boot partition.
mount /dev/sda1 /mnt/venom/boot/   # Mount the boot partition.

# Extract the root file system.

tar xvJpf venomlinux-rootfs-sysv-x86_64.tar.xz -C /mnt/venom

mount -v --bind /dev /mnt/venom/dev
mount -vt devpts devpts /mnt/venom/dev/pts -o gid=5,mode=620
mount -vt proc proc /mnt/venom/proc
mount -vt sysfs sysfs /mnt/venom/sys
mount -vt tmpfs tmpfs /mnt/venom/run
mkdir -pv /mnt/venom/$(readlink /mnt/venom/dev/shm)
cp -L /etc/resolv.conf /mnt/venom/etc/
chroot /mnt/venom /bin/bash

