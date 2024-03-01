#!/bin/sh

# This script is a way to make the Venom-Linux installation more easy.
# this script will install some packages, an build some config files.

# Special thanks to:
# Visone Selektah
# Lumaro

venom_chroot() {
    # Configuring system
    # Configure the system's hostname, timezone, clock, font, keymap
    echo "Configure the system's hostname, timezone, clock, font, keymap..."
    printf "
# /etc/rc.conf - system configuration for venom-linux

# Set the host name.
HOSTNAME="venom"

# Set RTC to UTC or localtime.
HARDWARECLOCK="UTC"

TIMEZONE=America/Matamoros

# Keymap to load, see loadkeys(8).
KEYMAP=us\n" > /etc/rc.conf

    #TODO: edit config files, locales etc...
    echo "Setting the locales..."
    sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locales
    genlocales

    echo "generating fstab file..."
    printf "
/dev/sda1   /boot   vfat    defaults,noatime    0   2
/dev/sda2   /       ext4    defaults,noatime    0   1
/dev/sda3   swap    swap    defaults            0   0" >> /etc/fstab
    echo "Fstab file generated..."
    
    echo "venom" > /etc/hostname

}

scratch_install () {
    export GIT_SSL_NO_VERIFY=true
    echo insecure >> $HOME/.curlrc
    echo "Updating the system..."
    scratch sync
    scratch sysup
    scratch install linux -y
}

grub_install () {
    echo "Installing grub..."
    scratch install -m grub-efi -y
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id="venomlinux"
    echo "generating the grub configuration..."
    grub-mkconfig -o /boot/grub/grub.cfg
}

add_user (){
    # This function is going to change the root password and add a user...
    passwd
    echo "Add an user:"
    echo "Enter the name of the new user: "
    read user
    useradd -m -G users,wheel,audio,video -s /bin/bash $user
    passwd $user
}
# Here the script actually start to run...
venom_chroot
add_user
scratch_install
grub_install
