FROM php:5-apache-jessie

RUN apt-get update && apt-get install -f gpgv

# set up tor repo
RUN echo "deb http://deb.torproject.org/torproject.org jessie main" > /etc/apt/sources.list.d/torproject && \
    gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 && \
    gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

# install debian packages
RUN apt-get update && apt-get install -f \
    default-jdk-headless \
    mysql-server-5.5 \
    maven \
    git \
    svn \
    perl \
    geoip-bin \
    libgeo-ip-perl \
    libgeoip1 \
    tor-geoipdb \
    tor \
    deb.torproject.org-keyring

# install mysql
RUN service mysql start && \
    /usr/bin/mysql -u root -e "CREATE DATABASE anontest; \
CREATE TABLE anontest.sslsession (`sessionid` varchar(70) NOT NULL, `zeit` int(11) NOT NULL, \
PRIMARY KEY (`sessionid`)) ENGINE=MyISAM DEFAULT CHARSET=latin1; \
CREATE USER 'anontest'@'localhost' IDENTIFIED BY 'kzgt56TR12'; \
GRANT ALL ON anontest.* TO 'anontest'@'localhost';" && \
    service mysql stop
# ----------

COPY docker-entrypoint.sh /
COPY apache2/ipcheck.conf /etc/apache2/sites-enabled 
COPY /perl/aplog_anon.pl /bin/aplog_anon
COPY java/InfoService.properties /etc/infoservice
COPY cgi-bin /var/www
COPY policyserver /var/www
COPY /perl/geo_anon.pl /usr/local/bin
COPY /perl/rssfeedupdater /usr/local/bin
COPY tor/torupdate /usr/local/bin
COPY ftp /home

RUN echo "10 * * * * /usr/local/bin/torupdate.sh" | crontab

RUN chmod -R a+x \
    /bin/aplog_anon \
    /usr/local/bin/ \
    /root/torupdate \
    /var/www/cgi-bin/ \
    /var/www/policyserver/ \
    /docker-entrypoint.sh

VOLUME /var/log/apache2

RUN ln -sf /dev/stdout /var/log/tor/log

RUN cd /var/www && \
    svn checkout https://svn.jondos.de/svn/anontest

RUN cd /root && \
    svn checkout https://svn.jondos.de/svn/InfoService/InfoService/trunk/ InfoService && \
    cd InfoService && \
    mvn verify && \
    install -m 755 target/*.jar /usr/share/java/InfoService.jar && \
    cd .. && \
    rm -rf InfoService ~/.m2 && \
    apt-get purge maven

#COPY InfoService.jar /usr/share/java

RUN useradd -d /var/lib/infoservice -U jondonym-infoservice && \
    useradd -M infoservice

EXPOSE 21
EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "/docker-entrypoint.sh" ]



