## Note on github credentils:
## Write the credentials in the form
##   https://username:password@github.com
## to a file called "github-credentials" in the container build context.
## You can delete the file once the image is built
##
## There currently is no other secure way to
## pass credentials to a docker build.

FROM php:5-apache-jessie

ENV DEBIAN_FRONTEND noninteractive

RUN echo Europe/Berlin > /etc/timezone

RUN apt-get update && apt-get install -y gpgv sudo

# set up tor repo
RUN echo "deb http://deb.torproject.org/torproject.org jessie main" > /etc/apt/sources.list.d/torproject.list && \
    gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 && \
    gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

# install debian packages
RUN apt-get update && apt-get install -y \
    default-jdk \
    mysql-server-5.5 \
    maven \
    subversion \
    perl \
    wget \
    geoip-bin \
    libgeo-ip-perl \
    libgeoip1 \
    tor-geoipdb \
    tor \
    deb.torproject.org-keyring \
    git \
    automake autoconf libtool \
    build-essential libcurl4-openssl-dev zlib1g-dev

COPY github-credentials /tmp/github-credentials

RUN cd /var/www && \
    git config --global credential.helper "store --file=/tmp/github-credentials" && \
    git clone https://github.com/jondos/anontest.git && \
    rm -f /tmp/github

# install geoipupdate
# there is no package for Jessie, need to compile it ourselves
RUN git clone https://github.com/maxmind/geoipupdate /tmp/geoipupdate && \
    cd /tmp/geoipupdate && ./bootstrap && ./configure --prefix=/usr --sysconfdir=/etc && make && make install && \
    cd && rm -rf /tmp/geoipupdate

# Workaround for docker filesystem issue https://github.com/docker/for-linux/issues/72
RUN find /var/lib/mysql -type f -exec touch {} \; && service mysql start

# install mysql
# Workaround for docker filesystem issue https://github.com/docker/for-linux/issues/72
RUN find /var/lib/mysql -type f -exec touch {} \; && \
    service mysql start && \
    /usr/bin/mysql -u root -e "CREATE DATABASE anontest; \
CREATE TABLE anontest.sslsession (sessionid varchar(70) NOT NULL, zeit int(11) NOT NULL, \
PRIMARY KEY (sessionid)) ENGINE=MyISAM DEFAULT CHARSET=latin1; \
CREATE USER 'anontest'@'localhost' IDENTIFIED BY 'kzgt56TR12'; \
GRANT ALL ON anontest.* TO 'anontest'@'localhost';" && \
    service mysql stop
# ----------

COPY docker-entrypoint.sh /
COPY apache2/ipcheck.conf /etc/apache2/sites-enabled
COPY /perl/aplog_anon.pl /bin/aplog_anon
COPY java/InfoService.properties /etc/infoservice/InfoService.properties
COPY certs /etc/infoservice/certs
COPY cgi-bin /var/www/cgi-bin
COPY policyserver /var/www/policyserver
COPY /perl/geo_anon.pl /usr/local/bin
COPY /perl/rssfeedupdater /usr/local/bin
COPY tor/torupdate /usr/local/bin
COPY ftp /home
COPY cron.weekly /etc/cron.weekly
COPY geoip/GeoIP.conf /etc/GeoIP.conf
COPY tor/torrc /etc/tor/torrc
COPY tor/torsocks.conf /etc/tor/torsocks.conf
COPY tor/tor-service-defaults-torrc /usr/share/tor/tor-service-defaults-torrc

RUN echo "10 * * * * /usr/local/bin/torupdate" | crontab

RUN chmod -R a+x \
    /bin/aplog_anon \
    /usr/local/bin \
    /var/www/cgi-bin \
    /var/www/policyserver \
    /etc/cron.weekly \
    /docker-entrypoint.sh

# Building InfoService fails because TU Dresden maven repo is defunct
#
#RUN cd /root && \
#    svn checkout https://svn.jondos.de/svn/InfoService/InfoService/trunk/ InfoService && \
#    cd InfoService && \
#    mvn verify && \
#    install -m 755 target/*.jar /usr/share/java/InfoService.jar && \
#    cd .. && \
#    rm -rf InfoService ~/.m2

RUN /etc/cron.weekly/updategeoip

# clean up unneccesary packages
RUN apt-get purge -y maven automake autoconf libtool git subversion && apt-get autoremove -y && apt-get clean

COPY java/InfoService.jar /usr/share/java

RUN cd /var/www/anontest/ftptest && javac testftpserver/FTPServer.java

RUN useradd -d /var/lib/infoservice -U jondonym-infoservice && \
    useradd -M infoservice

RUN a2enmod expires && a2enmod rewrite && apachectl configtest

VOLUME /var/log/apache2

WORKDIR /var/www/anontest

EXPOSE 21
EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "/docker-entrypoint.sh" ]
