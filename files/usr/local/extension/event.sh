ext-lib libevent-dev
ext-pcl event-${EXTENSION_EVENT_VERSION} \
        --enable-event-debug=no \
        --enable-event-sockets=yes \
        --with-event-libevent-dir=/usr \
        --with-event-pthreads=no \
        --with-event-extra \
        --with-event-openssl \
        --with-event-ns= \
        --with-openssl-dir=no
