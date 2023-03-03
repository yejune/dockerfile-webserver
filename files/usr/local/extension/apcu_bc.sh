cd $PECL_SRC_DIR

git clone --recursive https://github.com/krakjoe/apcu-bc apcu-bc-${EXTENSION_APCU_BC_VERSION}

ext-pcl apcu-bc-${EXTENSION_APCU_BC_VERSION};