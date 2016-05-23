#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && shellcheck "$0"

debootstrap --arch i386 trusty /chroot-trusty32 http://de.archive.ubuntu.com/ubuntu/     
 
(
        echo "[trusty32]"
        echo "description=Ubuntu 14.04 Trusty Tahr (32 Bit)"
        echo "directory=/chroot-trusty32"
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
) > /chroot-trusty32/etc/sudoers.d/90-admin-user-kullo

# APT sources list
cp /etc/apt/sources.list /chroot-trusty32/etc/apt/sources.list

schroot -c trusty32 --directory / -- sudo apt-get update
schroot -c trusty32 --directory / -- sudo apt-get upgrade -y
schroot -c trusty32 --directory / -- sudo apt-get autoremove -y
schroot -c trusty32 --directory / -- sudo apt-get install -y git
schroot -c trusty32 --directory / -- sudo mkdir -p /run/shm/workspace
schroot -c trusty32 --directory / -- sudo chown kullo:kullo /run/shm/workspace
