#!/bin/bash
set -o errexit -o nounset -o pipefail
command -v shellcheck > /dev/null && (shellcheck -x "$0" || shellcheck "$0")

source "./_includes.sh"

mkdir -p "$DOWNLOADS_DIR"
(
    cd "$DOWNLOADS_DIR"
    wget -O "$QT_LOCAL_FILE" "$QT_URL"

    echo "Checking checksum ..."
    sha256sum "$QT_LOCAL_FILE" | grep -F "$QT_SHA256_HASH"

    echo "Extracting $QT_LOCAL_FILE ..."
    tar xf "$QT_LOCAL_FILE"
    rm "$QT_LOCAL_FILE"
)
