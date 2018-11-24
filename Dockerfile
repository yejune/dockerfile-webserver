FROM ubuntu:18.04
LABEL maintainer="k@yejune.com"

ENV DEBIAN_FRONTEND noninteractive

ARG PHP_VERSION=7.2.12
ARG PHP_GPGKEYS="1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F"
ARG PHP_SHA256="989c04cc879ee71a5e1131db867f3c5102f1f7565f805e2bb8bde33f93147fe1"

ARG REPOGITORY_URL="archive.ubuntu.com"

ARG BUILD_EXTENSIONS

ARG EXTENSION_PHALCON_VERSION=3.4.1
ARG EXTENSION_SWOOLE_VERSION=4.2.8
ARG EXTENSION_UUID_VERSION=1.0.4
ARG EXTENSION_YAML_VERSION=2.0.4
ARG EXTENSION_JSONNET_VERSION=1.3.1
ARG EXTENSION_IGBINARY_VERSION=2.0.8
ARG EXTENSION_MSGPACK_VERSION=2.0.2
ARG EXTENSION_APCU_VERSION=5.1.14
ARG EXTENSION_MEMCACHED_VERSION=3.0.4
ARG EXTENSION_REDIS_VERSION=4.2.0
ARG EXTENSION_MONGODB_VERSION=1.5.3
ARG EXTENSION_COUCHBASE_VERSION=2.6.0
ARG EXTENSION_CASSANDRA_VERSION=1.3.2
ARG EXTENSION_AMQP_VERSION=1.9.3
ARG EXTENSION_GEARMAN_VERSION=2.0.3
ARG EXTENSION_SODIUM_VERSION=2.0.15
ARG EXTENSION_SCREWIM_VERSION=1.0.1
ARG EXTENSION_EV_VERSION=1.0.4
ARG EXTENSION_UV_VERSION=0.2.2
ARG EXTENSION_EIO_VERSION=2.0.4
ARG EXTENSION_EVENT_VERSION=2.4.1
ARG EXTENSION_MEMPROF_VERSION=2.0.0
ARG EXTENSION_HTTP_VERSION=3.2.0
ARG EXTENSION_PSR_VERSION=0.6.1
ARG EXTENSION_CALLEE_VERSION=0.0.0
ARG EXTENSION_DECIMAL_VERSION=1.1.0
ARG EXTENSION_IMAGICK_VERSION=3.4.3
ARG EXTENSION_VIPS_VERSION=1.0.9
ARG EXTENSION_SSH2_VERSION=1.1.2
ARG EXTENSION_SQLSRV_VERSION=5.4.0preview
ARG EXTENSION_V8JS_VERSION=2.1.0
ARG EXTENSION_V8_VERSION=0.2.2
ARG EXTENSION_OAUTH_VERSION=2.0.3
ARG EXTENSION_EXCEL_VERSION=1.0.2
ARG EXTENSION_XLSWRITER_VERSION=1.2.2
ARG EXTENSION_XDEBUG_VERSION=2.6.1
ARG EXTENSION_SEASLOG_VERSION=1.8.6
ARG DOCKERIZE_VERSION=0.6.1
ARG LIBRARY_XL_VERSION=3.8.3
ARG LIBRARY_VIPS_VERSION=8.7.0

SHELL ["/bin/bash", "-c"]

RUN if [ "archive.ubuntu.com" != "${REPOGITORY_URL}" ]; then \
        sed -i "s/archive.ubuntu.com/${REPOGITORY_URL}/g" /etc/apt/sources.list; \
        sed -i "s/security.ubuntu.com/${REPOGITORY_URL}/g" /etc/apt/sources.list; \
    fi

ENV PHP_INI_DIR=/etc/php \
    PHP_RUN_DIR=/run/php \
    PHP_LOG_DIR=/var/log/php \
    PHP_DATA_DIR=/var/lib/php \
    PHP_SRC_DIR=/usr/src/php \
    PHP_CONF_DIR=/etc/php/conf.d \
    PECL_SRC_DIR=/usr/src/pecl \
    SRC_DIR=/usr/src

ENV DEFAULT_EXTENSIONS="\
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
        json\
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
        zip\
        bz2\
        phar\
        \
        tidy\
        tokenizer\
        \
        sodium\
"

ENV MINI_EXTENSIONS="${DEFAULT_EXTENSIONS}\
        phalcon\
        \
        uuid\
        jsonnet\
        igbinary\
        msgpack\
        yaml\
        memcached\
        mongodb\
        redis\
        amqp\
        gearman\
        screwim\
        ev\
        uv\
        eio\
        event\
        \
        swoole\
        http\
        excel\
        psr\
        callee\
        decimal\
"

ENV FULL_EXTENSIONS="${MINI_EXTENSIONS}\
        \
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
        memprof\
        seaslog\
        oauth\
"

COPY files/ /

