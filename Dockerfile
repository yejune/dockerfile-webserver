FROM ubuntu:16.04

ENV PHP_RUN_DIR=/run/php \
    PHP_LOG_DIR=/var/log/php \
    PHP_INI_DIR=/etc/php \
    PHP_DATA_DIR=/var/lib/php

ENV DOCKERIZE_VERSION 0.2.0

ENV NGINX_VERSION 1.11.7

ENV PHP_VERSION 7.0.14

ENV PHALCON_VER 3.0.3

ENV LIBMEMCACHED_VERSION 1.0.18

ENV LIBRABBITMQ_VERSION 0.8.0

ENV LIBV8_VERSION 5.7

ENV PHP_LIB \
        redis-3.1.0 \
        yaml-2.0.0 \
        amqp-1.7.1 \
        memcached-2.2.0 \
        apcu-5.1.7 \
        v8js-1.3.3 --with-v8js=/opt/libv8-${LIBV8_VERSION} \
        v8-0.1.1 --with-v8=/opt/libv8-${LIBV8_VERSION} \
        libsodium-1.0.6 \
        uuid-1.0.4 \
        ev-1.0.4 \
        uv-0.1.1

ENV NGINX_EXTRA_CONFIGURE_ARGS \
        --sbin-path=/usr/sbin \
        --conf-path=/etc/nginx/nginx.conf \
        --with-http_ssl_module \
        --with-http_dav_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module

ENV NGINX_BUILD_DEPS \
        bzip2 \
        file \
        libbz2-dev \
        libcurl4-openssl-dev \
        openssl \
        ca-certificates \
        libssl-dev \
        libxslt1-dev \
        libxml2-dev \
        libpcre3 \
        libpcre3-dev \
        libc6 \
        libxml2 \
        git \
        wget \
        libev-dev \
        libuv1-dev

ENV NGINX_EXTRA_BUILD_DEPS \
        gcc \
        libc-dev \
        make \
        pkg-config \
        autoconf \
        runit \
        nano \
        less \
        curl \
        tmux

ENV PHP_BUILD_DEPS \
        mysql-client \
        libmysqlclient-dev\
        libyaml-dev \
        librabbitmq-dev \
        libsasl2-dev \
        libicu-dev \
        libgmp-dev \
        libsodium-dev \
        libreadline6-dev \
        uuid-dev \
        libjpeg-dev \
        libpng12-dev \
        libwebp-dev \
        libxpm-dev \
        libfreetype6-dev

#       libmcrypt-dev \

ENV PHP_EXTRA_BUILD_DEPS \
        re2c \
        g++ \
        bison \
        python-software-properties \
        software-properties-common

ENV PHP_EXTRA_CONFIGURE_ARGS \
        --sysconfdir=${PHP_INI_DIR} \
        --with-config-file-path=${PHP_INI_DIR} \
        --with-config-file-scan-dir=${PHP_INI_DIR}/conf.d \
        --with-fpm-user=www-data \
        --with-fpm-group=www-data \
        --with-libdir=lib64 \
        --with-openssl \
        --with-curl \
        --with-iconv \
        --with-pdo-mysql \
        --with-openssl \
        --with-xsl \
        --with-zlib \
        --with-bz2 \
        --with-gmp \
        --with-readline \
        --enable-fpm \
        --enable-opcache \
        --enable-sockets \
        --enable-bcmath \
        --enable-mbstring \
        --enable-intl \
        --enable-mysqlnd \
        --enable-zip \
        --enable-pcntl \
        --enable-calendar \
        --disable-cgi \
        --disable-short-tags \
        --with-gd \
        --with-gettext \
        --enable-gd-native-ttf \
        --with-freetype-dir \
        --with-jpeg-dir \
        --with-xpm-dir \
        --with-webp-dir \
        --with-png-dir

#       --without-sqlite3 \
#       --disable-fileinfo \
#       --without-pdo-sqlite \
#       --disable-posix
#       --disable-tokenizer \
#       --with-mysql \
#       --with-mysqli \
#       --with-mcrypt \

RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list

ENV NGINX_KEY "A1C052F8"

ENV PHP7_KEY "1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3"

COPY files/ /

