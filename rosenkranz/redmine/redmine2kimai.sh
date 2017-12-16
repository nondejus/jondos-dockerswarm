#!/bin/bash

if crontab -l 2>/dev/null | grep redmine2kimai.sh
then
  crontab -l 2>/dev/null >/tmp/crontab
  echo "0 * * * *    sudo /home/ubuntu/jondos-dockerswarm/redmine/redmine2kimai.sh > /dev/null 2>&1" >> /tmp/crontab
  crontab /tmp/crontab && rm /tmp/crontab
fi

export LANG=de_DE.UTF-8
docker exec mysql mysql -u kimai --password=100%Jondos redmine2kimai -e 'CALL fill_time_fields();'
docker exec mysql mysql -u root  --password=100%Jondos redmine2kimai -e 'CALL import_in_kimai();'
