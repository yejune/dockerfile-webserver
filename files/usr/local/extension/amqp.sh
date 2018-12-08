cd $PECL_SRC_DIR

ext-lib librabbitmq4 librabbitmq-dev

git clone https://github.com/pdezwart/php-amqp amqp-${EXTENSION_AMQP_VERSION}

ext-pcl amqp-${EXTENSION_AMQP_VERSION}
