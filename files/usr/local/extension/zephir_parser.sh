cd ${PECL_SRC_DIR};

# git clone git://github.com/phalcon/php-zephir-parser.git;

wget-retry https://github.com/zephir-lang/php-zephir-parser/archive/v${EXTENSION_ZEPHIR_PARSER_VERSION}.tar.gz

tar zxvf v${EXTENSION_ZEPHIR_PARSER_VERSION}.tar.gz;

mv php-zephir-parser-${EXTENSION_ZEPHIR_PARSER_VERSION} zephir_parser-${EXTENSION_ZEPHIR_PARSER_VERSION};

ext-pcl zephir_parser-${EXTENSION_ZEPHIR_PARSER_VERSION}

php -m;

cd ${USR_LIB_DIR}/;

# wget-retry https://github.com/phalcon/zephir/archive/zephir-php8.tar.gz;
# tar zxvf zephir-php8.tar.gz;
# rm -rf zephir-php8.tar.gz;

# mv zephir-zephir-php8 zephir;
# cd ${USR_LIB_DIR}/zephir;
# composer install;

wget-retry https://github.com/zephir-lang/zephir/releases/download/${EXTENSION_ZEPHIR_VERSION}/zephir.phar

mv zephir.phar ${USR_LOCAL_BIN_DIR}/zephir;
# echo '#!/bin/bash
# ${USR_LIB_DIR}/zephir/zephir $@
# ' > ${USR_LOCAL_BIN_DIR}/zephir
chmod a+rx ${USR_LOCAL_BIN_DIR}/zephir

zephir help || exit 1;

# php -r "print_r(get_loaded_extensions());";
# zephir_parser
# new_extension_name="Zephir Parser";