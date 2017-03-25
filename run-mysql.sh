#!/bin/bash

# start script for MySQL when docker-compose is not available

mkdir -p mysql
docker start mysql && exit

docker run \
  -d \
  --name mysql \
  -v $HOME/mysql:/var/lib/mysql \
  mysql/mysql-server
