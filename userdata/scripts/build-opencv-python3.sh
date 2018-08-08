set -x

THIS_DIR=$(cd $(dirname $BASH_SOURCE) && pwd)

OPENCV_SRC=$(cd $THIS_DIR/../../ && pwd)
OPENCV_BIN=${OPENCV_SRC}/build-x86_64/
INSTALL_DIR=${OPENCV_BIN}/install/


if [ ! -d "$INSTALL_DIR" ] ; then
  echo "make install first"
  exit
fi

(

mkdir python3
cd python3

export PKG_CONFIG_PATH=${OPENCV_BIN}/install/lib/pkgconfig

# copy headers.txt
cp -f ${OPENCV_BIN}/modules/python_bindings_generator/headers.txt .
cp -f ${OPENCV_BIN}/modules/python_bindings_generator/pyopencv_custom_headers.h .

# generate headers
/opt/anaconda3/bin/python ${OPENCV_SRC}/modules/python/src2/gen2.py . headers.txt PYTHON3

g++ -shared -fPIC -O3 ${OPENCV_SRC}/modules/python/src2/cv2.cpp -o cv2.so \
  -Wl,--as-needed,-z,defs,-soname,cv2.so \
  -I /opt/anaconda3/include/python3.5m/ \
  -I . \
  `pkg-config opencv --cflags` \
  -I /opt/anaconda3/lib/python3.5/site-packages/numpy/core/include/ \
  `pkg-config opencv --libs` \
  /opt/anaconda3/lib/libpython3.5m.so

if [ -d "$INSTALL_DIR" ] ; then
  PYTHON3_DIR=${INSTALL_DIR}/lib/python3.5/dist-packages
  mkdir -p ${PYTHON3_DIR}
  cp cv2.so ${PYTHON3_DIR}/
fi
)