RUN set -xe; \
    source /init.sh; \
    \
    # savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get upgrade -y; \
    \
    DEPS="locales tzdata openssl ca-certificates wget curl ssh git apt-utils apt-transport-https xz-utils zip unzip"; \
    \
    DEV_DEPS="pkg-config autoconf dpkg-dev file g++ gcc make re2c bison software-properties-common"; \
    \
    LIB_DEPS=" \
        libc-dev \
        libpcre2-dev \
        libpcre3-dev \
        \
        libcurl4-openssl-dev \
        libreadline6-dev \
        libssl-dev \
        libxml2-dev \
        zlib1g-dev \
        libargon2-0 \
        libargon2-0-dev \
    "; \
    \
    mkdir -p "${PHP_CONF_DIR}"; \
    mkdir -p "${PHP_LOG_DIR}"; \
    mkdir -p "${SRC_DIR}"; \
    mkdir -p "${PECL_SRC_DIR}"; \
    mkdir -p "${PHP_SRC_DIR}"; \
    mkdir -p "${PHP_INI_DIR}/"; \
    mkdir -p "${PHP_INI_DIR}/php-fpm.d/"; \
    cd "${SRC_DIR}"; \
    \
    ADD_DEPS=' \
        lsb-release \
    '; \
    if ! command -v gpg > /dev/null; then \
        ADD_DEPS="${ADD_DEPS} \
            dirmngr \
            gnupg2 \
        "; \
    fi; \
    apt-get install --no-install-recommends --no-install-suggests -y ${DEPS} ${ADD_DEPS} ${DEV_DEPS} ${LIB_DEPS}; \
    dpkg-reconfigure tzdata ; \
    \
    \
    # Install nginx
    # found=''; \
    # for server in \
    #     ha.pool.sks-keyservers.net \
    #     hkp://keyserver.ubuntu.com:80 \
    #     hkp://p80.pool.sks-keyservers.net:80 \
    #     pgp.mit.edu \
    # ; do \
    #     echo "Fetching GPG key ${NGINX_GPGKEY} from $server"; \
    #     apt-key adv --keyserver "${server}" --keyserver-options timeout=10 --recv-keys "${NGINX_GPGKEY}" && found=yes && break; \
    # done; \
    # test -z "$found" && echo >&2 "error: failed to fetch GPG key ${NGINX_GPGKEY}" && exit 1; \
    # echo "deb http://nginx.org/packages/ubuntu/ $(lsb_release -cs) nginx" >> /etc/apt/sources.list; \
    add-apt-repository ppa:nginx/stable; \
    apt-get update; \
    apt-get install --no-install-recommends --no-install-suggests -y -o Dpkg::Options::="--force-confold" nginx; \
    # forward request and error logs to docker log collector
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    #ln -sf /dev/stderr /var/log/nginx/error.log; \
    \
    \
    # Install php
    \
    \
    if [[ $PHP_VERSION == *"RC"* ]]; then \
        PHP_URL="https://downloads.php.net/~cmb/php-${PHP_VERSION}.tar.xz"; \
        PHP_ASC_URL="https://downloads.php.net/~cmb/php-${PHP_VERSION}.tar.xz.asc"; \
    else \
        PHP_URL="https://secure.php.net/get/php-${PHP_VERSION}.tar.xz/from/this/mirror"; \
        PHP_ASC_URL="https://secure.php.net/get/php-${PHP_VERSION}.tar.xz.asc/from/this/mirror"; \
    fi; \
    \
    wget-retry -O php.tar.xz "${PHP_URL}"; \
    \
    if [ -n "$PHP_SHA256" ]; then \
        echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -; \
    fi; \
    \
    if [ -n "$PHP_ASC_URL" ]; then \
        wget-retry -O php.tar.xz.asc "$PHP_ASC_URL"; \
        export GNUPGHOME="$(mktemp -d)"; \
        for key in $PHP_GPGKEYS; do \
            gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" \
            || gpg --keyserver pgp.mit.edu --recv-keys "$key" \
            || gpg --keyserver keyserver.pgp.com --recv-keys "$key" \
            || gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$key" \
            || gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key"; \
        done; \
        gpg --batch --verify php.tar.xz.asc php.tar.xz; \
        rm -rf "$GNUPGHOME"; \
    fi; \
    \
    locale-gen en_US.UTF-8; \
    \
    # php
    tar -Jxf $SRC_DIR/php.tar.xz -C "${PHP_SRC_DIR}" --strip-components=1; \
    cd "${PHP_SRC_DIR}"; \
    \
    BUILD_ARCH="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    DEV_MULTI_ARCH="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
    \
    # https://bugs.php.net/bug.php?id=74125
	if [ ! -d /usr/include/curl ]; then \
		ln -sT "/usr/include/${DEV_MULTI_ARCH}/curl" /usr/local/include/curl; \
	fi; \
    # Apply stack smash protection to functions using local buffers and alloca()
    # Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
    # Enable optimization (-O2)
    # Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
    # Adds GNU HASH segments to generated executables (this is used if present, and is much faster than sysv hash; in this configuration, sysv hash is also generated)
    # https://github.com/docker-library/php/issues/272
    PHP_CFLAGS="-I${PHP_SRC_DIR} -fstack-protector-strong -fpic -fpie -O2"; \
    PHP_CPPFLAGS="$PHP_CFLAGS"; \
    PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"; \
    \
    ./configure \
        CFLAGS="$PHP_CFLAGS" \
        CPPFLAGS="$PHP_CPPFLAGS" \
        LDFLAGS="$PHP_LDFLAGS" \
        --build="${BUILD_ARCH}" \
        --sysconfdir="${PHP_INI_DIR}" \
        --with-libdir="lib/${DEV_MULTI_ARCH}" \
        --with-pcre-regex=/usr \
        \
        --disable-all \
        \
        --with-config-file-path="${PHP_INI_DIR}" \
        --with-config-file-scan-dir="${PHP_CONF_DIR}" \
        \
        # make sure invalid --configure-flags are fatal errors intead of just warnings
		--enable-option-checking=fatal \
        \
        --with-fpm-user=www-data \
        --with-fpm-group=www-data \
        \
        # --disable-cgi \
        # --disable-short-tags \
        --enable-hash \
        --with-mhash \
        \
        --enable-ipv6 \
        --enable-fpm \
        --enable-opcache \
        \
        --enable-ftp \
        --enable-mbstring \
        --enable-mysqlnd \
        \
        --with-curl \
        --with-openssl \
        --with-zlib \
        --with-readline \
        --enable-filter \
        \
        --enable-xml \
        --enable-libxml \
        --with-pear \
        --with-libxml-dir \
        --enable-phar \
        \
        # https://wiki.php.net/rfc/argon2_password_hash (7.2+)
        $([[ $PHP_VERSION != "7.1."* ]] && echo '--with-password-argon2') \
        # bundled pcre does not support JIT on s390x
        # https://manpages.debian.org/stretch/libpcre3-dev/pcrejit.3.en.html#AVAILABILITY_OF_JIT_SUPPORT
        $(test "$BUILD_ARCH" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
        \
        --without-sqlite3 \
        --without-pdo-sqlite \
    ; \
    \
    make -j "$(nproc)"; \
    make install; \
    make clean; \
    \
    PHP_EXTENSION_DIR=$(php-config --extension-dir); \
    \
    cp ${PHP_SRC_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini; \
    echo "zend_extension=opcache.so" > ${PHP_CONF_DIR}/opcache.ini; \
    \
    if [ ! -z "${BUILD_EXTENSIONS}" ]; then \
        BUILD_PHP_EXTENSIONS=( $BUILD_EXTENSIONS ); \
    else \
        BUILD_PHP_EXTENSIONS=( $FULL_EXTENSIONS ); \
    fi; \
    \
    \
    # sysvsem
    if in_array BUILD_PHP_EXTENSIONS "sysvsem"; then \
        ext-src sysvsem; \
    fi; \
    \
    # sysvshm
    if in_array BUILD_PHP_EXTENSIONS "sysvshm"; then \
        ext-src sysvshm; \
    fi; \
    \
    # sysvmsg
    if in_array BUILD_PHP_EXTENSIONS "sysvmsg"; then \
        ext-src sysvmsg; \
    fi; \
    \
    # bcmath
    if in_array BUILD_PHP_EXTENSIONS "bcmath"; then \
        ext-src bcmath; \
    fi; \
    \
    # bz2
    if in_array BUILD_PHP_EXTENSIONS "bz2"; then \
        ext-lib libbz2-dev; \
        ext-src bz2; \
    fi; \
    \
    # calendar
    if in_array BUILD_PHP_EXTENSIONS "calendar"; then \
        ext-src calendar; \
    fi; \
    \
    # ctype
    if in_array BUILD_PHP_EXTENSIONS "ctype"; then \
        ext-src ctype; \
    fi; \
    \
    # dba
    if in_array BUILD_PHP_EXTENSIONS "dba"; then \
        ext-src dba; \
    fi; \
    \
    # dom
    if in_array BUILD_PHP_EXTENSIONS "dom"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src dom; \
    fi; \
    \
    # enchant
    if in_array BUILD_PHP_EXTENSIONS "enchant"; then \
        ext-lib libenchant1c2a libenchant-dev; \
        ext-src enchant; \
    fi; \
    \
    # exif
    if in_array BUILD_PHP_EXTENSIONS "exif"; then \
        ext-src exif; \
    fi; \
    \
    # fileinfo
    if in_array BUILD_PHP_EXTENSIONS "fileinfo"; then \
        ext-src fileinfo; \
    fi; \
    \
    # gd
    if in_array BUILD_PHP_EXTENSIONS "gd"; then \
        ext-lib \
                libjpeg-dev \
                libpng-dev \
                libwebp-dev \
                libxpm-dev \
                libfreetype6-dev \
        ; \
        \
        ext-src gd --with-webp-dir \
                   --with-jpeg-dir \
                   --with-png-dir \
                   --with-zlib-dir \
                   --with-xpm-dir \
                   --with-freetype-dir \
                   --enable-gd-native-ttf \
        ; \
    fi; \
    \
    # gettext
    if in_array BUILD_PHP_EXTENSIONS "gettext"; then \
        ext-src gettext; \
    fi; \
    \
    # gmp
    if in_array BUILD_PHP_EXTENSIONS "gmp"; then \
        ext-lib libgmp-dev; \
        ext-src gmp --with-gmp=/usr/include/x86_64-linux-gnu/gmp.h; \
    fi; \
    \
    # hash
    if in_array BUILD_PHP_EXTENSIONS "hash"; then \
        ext-src hash; \
    fi; \
    \
    # iconv
    if in_array BUILD_PHP_EXTENSIONS "iconv"; then \
        ext-src iconv; \
    fi; \
    \
    # intl
    if in_array BUILD_PHP_EXTENSIONS "intl"; then \
        ext-lib libicu-dev; \
        ext-src intl; \
    fi; \
    \
    # json
    if in_array BUILD_PHP_EXTENSIONS "json"; then \
        ext-src json; \
    fi; \
    # callee
    if in_array BUILD_PHP_EXTENSIONS "callee"; then \
        cd $PECL_SRC_DIR; \
        git clone https://github.com/mpyw-junks/phpext-callee callee-${EXTENSION_JSONNET_VERSION}; \
        ext-pcl callee-${EXTENSION_JSONNET_VERSION} --enable-callee; \
    fi; \
    # decimal
    if in_array BUILD_PHP_EXTENSIONS "decimal"; then \
        cd $PECL_SRC_DIR; \
        ext-lib libmpdec-dev; \
        wget-retry https://github.com/php-decimal/ext-decimal/archive/v${EXTENSION_DECIMAL_VERSION}.tar.gz; \
        tar -zxvf v${EXTENSION_DECIMAL_VERSION}.tar.gz; \
        mv ext-decimal-${EXTENSION_DECIMAL_VERSION} decimal-${EXTENSION_DECIMAL_VERSION}; \
        ext-pcl decimal-${EXTENSION_DECIMAL_VERSION}; \
    fi; \
    # jsonnet
    if in_array BUILD_PHP_EXTENSIONS "jsonnet"; then \
        cd $PECL_SRC_DIR; \
        wget-retry http://pecl.php.net/get/Jsonnet-${EXTENSION_JSONNET_VERSION}.tgz; \
        tar -zxvf Jsonnet-${EXTENSION_JSONNET_VERSION}.tgz; \
        mv Jsonnet-${EXTENSION_JSONNET_VERSION} jsonnet-${EXTENSION_JSONNET_VERSION}; \
        ext-pcl jsonnet-${EXTENSION_JSONNET_VERSION}; \
    fi; \
    # seaslog
    if in_array BUILD_PHP_EXTENSIONS "seaslog"; then \
        cd $PECL_SRC_DIR; \
        wget-retry http://pecl.php.net/get/SeasLog-${EXTENSION_SEASLOG_VERSION}.tgz; \
        tar -zxvf SeasLog-${EXTENSION_SEASLOG_VERSION}.tgz; \
        mv SeasLog-${EXTENSION_SEASLOG_VERSION} seaslog-${EXTENSION_SEASLOG_VERSION}; \
        ext-pcl seaslog-${EXTENSION_SEASLOG_VERSION}; \
    fi; \
    \
    # pcntl
    if in_array BUILD_PHP_EXTENSIONS "pcntl"; then \
        ext-src pcntl; \
    fi; \
    \
    # pdo
    if in_array BUILD_PHP_EXTENSIONS "pdo"; then \
        ext-src pdo; \
    fi; \
    \
    # pdo mysql
    if in_array BUILD_PHP_EXTENSIONS "pdo_mysql"; then \
        ext-src pdo_mysql; \
    fi; \
    \
    # pdo pgsql
    if in_array BUILD_PHP_EXTENSIONS "pdo_pgsql"; then \
        ext-lib libpq-dev; \
        ext-src pdo_pgsql; \
    fi; \
    \
    # pdo sqlite
    if in_array BUILD_PHP_EXTENSIONS "pdo_sqlite"; then \
        ext-lib sqlite3 libsqlite3-dev libsqlite3-0; \
        ext-src pdo_sqlite; \
    fi; \
    \
    # phar
    if in_array BUILD_PHP_EXTENSIONS "phar"; then \
        ext-src phar; \
    fi; \
    \
    # posix
    if in_array BUILD_PHP_EXTENSIONS "posix"; then \
        ext-src posix; \
    fi; \
    \
    # pspell
    if in_array BUILD_PHP_EXTENSIONS "pspell"; then \
        ext-lib libpspell-dev; \
        ext-src pspell; \
    fi; \
    \
    # recode
    if in_array BUILD_PHP_EXTENSIONS "recode"; then \
        ext-lib librecode-dev; \
        ext-src recode; \
    fi; \
    \
    # session
    if in_array BUILD_PHP_EXTENSIONS "session"; then \
        ext-src session; \
    fi; \
    \
    # shmop
    if in_array BUILD_PHP_EXTENSIONS "shmop"; then \
        ext-src shmop; \
    fi; \
    \
    # simplexml
    if in_array BUILD_PHP_EXTENSIONS "simplexml"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src simplexml; \
    fi; \
    \
    # snmp
    if in_array BUILD_PHP_EXTENSIONS "snmp"; then \
        ext-lib libsnmp-dev snmp-mibs-downloader; \
        ext-src snmp; \
    fi; \
    \
    # soap
    if in_array BUILD_PHP_EXTENSIONS "soap"; then \
        ext-lib libxml2-dev; \
        ext-src soap; \
    fi; \
    \
    # sockets
    if in_array BUILD_PHP_EXTENSIONS "sockets"; then \
        ext-src sockets; \
    fi; \
    \
    # sqlite
    if in_array BUILD_PHP_EXTENSIONS "sqlite3"; then \
        ext-lib sqlite3 libsqlite3-dev libsqlite3-0; \
        ext-src sqlite3; \
    fi; \
    \
    # tidy
    if in_array BUILD_PHP_EXTENSIONS "tidy"; then \
        ext-lib libtidy-dev; \
        ext-src tidy; \
    fi; \
    \
    # tokenizer
    if in_array BUILD_PHP_EXTENSIONS "tokenizer"; then \
        ext-src tokenizer; \
    fi; \
    \
    # wddx
    if in_array BUILD_PHP_EXTENSIONS "wddx"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src wddx; \
    fi; \
    \
    # xml
    if in_array BUILD_PHP_EXTENSIONS "xml"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src xml; \
    fi; \
    \
    # xsl
    if in_array BUILD_PHP_EXTENSIONS "xsl"; then \
        ext-lib libxml2 libxslt1-dev; \
        ext-src xsl; \
    fi; \
    \
    # xmlreader
    if in_array BUILD_PHP_EXTENSIONS "xmlreader"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src xmlreader; \
    fi; \
    \
    # xmlwriter
    if in_array BUILD_PHP_EXTENSIONS "xmlwriter"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src xmlwriter; \
    fi; \
    \
    # xmlrpc
    if in_array BUILD_PHP_EXTENSIONS "xmlrpc"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src xmlrpc; \
    fi; \
    \
    # zip
    if in_array BUILD_PHP_EXTENSIONS "zip"; then \
        ext-lib libzip-dev; \
        ext-src zip; \
    fi; \
    \
    \
    \
    # pecl install
    \
    # yaml
    if in_array BUILD_PHP_EXTENSIONS "yaml"; then \
        ext-lib libyaml-dev; \
        ext-pcl yaml-${EXTENSION_YAML_VERSION}; \
    fi; \
    \
    # igbinary
    if in_array BUILD_PHP_EXTENSIONS "igbinary"; then \
        ext-pcl igbinary-${EXTENSION_IGBINARY_VERSION}; \
    fi; \
    \
    # msgpack
    if in_array BUILD_PHP_EXTENSIONS "msgpack"; then \
        ext-pcl msgpack-${EXTENSION_MSGPACK_VERSION}; \
    fi; \
    \
    # apcu
    if in_array BUILD_PHP_EXTENSIONS "apcu"; then \
        ext-pcl apcu-${EXTENSION_APCU_VERSION}; \
    fi; \
    \
    # memcached
    if in_array BUILD_PHP_EXTENSIONS "memcached"; then \
        ext-lib libmemcached-dev; \
        ext-pcl memcached-${EXTENSION_MEMCACHED_VERSION} \
            --enable-memcached-json \
            --enable-memcached-igbinary \
            --enable-memcached-msgpack; \
    fi; \
    \
    # redis
    if in_array BUILD_PHP_EXTENSIONS "redis"; then \
        ext-pcl redis-${EXTENSION_REDIS_VERSION}; \
    fi; \
    \
    \
    # mongodb
    if in_array BUILD_PHP_EXTENSIONS "mongodb"; then \
        ext-pcl mongodb-${EXTENSION_MONGODB_VERSION}; \
    fi; \
    \
    # cassandra
    # if in_array BUILD_PHP_EXTENSIONS "cassandra"; then \
    #     git clone https://github.com/datastax/php-driver.git; \
    #     cd php-driver; \
    #     git submodule update --init; \
    #     cd ext && ./install.sh; \
    #     ext-pcl cassandra-${EXTENSION_CASSANDRA_VERSION}; \
    # fi; \
    #\
    # couchbase
    # if in_array BUILD_PHP_EXTENSIONS "couchbase"; then \
    #     ext-lib libcouchbase; \
    #     ext-pcl couchbase-${EXTENSION_COUCHBASE_VERSION}; \
    # fi; \
    \
    # imagick
    if in_array BUILD_PHP_EXTENSIONS "imagick"; then \
        ext-lib libmagickwand-dev imagemagick; \
        ext-pcl imagick-${EXTENSION_IMAGICK_VERSION}; \
    fi; \
    \
    # vips
    if in_array BUILD_PHP_EXTENSIONS "vips"; then \
        ext-lib \
                \
                glib-2.0-dev \
                libexpat-dev \
                librsvg2-dev \
                libpng-dev \
                libgif-dev \
                libjpeg-dev \
                libexif-dev \
                liblcms2-dev \
                liborc-dev \
                ; \
        \
        url=https://github.com/libvips/libvips/releases/download; \
        version=8.7.0; \
        wget-retry $url/v$version/vips-$version.tar.gz; \
        tar xf vips-$version.tar.gz; \
        cd vips-$version; \
        CXXFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 ./configure --prefix=/usr; \
        make && make install; \
        \
        ext-pcl vips-${EXTENSION_VIPS_VERSION} --with-vips; \
    fi; \
    \
    # oauth
    if in_array BUILD_PHP_EXTENSIONS "oauth"; then \
        ext-pcl oauth-${EXTENSION_OAUTH_VERSION}; \
    fi; \
    \
    # uuid
    if in_array BUILD_PHP_EXTENSIONS "uuid"; then \
        ext-lib uuid-dev; \
        ext-pcl uuid-${EXTENSION_UUID_VERSION}; \
    fi; \
    \
    # ev
    if in_array BUILD_PHP_EXTENSIONS "ev"; then \
        ext-lib libev-dev; \
        ext-pcl ev-${EXTENSION_EV_VERSION}; \
    fi; \
    \
    # uv \
    if in_array BUILD_PHP_EXTENSIONS "uv"; then \
        ext-lib libuv1-dev; \
        ext-pcl uv-${EXTENSION_UV_VERSION}; \
    fi; \
    # eio \
    if in_array BUILD_PHP_EXTENSIONS "eio"; then \
        ext-pcl eio-${EXTENSION_EIO_VERSION} --enable-eio-debug=no; \
    fi; \
    # event \
    if in_array BUILD_PHP_EXTENSIONS "event"; then \
        ext-lib libevent-dev; \
        ext-pcl event-${EXTENSION_EVENT_VERSION} --enable-event-debug=no --enable-event-sockets=yes --with-event-libevent-dir=/usr --with-event-pthreads=no --with-event-extra --with-event-openssl --with-event-ns= --with-openssl-dir=no; \
    fi; \
    # memprof \
    if in_array BUILD_PHP_EXTENSIONS "memprof"; then \
        ext-lib libjudy-dev; \
        ext-pcl memprof-${EXTENSION_MEMPROF_VERSION}; \
    fi; \
    \
    # psr \
    if in_array BUILD_PHP_EXTENSIONS "psr"; then \
        ext-pcl psr-${EXTENSION_PSR_VERSION}; \
    fi; \
    \
    # ssh2
    if in_array BUILD_PHP_EXTENSIONS "ssh2"; then \
        ext-lib libssh2-1-dev; \
        ext-pcl ssh2-${EXTENSION_SSH2_VERSION}; \
    fi; \
    \
    # phalcon
    if in_array BUILD_PHP_EXTENSIONS "phalcon"; then \
        cd $PECL_SRC_DIR; \
        wget-retry https://github.com/phalcon/cphalcon/archive/v${EXTENSION_PHALCON_VERSION}.tar.gz; \
        tar -zxvf v${EXTENSION_PHALCON_VERSION}.tar.gz; \
        mv cphalcon-${EXTENSION_PHALCON_VERSION}/build/php7/64bits phalcon-${EXTENSION_PHALCON_VERSION}; \
        PREV_PHP_CFLAGS="${PHP_CFLAGS}"; \
        PHP_CFLAGS="${PHP_CFLAGS} -g -fomit-frame-pointer -DPHALCON_RELEASE"; \
        ext-pcl phalcon-${EXTENSION_PHALCON_VERSION}; \
        PHP_CFLAGS="${PREV_PHP_CFLAGS}"; \
    fi; \
    \
    # sodium
    if in_array BUILD_PHP_EXTENSIONS "sodium"; then \
        # cd $PECL_SRC_DIR; \
        # git clone --branch=stable https://github.com/jedisct1/libsodium; \
        # cd libsodium; \
        # ./configure; \
        # make; \
        # make install; \
        ext-lib libsodium-dev; \
        if [[ $PHP_VERSION == "7.1."* ]]; then \
            cd $PECL_SRC_DIR; \
            wget-retry https://github.com/jedisct1/libsodium-php/archive/${EXTENSION_SODIUM_VERSION}.tar.gz; \
            tar -zxvf ${EXTENSION_SODIUM_VERSION}.tar.gz; \
            mv libsodium-php-${EXTENSION_SODIUM_VERSION} sodium-${EXTENSION_SODIUM_VERSION}; \
            ext-pcl sodium-${EXTENSION_SODIUM_VERSION}; \
        else \
            ext-src sodium; \
        fi; \
    fi; \
    \
    # pdo_sqlsrv
    if in_array BUILD_PHP_EXTENSIONS "pdo_sqlsrv"; then \
        cd $PECL_SRC_DIR; \
        curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
        curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -sr)/prod.list > /etc/apt/sources.list.d/mssql-release.list; \
        apt-get update; \
        ACCEPT_EULA=Y ext-lib mssql-tools unixodbc-dev; \
        echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile; \
        echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc; \
        source ~/.bashrc; \
        ext-pcl pdo_sqlsrv-${EXTENSION_SQLSRV_VERSION}; \
    fi; \
    \
    # gearman
    if in_array BUILD_PHP_EXTENSIONS "gearman"; then \
        cd $PECL_SRC_DIR; \
        ext-lib libevent-dev libgearman-dev; \
        wget-retry https://github.com/wcgallego/pecl-gearman/archive/gearman-${EXTENSION_GEARMAN_VERSION}.tar.gz; \
        tar -zxvf gearman-${EXTENSION_GEARMAN_VERSION}.tar.gz; \
        mv pecl-gearman-gearman-${EXTENSION_GEARMAN_VERSION} gearman-${EXTENSION_GEARMAN_VERSION}; \
        ext-pcl gearman-${EXTENSION_GEARMAN_VERSION}; \
        rm -rf gearman-${EXTENSION_GEARMAN_VERSION}.tar.gz; \
    fi; \
    \
    # amqp
    if in_array BUILD_PHP_EXTENSIONS "amqp"; then \
        # cd $PECL_SRC_DIR; \
        # wget-retry http://${REPOGITORY_URL}/ubuntu/pool/universe/libr/librabbitmq/librabbitmq4_${LIBRARY_RABBITMQ_VERSION}-1_amd64.deb; \
        # dpkg -i librabbitmq4_${LIBRARY_RABBITMQ_VERSION}-1_amd64.deb; \
        # wget-retry http://${REPOGITORY_URL}/ubuntu/pool/universe/libr/librabbitmq/librabbitmq-dev_${LIBRARY_RABBITMQ_VERSION}-1_amd64.deb; \
        # dpkg -i librabbitmq-dev_${LIBRARY_RABBITMQ_VERSION}-1_amd64.deb; \
        ext-lib librabbitmq4 librabbitmq-dev; \
        ext-pcl amqp-${EXTENSION_AMQP_VERSION}; \
    fi; \
    \
    # v8js
    if in_array BUILD_PHP_EXTENSIONS "v8js"; then \
        cd $PECL_SRC_DIR; \
        rm -rf libv8; \
        git clone https://github.com/yejune/libv8 -b bionic; \
        cp -r libv8/opt/libv8 /opt/libv8/; \
        ext-pcl v8js-${EXTENSION_V8JS_VERSION} --with-v8js=/opt/libv8; \
    fi; \
    \
    # v8
    if in_array BUILD_PHP_EXTENSIONS "v8"; then \
        cd $PECL_SRC_DIR; \
        rm -rf libv8; \
        git clone https://github.com/yejune/libv8 -b bionic; \
        cp -r libv8/opt/libv8 /opt/libv8/; \
        ext-pcl v8-${EXTENSION_V8_VERSION} --with-v8=/opt/libv8; \
    fi; \
    \
    # screwim
    if in_array BUILD_PHP_EXTENSIONS "screwim"; then \
        cd $PECL_SRC_DIR; \
        wget-retry https://github.com/OOPS-ORG-PHP/mod_screwim/archive/v${EXTENSION_SCREWIM_VERSION}.tar.gz; \
        tar -zxvf v${EXTENSION_SCREWIM_VERSION}.tar.gz; \
        mv mod_screwim-${EXTENSION_SCREWIM_VERSION} screwim-${EXTENSION_SCREWIM_VERSION}; \
        ext-pcl screwim-${EXTENSION_SCREWIM_VERSION}; \
    fi; \
    \
    # swoole
    if in_array BUILD_PHP_EXTENSIONS "swoole"; then \
        ext-lib libnghttp2-dev libhiredis-dev libpq-dev; \
        # cd $PECL_SRC_DIR; \
        # git clone https://github.com/redis/hiredis.git; \
        # cd hiredis; \
        # make -j; \
        # make install; \
        # ldconfig; \
        # ext-pcl swoole-1.10.1; \
        ext-pcl swoole-${EXTENSION_SWOOLE_VERSION} \
            --enable-swoole-debug \
            --enable-openssl \
            --enable-sockets \
            --enable-async-redis \
            --enable-mysqlnd \
            --enable-http2 \
            --enable-coroutine-postgresql; \
    fi; \
    # http
    if in_array BUILD_PHP_EXTENSIONS "http"; then \
        ext-lib libidn2-dev libevent-dev libicu-dev; \
        pecl install raphf; \
        echo "extension=raphf.so" > ${PHP_CONF_DIR}/raphf.ini; \
        pecl install propro; \
        echo "extension=propro.so" > ${PHP_CONF_DIR}/propro.ini; \
        printf "yes\n" | pecl install pecl_http-${EXTENSION_HTTP_VERSION}; \
        echo "extension=http.so" > ${PHP_CONF_DIR}/http.ini; \
    fi; \
    # excel
    if in_array BUILD_PHP_EXTENSIONS "excel"; then \
        cd $PECL_SRC_DIR; \
        wget-retry http://www.libxl.com/download/libxl-lin-${LIBRARY_XL_VERSION}.tar.gz; \
        tar -zxv -f libxl-lin-${LIBRARY_XL_VERSION}.tar.gz; \
        cp libxl-${LIBRARY_XL_VERSION}.0/lib64/libxl.so /usr/lib/libxl.so; \
        mkdir -p /usr/include/libxl_c/; \
        cp libxl-${LIBRARY_XL_VERSION}.0/include_c/* /usr/include/libxl_c/; \
        #git clone https://github.com/iliaal/php_excel.git -b php7 excel-${EXTENSION_EXCEL_VERSION}; \
        wget-retry https://github.com/iliaal/php_excel/releases/download/Excel-${EXTENSION_EXCEL_VERSION}-PHP7/excel-${EXTENSION_EXCEL_VERSION}-php7.tgz; \
        tar zxvf excel-${EXTENSION_EXCEL_VERSION}-php7.tgz; \
        ext-pcl excel-${EXTENSION_EXCEL_VERSION} --with-libxl-incdir=/usr/include/libxl_c/; \
    fi;\
    # xlswriter
    if in_array BUILD_PHP_EXTENSIONS "xlswriter"; then \
        cd $PECL_SRC_DIR; \
        ext-lib zlib1g-dev; \
        git clone https://github.com/jmcnamara/libxlsxwriter.git; \
        cd libxlsxwriter; \
        make; \
        make install; \
        ext-pcl xlswriter-${EXTENSION_XLSWRITER_VERSION}; \
    fi;\
    # xdebug
    if in_array BUILD_PHP_EXTENSIONS "xdebug"; then \
        pecl install xdebug-${EXTENSION_XDEBUG_VERSION}; \
        XDEBUG_INI="${PHP_CONF_DIR}/xdebug.ini.stop"; \
        echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > ${XDEBUG_INI}; \
        echo "xdebug.remote_enable=on" >> ${XDEBUG_INI}; \
        echo "xdebug.remote_autostart=on" >> ${XDEBUG_INI}; \
    fi; \
    \
    # Install filebeat
    cd "${SRC_DIR}"; \
    wget-retry -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -; \
    echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" > /etc/apt/sources.list.d/elastic-6.x.list; \
    apt-get update; \
    apt-get install --no-install-recommends --no-install-suggests -y -o Dpkg::Options::="--force-confold" filebeat; \
    \
    # Install dockerize
    cd $SRC_DIR; \
    wget-retry https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz; \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz; \
    rm -rf dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz; \
    \
    # Install supervisor
    apt-get install -y supervisor; \
    mkdir -p /var/log/supervisor; \
    \
    # Install composer
    wget-retry http://getcomposer.org/composer.phar; \
    chmod +x composer.phar; \
    mv composer.phar /usr/local/bin/composer; \
    \
    # Install phpunit
    wget-retry https://phar.phpunit.de/phpunit.phar; \
    chmod +x phpunit.phar; \
    mv phpunit.phar /usr/local/bin/phpunit; \
    \
    \
    # clean
    rm -rf /init.sh; \
    { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; }; \
    apt-get clean; \
    apt-get purge --yes --auto-remove ${DEV_DEPS} ${ADD_DEPS}; \
    rm -rf $SRC_DIR/*; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    php -v;

RUN chown -Rf www-data:www-data /var/www

WORKDIR /var/www

EXPOSE 80 443

STOPSIGNAL SIGTERM

RUN chmod +x /run.sh

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD wget -qO- localhost/healthcheck.php || exit 1

ENTRYPOINT ["/run.sh"]
