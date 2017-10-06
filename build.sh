#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && (shellcheck -x "$0" || shellcheck "$0")

QT_SOURCEDIR=$(realpath "$1")

source "./_includes.sh"

BUILDDIR="$WORKSPACE/tmp/qt-build-$USER"
OUTFILE="$OUTDIR/kullo_qt${QT_VERSION}_${OS_NAME}.tar.gz"
INSTALL_SRC="$INSTALL_ROOT/src"

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

# Install Qt sources
if ! mkdir -p "$INSTALL_SRC"; then
    echo "Could not create source directory '$INSTALL_SRC'"
    exit 1
fi
echo "Copying Qt sources to '$INSTALL_SRC' ..."
time rsync --archive --delete "$QT_SOURCEDIR/" "$INSTALL_SRC"

# Build Qt
for MODE in debug release; do
    PREFIX="$INSTALL_ROOT/$MODE"

    rm -rf "$BUILDDIR"
    mkdir -p "$BUILDDIR"

    (
        cd "$BUILDDIR"
        "$INSTALL_SRC/configure" \
            -opensource \
            -confirm-license \
            -nomake examples \
            -platform linux-clang-libc++ \
            -prefix "$PREFIX" \
            -c++std c++11 \
            -no-mtdev \
            -no-openssl \
            -no-sql-sqlite \
            -no-sql-sqlite2 \
            -no-gstreamer \
            --zlib=qt \
            --libpng=qt \
            --libjpeg=qt \
            --xcb=qt \
            -gtk \
            -pulseaudio \
            -alsa \
            -$MODE \
            -cups \
            -skip qt3d \
            -skip qtactiveqt \
            -skip qtandroidextras \
            -skip qtcanvas3d \
            -skip qtconnectivity \
            -skip qtgamepad \
            -skip qtlocation \
            -skip qtmacextras \
            -skip qtnetworkauth \
            -skip qtscript \
            -skip qtscxml \
            -skip qtsensors \
            -skip qtserialbus \
            -skip qtserialport \
            -skip qtspeech \
            -skip qttranslations \
            -skip qtvirtualkeyboard \
            -skip qtwayland \
            -skip qtwebchannel \
            -skip qtwebengine \
            -skip qtwebkit \
            -skip qtwebsockets \
            -skip qtwebview \
            -skip qtwinextras \
            -skip qtx11extras \
            -skip qtxmlpatterns \
            -shared
        time CCACHE_DISABLE=1 make -j "$CORES"
        make install
        cp config.summary "$PREFIX"
    )
done

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
echo "# scp $USER@$PRIMARY_IP:$OUTFILE ."
echo "#####################"
