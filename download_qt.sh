#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && (shellcheck -x "$0" || shellcheck "$0")

source "./_includes.sh"

URL="http://download.qt.io/official_releases/qt/5.9/5.9.1/single/qt-everywhere-opensource-src-5.9.1.tar.xz"
LOCAL_FILE="qt-everywhere-opensource-src-5.9.1.tar.xz"
SHA1_HASH="8b9900cece0a18cf23d53a42379a628a1c1330ae"

(
    cd "$WORKSPACE"
    wget -O "$LOCAL_FILE" "$URL"
    if [ "$SHA1_HASH" != "" ]; then
        echo "Checking checksum ..."
        sha1sum "$LOCAL_FILE" | fgrep "$SHA1_HASH"
    fi
    echo "Extracting $LOCAL_FILE ..."
    tar xf "$LOCAL_FILE"
    rm "$LOCAL_FILE"
)
