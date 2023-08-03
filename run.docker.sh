docker build --build-arg ISCHINA=yes --tag warp+v2fly .

if [[ -z $2 ]]; then
    port=1080;
else
    port=$2;
fi

echo $port

if [ $? -eq 0 ]; then
    docker stop warp-fly
    docker rm warp-fly
    docker run -ti --name warp-fly --privileged --cap-add=NET_ADMIN -p $port:10809 warp+v2fly $1;
fi