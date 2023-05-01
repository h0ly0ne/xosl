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
a DOS environment. However, thanks to [DOSBox-X](https://www.dosbox-x.com/)
it is quite easy to setup a fully working DOS environment.

The Borland C++ tools are included with the sources: they take up a few MiB
of space and are now an easily found abandonware. I have not included the
setup or the entire installation tree. Instead, only the file sets that are
actually required to compile XOSL are present, so if your goal is to grab a
pristine version of the development tools, look for them on any abandonware
sites.

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

### More space to load RPM

My other project about [Ranish Partition Manager][rpm] requires more than 64kB
of space for the final executable. XOSL expects RPM to fit into 64 kB. The XOSL
load address, as well as the memory pool for new/delete has been moved up in the
address space to allow RPM to grow up to 128kB.

The current latest build embeds my own build of RPM 2.46.

## Build system

    .
    ├── build/
    ├── src/
    ├── tools/
    ├── CHANGELOG.md
    ├── LICENSE.txt
    └── README.md

`build` contains files needed to build and the final output of the build system
and ancillary tools.

`src` contains the source code and the Makefiles to build it. The build system
is in-tree, so all object files and output artifacts will be placed here.

`tools` contains a (partial) copy of the Borland C++ 3.1 toolchain and the
other required components.

While compiling, the output from the various tools (Assembler, compiler, linker
and so on) will be written to `build/BUILD.LOG`. Important information, like
errors in source files, will be logged in there too.

Artifacts are also stored under `build`:

* `build` contains a copy of every produced file, including the
  installer. This is what you may want to copy to produce an installer media;
* `build/BOOTFL.IMG` is a bootable floppy image based on FreeDOS, onto
  which the installer just built has been copied. If you are looking for a
  bootable installer media to use with Syslinux or to mount in a VM, this is
  the fastest way to get one. The XOSL installer is found under `XOSL` on the
  floppy.
* `build/BOOTFLRD.IMG` is a bootable floppy image based on most recent
  FreeDOS, onto which the installer just built has been copied. In addition
  the startup process of the INSTALLER.EXE was automated on floppy boot -
  including the creation and usage of a ramdrive to get over the storage limit
  that is a problem when you install SBM+RPM in combination with XOSL. Please
  keep in mind that data on the ramdrive WILL NOT PRESERVED on reboot - so if
  you have some valuable data on your XOSL partition/disk keep this in mind.

For convenience, there is a clean `build/clean.ps1` (for cleanup environment)
and a build powershell script `build/build.ps1` which take care of building
RPM.

These scripts require the most recent [Microsoft PowerShell-Framework (7.3)](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3#msi) installed (x64 or x86)
on the host machine. 

To build XOSL, simply run:

    cd build
    ./build.ps1

To clean the working directories, run:

    cd build
    ./clean.ps1

Keep in mind that these script may have to download the required 3rd party
components and tools to complete the building environment. Depending on your
connection, this may take some time and some MiB's of space.

## XOSL memory layout

An approximated memory map for the various stages of XOSL follow. All addresses
are linear, not segmented.  _Approximated_ here means that sizes have been
rounded up to sensible values in order to be easier to read and/or adhere to
hardwired limits in the code (ex. an image which can grow up to 8kB but is just
a little bit smaller has been rounded to 8kB).

### IPL

| Segment    | Start (incl.) | End (excl.) |
|:-----------|:-------------:|:-----------:|
| Code+Data  | 0x7C00        | 0x7E00      |
| Stack      | 0x7B00        | 0x17B00     |

### XOSLLOAD

| Segment    | Start (incl.) | End (excl.) |
|:-----------|:-------------:|:-----------:|
| Code+Data  | 0x80100       | 0x82100     |
| BSS        | 0x82100       | 0x8A100     |
| Stack      | 0x80100       | 0x90100     |
| Allocator  | 0x60000       | 0xA0000     |

### XOSL

| Segment              | Start (incl.) | End (excl.) |
|:---------------------|:-------------:|:-----------:|
| Ranish PM Load Area  | 0x10000       | 0x30000     |
| Code+Data+Stack+BSS  | 0x30000       | 0x60000     |
| Allocator            | 0x60000       | 0xA0000     |

### Building tools

`Borland C++  Version 3.1 Copyright (c) 1992 Borland International`<br />
`DPMI Loader Version 1.0  Copyright (c) 1990, 1991 Borland International`<br />
`MAKE Version 3.6  Copyright (c) 1992 Borland International`<br />
`Turbo Assembler  Version 3.1  Copyright (c) 1988, 1992 Borland International`<br />
`TLIB 3.02 Copyright (c) 1992 Borland International`<br />
`Turbo Link  Version 5.1 Copyright (c) 1992 Borland International`<br />

[rpm]: https://github.com/binary-manu/rpm
<!-- vi: set fo=crotn et sts=-1 sw=4 :-->