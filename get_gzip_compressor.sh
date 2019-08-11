#!/bin/bash
set -o errexit -o nounset -o pipefail
command -v shellcheck > /dev/null && (shellcheck -x "$0" || shellcheck "$0")

if command -v pigz > /dev/null; then
    echo "pigz"
else
    echo "gzip"
fi
