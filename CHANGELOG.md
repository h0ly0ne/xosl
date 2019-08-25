# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [v1.1.6] - 2019-08-25

### Changed

* Version set to 1.1.6.

### Fixed

* The IPL no longer overwrites the disk signature in the MBR.
* The IPL looks for files on the boot drive, not on drive 0x80.
* The installer copies the IPL to the disk holding the DOS partition to which
  the files are installed.
* The helper tool `SPLIT.EXE` is now built from sources, rather than tracking
  a prebuilt version.
* `EXESPLIT` sources fixed to add the required 2-byte header to the first
  segment.
* The MBR signature will be preserved even if SBM is installed.
* Replace hardwired references to drive 0x80 with the real boot drive.

### Added

* DosBox based build system.
* Dockerfile for build helper container.
* Added contributor information.
