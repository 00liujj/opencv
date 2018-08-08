set -x


THIS_DIR=$(cd $(dirname $BASH_SOURCE) && pwd)

export OpenCV_DIR=${THIS_DIR}
export PKG_CONFIG_PATH=${OpenCV_DIR}/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=${OpenCV_DIR}/lib:$LD_LIBRARY_PATH

if python --version |& grep -q -i 'Python 2' ; then
  export PYTHONPATH=${OpenCV_DIR}/lib/python2.7/dist-packages:${PYTHONPATH}
else
  export PYTHONPATH=${OpenCV_DIR}/lib/python3.5/dist-packages:${PYTHONPATH}
fi

(
cd ${OpenCV_DIR}/lib/pkgconfig
if ! grep -q ${OpenCV_DIR} opencv.pc; then
  sed -i "s|^prefix=.*$|prefix=${OpenCV_DIR}|g" opencv.pc
fi
)

set +x
