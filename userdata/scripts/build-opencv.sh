
THIS_DIR=$(cd $(dirname $BASH_SOURCE) && pwd)

export PKG_CONFIG_PATH=/opt/ffmpeg-3.1.4/lib/pkgconfig/

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ffmpeg-3.1.4/lib

cmake -DCMAKE_TOOLCHAIN_FILE=/data/public-space/toolchains/linux-gcc-4.9-x86_64-toolchain.cmake ../

make -j5 install

cp ${THIS_DIR}/opencv-vars.sh install/

bash ${THIS_DIR}/build-opencv-python3.sh

