#docker build -t cloud.canister.io:5000/javagrinko/mine-server .
#docker push cloud.canister.io:5000/javagrinko/mine-server
docker build --build-arg MINEJS_VERSION=$1 -t server .
docker rm -f server
docker run -d --net=host --name=server server