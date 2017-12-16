#!/bin/bash 

service mysql start

java -server -Djava.awt.headless=true -jar /usr/share/java/InfoService.jar /etc/infoservice/InfoService.properties &

java -cp /var/www/anontest/ftptest testftpserver.FTPServer > /var/log/ftptest.log &

/usr/bin/tor --defaults-torrc /usr/share/tor/tor-service-defaults-torrc --hush & 

/usr/local/bin/docker-php-entrypoint /usr/local/bin/apache-foreground