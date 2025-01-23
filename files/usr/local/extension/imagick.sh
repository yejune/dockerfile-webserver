cd $PECL_SRC_DIR

ext-lib libmagickwand-dev imagemagick


# git clone https://github.com/Imagick/imagick imagick-${EXTENSION_IMAGICK_VERSION}


git clone https://github.com/Imagick/imagick.git imagick-${EXTENSION_IMAGICK_VERSION}
cd imagick-${EXTENSION_IMAGICK_VERSION}

# imagick.c 파일에서 모든 php_strtolower를 zend_str_tolower로 변경
sed -i 's/php_strtolower/zend_str_tolower/g' imagick.c

cd $PECL_SRC_DIR

ext-pcl imagick-${EXTENSION_IMAGICK_VERSION}
