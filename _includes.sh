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

QT_VERSION="5.12.4"
QT_URL="https://download.qt.io/official_releases/qt/5.12/5.12.4/single/qt-everywhere-src-5.12.4.tar.xz"
QT_SHA256_HASH="85da5e0ee498759990180d5b8192efaa6060a313c5018b772f57d446bdd425e1"

QT_LOCAL_FILE="qt-source-$QT_VERSION-download.tar.xz"
