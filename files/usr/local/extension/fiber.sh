cd $PECL_SRC_DIR


EXTENSION_FIBER_VERSION=1.0.0

git clone https://github.com/amphp/ext-fiber fiber-${EXTENSION_FIBER_VERSION}
ext-pcl fiber-${EXTENSION_FIBER_VERSION}

