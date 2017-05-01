#!/bin/bash
export LANG=de_DE.UTF-8
docker exec mysql mysql -u kimai --password=100%Jondos redmine2kimai -e 'CALL fill_time_fields();'
docker exec mysql mysql -u root  --password=100%Jondos redmine2kimai -e 'CALL import_in_kimai();'
