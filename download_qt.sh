#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && (shellcheck -x "$0" || shellcheck "$0")

source "./_includes.sh"

URL="https://download.qt.io/official_releases/qt/5.6/5.6.2/single/qt-everywhere-opensource-src-5.6.2.tar.gz"
LOCAL_FILE="qt-everywhere-opensource-src-5.6.2.tar.gz"
SHA1_HASH="4385b53f78665ac340ea2a709ebecf1e776efdc2"

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
