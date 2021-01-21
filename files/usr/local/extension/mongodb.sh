# ext-lib libmongoc-dev libbson-dev


git clone https://github.com/mongodb/mongo-php-driver mongodb-${EXTENSION_MONGODB_VERSION}

git clone https://github.com/mongodb/mongo-c-driver mongodb-${EXTENSION_MONGODB_VERSION}/src/libmongoc

git clone https://github.com/mongodb/libmongocrypt mongodb-${EXTENSION_MONGODB_VERSION}/src/libmongocrypt

ext-pcl mongodb-${EXTENSION_MONGODB_VERSION}
# --with-mongodb-client-side-encryption=yes
#--with-mongodb-sasl=yes