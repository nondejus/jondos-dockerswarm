FROM httpd:latest

ENV DEBIAN_FRONTEND noninteractive

ARG GIT_USER
ARG GIT_PASSWORD

RUN apt-get update && \
    apt-get install -y \
    mysql-server \
    git \
    tomcat8 \
    rsyslog \
    postfix

COPY apache2/shop.conf /etc/apache2/sites-available/
COPY perl/aplog_anon.pl /usr/local/bin/
COPY java/paysafecardclient.war /var/lib/tomcat8/webapps/
COPY tomcat/tomcat-users.xml /var/lib/tomcat8/conf/
COPY postfix/* /etc/postfix/
COPY aliases /etc/
COPY docker-entrypoint.sh /

RUN chmod a+x /usr/local/bin/aplog_anon.pl

RUN rm -f /var/lib/tomcat8/webapps/manager

VOLUME /var/lib/mysql

RUN git clone https://${GIT_USER}:${GIT_PASSWORD}@github.com/jondos/jondos-shop /var/www/shop
RUN chown -R www-data.www-data /var/www/shop

ENTRYPOINT [ "/docker-entrypoint.sh" ]
