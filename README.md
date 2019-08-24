# A modern way to build XOSL, plus some nice fixes

## Intro

This is a modified version of
[XOSL](http://www2.arnes.si/~fkomar/xosl.org/home.html), based on the
historical v1.1.5.

The goals of this project are:

* to make it easy to build XOSL from source while still using the Borland
  C++ 3.1 development environment, just like the original code;
* to fix some behaviour that makes the use of XOSL on modern systems less
  profitable, like the installer trashing the disk signature within the MBR.

## Easy compilation

The Borland C++ environment is a DOS tool. As such, it can only be run under
a DOS environment. However, thanks to [DosBox](https://www.dosbox.com/)
it is quite easy to setup a fully working DOS environment.

The Borland C++ tools are included with the sources: they take up a few MiB
of space and are now an easily found abandonware. I have not included the
setup or the entire installation tree. Instead, only the file sets that are
actually required to compile XOSL are present, so if your goal is to grab a
pristine version of the development tools, look for them on any abandonware
sites.

To make things more streamlined, a Dockerfile is provided which can be used
to build a container image containing DosBox, GNU make and the other tools
which are required for a build. So, in the end, in order to build XOSL from
the sources you only actually need Docker installed.

## Fixes

### The IPL should look for XOSL files on the boot disk

The XOSL IPL code will look for the other files on disk 0x80 (the first HDD).
But if the boot sequence is changed during the boot, so that for example the
second disk (0x81) is selected, then the IPL will try to load XOSL from the
wrong drive.

The patch ensures that the boot drive is used instead of the fixed 0x80 value.
The boot drive is what the BIOS leaves in `dl` register after the handover.

### Install the IPL code to the same disk hosting XOSL files

By default, the installer puts the MBR IPL code on disk 0x80 (the first HDD).
This is not desirable. Instead, the IPL should be installed on the same disk
where the DOS partition for XOSL files is kept.

Otherwise, XOSL is effectively split across disk, with the IPL on a drive and
the files on another. Failure or removal of any disk would make the system
unbootable.

### MBR Disk Signature preservation

The XOSL installer overwrites the 6 bytes starting at offset 440 of the MBR,
the _disk signature_. This results in other OSes being unable to boot
properly after XOSL is installed because the disk signature they look for is
no longer there. A patch was provided to preserve its value when installing.
This is also true when SBM is installed as part of the process.

Have a look at the [Master Boot record Wikipedia
page](https://en.wikipedia.org/wiki/Master_boot_record) for more details.

## Build system

     .              # Repository root
     ├── Makefile
     ├── build/     # Empty dir for artifacts
     ├── docker/    # Dockerfile for the helper container
     ├── src/       # XOSL sources
     └── tools/     # Borland C++ and DosBox config files

The build is still based on a DOS environment and Borland C++ 3.1; in order
to automate it the `/tools` subdirectory contains a copy of the abandonware
Borland toolchain, plus some DosBox config files which map the `src`,
`tools` and `build` folders to drive letters and starts a build. There is
also a bootable floppy image based on FreeDOS, which is used to produce a
bootable XOSL install media as part of the build.

The build process is driven by the `Makefile` and run under DosBox without
graphical output. Instead, the following information are recorder for later
inspection:

* `build/RESULT` contains `0` if the build was successful and `1` otherwise;
* `build/BUILD.LOG` contains the output produced by the Borland `make` tool.

Artifacts are also stored under `build`:

* `build/xosl-files` contains a copy of every produced file, including the
  installer. This is what you may want to copy to produce an installer media;
* `build/bootfloppy.img` is a bootable floppy image based on FreeDOS, onto
  which the installer just built has been copied. If you are looking for a
  bootable installer media to use with Syslinux or to mount in a VM, this is
  the fastest way to get one. The XOSL installer is found under `XOSL` on the
  floppy.

If you are planning to build on your host Linux system, the following
dependencies must be installed for:

* GNU mtools
* GNU make
* DosBox

However, it is easier to just use the helper Docker container. There is a
`docker/Dockerfile` file which will build a container, based on Arch Linux,
with DosBox and the other tools already installed. Once built, it can be run
by passing the build command as the command to execute, which defaults to
`make`. The repository root must be bound to `/build` within the container,
For example:

     docker run -it --rm -v /home/user/xosl:/build $builder_name            # Runs `make`
     docker run -it --rm -v /home/user/xosl:/build $builder_name make clean # Clean everything

There is an even simpler way: use `docker/build.sh`. This script will:

* build the container, naming it `xosl-borlandc-builder`, if it does not exist;
* run the container by binding the repositoy under the expected mountpoint and
  passing all its arguments to the run invocation. So the previous examples
  becomes:

          ./build.sh            # Runs `make`
          ./build.sh make clean # Clean everything

`build.sh` expects to be called from the `docker` folder.

## TL;DR

Improved version of XOSL. To build from source:

* install Docker;
* `cd $repository_root/docker`
* `./build.sh`
* grab `$repository_root/build/bootfloppy.img` and do what you want with it:
  start it in an hypervisor, use it with Syslinux `memdisk`, or write it to a
  floppy.
