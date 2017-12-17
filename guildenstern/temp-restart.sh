#!/bin/bash

# Currently, the legacy container "mail" fucks up the certificate generation for this compose setup.
# For some reason, the letsencrypt companion will detect the presence of the container and try to create an https config
# for it, leavint the "upstream" section in the nginx.conf empty.
# NginX subsequently pukes when trying to read the config, which screws up the letsencrypt cert generation in turn m(

# When restarting the compose setup, please use this script until the mail container has been migrated into the setup.

docker-compose down
docker volume prune
rm -rf /tmp/nginx-proxy
docker stop mail
docker-compose up -d nginx-proxy letsencrypt subversion jenkins

# wait until the letsencrypt companion is finished setting up its config
sleep 30s

docker start mail
