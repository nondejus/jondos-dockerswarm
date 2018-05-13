FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  git apache2 supervisor mysql-server-5.5 maven svn

RUN rm -f /etc/apache2/sites-enabled/*
RUN mkdir /etc/infoservice

COPY service.conf /etc/supervisor/conf.d/service.conf
COPY ipcheck.conf /etc/apache2/sites-enabled/
COPY perl/aplog_anon.pl /bin/aplog_anon
COPY perl/geo_anon.pl /usr/local/bin/
COPY java/InfoService.properties /etc/infoservice

RUN /usr/sbin/a2ensite ipcheck
RUN service mysql start
RUN /usr/bin/mysql -u root -e "CREATE DATABASE anontest; \
CREATE TABLE anontest.sslsession (`sessionid` varchar(70) NOT NULL, `zeit` int(11) NOT NULL, \
PRIMARY KEY (`sessionid`)) ENGINE=MyISAM DEFAULT CHARSET=latin1;"
RUN service mysql stop

RUN cd /var/www && git clone https://github.com/jondos/anontest
RUN cd /root && \
    svn checkout https://svn.jondos.de/svn/InfoService/InfoService/trunk/ InfoService && \
    cd InfoService && \
    mvn verify && \
    install -m 755 target/*.jar /usr/share/java/InfoService.jar && \
    cd .. && \
    rm -rf InfoService ~/.m2 && \
    apt-get purge maven

EXPOSE 21
EXPOSE 80
EXPOSE 443

CMD [ "/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf" ]
