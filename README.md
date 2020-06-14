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
-   NGINX 1.16.1
-   LIBV8 7.5
-   LIBRABBITMQ 0.8.0
-   LIBXL 3.8.3
-   LIBXLSWRITER 0.9.1
-   PHP 7.3.9
    -   phalcon 4.0.4
    -   swoole 4.4.17
    -   uuid 1.1.0
    -   yaml 2.1.0
    -   jsonnet 1.3.1
    -   protobuf 3.11.4
    -   igbinary 3.1.1
    -   msgpack 2.1.0
    -   mailparse 3.0.4
    -   base58 0.1.3
    -   apcu 5.1.15
    -   memcached 3.1.5
    -   redis 5.2.1
    -   mongodb 1.7.3
    -   rdkafka 4.0.2
    -   couchbase 3.0.0beta1
    -   ~~cassandra 1.3.2~~
    -   amqp 1.9.3
    -   gearman 2.0.6
    -   sodium 2.0.22
    -   mcrypt 1.0.3
    -   ev 1.0.8
    -   uv 0.2.4
    -   eio 2.0.4
    -   event 2.5.4
    -   memprop 2.0.0
    -   http 3.2.2
    -   psr 1.0.0
    -   callee
    -   decimal 1.1.1
    -   imagick 3.4.4
    -   vips 1.0.10
    -   ssh2 1.2
    -   pdo_mysql
    -   pdo_sqlite
    -   pdo_pgsql
    -   pdo_sqlsrv 5.8.0
    -   v8js 2.1.1
    -   v8 0.2.2
    -   oauth 2.0.4
    -   excel 1.0.2
    -   xlswriter 1.3.4.2
    -   xdebug 2.9.2
    -   seaslog 2.1.0
    -   componere 3.1.1
    -   runkit7 3.1.0a1
    -   vld 0.16.0
    -   datadog_trace 0.42.0
    -   grpc 1.28.0
    -   http_message 0.2.1
    -   yaconf 1.0.8

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
        -   excel
        -   seaslog
        -   callee
        -   decimal
        -   vips
        -   oauth
        -   componere
        -   runkit7
        -   vld
        -   datadog_trace
        -   grpc
        -   psr
        -   http_message
        -   yaconf
-   LIBRARY_V8_VERSION
-   LIBRARY_RABBITMQ_VERSION
-   LIBRARY_XL_VERSION
-   LIBRARY_XLSWRITER_VERSION
-   LIBRARY_VIPS_VERSION
-   EXTENSION_PHALCON_VERSION
-   EXTENSION_SWOOLE_VERSION
-   EXTENSION_UUID_VERSION
-   EXTENSION_YAML_VERSION
-   EXTENSION_JSONNET_VERSION
-   EXTENSION_IGBINARY_VERSION
-   EXTENSION_MSGPACK_VERSION
-   EXTENSION_APCU_VERSION
-   EXTENSION_MEMCACHED_VERSION
-   EXTENSION_REDIS_VERSION
-   EXTENSION_MONGODB_VERSION
-   EXTENSION_COUCHBASE_VERSION
-   EXTENSION_CASSANDRA_VERSION
-   EXTENSION_AMQP_VERSION
-   EXTENSION_GEARMAN_VERSION
-   EXTENSION_SODIUM_VERSION
-   EXTENSION_MCRYPT_VERSION
-   EXTENSION_SCREWIM_VERSION
-   EXTENSION_EV_VERSION
-   EXTENSION_UV_VERSION
-   EXTENSION_EIO_VERSION
-   EXTENSION_EVENT_VERSION
-   EXTENSION_MEMPROF_VERSION
-   EXTENSION_HTTP_VERSION
-   EXTENSION_CALLEE_VERSION
-   EXTENSION_DECIMAL_VERSION
-   EXTENSION_IMAGICK_VERSION
-   EXTENSION_VIPS_VERSION
-   EXTENSION_SSH2_VERSION
-   EXTENSION_SQLSRV_VERSION
-   EXTENSION_V8JS_VERSION
-   EXTENSION_V8_VERSION
-   EXTENSION_OAUTH_VERSION
-   EXTENSION_EXCEL_VERSION
-   EXTENSION_XLSWRITER_VERSION
-   EXTENSION_XDEBUG_VERSION
-   EXTENSION_SEASLOG_VERSION
-   EXTENSION_COMPONERE_VERSION
-   EXTENSION_RUNKIT7_VERSION
-   EXTENSION_VLD_VERSION
-   EXTENSION_DATADOG_TRACE_VERSION
-   EXTENSION_GRPC_VERSION
-   EXTENSION_PSR_VERSION
-   EXTENSION_HTTP_MESSAGE_VERSION
-   EXTENSION_YACONF_VERSION
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
