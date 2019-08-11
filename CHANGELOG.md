# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Fixed

* The IPL no longer overwrites the disk signature in the MBR.
* The IPL looks for files on the boot drive, not on drive 0x80.
* The installer copies the IPL to the disk holding the DOS partition to which
  the files are installed.

### Added

* DosBox based build system.
* Dockerfile for build helper container.
