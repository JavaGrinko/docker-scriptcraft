#docker build -t cloud.canister.io:5000/javagrinko/mine-server .
#docker push cloud.canister.io:5000/javagrinko/mine-server
docker build --build-arg MINE_JS_VERSION=$1 --build-arg OAUTH_VERSION=$2 -t server .
docker rm -f minejs-server
docker run -d --net=host --name=minejs-server -v minecraft:/opt/minecraft/world server
