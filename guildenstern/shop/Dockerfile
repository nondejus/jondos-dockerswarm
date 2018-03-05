FROM httpd:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
    mysql-server \
    git \
    tomcat8

COPY apache2/shop.conf /etc/apache2/sites-available
COPY perl/aplog_anon.pl /usr/local/bin
COPY java/paysafecardclient.war /var/lib/tomcat8/webapps
COPY tomcat/tomcat-users.xml /var/lib/tomcat8/conf

RUN chmod a+x /usr/local/bin/aplog_anon.pl

RUN rm -f /var/lib/tomcat8/webapps/manager

VOLUME /var/lib/mysql

RUN git clone https://github.com/jondos/jondos-shop /var/www/shop

ENTRYPOINT [ "/docker-entrypoint.sh" ]
