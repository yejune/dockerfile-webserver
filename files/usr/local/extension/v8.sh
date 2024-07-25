cd $PECL_SRC_DIR
add-apt-repository ppa:stesie/libv8
apt-get update

apt-get install -y libv8-${LIBRARY_V8_VERSION}-dev
ext-pcl v8-${EXTENSION_V8_VERSION} --with-v8=/opt/libv8-${LIBRARY_V8_VERSION}/
