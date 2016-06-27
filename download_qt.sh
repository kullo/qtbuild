#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && shellcheck "$0"

source "./_includes.sh"

# http://download.qt.io/official_releases/qt/5.6/5.6.1-1/single/qt-everywhere-opensource-src-5.6.1-1.tar.gz.mirrorlist
URL="http://download.qt.io/official_releases/qt/5.6/5.6.1-1/single/qt-everywhere-opensource-src-5.6.1-1.tar.gz"
LOCAL_FILE="qt-everywhere-opensource-src-5.6.1-1.tar.gz"
SHA1_HASH="1ece129e6230f65fde714203e6fabac743f9b323"

(
    cd "$WORKSPACE"
    wget -O "$LOCAL_FILE" "$URL"
    sha1sum "$LOCAL_FILE" | fgrep "$SHA1_HASH"
    echo "Extracting $LOCAL_FILE ..."
    tar -x \
        --use-compress-program="$GZIP_COMPRESSOR" \
        -f "$LOCAL_FILE"
    rm "$LOCAL_FILE"
)
