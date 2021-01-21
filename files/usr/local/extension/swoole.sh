ext-lib libnghttp2-dev libhiredis-dev libpq-dev
ext-pcl swoole-${EXTENSION_SWOOLE_VERSION} \
    --enable-openssl \
    --enable-sockets \
    --enable-mysqlnd \
    --enable-http2

    #  \
    # --enable-swoole-debug \
    # --enable-async-redis \
    # --enable-coroutine-mysql

# git clone https://github.com/swoole/async-ext async-ext-4.5.5
# ext-pcl async-ext-4.5.5