#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && shellcheck "$0"

QT_VERSION="5.6.0"
QT_SOURCEDIR=$(realpath "$1")
CORES=$(nproc)

BUILDDIR="/run/shm/qt-build-$USER"
OUTFILE="/run/shm/out/kullo-qt5.6.0-linux64.tar.gz"
INSTALL_PARENT="/opt"
INSTALL_FOLDERNAME="qt-$QT_VERSION-linux-clang-libc++"
INSTALL_ROOT="$INSTALL_PARENT/$INSTALL_FOLDERNAME"
INSTALL_SRC="$INSTALL_ROOT/src"
INSTALL_ICU="$INSTALL_ROOT/icu"

# sudo apt-get install -y libfontconfig1-dev libfreetype6-dev libx11-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libx11-xcb-dev libxcb-glx0-dev libgl1-mesa-dev libgtk2.0-dev
# sudo apt-get install -y clang-3.6 libc++-dev
# sudo update-alternatives --install /usr/bin/cc      cc      /usr/bin/clang-3.6 100
# sudo update-alternatives --install /usr/bin/c++     c++     /usr/bin/clang++-3.6 100
# sudo update-alternatives --install /usr/bin/clang   clang   /usr/bin/clang-3.6 100
# sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100
#
# sudo update-alternatives --config clang
# sudo update-alternatives --config clang++
# sudo update-alternatives --config cc
# sudo update-alternatives --config c++

if [ ! -w "$INSTALL_ROOT" ] ; then
    echo "Can not write to directory '$INSTALL_ROOT'"
    exit 1
fi

if [ ! mkdir -p "$(dirname "$OUTFILE")" ] ; then
    echo "Could not create parent direcory for outfile '$OUTFILE'"
    exit 1
fi

# Build ICU
(
    cd icu/source
    CXXFLAGS="-stdlib=libc++" ./configure --prefix="$INSTALL_ICU"
    make -j "$CORES"
    make install
)

# Build Qt
for MODE in debug release; do
    PREFIX="$INSTALL_ROOT/$MODE"

    rm -rf "$BUILDDIR"
    mkdir -p "$BUILDDIR"

    (
        export LD_LIBRARY_PATH="$INSTALL_ICU/lib"
        cd "$BUILDDIR"
        "$QT_SOURCEDIR/configure" \
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
            -I "$INSTALL_ICU/include" \
            -L "$INSTALL_ICU/lib" \
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
        time CCACHE_DISABLE=1 make -j "$CORES"
        make install
    )
done

# Install Qt sources
if ! mkdir -p "$INSTALL_SRC"; then
    echo "Could not create source directory '$INSTALL_SRC'"
    exit 1
fi
echo "Copying Qt sources to '$INSTALL_SRC' ..."
time rsync --archive --delete "$QT_SOURCEDIR/" "$INSTALL_SRC"

# Export
(
    cd "$INSTALL_PARENT"
    time tar -cv \
        --use-compress-program="$(./get_gzip_compressor.sh)" \
        -f "$OUTFILE" \
        "$INSTALL_FOLDERNAME"
)
