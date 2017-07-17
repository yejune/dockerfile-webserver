FROM ubuntu:16.04

ENV PHP_RUN_DIR=/run/php \
    PHP_LOG_DIR=/var/log/php \
    PHP_INI_DIR=/etc/php \
    PHP_DATA_DIR=/var/lib/php

ENV DOCKERIZE_VERSION 0.5.0

ENV NGINX_VERSION 1.12.1

ENV PHP_VERSION 7.1.7

ENV PHALCON_VER 3.2.1

ENV LIBMEMCACHED_VERSION 1.0.18

ENV LIBRABBITMQ_VERSION 0.8.0

ENV LIBV8_VERSION 6.1

ENV PHP_LIB \
        pdo_sqlsrv-4.3.0 \
        sodium-2.0.2 \
#       v8js-1.4.0 --with-v8js=/opt/libv8-${LIBV8_VERSION} \
        v8-0.1.7 --with-v8=/opt/libv8-${LIBV8_VERSION} \
        ev-1.0.4 \
        uv-0.2.2 \
        ssh2-1.1.1 \
        gearman-2.0.3 \
        amqp-1.9.1 \
        yaml-2.0.0 \
        apcu-5.1.8 \
        memcached-3.0.3 \
        redis-3.1.3 \
        uuid-1.0.4

ENV NGINX_EXTRA_CONFIGURE_ARGS \
        --sbin-path=/usr/sbin \
        --conf-path=/etc/nginx/nginx.conf \
        --with-http_ssl_module \
        --with-http_dav_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module

ENV NGINX_BUILD_DEPS \
        locales \
        tzdata \
        bzip2 \
        file \
        openssl \
        ca-certificates \
        wget \
        curl \
        ssh \
        git \
        libbz2-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libxslt1-dev \
        libxml2-dev \
        libpcre3 \
        libpcre3-dev \
        libc6 \
        libxml2

ENV NGINX_EXTRA_BUILD_DEPS \
        gcc \
        libc-dev \
        make \
        pkg-config \
        autoconf \
        runit \
        nano \
        less \
        tmux

ENV PHP_BUILD_DEPS \
        mysql-client \
        libmysqlclient-dev \
        libpq-dev \
        libsasl2-dev \
        libicu-dev \
        libgmp-dev \
        libreadline6-dev \
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
        --with-libxml-dir \
        --with-openssl \
        --with-curl \
        --with-iconv \
        --with-pdo-mysql \
        --with-pdo-pgsql \
#       --without-sqlite3 \
#       --without-pdo-sqlite \
        --with-openssl \
        --with-xsl \
        --with-xml \
        --with-zlib \
        --with-bz2 \
        --with-gmp \
        --with-readline \
        --with-gd \
        --with-gettext \
        --with-freetype-dir \
        --with-jpeg-dir \
        --with-xpm-dir \
        --with-webp-dir \
        --with-png-dir \
        --enable-gd-native-ttf \
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
        --enable-soap \
        --disable-cgi \
        --disable-short-tags
#       --disable-fileinfo \
#       --disable-posix
#       --disable-tokenizer \
#       --with-mysql \
#       --with-mysqli \
#       --with-mcrypt \

RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list

COPY files/ /

RUN set -x && \
    apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ${NGINX_BUILD_DEPS} ${NGINX_EXTRA_BUILD_DEPS} \
    ${PHP_BUILD_DEPS} ${PHP_EXTRA_BUILD_DEPS} \
    && locale-gen en_US.UTF-8 \
    # Install nginx
    && /usr/local/bin/installer/nginx.sh \
    # Install php
    && /usr/local/bin/installer/php.sh \
    # Install php phalcon
    && /usr/local/bin/installer/phalcon.sh \
    # Install php extension
    && /usr/local/bin/installer/php-pecl.sh \
    # Install dockerize
    && /usr/local/bin/installer/dockerize.sh \
    # Install supervisor
    && /usr/local/bin/installer/supervisor.sh \
    # clean
    && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
    && rm -rf /usr/src/pecl \
    && rm -rf /usr/src/php \
    && rm -rf /usr/src/nginx \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get clean \
    && apt-get purge --yes --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $NGINX_EXTRA_BUILD_DEPS $PHP_EXTRA_BUILD_DEPS

RUN userdel www-data && groupadd -r www-data -g 433 \
    && mkdir -p /var/www \
    && mkdir -p /var/www/public \
    && useradd -u 431 -r -g www-data -d /var/www -s /sbin/nologin -c "Docker image user for web application" www-data \
    && chown -Rf www-data:www-data /var/www \
    && chmod 711 /var/www

WORKDIR /var/www

EXPOSE 80 443

RUN chmod +x /run.sh

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD wget -qO- localhost/healthcheck.php || exit 1

ENTRYPOINT ["/run.sh"]
