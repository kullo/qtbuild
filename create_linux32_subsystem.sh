#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && shellcheck "$0"

# Installing into ramdisc is not possible because of 'nodev' mount flag
# Prefer temporary SSD location
SCHROOT_ROOT="/mnt/chroot-trusty32"

debootstrap --arch i386 trusty "$SCHROOT_ROOT" "http://de.archive.ubuntu.com/ubuntu/"
 
(
    echo "[trusty32]"
    echo "description=Ubuntu 14.04 Trusty Tahr (32 Bit)"
    echo "directory=$SCHROOT_ROOT"
    echo "users=kullo"
    echo "type=directory"
    echo "profile=desktop"
    echo "personality=linux32"
    echo "preserve-environment=true"
) > /etc/schroot/chroot.d/trusty32.conf
 
 
(
    echo "# Created by $0 on $(date)"
    echo ""
    echo "# User rules for kullo"
    echo "kullo ALL=(ALL) NOPASSWD:ALL"
) > "$SCHROOT_ROOT/etc/sudoers.d/90-admin-user-kullo"

# APT sources list
cp /etc/apt/sources.list "$SCHROOT_ROOT/etc/apt/sources.list"

schroot -c trusty32 --directory / -- sudo apt-get update
schroot -c trusty32 --directory / -- sudo apt-get upgrade -y
schroot -c trusty32 --directory / -- sudo apt-get autoremove -y
schroot -c trusty32 --directory / -- sudo apt-get install -y git wget
schroot -c trusty32 --directory / -- sudo mkdir -p /run/shm/workspace
schroot -c trusty32 --directory / -- sudo chown kullo:kullo /run/shm/workspace
schroot -c trusty32 --directory /run/shm/workspace -- sudo git clone "https://github.com/webmaster128/qtbuild.git"
schroot -c trusty32 --directory /run/shm/workspace -- sudo chown -R kullo:kullo qtbuild
