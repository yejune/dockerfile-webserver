ext-lib libjpeg-dev \
        libpng-dev \
        libwebp-dev \
        libxpm-dev \
        libfreetype6-dev

ext-src gd  --with-webp-dir \
            --with-jpeg-dir \
            --with-png-dir \
            --with-zlib-dir \
            --with-xpm-dir \
            --with-freetype-dir \
            --enable-gd-native-ttf
