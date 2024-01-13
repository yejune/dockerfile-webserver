#!make

REPOGITORY_URL:=ap-northeast-2.ec2.archive.ubuntu.com

PHP81_GPGKEYS:=528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 39B641343D8C104B2B146DC3F9C39DC0B9698544 F1F692238FBC1666E5A5CCD4199F9DFEF6FFBAFD

PHP81_VERSION:=8.1.11
PHP81_SHA256:=3005198d7303f87ab31bc30695de76e8ad62783f806b6ab9744da59fe41cc5bd

# tar.xz
PHP82_VERSION:=8.2.4
PHP82_SHA256:=bc7bf4ca7ed0dd17647e3ea870b6f062fcb56b243bfdef3f59ff7f94e96176a8


PHP83_VERSION:=8.3.1
PHP83_SHA256:=56445b1771b2ba5b7573453f9e8a9451e2d810b1741a352fa05259733b1e9758


# LIBRARY_V8_VERSION:=7.5
# LIBRARY_XL_VERSION:=3.8.3
LIBRARY_XLSWRITER_VERSION:=1.1.5
# LIBRARY_VIPS_VERSION:=8.10.0
# LIBRARY_RABBITMQ_VERSION:=0.8.0

EXTENSION_PHALCON_VERSION:=5.6.0
EXTENSION_SWOOLE_VERSION:=5.1.1
EXTENSION_UUID_VERSION:=1.2.0
EXTENSION_APFD_VERSION:=1.0.3
EXTENSION_JSONPOST_VERSION:=1.1.0
EXTENSION_YAML_VERSION:=2.2.3
EXTENSION_JSONNET_VERSION:=1.3.1
EXTENSION_PROTOBUF_VERSION:=3.25.2
EXTENSION_IGBINARY_VERSION:=3.2.15
EXTENSION_MSGPACK_VERSION:=2.2.0
EXTENSION_MAILPARSE_VERSION:=3.1.6
EXTENSION_BASE58_VERSION:=1.0.2
EXTENSION_APCU_VERSION:=5.1.23
EXTENSION_APCU_BC_VERSION:=1.0.5
EXTENSION_MEMCACHED_VERSION:=3.2.0
EXTENSION_REDIS_VERSION:=6.0.2
EXTENSION_MONGODB_VERSION:=1.17.2
EXTENSION_RDKAFKA_VERSION:=6.0.3
EXTENSION_SIMPLE_KAFKA_CLIENT_VERSION:=0.1.4
EXTENSION_VAR_REPRESENTATION_VERSION:=0.1.4
EXTENSION_JSONPATH_VERSION:=2.1.0
EXTENSION_COUCHBASE_VERSION:=4.1.6
EXTENSION_CASSANDRA_VERSION:=1.3.2
EXTENSION_AMQP_VERSION:=2.1.1
EXTENSION_GEARMAN_VERSION:=2.1.0
EXTENSION_SODIUM_VERSION:=2.0.23
EXTENSION_MCRYPT_VERSION:=1.0.7
EXTENSION_SCREWIM_VERSION:=1.0.5
EXTENSION_EV_VERSION:=1.1.6RC1
EXTENSION_UV_VERSION:=0.3.0
EXTENSION_EIO_VERSION:=3.1.0
EXTENSION_EVENT_VERSION:=3.1.1
EXTENSION_MEMPROF_VERSION:=3.0.2
EXTENSION_HTTP_VERSION:=4.2.4
EXTENSION_CALLEE_VERSION:=0.0.0
EXTENSION_DECIMAL_VERSION:=1.4.0
EXTENSION_IMAGICK_VERSION:=3.7.0
EXTENSION_VIPS_VERSION:=1.0.13
EXTENSION_SSH2_VERSION:=1.4
EXTENSION_SQLSRV_VERSION:=5.12.0beta1
EXTENSION_V8JS_VERSION:=2.1.2
EXTENSION_V8_VERSION:=0.2.2
EXTENSION_OAUTH_VERSION:=2.0.7
#EXTENSION_EXCEL_VERSION:=1.1.0
EXTENSION_XLSWRITER_VERSION:=1.5.5
EXTENSION_XDEBUG_VERSION:=3.3.1
EXTENSION_SEASLOG_VERSION:=2.2.0
EXTENSION_COMPONERE_VERSION:=3.1.2
EXTENSION_RUNKIT7_VERSION:=4.0.0a6
EXTENSION_VLD_VERSION:=0.18.0
EXTENSION_DATADOG_TRACE_VERSION:=0.96.0
EXTENSION_GRPC_VERSION:=1.60.0
EXTENSION_PSR_VERSION:=1.2.0
EXTENSION_YACONF_VERSION:=1.1.2
EXTENSION_HTTP_MESSAGE_VERSION:=1.0.0
EXTENSION_GEOSPATIAL_VERSION:=0.3.2
EXTENSION_EXCIMER_VERSION:=1.1.1
EXTENSION_WASM_VERSION:=1.1.0
EXTENSION_ZEPHIR_PARSER_VERSION:=1.6.0
EXTENSION_ZEPHIR_VERSION:=0.17.0
EXTENSION_AWSCRT_VERSION:=1.2.3
EXTENSION_ZOOKEEPER_VERSION:=1.2.1
EXTENSION_XHPROF_VERSION:=2.3.9
EXTENSION_UOPZ_VERSION:=7.1.1
EXTENSION_SIMDJSON_VERSION:=4.0.0
EXTENSION_BSDIFF_VERSION:=0.1.2
EXTENSION_SOLR_VERSION:=2.7.0
DOCKERIZE_VERSION:=0.7.0


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
#    simple_kafka\
#    rdkafka\
#    componere\
#    ddtrace\
#    excimer\
#    swoole\
#    fiber\
#    http_message\
#    solr\
#    apcu_bc\
#    grpc\
#    awscrt\
#    protobuf\
#    ssh2\
#    xhprof\
#    runkit7\
#    gearman\
#    memprof\
#    vld\
#    oauth\

define CUSTOM_EXTENSIONS
    apcu\
    simdjson\
    bsdiff\
    msgpack\
    igbinary\
    memcached\
    xlswriter\
    yaml\
    imagick\
    mailparse\
    base58\
    json_post\
    apfd\
    yaconf\
    uuid\
    vips\
    mongodb\
    psr\
    \
    redis\
    amqp\
    decimal\
    jsonpath\
    var_representation\
    zephir_parser\
    eio\
    ev\
    uv\
    geospatial\
    seaslog
endef
