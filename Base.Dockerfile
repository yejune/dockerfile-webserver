FROM ubuntu:18.04
LABEL maintainer="k@yejune.com"

ENV DEBIAN_FRONTEND noninteractive
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

ARG PHP_VERSION=7.3.10
ARG PHP_GPGKEYS="CBAF69F173A0FEA4B537F470D66C9593118BCCB6 F38252826ACD957EF380D39F2F7956BC5DA04B5D"
ARG PHP_SHA256="42f00a15419e05771734b7159c8d39d639b8a5a6770413adfa2615f6f923d906"

ARG REPOGITORY_URL="archive.ubuntu.com"

ARG BUILD_EXTENSIONS

ARG DOCKERIZE_VERSION=0.6.1

SHELL ["/bin/bash", "-c"]

RUN if [ "archive.ubuntu.com" != "${REPOGITORY_URL}" ]; then \
        sed -i "s/:\/\/archive.ubuntu.com/:\/\/${REPOGITORY_URL}/g" /etc/apt/sources.list; \
        sed -i "s/:\/\/security.ubuntu.com/:\/\/${REPOGITORY_URL}/g" /etc/apt/sources.list; \
    fi

ENV PHP_INI_DIR=/etc/php \
    PHP_CONF_DIR=/etc/php/conf.d \
    PHP_RUN_DIR=/run/php \
    PHP_LOG_DIR=/var/log/php \
    PHP_DATA_DIR=/var/lib/php \
    PHP_SRC_DIR=/usr/src/php \
    PECL_SRC_DIR=/usr/src/pecl \
    SRC_DIR=/usr/src \
    USR_LOCAL_BIN_DIR=/usr/local/bin \
    USR_LIB_DIR=/usr/lib


ENV DEFAULT_EXTENSIONS="\
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
        interbase\
        intl\
        json\
        ldap\
        libxml\
        mbstring\
        mysqli\
        mysqlnd\
        opcache\
        openssl\
        pcntl\
        pcre\
        pdo\
        pdo_dblib\
        pdo_firebird\
        pdo_mysql\
        pdo_pgsql\
        pdo_sqlite\
        pgsql\
        phar\
        posix\
        pspell\
        readline\
        recode\
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
        wddx\
        xml\
        xmlreader\
        xmlrpc\
        xmlwriter\
        xsl\
        zip\
        zlib\
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
    #ntp \
    \
    DEV_DEPS="pkg-config autoconf dpkg-dev file g++ gcc make re2c bison software-properties-common"; \
    \
    LIB_DEPS=" \
        libc-dev \
        libpcre2-dev \
        libpcre3-dev \
        \
        libonig-dev \
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
    dpkg-reconfigure tzdata; \
    #service ntp restart; \
    \
    \
    add-apt-repository -y ppa:maxmind/ppa; \
    apt-get update; \
    apt-get install libmaxminddb0 libmaxminddb-dev mmdb-bin; \
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
    add-apt-repository -y ppa:nginx/stable; \
    apt-get update; \
    apt-get install --no-install-recommends --no-install-suggests -y -o Dpkg::Options::="--force-confold" nginx nginx-extras; \
    # forward request and error logs to docker log collector
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    #ln -sf /dev/stderr /var/log/nginx/error.log; \
    \
    \
    # Install php
    \
    \
    if [[ $PHP_VERSION == *"RC"* ]]; then \
        PHP_URL="https://downloads.php.net/~derick/php-${PHP_VERSION}.tar.xz"; \
        PHP_ASC_URL="https://downloads.php.net/~derick/php-${PHP_VERSION}.tar.xz.asc"; \
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
        --build="${BUILD_ARCH}" \
        --sysconfdir="${PHP_INI_DIR}" \
        --with-libdir="lib/${DEV_MULTI_ARCH}" \
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
        \
        # make sure invalid --configure-flags are fatal errors intead of just warnings
        --enable-option-checking=fatal \
#        --with-pcre-regex=/usr \
#        --enable-hash \
        --enable-xml \
#        --with-libxml \
#        --enable-libxml \
#        --with-libxml-dir \
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
        --with-pear \
        --enable-phar \
        --with-pcre-jit \
        \
        # https://wiki.php.net/rfc/argon2_password_hash (7.2+)
        $([[ $PHP_VERSION != "7.1."* ]] && echo '--with-password-argon2') \
        $([[ $PHP_VERSION == "7.4."* ]] && echo '--with-libxml') \
        $([[ $PHP_VERSION != "7.4."* ]] && echo '--enable-libxml --with-libxml-dir --with-onig') \
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
    pear upgrade pear; \
    \
    PHP_EXTENSION_DIR=$(php-config --extension-dir); \
    \
    cp ${PHP_SRC_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini; \
    echo "zend_extension=opcache.so" > ${PHP_CONF_DIR}/opcache.ini; \
    \
    if [ ! -z "${BUILD_EXTENSIONS}" ]; then \
        BUILD_PHP_EXTENSIONS=( $BUILD_EXTENSIONS ); \
    else \
        BUILD_PHP_EXTENSIONS=( $DEFAULT_EXTENSIONS ); \
    fi; \
    \
    \
    # src extension install
    for extension in "${BUILD_PHP_EXTENSIONS[@]}"; do \
        echo $extension; \
        if [ -f "/usr/local/script/${extension}.sh" ]; then \
            source "/usr/local/script/${extension}.sh"; \
        else \
            if [ -f "/usr/local/extension/${extension}.sh" ]; then \
                source "/usr/local/extension/${extension}.sh"; \
            else \
                ext-src $extension; \
            fi; \
        fi; \
    done; \
    \
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
