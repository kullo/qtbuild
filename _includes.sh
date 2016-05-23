CORES=$(nproc)

PLATFORM=$(uname --hardware-platform)
if [[ "$PLATFORM" == "i686" ]]; then
    OS_NAME="linux32"
elif [[ "$PLATFORM" == "x86_64" ]]; then
    OS_NAME="linux64"
else
    echo "Unsupported platform: '$PLATFORM'."
    exit 1
fi

WORKSPACE="/run/shm/workspace"
OUTDIR="$WORKSPACE/out"
