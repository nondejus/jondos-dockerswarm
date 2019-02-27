#!/bin/bash

service mysql start

service tomcat8 start

service postfix start

service rsyslog start

exec /usr/local/bin/httpd-foreground
