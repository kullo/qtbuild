#!/bin/bash
set -o errexit -o nounset -o pipefail
which shellcheck > /dev/null && shellcheck "$0"

if which pigz > /dev/null; then
    echo "pigz"
else
    echo "gzip"
fi
