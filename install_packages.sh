#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && shellcheck "$0"

apt-get install -y \
    # Handy system tools:
    joe htop git \
    # Required by this script:
    realpath pigz wget \
    libfontconfig1-dev libfreetype6-dev libx11-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libx11-xcb-dev libxcb-glx0-dev libgl1-mesa-dev libgtk2.0-dev \
    clang-3.6 libc++-dev

# Setup compiler:
#   sudo update-alternatives --install /usr/bin/cc      cc      /usr/bin/clang-3.6   100
#   sudo update-alternatives --install /usr/bin/c++     c++     /usr/bin/clang++-3.6 100
#   sudo update-alternatives --install /usr/bin/clang   clang   /usr/bin/clang-3.6   100
#   sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100
#   sudo update-alternatives --config clang
#   sudo update-alternatives --config clang++
#   sudo update-alternatives --config cc
#   sudo update-alternatives --config c++
