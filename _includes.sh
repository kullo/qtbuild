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
PRIMARY_IP=$(ifconfig eth0 | sed -En 's/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

DOWNLOADS_DIR="$HOME/Downloads"
# Do not use anything in $HOME because linux64 and linux32 share the same home directory
WORKSPACE="/run/shm/workspace"
OUTDIR="$WORKSPACE/out"

INSTALL_PARENT="/opt"
INSTALL_FOLDERNAME="qt-clang-libc++"
INSTALL_ROOT="$INSTALL_PARENT/$INSTALL_FOLDERNAME"

QT_VERSION="5.9.7"
QT_URL="http://download.qt.io/official_releases/qt/5.9/5.9.7/single/qt-everywhere-opensource-src-5.9.7.tar.xz"
QT_LOCAL_FILE="qt-everywhere-opensource-src-5.9.7.tar.xz"
QT_MD5_HASH="70e617aeb1f9bbf84a12b8cf09b01ece"
