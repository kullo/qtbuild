#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && shellcheck "$0"

source "./_includes.sh"

URL="http://download.qt.io/snapshots/qt/5.6/5.6.2/latest_src/qt-everywhere-opensource-src-5.6.2.tar.gz"
LOCAL_FILE="qt-everywhere-opensource-src-5.6.2.tar.gz"
SHA1_HASH=""

(
    cd "$WORKSPACE"
    wget -O "$LOCAL_FILE" "$URL"
    if [ "$SHA1_HASH" != "" ]; then
        echo "Checking checksum ..."
        sha1sum "$LOCAL_FILE" | fgrep "$SHA1_HASH"
    fi
    echo "Extracting $LOCAL_FILE ..."
    tar -x \
        --use-compress-program="$GZIP_COMPRESSOR" \
        -f "$LOCAL_FILE"
    rm "$LOCAL_FILE"
)
