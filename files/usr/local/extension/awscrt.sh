cd $PECL_SRC_DIR

git clone --recursive https://github.com/awslabs/aws-crt-php.git awscrt-${EXTENSION_AWSCRT_VERSION}

ext-pcl awscrt-${EXTENSION_AWSCRT_VERSION};

find / -name libaws-crt-ffi.so;

# cp ${PECL_SRC_DIR}/awscrt-${EXTENSION_AWSCRT_VERSION}/build/install/lib/libaws-crt-ffi.so /usr/local/lib/;