RUN set -x && \
    apt-get update && apt-get install -y --no-install-recommends \
    ${NGINX_BUILD_DEPS} ${NGINX_EXTRA_BUILD_DEPS} \
    ${PHP_BUILD_DEPS} ${PHP_EXTRA_BUILD_DEPS} \
    # Install nginx
    && gpg --keyserver keys.gnupg.net --recv-key ${NGINX_KEY} \
    && mkdir -p /var/log/nginx \
    && curl -SL "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -o nginx.tar.bz2 \
    && curl -SL "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc" -o nginx.tar.bz2.asc \
    && gpg --verify nginx.tar.bz2.asc \
    && mkdir -p /usr/src/nginx \
    && tar -xof nginx.tar.bz2 -C /usr/src/nginx --strip-components=1 \
    && rm nginx.tar.bz2* \
    && cd /usr/src/nginx \
    && ./configure ${NGINX_EXTRA_CONFIGURE_ARGS} \
    && make -j"$(nproc)" \
    && make install \
    && make clean \
    # Install php
    && gpg --keyserver keys.gnupg.net --recv-keys ${PHP7_KEY} \
    && mkdir -p ${PHP_INI_DIR}/conf.d \
    && curl -SL "http://php.net/get/php-${PHP_VERSION}.tar.bz2/from/this/mirror" -o php.tar.bz2 \
    && curl -SL "http://php.net/get/php-${PHP_VERSION}.tar.bz2.asc/from/this/mirror" -o php.tar.bz2.asc \
    && gpg --verify php.tar.bz2.asc \
    && mkdir -p /usr/src/php \
    && tar -xof php.tar.bz2 -C /usr/src/php --strip-components=1 \
    && rm php.tar.bz2* \
    && cd /usr/src/php \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && ./configure ${PHP_EXTRA_CONFIGURE_ARGS} \
    && make -j"$(nproc)" \
    && make install \
    && make clean \
    && cp /usr/src/php/php.ini-production ${PHP_INI_DIR}/php.ini \
    && mkdir -p ${PHP_LOG_DIR} ${PHP_RUN_DIR} \
    # Install php phalcon
    && mkdir -p /usr/src/pecl && cd /usr/src/pecl \
    && wget https://github.com/phalcon/cphalcon/archive/v${PHALCON_VER}.tar.gz \
    && tar zxvf v${PHALCON_VER}.tar.gz \
    && cd /usr/src/pecl/cphalcon-${PHALCON_VER}/build \
    && ./install \
    && echo "extension=phalcon.so" > ${PHP_INI_DIR}/conf.d/phalcon.ini \
    # Install libmemcached
    && cd /usr/src/pecl \
    && wget https://launchpad.net/libmemcached/1.0/${LIBMEMCACHED_VERSION}/+download/libmemcached-${LIBMEMCACHED_VERSION}.tar.gz \
    && tar xzf libmemcached-${LIBMEMCACHED_VERSION}.tar.gz \
    && cd libmemcached-${LIBMEMCACHED_VERSION} \
    && ./configure --enable-sasl \
    && make -j"$(nproc)" \
    && make install \
    && make clean \
    # Install librabbitmq
    && cd /usr/src/pecl \
    && wget http://ftp.daum.net/ubuntu/pool/universe/libr/librabbitmq/librabbitmq4_${LIBRABBITMQ_VERSION}-1_amd64.deb \
    && dpkg -i librabbitmq4_${LIBRABBITMQ_VERSION}-1_amd64.deb \
    && wget http://ftp.daum.net/ubuntu/pool/universe/libr/librabbitmq/librabbitmq-dev_${LIBRABBITMQ_VERSION}-1_amd64.deb \
    && dpkg -i librabbitmq-dev_${LIBRABBITMQ_VERSION}-1_amd64.deb \
    # Install libv8
    && apt-add-repository ppa:pinepain/libv8-${LIBV8_VERSION} -y \
    && apt-get update \
    && apt-get install libv8-${LIBV8_VERSION}-dev -y --allow-unauthenticated \
    # Install php extension
    && bash -c "/usr/local/bin/docker-pecl-install ${PHP_LIB}" \
    # Install dockerize
    && cd /usr/src/pecl \
    && wget https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz \
    # Install supervisor
    && apt-get install -y supervisor \
    && mkdir -p /var/log/supervisor \
    # Install composer
    && bash -c "wget http://getcomposer.org/composer.phar && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer" \
    # Install phpunit
    && bash -c "wget https://phar.phpunit.de/phpunit.phar && chmod +x phpunit.phar && mv phpunit.phar /usr/local/bin/phpunit" \
    # Forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    # clean
    && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
    && rm -rf /usr/src/pecl/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get clean \
    && apt-get purge --yes --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $NGINX_EXTRA_BUILD_DEPS $PHP_EXTRA_BUILD_DEPS

RUN userdel www-data && groupadd -r www-data -g 433 \
    && mkdir -p /var/www \
    && mkdir -p /var/www/public \
    && useradd -u 431 -r -g www-data -d /var/www -s /sbin/nologin -c "Docker image user for web application" www-data \
    && chown -Rf www-data:www-data /var/www \
    && chmod 711 /var/www

VOLUME ["/var/www"]

WORKDIR /var/www/

EXPOSE 80 443

RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
