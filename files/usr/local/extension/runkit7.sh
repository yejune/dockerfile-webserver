cd $PECL_SRC_DIR

wget-retry https://github.com/runkit7/runkit7/archive/${EXTENSION_RUNKIT7_VERSION}.tar.gz

tar zxvf ${EXTENSION_RUNKIT7_VERSION}.tar.gz

rm -rf ${EXTENSION_RUNKIT7_VERSION}.tar.gz

cd runkit7-${EXTENSION_RUNKIT7_VERSION}

ext-pcl runkit7-${EXTENSION_RUNKIT7_VERSION}
