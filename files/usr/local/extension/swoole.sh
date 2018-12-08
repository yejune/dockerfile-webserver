ext-lib libnghttp2-dev libhiredis-dev libpq-dev
ext-pcl swoole-${EXTENSION_SWOOLE_VERSION} \
    --enable-swoole-debug \
    --enable-openssl \
    --enable-sockets \
    --enable-async-redis \
    --enable-mysqlnd \
    --enable-http2 \
    --enable-coroutine-postgresql
