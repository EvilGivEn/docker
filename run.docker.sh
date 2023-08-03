docker build --build-arg ISCHINA=yes --tag warpedv2fly .

if [[ -z $2 ]]; then
    port=1080;
else
    port=$2;
fi

if [ $? -eq 0 ]; then
    docker stop wannafly
    docker rm wannafly
    docker run -tid --name wannafly --privileged --cap-add=NET_ADMIN -p $port:10809 warpedv2fly $1;
fi