# Semi Automatic Venom Strap -> SAVS

<img 
    style="display: block; 
           margin-left: auto;
           margin-right: auto;
           width: 30%;"
    src="./img/venom.gif" 
    alt="Our logo">
</img>

A script that make a venom installation more "easy", the idea is going to be that
you only prepare some things like format your system partitions, and a bit more things.

## How to use it:

1. First you need to download the scripts:
``` sh
git clone https://codeberg.org/jpacheco/venom --depth 1 && cd venom
```

1. Now format your partitions:

I use *cfdisk* because for me is more easy and fast...
``` sh
cfdisk -z /dev/sdX
```
- Make a *boot* partition with 150M and type EFI (or whatever the type do you have).
- Make a *root* partition whit the rest of the drive size.

1. run the *install.sh* script as ***sudo***:
``` sh
sh install.sh
```

The script will format and mount the drives into the path suggested by the venom *wiki*.

**Note: check the name of the drives that you are going to use and change the path in the
***install.sh*** file.**

``` sh
venom_initialize () {
    echo "formating the partitions..."
    mkfs.fat -F32 /dev/sda1             # Change this line for the specific drive name.
    mkfs.ext4 /dev/sda2                 # Change this line for the specific drive name.
    echo "partition formated..."
    sleep 1
    echo "creating mounting folders..."
    mkdir -p /mnt/venom   
    mount /dev/sda2 /mnt/venom          # Change this line for the specific drive name.
    mkdir -p /mnt/venom/boot
    mount /dev/sda1 /mnt/venom/boot     # Change this line for the specific drive name.
    sleep 1
```

Once running the script, it will download the venom file system and the Linux kernel,
this last package is because if we install the kernel from the package manager it will 
compile it, so it will going to take a while, so install the kernel from the 
*<kernel>.spkg.tar.xz* will be more faster.

Once the install.sh script finish, we need to chroot in to */mnt/venom/*

```sh
chroot /mnt/venom
```

Now, the chroot process, is going to update the system, and it'll install the *kernel*
and *grub*, also is going to configure the *locales*, and the *rc.conf* file.

The script is located in /tmp/vchroot.sh, run it and wait to finish the task.

``` sh
sh /tmp/vcroot.sh
```

From here you only need to add a user, and begin installing your favorites packages!!

***Enjoy VENOM Linux***
---
## Special thanks to:
*Lumaro & Visone* to make this journey the beginning of a no return road.

***Lumaro***:           https://github.com/lumarogit

***Visone-Selektah***:  https://github.com/Visone-Selektah


