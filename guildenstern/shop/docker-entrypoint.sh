#!/bin/bash 

service mysql start

service tomcat8 start

exec /usr/local/bin/httpd-foreground