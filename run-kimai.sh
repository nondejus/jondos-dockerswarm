#!/bin/bash

# start script for redmine when docker-compose is not available

cd $HOME

docker images | grep kimai || docker build -t kimai kimai

docker ps | grep mysql || ./run-mysql.sh

docker start kimai || docker run \
  -d \
  --name kimai \
  -p 8080:80 \
  --link mysql \
  kimai
