os=$(uname -s)
if [ $os = "Darwin" ]; then
    eval $(docker-machine env bootapp-docker-machine)
fi

type="$1"

VERSION="$2"

if [ -z $VERSION ]; then
    VERSION=7.2
fi

subname=""
if [ ! -z "$type" ]; then
    if [ "$type" = "full" ] || [ "$type" = "mini" ] || [ "$type" = "main" ]; then #|| [ "$type" = "extra" ]
        subname="-$type"
    else
        echo "$type not support, full, main, mini" # or extra
        exit
    fi
else
    echo "$type not support, full, main, mini" # or extra
    exit
fi

if [ $type = "main" ]; then
    type=""
    subname=""
fi

tagname="yejune/webserver:${VERSION}${subname}"

if [[ $subname = "-mini" ]]; then
    EXTENSIONS="\
        bcmath\
        bz2\
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
        \
        json\
        igbinary\
        msgpack\
        yaml\
        dom\
        xml\
        xmlreader\
        xmlwriter\
        simplexml\
        xsl\
        \
        memcached\
        mongodb\
        redis\
        amqp\
        \
        uuid\
        phalcon\
        phar\
        zip\
        \
        tidy\
        tokenizer\
        \
        sodium\
        \
        screwim\
"
elif [[ $subname = "-full" ]]; then
    EXTENSIONS="\
        bcmath\
        bz2\
        calendar\
        ctype\
        gettext\
        gmp\
        hash\
        iconv\
        intl\
        json\
        igbinary\
        msgpack\
        pcntl\
        pdo\
        pdo_mysql\
        posix\
        session\
        sockets\
        apcu\
        memcached\
        mongodb\
        redis\
        uuid\
        phalcon\
        phar\
        shmop\
        zip\
        tidy\
        tokenizer\
        snmp\
        dom\
        xml\
        xmlreader\
        xmlwriter\
        simplexml\
        xsl\
        soap\
        yaml\
        \
        xmlrpc\
        exif\
        fileinfo\
        gd\
        imagick\
        ev\
        uv\
        ssh2\
        sodium\
        gearman\
        amqp\
        screwim\
        swoole\
        \
        dba\
        enchant\
        pspell\
        recode\
        wddx\
        sqlite3\
        pdo_pgsql\
        pdo_sqlite\
        pdo_sqlsrv\
        v8js\
        v8\
"
else
    EXTENSIONS="\
        bcmath\
        bz2\
        calendar\
        ctype\
        gettext\
        gmp\
        hash\
        iconv\
        intl\
        pcntl\
        \
        json\
        igbinary\
        msgpack\
        \
        pdo\
        pdo_mysql\
        posix\
        session\
        sockets\
        apcu\
        memcached\
        mongodb\
        redis\
        uuid\
        phalcon\
        phar\
        shmop\
        zip\
        tidy\
        tokenizer\
        snmp\
        dom\
        xml\
        xmlreader\
        xmlwriter\
        simplexml\
        xsl\
        soap\
        yaml\
        \
        xmlrpc\
        exif\
        fileinfo\
        gd\
        imagick\
        ev\
        uv\
        ssh2\
        sodium\
        gearman\
        amqp\
        screwim\
        swoole\
"
fi

echo $tagname
echo $EXTENSIONS

REPOGITORY_URL="ap-northeast-2.ec2.archive.ubuntu.com"

NJS_VERSION="1.12.2.0.1.14-1"
NGINX_VERSION="1.12.2-1"
NGINX_GPGKEY="573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62"

if [[ $VERSION == "7.1."* ]]; then
    PHP_VERSION="7.1.14"
    PHP_GPGKEYS="A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 1729F83938DA44E27BA0F4D3DBDB397470D12172"
    PHP_SHA256="c09f0c1074f5689b492d79034adb84e6a6c6d08c6763c02282e6318d41156779"
else
    PHP_VERSION="7.2.3"
    PHP_GPGKEYS="1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F"
    PHP_SHA256="b3a94f1b562f413c0b96f54bc309706d83b29ac65d9b172bc7ed9fb40a5e651f"
fi

echo ${PHP_VERSION}
docker build --no-cache \
    --tag ${tagname} \
    --build-arg BUILD_EXTENSIONS="${EXTENSIONS}" \
    --build-arg NGINX_VERSION="${NGINX_VERSION}" \
    --build-arg NJS_VERSION="${NJS_VERSION}" \
    --build-arg NGINX_GPGKEY="${NGINX_GPGKEY}" \
    --build-arg PHP_VERSION="${PHP_VERSION}" \
    --build-arg PHP_GPGKEYS="${PHP_GPGKEYS}" \
    --build-arg PHP_SHA256="${PHP_SHA256}" \
    --build-arg REPOGITORY_URL="${REPOGITORY_URL}" \
    --build-arg LIBRARY_V8_VERSION=6.6 \
    --build-arg LIBRARY_RABBITMQ_VERSION=0.8.0 \
    --build-arg EXTENSION_YAML_VERSION=2.0.2 \
    --build-arg EXTENSION_IGBINARY_VERSION=2.0.5 \
    --build-arg EXTENSION_MSGPACK_VERSION=2.0.2 \
    --build-arg EXTENSION_APCU_VERSION=5.1.10 \
    --build-arg EXTENSION_MEMCACHED_VERSION=3.0.4 \
    --build-arg EXTENSION_REDIS_VERSION=3.1.6 \
    --build-arg EXTENSION_MONGODB_VERSION=1.4.1 \
    --build-arg EXTENSION_IMAGICK_VERSION=3.4.3 \
    --build-arg EXTENSION_UUID_VERSION=1.0.4 \
    --build-arg EXTENSION_EV_VERSION=1.0.4 \
    --build-arg EXTENSION_UV_VERSION=0.2.2 \
    --build-arg EXTENSION_SSH2_VERSION=1.1.2 \
    --build-arg EXTENSION_PHALCON_VERSION=3.3.1 \
    --build-arg EXTENSION_SODIUM_VERSION=2.0.10 \
    --build-arg EXTENSION_SQLSRV_VERSION=4.3.0 \
    --build-arg EXTENSION_GEARMAN_VERSION=2.0.3 \
    --build-arg EXTENSION_AMQP_VERSION=1.9.3 \
    --build-arg EXTENSION_V8JS_VERSION=2.1.0 \
    --build-arg EXTENSION_V8_VERSION=0.2.2 \
    --build-arg EXTENSION_SCREWIM_VERSION=1.0.1 \
    --build-arg EXTENSION_SWOOLE_VERSION=2.1.0 \
    --build-arg EXTENSION_XDEBUG_VERSION=2.6.0 \
    --build-arg DOCKERIZE_VERSION=0.6.0 \
    . || exit

docker push ${tagname}
