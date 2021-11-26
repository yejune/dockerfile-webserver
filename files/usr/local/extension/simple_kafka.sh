cd $PECL_SRC_DIR
ext-lib librdkafka-dev
# ext-pcl simple_kafka_client-${EXTENSION_SIMPLE_KAFKA_CLIENT_VERSION}

git clone https://github.com/php-kafka/php-simple-kafka-client.git
cd php-simple-kafka-client
phpize && ./configure && make -j5 all && make install