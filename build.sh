#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && shellcheck "$0"

QT_VERSION="5.6.1-1"
QT_SOURCEDIR=$(realpath "$1")

source "./_includes.sh"

BUILDDIR="$WORKSPACE/tmp/qt-build-$USER"
OUTFILE="$OUTDIR/kullo_qt${QT_VERSION}_${OS_NAME}.tar.gz"
INSTALL_PARENT="/opt"
INSTALL_FOLDERNAME="qt-clang-libc++"
INSTALL_ROOT="$INSTALL_PARENT/$INSTALL_FOLDERNAME"
INSTALL_SRC="$INSTALL_ROOT/src"
INSTALL_ICU="$WORKSPACE/icu-installation"

if [ ! -w "$INSTALL_ROOT" ] ; then
    echo "Can not write to directory '$INSTALL_ROOT'"
    exit 1
fi

if ! mkdir -p "$(dirname "$OUTFILE")"; then
    echo "Could not create parent directory for outfile '$OUTFILE'"
    exit 1
fi

# Clear Qt installation dir
echo "Clearing Qt installation dir ..."
rm -rf "${INSTALL_ROOT:?}/"*

# Build ICU
(
    echo "Building ICU ..."
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
            -cups \
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
        cp qtbase/config.summary "$PREFIX"
    )

    # Copy ICU libs into Qt installation
    (
        DST="$PREFIX/lib"
        echo "Copy ICU libs into Qt installation '$DST' ..."
        cd "$DST"
        MAJOR=57
        MINOR=1
        cp "$INSTALL_ICU/lib/libicudata.so.$MAJOR.$MINOR" .
        cp "$INSTALL_ICU/lib/libicui18n.so.$MAJOR.$MINOR" .
        cp "$INSTALL_ICU/lib/libicuuc.so.$MAJOR.$MINOR"   .
        ln -s libicudata.so.$MAJOR.$MINOR libicudata.so.$MAJOR
        ln -s libicui18n.so.$MAJOR.$MINOR libicui18n.so.$MAJOR
        ln -s libicuuc.so.$MAJOR.$MINOR   libicuuc.so.$MAJOR
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
    echo "Exporting to $OUTFILE ..."
    time tar -cv \
        --use-compress-program="$GZIP_COMPRESSOR" \
        -f "$OUTFILE" \
        "$INSTALL_FOLDERNAME"
)

# Next step
echo "#####################"
echo "# Use this command to download from build machine:"
echo "# scp $USER@$(hostname).cloudapp.net:$OUTFILE ."
echo "#####################"
