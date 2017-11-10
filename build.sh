eval $(docker-machine env bootapp-docker-machine)

type="$1";
subname="";
if [ ! -z "$type" ]; then
    subname="-$type"
fi

echo $type;
echo $subname;

docker build --tag yejune/webserver:7.1.11${subname} --build-arg BUILD_LOCALE=ko --build-arg BUILD_TYPE=${type} .