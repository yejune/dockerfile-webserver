cd $PECL_SRC_DIR
git clone https://github.com/mpyw-junks/phpext-callee callee-${EXTENSION_CALLEE_VERSION}
ext-pcl callee-${EXTENSION_CALLEE_VERSION} --enable-callee
