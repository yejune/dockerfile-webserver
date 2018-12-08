cd $PECL_SRC_DIR
rm -rf libv8
git clone https://github.com/yejune/libv8 -b bionic
cp -r libv8/opt/libv8 /opt/libv8/
ext-pcl v8-${EXTENSION_V8_VERSION} --with-v8=/opt/libv8
