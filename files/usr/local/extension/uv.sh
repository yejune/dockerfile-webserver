cd $PECL_SRC_DIR

ext-lib libuv1-dev

git clone https://github.com/bwoebi/php-uv uv-${EXTENSION_UV_VERSION}

ext-pcl uv-${EXTENSION_UV_VERSION}
