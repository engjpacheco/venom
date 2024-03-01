#!/bin/sh

# The goal is add options to choose init and iso type ( xorg, wayland, base)

msgerr() {                                                                                   
	echo "!> $*"
}

die() {
	[ "$@" ] && msgerr $@
	exit 1
}

as_root()
{
	if [ $(id -u) = 0 ]; then
		$*
	elif [ -x /usr/bin/sudo ]; then
		sudo $*
	elif [ -x /usr/bin/doas ]; then
		doas $*
	else
		su -c \\"$*\\"
	fi
}


wayland() {
MUST_PKG="wpa_supplicant os-prober grub"
WAYLAND_PKG="xcb-util-cursor xcb-util-keysyms libxfont2 libxcvt libtirpc xwayland elogind polkitd"
MAIN_PKG="sudo alsa-utils dosfstools mtools gvfs qutebrowser nnn irssi htop wireplumber pipewire fzy upower"
SWAY_PKG="nwg-shell"
THEME_PKG="osx-arc-theme ttf-mononoki"

outputiso="$PORTSDIR/venomlinux-wayland-$INIT-$(uname -m)-$(date +%Y%m%d).iso"
pkgs="$(echo $MUST_PKG $WAYLAND_PKG $MAIN_PKG $SWAY_PKG $THEME_PKG | tr ' ' ',')"
}


RELEASE=rolling
PORTSDIR="$(dirname $(dirname $(realpath $0)))"
SCRIPTDIR="$(dirname $(realpath $0))"
ROOTFS="$PWD/rootfs"

INIT="$2"
[ -z $INIT ] && INIT=sysv

[ -f $SCRIPTDIR/config ] && . $SCRIPTDIR/config

case "$1" in
    -w) wayland ;;
     *) die "You need to choose a type of iso [-b(ase) -x(org) -x(ayland)] and init (sysv s6 runit)" ;;
esac
as_root $SCRIPTDIR/builder.sh \
	-zap || exit 1

if [ "$INIT" = runit ]; then
	echo 'rc runit-rc' | as_root tee -a $ROOTFS/etc/scratchpkg.alias
	as_root $ROOTFS/usr/bin/xchroot $ROOTFS scratch remove -y sysvinit rc
	pkgs="$pkgs,runit-rc"
fi

as_root $SCRIPTDIR/builder.sh \
	-rebase \
	-iso \
	-outputiso="$outputiso" \
	-pkg="$pkgs" || exit 1

exit 0

