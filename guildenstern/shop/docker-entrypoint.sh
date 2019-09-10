#!/bin/bash

chgrp -R mysql /var/lib/mysql
chmod -R g+rwX /var/lib/mysql

service mysql start

/opt/tomcat9/bin/startup.sh &

service postfix start

service rsyslog start

exec /usr/local/bin/httpd-foreground
