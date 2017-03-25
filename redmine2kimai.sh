#!/bin/bash
export LANG=de_DE.UTF-8
docker exec mysql mysql --login-path=kimai redmine2kimai -e 'CALL fill_time_fields();'
docker exec mysql mysql --login-path=root  redmine2kimai -e 'CALL import_in_kimai();'
