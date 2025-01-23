cd $PECL_SRC_DIR
# ext-lib libmongoc-dev libbson-dev


git clone --recursive https://github.com/mongodb/mongo-php-driver mongodb-${EXTENSION_MONGODB_VERSION}

ext-pcl mongodb-${EXTENSION_MONGODB_VERSION}
# --with-mongodb-client-side-encryption=yes
# --with-mongodb-sasl=yes