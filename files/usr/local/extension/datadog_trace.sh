cd $PECL_SRC_DIR

wget https://github.com/DataDog/dd-trace-php/releases/download/${EXTENSION_DATADOG_TRACE_VERSION}/datadog-php-tracer_${EXTENSION_DATADOG_TRACE_VERSION}_amd64.deb
dpkg -i datadog-php-tracer_${EXTENSION_DATADOG_TRACE_VERSION}_amd64.deb

# cp /usr/src/pecl/datadog_trace-${EXTENSION_DATADOG_TRACE_VERSION}/modules/datadog_trace.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/

# ext-pcl datadog_trace-${EXTENSION_DATADOG_TRACE_VERSION}