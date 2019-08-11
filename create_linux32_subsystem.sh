#!/bin/bash
set -o errexit -o nounset -o pipefail
command -v shellcheck > /dev/null && (shellcheck -x "$0" || shellcheck "$0")

source "./_includes.sh"

# Installing into ramdisc is not possible because of 'nodev' mount flag
# Prefer temporary SSD location
SCHROOT_ROOT="/mnt/chroot-trusty32"

debootstrap --arch i386 trusty "$SCHROOT_ROOT" "http://de.archive.ubuntu.com/ubuntu/"

USER=$(whoami)
GROUP="$USER" # Assume there is a group called like the user

(
    echo "[trusty32]"
    echo "description=Ubuntu 14.04 Trusty Tahr (32 Bit)"
    echo "directory=$SCHROOT_ROOT"
    echo "users=$USER"
    echo "type=directory"
    echo "profile=default"
    echo "personality=linux32"
    echo "preserve-environment=true"
) > /etc/schroot/chroot.d/trusty32.conf


# (
#     echo "# Created by $0 on $(date)"
#     echo ""
#     echo "# User rules for kullo"
#     echo "kullo ALL=(ALL) NOPASSWD:ALL"
# ) > "$SCHROOT_ROOT/etc/sudoers.d/90-admin-user-kullo"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# APT sources list
cp /etc/apt/sources.list "$SCHROOT_ROOT/etc/apt/sources.list"

schroot -c trusty32 --directory / -- sudo apt-get update
schroot -c trusty32 --directory / -- sudo apt-get upgrade -y
schroot -c trusty32 --directory / -- sudo apt-get autoremove -y
schroot -c trusty32 --directory / -- sudo apt-get install -y git wget

schroot -c trusty32 --directory / -- sudo mkdir -p "$INSTALL_ROOT"
schroot -c trusty32 --directory / -- sudo chown "$USER":"$GROUP" "$INSTALL_ROOT"
schroot -c trusty32 --directory / -- sudo mkdir -p "$WORKSPACE"
schroot -c trusty32 --directory / -- sudo chown "$USER":"$GROUP" "$WORKSPACE"

schroot -c trusty32 --directory "$WORKSPACE" -- sudo git clone "https://github.com/webmaster128/qtbuild.git"
schroot -c trusty32 --directory "$WORKSPACE/qtbuild" -- sudo git checkout "$CURRENT_BRANCH"
schroot -c trusty32 --directory "$WORKSPACE/qtbuild" -- sudo chown -R "$USER":"$GROUP" .
schroot -c trusty32 --directory "$WORKSPACE/qtbuild" -- sudo ./install_packages.sh
schroot -c trusty32 --directory "$WORKSPACE/qtbuild" -- sudo ./download_qt.sh
