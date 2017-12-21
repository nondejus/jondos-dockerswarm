#!/bin/bash

service mysql start
service tor start

java -server -Djava.awt.headless=true -jar /usr/share/java/InfoService.jar /etc/infoservice/InfoService.properties &

cd /var/www/anontest/ftptest && java -cp . testftpserver.FTPServer >/var/log/ftptest.log 2>&1 &

/usr/local/bin/docker-php-entrypoint /usr/local/bin/apache2-foreground
