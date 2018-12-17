Qt build scrips
===============

## Basic usage

 * Create and cd to `/mnt/workspace`
 * `apt-get install git`
 * `git clone https://github.com/kullo/qtbuild && cd qtbuild`
 * Run `./install_packages.sh`
 * Run `./download_qt.sh`
 * Run `./build.sh ~/Downloads/qt-everywhere-opensource-src-*/`

## Linux32 subsystem

 * cd to `/mnt/workspace` and run `sudo ./create_linux32_subsystem.sh`
 * Switch to subsystem: `schroot -c trusty32`
 * cd to `/mnt/workspace`
 * Run `./build.sh ~/Downloads/qt-everywhere-opensource-src-*/`
