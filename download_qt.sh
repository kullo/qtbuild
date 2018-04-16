#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && (shellcheck -x "$0" || shellcheck "$0")

source "./_includes.sh"

mkdir -p "$DOWNLOADS_DIR"
(
    cd "$DOWNLOADS_DIR"
    wget -O "$QT_LOCAL_FILE" "$QT_URL"
    if [ "$QT_MD5_HASH" != "" ]; then
        echo "Checking checksum ..."
        md5sum "$QT_LOCAL_FILE" | grep -F "$QT_MD5_HASH"
    fi
    echo "Extracting $QT_LOCAL_FILE ..."
    tar xf "$QT_LOCAL_FILE"
    rm "$QT_LOCAL_FILE"
)
