#!/bin/sh

# This script is a way to make the Venom-Linux installation more easy.
# this script will download the venomfs from a repo maintained by:
# Visone Selektah
# Lumaro

# Keep an eye whn Lumaro or Visone update the kerne in its domain.
KERNEL_VERSION="linux-6.2.12-1"
KERNEL="https://nc.abetech.es/index.php/s/ebMeZMrHkNESL4T/download?path=%2F&files=$KERNEL_VERSION.spkg.tar.xz"
VENOMFS="https://sourceforge.net/projects/venomlinux/files/venom-rootfs.txz/"

partition () {
    cfdisk -z /dev/sda
}

download_files () {
    # This line download the venom linux filesystem
    echo "Downloading the venom file system..."
    curl -LO -k $VENOMFS > /dev/null 2>&1
    
    # this line will download the linux kernel
    echo "Downloading the linux kernel..."
    curl -LO -k $KERNEL > /dev/null 2>&1
    echo "Downloads complete"
}

moving_downloads () {
    mv "download?path=%2F&files=$KERNEL_VERSION.spkg.tar.xz" $KERNEL_VERSION.spkg.tar.xz
    mv $KERNEL_VERSION.spkg.tar.xz /mnt/venom/var/cache/scratchpkg/packages/
    echo "Kernel moved to cache folder"
}

venom_initialize () {
    echo "formating the partitions..."
    mkfs.vfat /dev/sda1             # Change this line for the specific drive name.
    mkfs.ext4 -L Venom /dev/sda3                 # Change this line for the specific drive name.
    echo "partition formated..."
    sleep 1
    echo "creating mounting folders..."
    mkdir -p /mnt/venom   
    mount /dev/sda3 /mnt/venom          # Change this line for the specific drive name.
    mkdir -pv /mnt/venom/boot
    mount /dev/sda1 /mnt/venom/boot     # Change this line for the specific drive name.
    sleep 1
    mkswap /dev/sda2
    swapon /dev/sda2
    echo "unwrapping the venom filesystem..."
    tar xvJpf venomlinux-rootfs-4.0-x86_64-20230411.tar.xz -C /mnt/venom
    echo "Filesystem unwrapped..."
    echo "mounting more folders..."
    mount -v --bind /dev /mnt/venom/dev
    mount -vt devpts devpts /mnt/venom/dev/pts -o gid=5,mode=620
    mount -vt proc proc /mnt/venom/proc
    mount -vt sysfs sysfs /mnt/venom/sys
    mount -vt tmpfs tmpfs /mnt/venom/run
    mkdir -pv /mnt/venom/$(readlink /mnt/venom/dev/shm)
    cp -L /etc/resolv.conf /mnt/venom/etc/
    echo "folders mounted..."
    cp vchroot.sh /mnt/venom/tmp/
    cp postinstall.sh /mnt/venom/tmp
    cp userconfig.sh /mnt/venom/tmp
}


# Here the script actually start to run...
partition
download_files 
venom_initialize
moving_downloads
