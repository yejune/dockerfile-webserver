cd $PECL_SRC_DIR

ext-lib \
        \
        glib-2.0-dev \
        libexpat-dev \
        librsvg2-dev \
        libpng-dev \
        libgif-dev \
        libjpeg-dev \
        libexif-dev \
        liblcms2-dev \
        liborc-dev \
        libvips-dev

apt-mark manual libvips-dev

# url=https://github.com/libvips/libvips/releases/download
# version=8.7.2
# wget-retry $url/v$version/vips-$version.tar.gz
# tar xf vips-$version.tar.gz
# cd vips-$version
# CXXFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 ./configure --prefix=/usr
# make && make install

ext-pcl vips-${EXTENSION_VIPS_VERSION} --with-vips
