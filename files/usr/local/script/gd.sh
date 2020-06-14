ext-lib libjpeg-dev \
        libpng-dev \
        libwebp-dev \
        libxpm-dev \
        libfreetype6-dev

ext-src gd  --enable-gd \
            --with-webp \
            --with-jpeg \
            --with-xpm \
            --with-freetype \
            --with-webp-dir \
            --enable-gd-jis-conv
