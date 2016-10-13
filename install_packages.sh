#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && shellcheck "$0"

apt-get update
apt-get upgrade -y

apt-get install -y \
  joe htop git \
  realpath pigz wget \
  libfontconfig1-dev libfreetype6-dev libx11-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libx11-xcb-dev libxcb-glx0-dev libgl1-mesa-dev libgtk2.0-dev \
  libcups2-dev \
  clang-3.6 libc++-dev

update-alternatives --install /usr/bin/cc      cc      /usr/bin/clang-3.6   100
update-alternatives --install /usr/bin/c++     c++     /usr/bin/clang++-3.6 100
update-alternatives --install /usr/bin/clang   clang   /usr/bin/clang-3.6   100
update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100

update-alternatives --set cc      /usr/bin/clang-3.6
update-alternatives --set c++     /usr/bin/clang++-3.6
update-alternatives --set clang   /usr/bin/clang-3.6
update-alternatives --set clang++ /usr/bin/clang++-3.6
