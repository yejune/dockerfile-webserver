#!make

REPOGITORY_URL:=ap-northeast-2.ec2.archive.ubuntu.com

PHP71_GPGKEYS:=A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 1729F83938DA44E27BA0F4D3DBDB397470D12172

PHP72_GPGKEYS:=1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F

PHP73_GPGKEYS:=CBAF69F173A0FEA4B537F470D66C9593118BCCB6 F38252826ACD957EF380D39F2F7956BC5DA04B5D

PHP74_GPGKEYS:=42670A7FE4D0441C8E4632349E4FDC074A4EF02D 5A52880781F755608BF815FC910DEB46F53EA312

PHP80_GPGKEYS:=BFDDD28642824F8118EF77909B67A5C12229118F 1729F83938DA44E27BA0F4D3DBDB397470D12172

PHP81_GPGKEYS:=528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 39B641343D8C104B2B146DC3F9C39DC0B9698544 F1F692238FBC1666E5A5CCD4199F9DFEF6FFBAFD

PHP74_VERSION:=7.4.24
PHP74_SHA256:=ff7658ee2f6d8af05b48c21146af5f502e121def4e76e862df5ec9fa06e98734

PHP80_VERSION:=8.0.11
PHP80_SHA256:=e3e5f764ae57b31eb65244a45512f0b22d7bef05f2052b23989c053901552e16

PHP81_VERSION:=8.1.3
PHP81_SHA256:=5d65a11071b47669c17452fb336c290b67c101efb745c1dbe7525b5caf546ec6

LIBRARY_V8_VERSION:=7.5
LIBRARY_XL_VERSION:=3.8.3
LIBRARY_XLSWRITER_VERSION:=1.1.4
LIBRARY_VIPS_VERSION:=8.10.0
LIBRARY_RABBITMQ_VERSION:=0.8.0

EXTENSION_PHALCON_VERSION:=5.0.0beta3
EXTENSION_SWOOLE_VERSION:=4.8.7
EXTENSION_UUID_VERSION:=1.2.0
EXTENSION_APFD_VERSION:=1.0.3
EXTENSION_JSONPOST_VERSION:=1.1.0
EXTENSION_YAML_VERSION:=2.2.2
EXTENSION_JSONNET_VERSION:=1.3.1
EXTENSION_PROTOBUF_VERSION:=3.20.0RC1
EXTENSION_IGBINARY_VERSION:=3.2.7
EXTENSION_MSGPACK_VERSION:=2.2.0RC1
EXTENSION_MAILPARSE_VERSION:=3.1.3
EXTENSION_BASE58_VERSION:=1.0.2
EXTENSION_APCU_VERSION:=5.1.21
EXTENSION_MEMCACHED_VERSION:=3.2.0RC1
EXTENSION_REDIS_VERSION:=5.3.7
EXTENSION_MONGODB_VERSION:=1.12.1
EXTENSION_RDKAFKA_VERSION:=6.0.1
EXTENSION_SIMPLE_KAFKA_CLIENT_VERSION:=0.1.4
EXTENSION_VAR_REPRESENTATION_VERSION:=0.1.1
EXTENSION_JSONPATH_VERSION:=0.9.6
EXTENSION_COUCHBASE_VERSION:=3.2.2
EXTENSION_CASSANDRA_VERSION:=1.3.2
EXTENSION_AMQP_VERSION:=1.11.0
EXTENSION_GEARMAN_VERSION:=2.1.0
EXTENSION_SODIUM_VERSION:=2.0.23
EXTENSION_MCRYPT_VERSION:=1.0.4
EXTENSION_SCREWIM_VERSION:=1.0.5
EXTENSION_EV_VERSION:=1.1.6RC1
EXTENSION_UV_VERSION:=0.2.4
EXTENSION_EIO_VERSION:=3.0.0RC4
EXTENSION_EVENT_VERSION:=3.0.7RC1
EXTENSION_MEMPROF_VERSION:=3.0.2
EXTENSION_HTTP_VERSION:=4.2.2
EXTENSION_CALLEE_VERSION:=0.0.0
EXTENSION_DECIMAL_VERSION:=1.4.0
EXTENSION_IMAGICK_VERSION:=3.7.0
EXTENSION_VIPS_VERSION:=1.0.13
EXTENSION_SSH2_VERSION:=1.3.1
EXTENSION_SQLSRV_VERSION:=5.10.0
EXTENSION_V8JS_VERSION:=2.1.2
EXTENSION_V8_VERSION:=0.2.2
EXTENSION_OAUTH_VERSION:=2.0.7
EXTENSION_EXCEL_VERSION:=1.0.2
EXTENSION_XLSWRITER_VERSION:=1.5.1
EXTENSION_XDEBUG_VERSION:=3.1.3
EXTENSION_SEASLOG_VERSION:=2.2.0
EXTENSION_COMPONERE_VERSION:=3.1.2
EXTENSION_RUNKIT7_VERSION:=4.0.0a3
EXTENSION_VLD_VERSION:=0.17.2
EXTENSION_DATADOG_TRACE_VERSION:=0.70.1
EXTENSION_GRPC_VERSION:=1.44.0
EXTENSION_PSR_VERSION:=1.2.0
EXTENSION_YACONF_VERSION:=1.1.1
EXTENSION_HTTP_MESSAGE_VERSION:=0.2.2
EXTENSION_GEOSPATIAL_VERSION:=0.3.1
EXTENSION_EXCIMER_VERSION:=1.0.2
EXTENSION_WASM_VERSION:=1.1.0
EXTENSION_ZEPHIR_PARSER_VERSION:=1.5.0
EXTENSION_ZEPHIR_VERSION:=0.15.2
EXTENSION_AWSCRT_VERSION:=1.0.9
EXTENSION_ZOOKEEPER_VERSION:=1.0.0
EXTENSION_XHPROF_VERSION:=2.3.5
EXTENSION_UOPZ_VERSION:=7.1.1
DOCKERIZE_VERSION:=0.6.1


