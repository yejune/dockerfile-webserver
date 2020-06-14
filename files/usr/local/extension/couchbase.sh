
# Only needed during first-time setup:
wget -O - http://packages.couchbase.com/ubuntu/couchbase.key | apt-key add -
echo "deb http://packages.couchbase.com/ubuntu bionic bionic/main" | tee /etc/apt/sources.list.d/couchbase.list

# Will install or upgrade packages
apt-get update
ext-lib libcouchbase-dev libcouchbase2-bin

ext-pcl couchbase-${EXTENSION_COUCHBASE_VERSION}