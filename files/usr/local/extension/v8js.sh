cd $PECL_SRC_DIR
add-apt-repository ppa:stesie/libv8
apt-get update

apt-get install -y libv8-${LIBRARY_V8_VERSION}-dev
ext-pcl v8js-${EXTENSION_V8JS_VERSION} --with-v8js=/opt/libv8-${LIBRARY_V8_VERSION}/
