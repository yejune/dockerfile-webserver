# Docker Php, Nginx Webserver

This is a Phalcon application server image based on Nginx (with SSL support) and PHP7.

## volumes
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
-   NGINX_CORS_METHODS
    -   optionally
-   NGINX_CORS_HEADERS
    -   optionally
-   PROXY_VARIABLES_FIXED
    -   optionally
    -   Modify REMOTE_ADDR, REQUEST_SCHEME, SERVER_PROTOCOL, SERVER_PORT variable to the value before forward

## version
-   UBUNTU 18.04
-   DOCKERIZE 0.6.1
-   NGINX 1.14.0
-   LIBV8 6.6
-   LIBRABBITMQ 0.8.0
-   PHP 7.2.9
    -   phalcon 3.4.0
    -   redis 4.1.1
    -   yaml 2.0.2
    -   memcached 3.0.4
    -   mongodb 1.5.2
    -   ~~couchbase 2.4.6~~
    -   ~~cassandra 1.3.2~~
    -   apcu 5.1.11
    -   uuid 1.0.4
    -   amqp 1.9.3
    -   v8js 2.1.0
    -   v8 0.2.2
    -   sodium 2.0.12
    -   ev 1.0.4
    -   uv 0.2.2
    -   eio 2.0.4
    -   ssh2 1.1.2
    -   gearman 2.0.3
    -   imagick 3.4.3
    -   igbinary 2.0.7
    -   msgpack 2.0.2
    -   swoole 4.1.2
    -   http 3.2.0
    -   pdo_mysql
    -   pdo_sqlite
    -   pdo_pgsql
    -   pdo_sqlsrv 5.2.0
    -   xlswriter 1.2.2
    -   xdebug 2.6.1
    -   jsonnet 1.3.1
    -   memprop 2.0.0
    -   psr 0.5.0

## Build Options
-   REPOGITORY_URL
-   NGINX_VERSION
-   NJS_VERSION
-   NGINX_GPGKEY
-   PHP_VERSION
-   PHP_GPGKEYS
-   PHP_SHA256
    -   file type php-*.tar.xz
-   BUILD_EXTENSIONS
    -   optionally
    -   null is all extensions
    -   Type the extension you want to use, separated by spaces
        -   bcmath
        -   calendar
        -   ctype
        -   gettext
        -   gmp
        -   hash
        -   iconv
        -   intl
        -   pcntl
        -   shmop
        -   posix
        -   pdo
        -   pdo_mysql
        -   session
        -   sockets
        -   apcu
        -   opcache
        -   uuid
        -   json
        -   igbinary
        -   msgpack
        -   yaml
        -   dom
        -   xml
        -   xmlreader
        -   xmlwriter
        -   simplexml
        -   xsl
        -   soap
        -   xmlrpc
        -   wddx
        -   memcached
        -   mongodb
        -   redis
        -   amqp
        -   gearman
        -   zip
        -   bz2
        -   phar
        -   tidy
        -   tokenizer
        -   screwim
        -   sodium
        -   ev
        -   uv
        -   phalcon
        -   swoole
        -   snmp
        -   exif
        -   fileinfo
        -   gd
        -   imagick
        -   ssh2
        -   dba
        -   enchant
        -   pspell
        -   recode
        -   sqlite3
        -   pdo_pgsql
        -   pdo_sqlite
        -   pdo_sqlsrv
        -   v8js
        -   v8
        -   sysvsem
        -   sysvshm
        -   sysvmsg
        -   event
        -   eio
        -   memprof
        -   jsonnet
        -   http
        -   xlswriter
-   LIBRARY_V8_VERSION
-   LIBRARY_RABBITMQ_VERSION
-   EXTENSION_YAML_VERSION
-   EXTENSION_IGBINARY_VERSION
-   EXTENSION_MSGPACK_VERSION
-   EXTENSION_APCU_VERSION
-   EXTENSION_MEMCACHED_VERSION
-   EXTENSION_REDIS_VERSION
-   EXTENSION_MONGODB_VERSION
-   EXTENSION_IMAGICK_VERSION
-   EXTENSION_UUID_VERSION
-   EXTENSION_EV_VERSION
-   EXTENSION_UV_VERSION
-   EXTENSION_SSH2_VERSION
-   EXTENSION_PHALCON_VERSION
-   EXTENSION_SODIUM_VERSION
-   EXTENSION_SQLSRV_VERSION
-   EXTENSION_GEARMAN_VERSION
-   EXTENSION_AMQP_VERSION
-   EXTENSION_V8JS_VERSION
-   EXTENSION_V8_VERSION
-   EXTENSION_SCREWIM_VERSION
-   EXTENSION_SWOOLE_VERSION
-   EXTENSION_HTTP_VERSION
-   EXTENSION_XLSWRITER_VERSION
-   EXTENSION_XDEBUG_VERSION
-   EXTENSION_JSONNET_VERSION
-   EXTENSION_EIO_VERSION
-   EXTENSION_EVENT_VERSION
-   EXTENSION_MEMPROF_VERSION
-   EXTENSION_PSR_VERSION
-   DOCKERIZE_VERSION

## Examples
-   build
    -   ``docker build .``
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
