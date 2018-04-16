#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && (shellcheck -x "$0" || shellcheck "$0")

source "./_includes.sh"

URL="http://download.qt.io/official_releases/qt/5.9/5.9.5/single/qt-everywhere-opensource-src-5.9.5.tar.xz"
LOCAL_FILE="qt-everywhere-opensource-src-5.9.5.tar.xz"
MD5_HASH="0e6eaa2d118f9854345c2debb12e8536"

mkdir -p "$DOWNLOADS_DIR"
(
    cd "$DOWNLOADS_DIR"
    wget -O "$LOCAL_FILE" "$URL"
    if [ "$MD5_HASH" != "" ]; then
        echo "Checking checksum ..."
        md5sum "$LOCAL_FILE" | fgrep "$MD5_HASH"
    fi
    echo "Extracting $LOCAL_FILE ..."
    tar xf "$LOCAL_FILE"
    rm "$LOCAL_FILE"
)
