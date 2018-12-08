cd $PECL_SRC_DIR

ext-lib libssh2-1-dev

git clone https://git.php.net/repository/pecl/networking/ssh2.git

mv ssh2 ssh2-${EXTENSION_SSH2_VERSION}

ext-pcl ssh2-${EXTENSION_SSH2_VERSION}
