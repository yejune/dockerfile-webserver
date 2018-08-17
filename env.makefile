#!make

REPOGITORY_URL:=ap-northeast-2.ec2.archive.ubuntu.com

# PHP71_VERSION:=7.1.15
# PHP71_SHA256:=0e17192fb43532e4ebaa190ecec9c7e59deea7dadb7dab67b19c2081a68bd817
# PHP71_GPGKEYS:=A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 1729F83938DA44E27BA0F4D3DBDB397470D12172

# PHP72_VERSION:=7.2.3
# PHP72_SHA256:=b3a94f1b562f413c0b96f54bc309706d83b29ac65d9b172bc7ed9fb40a5e651f
# PHP72_GPGKEYS:=1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F

# PHP71_VERSION:=7.1.16
# PHP71_SHA256:=a5d67e477248a3911af7ef85c8400c1ba8cd632184186fd31070b96714e669f1
# PHP71_GPGKEYS:=A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 1729F83938DA44E27BA0F4D3DBDB397470D12172

# PHP72_VERSION:=7.2.4
# PHP72_SHA256:=7916b1bd148ddfd46d7f8f9a517d4b09cd8a8ad9248734e7c8dd91ef17057a88
# PHP72_GPGKEYS:=1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F

# PHP71_VERSION:=7.1.17
# PHP71_SHA256:=1a784806866e06367f7a5c88775d239d6f30041c7ce65a8232d03a3d4de56d56
# PHP71_GPGKEYS:=A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 1729F83938DA44E27BA0F4D3DBDB397470D12172

# PHP72_VERSION:=7.2.5
# PHP72_SHA256:=af70a33b3f7a51510467199b39af151333fbbe4cc21923bad9c7cf64268cddb2
# PHP72_GPGKEYS:=1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F

# PHP71_VERSION:=7.1.18
# PHP71_SHA256:=8bd91cea072ea5b368cc9b4533a1a683eb426abdacbf024bb6ffa9b799cd3b01
# PHP71_GPGKEYS:=A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 1729F83938DA44E27BA0F4D3DBDB397470D12172

# PHP72_VERSION:=7.2.6
# PHP72_SHA256:=1f004e049788a3effc89ef417f06a6cf704c95ae2a718b2175185f2983381ae7
# PHP72_GPGKEYS:=1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F

PHP71_VERSION:=7.1.20
PHP71_SHA256:=cd7d1006201459d43fae0790cce4eb3451add5c87f4cadb13b228d4c179b850c
PHP71_GPGKEYS:=A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 1729F83938DA44E27BA0F4D3DBDB397470D12172

# PHP72_VERSION:=7.2.8
# PHP72_SHA256:=53ba0708be8a7db44256e3ae9fcecc91b811e5b5119e6080c951ffe7910ffb0f
# PHP72_GPGKEYS:=1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F

PHP72_VERSION:=7.2.9
PHP72_SHA256:=3585c1222e00494efee4f5a65a8e03a1e6eca3dfb834814236ee7f02c5248ae0
PHP72_GPGKEYS:=1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F

LIBRARY_V8_VERSION:=6.6
LIBRARY_RABBITMQ_VERSION:=0.8.0
EXTENSION_YAML_VERSION:=2.0.2
EXTENSION_IGBINARY_VERSION:=2.0.7
EXTENSION_MSGPACK_VERSION:=2.0.2
EXTENSION_APCU_VERSION:=5.1.11
EXTENSION_MEMCACHED_VERSION:=3.0.4
EXTENSION_REDIS_VERSION:=4.1.1
EXTENSION_MONGODB_VERSION:=1.5.2
EXTENSION_COUCHBASE_VERSION:=2.4.6
EXTENSION_CASSANDRA_VERSION:=2.4.6
EXTENSION_IMAGICK_VERSION:=3.4.3
EXTENSION_UUID_VERSION:=1.0.4
EXTENSION_EV_VERSION:=1.0.4
EXTENSION_UV_VERSION:=0.2.2
EXTENSION_SSH2_VERSION:=1.1.2
EXTENSION_PHALCON_VERSION:=3.4.1
EXTENSION_SODIUM_VERSION:=2.0.11
EXTENSION_SQLSRV_VERSION:=5.2.0
EXTENSION_GEARMAN_VERSION:=2.0.3
EXTENSION_AMQP_VERSION:=1.9.3
EXTENSION_V8JS_VERSION:=2.1.0
EXTENSION_V8_VERSION:=0.2.2
EXTENSION_SCREWIM_VERSION:=1.0.1
EXTENSION_SWOOLE_VERSION:=4.0.4
EXTENSION_HTTP_VERSION:=3.2.0
EXTENSION_XLSWRITER_VERSION:=1.2.2
EXTENSION_XDEBUG_VERSION:=2.6.1
EXTENSION_JSONNET_VERSION:=1.3.1
EXTENSION_EIO_VERSION:=2.0.4
EXTENSION_MEMPROF_VERSION:=2.0.0
EXTENSION_EVENT_VERSION:=2.4.1
DOCKERIZE_VERSION:=0.6.1

define MINI_EXTENSIONS
    phalcon\
    bcmath\
    calendar\
    ctype\
    gettext\
    gmp\
    hash\
    iconv\
    intl\
    pcntl\
    shmop\
    posix\
    \
    pdo\
    pdo_mysql\
    session\
    sockets\
    apcu\
    opcache\
    \
    uuid\
    json\
    jsonnet\
    igbinary\
    msgpack\
    yaml\
    \
    dom\
    xml\
    xmlreader\
    xmlwriter\
    simplexml\
    xsl\
    soap\
    xmlrpc\
    wddx\
    \
    memcached\
    mongodb\
    redis\
    amqp\
    gearman\
    \
    zip\
    bz2\
    phar\
    \
    tidy\
    tokenizer\
    screwim\
    \
    sodium\
    \
    ev\
    uv\
    eio\
    \
    swoole\
    http\
    xlswriter
endef

define FULL_EXTENSIONS
    ${MINI_EXTENSIONS}\
    snmp\
    \
    exif\
    fileinfo\
    gd\
    imagick\
    ssh2\
    \
    dba\
    enchant\
    pspell\
    recode\
    couchbase\
    cassandra\
    sqlite3\
    pdo_pgsql\
    pdo_sqlite\
    pdo_sqlsrv\
    v8js\
    v8\
    \
    sysvsem\
    sysvshm\
    sysvmsg\
    \
    memprof
endef
