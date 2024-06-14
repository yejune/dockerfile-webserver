cd ${PECL_SRC_DIR};


# git clone git://github.com/phalcon/php-zephir-parser.git;
git clone https://github.com/zephir-lang/php-zephir-parser -b development

# # wget-retry https://github.com/zephir-lang/php-zephir-parser/archive/v${EXTENSION_ZEPHIR_PARSER_VERSION}.tar.gz

# # tar zxvf v${EXTENSION_ZEPHIR_PARSER_VERSION}.tar.gz;

# mv php-zephir-parser-${EXTENSION_ZEPHIR_PARSER_VERSION} zephir_parser-${EXTENSION_ZEPHIR_PARSER_VERSION};


mv php-zephir-parser zephir_parser-${EXTENSION_ZEPHIR_PARSER_VERSION};

ext-pcl zephir_parser-${EXTENSION_ZEPHIR_PARSER_VERSION}

php -m;

# cd ${USR_LIB_DIR}/;

# wget-retry https://github.com/phalcon/zephir/archive/zephir-php8.tar.gz;
# tar zxvf zephir-php8.tar.gz;
# rm -rf zephir-php8.tar.gz;

# mv zephir-zephir-php8 zephir;
# cd ${USR_LIB_DIR}/zephir;
# # composer install;

# wget-retry https://github.com/zephir-lang/zephir/releases/download/${EXTENSION_ZEPHIR_VERSION}/zephir.phar

# mv zephir.phar ${USR_LOCAL_BIN_DIR}/zephir;


# git clone https://github.com/zephir-lang/zephir -b development
# cd zephir
# composer install
# cd ..

# mv zephir/zephir ${USR_LOCAL_BIN_DIR}/zephir;


# Clone the repository
git clone https://github.com/zephir-lang/zephir -b development
cd zephir
composer install
cd ..
mv zephir ${USR_LOCAL_BIN_DIR}/zephir-src
chmod +x ${USR_LOCAL_BIN_DIR}/zephir-src/zephir

ln -s ${USR_LOCAL_BIN_DIR}/zephir-src/zephir ${USR_LOCAL_BIN_DIR}/zephir

zephir help || exit 1;

# php -r "print_r(get_loaded_extensions());";
# zephir_parser
# new_extension_name="Zephir Parser";


curl https://get.wasmer.io -sSfL | sh