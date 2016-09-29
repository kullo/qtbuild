Qt build scrips
===============

## Basic usage

1. Create and cd to `/mnt/workspace`
2. Clone this repository
3. Run `./download_qt.sh`
4. Run `./build.sh ../qt-everywhere-opensource-src-<version>/`

## Linux32 subsystem

1. cd to `/mnt/workspace` and run `sudo ./create_linux32_subsystem.sh`
2. Switch to subsystem: `schroot -c trusty32`
3. cd to `/mnt/workspace`
3. Run `./build.sh ../qt-everywhere-opensource-src-<version>/`
