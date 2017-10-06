Qt build scrips
===============

## Basic usage

 * Create and cd to `/mnt/workspace`
 * `apt-get install git`
 * Clone this repository and cd qt `qtbuild`
 * Run `./install_packages.sh`
 * Run `./download_qt.sh`
 * Run `./build.sh ../qt-everywhere-opensource-src-<version>/`

## Linux32 subsystem

 * cd to `/mnt/workspace` and run `sudo ./create_linux32_subsystem.sh`
 * Switch to subsystem: `schroot -c trusty32`
 * cd to `/mnt/workspace`
 * Run `./build.sh ~/Downloads/qt-everywhere-opensource-src-<version>/`
