#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && shellcheck "$0"

QT_VERSION="5.6.0"
QT_SOURCE="$1"

BUILDDIR="/run/shm/qt-build-$USER"
INSTALL_ROOT="/opt/qt-$QT_VERSION-linux-clang-libc++"
INSTALL_SRC="$PREFIX_ROOT/src"

export LD_LIBRARY_PATH="/usr/local/lib:."

# sudo sudo apt-get install clang-3.6
# sudo update-alternatives --install /usr/bin/cc      cc      /usr/bin/clang-3.6 100
# sudo update-alternatives --install /usr/bin/c++     c++     /usr/bin/clang++-3.6 100
# sudo update-alternatives --install /usr/bin/clang   clang   /usr/bin/clang-3.6 100
# sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100
#
# sudo update-alternatives --config clang
# sudo update-alternatives --config clang++
# sudo update-alternatives --config cc
# sudo update-alternatives --config c++

sudo apt-get install -y \
    libfontconfig1-dev \
    libfreetype6-dev \
    libx11-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxrender-dev \
    libxcb1-dev \
    libx11-xcb-dev \
    libxcb-glx0-dev \
    libgl1-mesa-dev \
    libgtk2.0-dev \
    libc++-dev

if [ ! -w "$PREFIX_ROOT" ] ; then
    echo "Can not write to directory '$PREFIX_ROOT'"
    exit 1
fi

if ! mkdir -p "$PREFIX_SRC"; then
    echo "Could not create source directory '$PREFIX_SRC'"
    exit 1
fi
rsync --archive --delete "$QT_SOURCE/" "$PREFIX_SRC"

for MODE in debug release; do
    PREFIX="$PREFIX_ROOT/$MODE"

    rm -rf "$BUILDDIR"
    mkdir -p "$BUILDDIR"

    (
        cd "$BUILDDIR"
        "$PREFIX_SRC/configure" \
            -opensource \
            -confirm-license \
            -nomake examples \
            -platform linux-clang-libc++ \
            -prefix "$PREFIX" \
            -c++std c++11 \
            -no-openssl \
            -no-sql-sqlite \
            -no-sql-sqlite2 \
            -$MODE \
            -qt-xcb \
            -icu \
            -I /usr/local/include \
            -L /usr/local/lib \
            -gtkstyle \
            -skip qt3d \
            -skip qtactiveqt \
            -skip qtandroidextras \
            -skip qtcanvas3d \
            -skip qtconnectivity \
            -skip qtlocation \
            -skip qtmacextras \
            -skip qtscript \
            -skip qtsensors \
            -skip qtserialbus \
            -skip qtserialport \
            -skip qttools \
            -skip qtwayland \
            -skip qtwebchannel \
            -skip qtwebengine \
            -skip qtwebsockets \
            -skip qtwebview \
            -skip qtwinextras \
            -skip qtx11extras \
            -skip qtxmlpatterns \
            -shared
        time CCACHE_DISABLE=1 make -j "$(nproc)"
        make install
    )
done
