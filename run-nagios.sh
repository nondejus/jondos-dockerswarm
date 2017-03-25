#!/bin/bash

# start script for redmine when docker-compose is not available

cd $HOME
mkdir -p nagios-files

echo Enter new password for nagiosadmin:
test -f nagios-files/htpasswd.users || htpasswd -c nagios-files/htpasswd.users nagiosadmin

docker start nagios || docker run \
  -d \
  --name nagios \
  -p 443 \
  -v $HOME/nagios-files:/opt/nagios/etc \
  -v $HOME/redmine-configuration.yml:/usr/src/redmine/config/configuration.yml \
  guessi/docker-nagios4
