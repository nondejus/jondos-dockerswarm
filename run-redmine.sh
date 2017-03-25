#!/bin/bash

# start script for redmine when docker-compose is not available

cd $HOME
mkdir -p redmine-files

docker ps | grep mysql || ./run-mysql.sh

docker start redmine || docker run \
  -d \
  --name redmine \
  -p 3000:3000 \
  --link mysql \
  -v $HOME/redmine-files:/usr/src/redmine/files \
  -v $HOME/redmine-configuration.yml:/usr/src/redmine/config/configuration.yml \
  redmine
