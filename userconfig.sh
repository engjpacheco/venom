#!/bin/sh

# This script is a way to make the Venom-Linux installation more easy.
# this script will add some persnal stuff to my main machine

name=$(whoami)

# Create basic home directories
mkdir /home/$name/docs /home/$name/dwls /home/$name/vids /home/$name/music /home/$name/pics
mkdir -p /home/$name/.cache/zsh/ && cd /home/$name/.cache/zsh && touch history

# dotfiles

git clone https://codeberg.org/jpacheco/voidots --depth 1 /home/$name/.dotfiles >/dev/null 2>&1

# create symbolic links to config and local folders
for folder in /home/$name/.dotfiles/home/.config /home/$name/.dotfiles/home/.local
do
    ln -sf $folder /home/$name/
done


