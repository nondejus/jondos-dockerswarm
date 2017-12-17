#!/bin/bash 

service mysql start

java -server -Djava.awt.headless=true -jar /usr/share/java/InfoService.jar /etc/infoservice/InfoService.properties &

/etc/cron.weekly/updategeoip

cd /var/www/anontest/ftptest && java -cp . testftpserver.FTPServer >/var/log/ftptest.log 2>&1 &

/usr/bin/tor --defaults-torrc /usr/share/tor/tor-service-defaults-torrc --hush & 

/usr/local/bin/docker-php-entrypoint /usr/local/bin/apache-foreground
