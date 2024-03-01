#!/bin/sh

# This script is a way to make the Venom-Linux installation more easy.
# this script will install the packages that i use the most in my main machine.
# You can add or remove as you want.

# Special thanks to:
# Visone Selektah
# Lumaro

install_packages () {
    echo "Installing main packages..."
    scratch install \
        xorg-server \
        xorg \
        xauth \
        xrdb \
        libinput \
        xf86-input-libinput \
        ffmpeg \
        opendoas \
        htop \
        harfbuzz \
        git 
}

minor_configs () {
    # doas
    echo "permit nopass keepenv :wheel" > /etc/doas.conf

    #services 
    # tty, remove extra tty, for me those are useless.
    for i in $(seq 2 6)
    do
        sed -i "s/$i:2:respawn:/sbin/agetty tty$i 9600/#$i:2:respawn:/sbin/agetty tty$i 9600/g"
    done

    # Most important command! Get rid of the beep!
    rmmod pcspkr
    mkdir -p /etc/modprobe.d
    echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
}

suckless_tools () {
    mkdir -p /home/javier/repos
    git clone https://codeberg.org/jpacheco/dwm-jp --depth 1 /home/javier/repos/dwm
    git clone https://codeberg.org/jpacheco/st-jp --depth 1 /home/javier/repos/st
    git clone https://codeberg.org/jpacheco/dmenu-jp --depth 1 /home/javier/repos/dmenu
}

install_packages
minor_configs || echo "minor configs are already seted."
suckless_tools