# ocbc
# oci8
# pdo_dblib\

define DEFAULT_EXTENSIONS
    bcmath\
    bz2\
    calendar\
    ctype\
    curl\
    date\
    dba\
    dom\
    enchant\
    exif\
    fileinfo\
    filter\
    ftp\
    gd\
    gettext\
    gmp\
    hash\
    iconv\
    imap\
    intl\
    json\
    ldap\
    libxml\
    mbstring\
    mysqlnd\
    mysqli\
    opcache\
    openssl\
    pcntl\
    pcre\
    pdo\
    pdo_firebird\
    pdo_mysql\
    pdo_pgsql\
    pdo_sqlite\
    pgsql\
    phar\
    posix\
    pspell\
    readline\
    reflection\
    session\
    shmop\
    simplexml\
    snmp\
    soap\
    sockets\
    sodium\
    spl\
    sqlite3\
    standard\
    sysvmsg\
    sysvsem\
    sysvshm\
    tidy\
    tokenizer\
    xml\
    xmlreader\
    xmlwriter\
    xsl\
    zip\
    zlib\
    ffi
endef

# jsonnet
#
#
# couchbase

### php 8
#    v8js\
#    excel\
#    xmlrpc\
#    callee\
#    http\
#    pdo_sqlsrv\
#    wasm\
#    zookeeper\
#    event\
#    couchbase\
#    uopz\
#    apcu\
#    simple_kafka\
#    rdkafka\
#    componere\
#    ddtrace\
#    excimer\
#    swoole\
#    fiber\

define CUSTOM_EXTENSIONS
    xlswriter\
    yaml\
    imagick\
    msgpack\
    igbinary\
    memcached\
    mailparse\
    base58\
    json_post\
    apfd\
    yaconf\
    oauth\
    uuid\
    vips\
    runkit7\
    gearman\
    mongodb\
    psr\
    \
    http_message\
    redis\
    amqp\
    grpc\
    decimal\
    awscrt\
    jsonpath\
    var_representation\
    xhprof\
    zephir_parser\
    memprof\
    vld\
    eio\
    ev\
    uv\
    protobuf\
    geospatial\
    ssh2\
    seaslog
endef
