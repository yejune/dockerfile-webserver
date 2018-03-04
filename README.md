# Docker Php, Nginx Webserver

This is a Phalcon application server image based on Nginx (with SSL support) and PHP7.

## mount
-   /var/www
    -   for your app code (e.g. using "-v /home/project/:/var/www/")
    -   with your document root in a directory named public/
-   /var/log/nginx
    -   optionally
    -   if you want to store logfiles visibly outside the container
-   /var/certs
    -   optionally
    -   if you wish to use SSL with real keys
-   /usr/local/share/ca-certificates/local
    -   optionally
    -   Adding trusted local certificates

## Env variables
-   DOMAIN
    -   optionally
    -   domain name, null
-   USE_SSL
    -   optionally
    -   if you wish to use SSL with real keys /var/certs
    -   /var/certs/${DOMAIN}.crt, /var/certs/${DOMAIN}.key
    -   yes, only, null
-   DEBUG
    -   optionally
    -   display errors
    -   yes, null
-   WEBROOT
    -   optionally, default /var/www/public
    -   app code (e.g. using "-v /home/project/:/var/www/")
    -   document root in a directory named /var/www/public/
-   SHOW_VERSION
    -   optionally
    -   php, nginx show version
    -   yes, null
-   TZ
    -   default Asia/Seoul
-   FPM_LISTEN
    -   optionally
    -   default /dev/shm/php-fpm.sock
    -   localhost:9000
-   FASTCGI_PASS
    -   optionally
    -   default unix:/dev/shm/php-fpm.sock
    -   localhost:9000
-   PHP_POST_MAX_SIZE
-   PHP_UPLOAD_MAX_FILESIZE
-   NGINX_CORS
    -   optionally
    -   enable CORS
    -   yes, null
-   NGINX_CORS_ORIGIN
    -   optionally, default *
    -   Access-Control-Allow-Origin

## version
-   UBUNTU 16.04
-   DOCKERIZE 0.6.0
-   NGINX 1.12.2
-   LIBV8 6.6
-   LIBRABBITMQ 0.8.0
-   PHP 7.2.2
    -   phalcon 3.3.1
    -   redis 3.1.6
    -   yaml 2.0.2
    -   memcached 3.0.4
    -   mongodb 1.4.1
    -   apcu 5.1.10
    -   uuid 1.0.4
    -   amqp 1.9.3
    -   v8js 2.1.0
    -   v8 0.2.2
    -   sodium 2.0.10
    -   ev 1.0.4
    -   uv 0.2.2
    -   ssh2 1.1.2
    -   gearman 2.0.3
    -   imagick 3.4.3
    -   igbinary 2.0.5
    -   msgpack 2.0.2
    -   swoole 2.1.0
    -   pdo_mysql
    -   pdo_sqlite
    -   pdo_pgsql
    -   pdo_sqlsrv

## Build Options
-   BUILD_TYPE
    -   null
        -   bcmath bz2 calendar ctype dom gettext gmp hash iconv intl json pcntl pdo pdo_mysql posix session simplexml soap sockets xml xmlreader xmlwriter yaml apcu memcached redis uuid phalcon igbinary msgpack
    -   full
        -   bcmath bz2 calendar ctype dom gettext gmp hash iconv intl json pcntl pdo pdo_mysql posix session simplexml soap sockets xml xmlreader xmlwriter yaml apcu memcached redis uuid phalcon igbinary msgpack
        -   dba enchant exif fileinfo gd pdo_pgsql pdo_sqlite phar pspell recode shmop snmp sqlite3 tidy tokenizer wddx xsl xmlrpc zip ev uv ssh2 sodium pdo_sqlsrv gearman amqp v8js v8 imagick mongodb


## Examples
-   build
    -   ``docker build build-arg .``
    -   ``docker build build-arg BUILD_TYPE=full .``
-   run
    -   ``docker run -p 80:80 -d yejune/webserver``
-   only SSL
    -   ``docker run -p 80:80 -p 443:443 -e USE_SSL=only -v `pwd`/var/certs:/var/certs -v `pwd`/var/certs:/usr/local/share/ca-certificates/local -v `pwd`:/var/www/ -d yejune/webserver``
-   without SSL
    -   ``docker run -p 80:80 -v `pwd`:/var/www/ -d yejune/webserver``
-   using non-standard ports
    -   ``docker run -p 8080:80 -p 8443:443 -e USE_SSL=on -v `pwd`/var/certs:/var/certs -v `pwd`:/var/www/ -d yejune/webserver``
-   logfile
    -   ``docker run -p 80:80 -v `pwd`/var/log/nginx:/var/log/nginx -v `pwd`:/var/www/ -d yejune/webserver``
