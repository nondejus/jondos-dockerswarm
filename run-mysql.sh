#!/bin/bash

# start script for MySQL when docker-compose is not available

mkdir -p mysql
docker start mysql && exit

docker run \
  -d \
  --name mysql \
  -v $HOME/mysql:/var/lib/mysql \
  mysql/mysql-server

echo Enter password for MYSQL user root:
docker exec mysql mysql_config_editor set --login-path=root  --host=localhost --user=kimai --password

echo Enter password for MYSQL user kimai:
docker exec mysql mysql_config_editor set --login-path=kimai --host=localhost --user=kimai --password
