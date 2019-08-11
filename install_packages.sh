#!/bin/bash
set -o errexit -o nounset -o pipefail
command -v shellcheck > /dev/null && (shellcheck -x "$0" || shellcheck "$0")

apt update
apt upgrade -y

apt install -y \
  joe htop git \
  pigz wget rsync \
  libfontconfig1-dev libfreetype6-dev libx11-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libx11-xcb-dev libxcb-glx0-dev libgl1-mesa-dev libgtk-3-dev \
  libasound2-dev libpulse-dev \
  libcups2-dev \
  clang libc++-dev libc++abi-dev \
  debootstrap schroot

update-alternatives --install /usr/bin/cc      cc      /usr/bin/clang    100
update-alternatives --install /usr/bin/c++     c++     /usr/bin/clang++  100

update-alternatives --set cc      /usr/bin/clang
update-alternatives --set c++     /usr/bin/clang++
