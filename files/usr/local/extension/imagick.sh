cd $PECL_SRC_DIR

ext-lib libmagickwand-dev imagemagick


git clone https://github.com/Imagick/imagick imagick-${EXTENSION_IMAGICK_VERSION}
ext-pcl imagick-${EXTENSION_IMAGICK_VERSION}
