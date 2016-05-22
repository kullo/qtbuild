#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && shellcheck "$0"

# http://download.qt.io/official_releases/qt/5.6/5.6.0/single/qt-everywhere-opensource-src-5.6.0.tar.gz.mirrorlist
URL="http://download.qt.io/official_releases/qt/5.6/5.6.0/single/qt-everywhere-opensource-src-5.6.0.tar.gz"
LOCAL_FILE="qt-everywhere-opensource-src-5.6.0.tar.gz"

wget -O "$LOCAL_FILE" "$URL"
sha1sum "$LOCAL_FILE" | grep "4f111a4d6bb90eaed024b857b1bd3d0731ace8a2"
echo "Extracting $LOCAL_FILE ..."
tar -x \
    --use-compress-program="$(./get_gzip_compressor.sh)" \
    -f "$LOCAL_FILE"
rm "$LOCAL_FILE"
