CORES=$(nproc)
GZIP_COMPRESSOR=$(./get_gzip_compressor.sh)

PLATFORM=$(uname --hardware-platform)
if [[ "$PLATFORM" == "i686" ]]; then
    OS_NAME="linux32"
elif [[ "$PLATFORM" == "x86_64" ]]; then
    OS_NAME="linux64"
else
    echo "Unsupported platform: '$PLATFORM'."
    exit 1
fi

DOWNLOADS_DIR="$HOME/Downloads"
# Do not use anything in $HOME because linux64 and linux32 share the same home directory
WORKSPACE="/run/shm/workspace"
OUTDIR="$WORKSPACE/out"

INSTALL_PARENT="/opt"
INSTALL_FOLDERNAME="qt-clang-libc++"
INSTALL_ROOT="$INSTALL_PARENT/$INSTALL_FOLDERNAME"
