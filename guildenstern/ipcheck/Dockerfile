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

RUN cpan install && cpan install Geo::IP

COPY github-credentials /tmp/github-credentials

RUN cd /var/www && \
    git config --global credential.helper "store --file=/tmp/github-credentials" && \
    git clone https://github.com/jondos/anontest.git && \
    rm -f /tmp/github

# install geoipupdate
# there is no package for Jessie, need to compile it ourselves
RUN wget https://github.com/maxmind/geoipupdate/releases/download/v4.1.5/geoipupdate_4.1.5_linux_amd64.tar.gz && \
    tar xzvf geoipupdate_4.1.5_linux_amd64.tar.gz && \
    cp geoipupdate_4.1.5_linux_amd64/geoipupdate /usr/bin && \
    rm -rf geoipupdate_4.1.5_linux_amd64*

# install mysql
# Workaround for docker filesystem issue https://github.com/docker/for-linux/issues/72
RUN ln -sf /dev/stdout /var/log/mysql/error.log && \
    find /var/lib/mysql -type f -exec touch {} \; && \
    service mysql start && \
    sleep 10 && \
    /usr/bin/mysql -u root -e "CREATE DATABASE anontest; \
CREATE TABLE anontest.sslsession (sessionid varchar(70) NOT NULL, zeit int(11) NOT NULL, \
PRIMARY KEY (sessionid)) ENGINE=MyISAM DEFAULT CHARSET=latin1; \
CREATE USER 'anontest'@'localhost' IDENTIFIED BY 'kzgt56TR12'; \
GRANT ALL ON anontest.* TO 'anontest'@'localhost';" && \
    service mysql stop
# ----------

# install certbot
RUN wget https://dl.eff.org/certbot-auto && \
    sudo mv certbot-auto /usr/local/bin/certbot-auto && \
    sudo chown root /usr/local/bin/certbot-auto && \
    sudo chmod 0755 /usr/local/bin/certbot-auto

COPY docker-entrypoint.sh /
COPY apache2/ipcheck.conf /etc/apache2/sites-enabled
COPY apache2/ip-check.conf /etc/apache2/sites-enabled
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
COPY geoip/GeoIPOrg.dat /var/www/anontest/geoip/GeoIPOrg.dat
COPY geoip/GeoIPISP.dat /var/www/anontest/geoip/GeoIPISP.dat
COPY tor/torrc /etc/tor/torrc
COPY tor/torsocks.conf /etc/tor/torsocks.conf
COPY tor/tor-service-defaults-torrc /usr/share/tor/tor-service-defaults-torrc
COPY crontab /tmp/crontab

RUN cat /tmp/crontab | crontab

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

#GeoIP is discontinued, need to migrate to GeoIP2
#RUN /etc/cron.weekly/updategeoipRUN /etc/cron.weekly/updategeoip
RUN ln -s /usr/share/GeoIP /usr/local/share/GeoIP && \
    ln -s /etc/GeoIP.conf /usr/local/etc/

# clean up unneccesary packages
RUN apt-get purge -y maven automake autoconf libtool git subversion && apt-get autoremove -y && apt-get clean

COPY java/InfoService.jar /usr/share/java

RUN cd /var/www/anontest/ftptest && javac testftpserver/FTPServer.java

RUN useradd -d /var/lib/infoservice -U jondonym-infoservice && \
    useradd -M infoservice

RUN a2enmod expires && a2enmod rewrite && a2dissite 000-default && apachectl configtest

COPY geoip/GeoIP.conf      /etc/GeoIP.conf
COPY geoip/GeoIP.dat       /var/www/anontest/geoip/GeoIP.dat
COPY geoip/GeoIPISP.dat    /var/www/anontest/geoip/GeoIPISP.dat
COPY geoip/GeoIPOrg.dat    /var/www/anontest/geoip/GeoIPOrg.dat
COPY geoip/GeoLiteCity.dat /var/www/anontest/geoip/GeoLiteCity.dat

WORKDIR /var/www/anontest

EXPOSE 21
EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "/docker-entrypoint.sh" ]
