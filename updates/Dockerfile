FROM ubuntu

RUN apt-get update && apt-get install libfindbin-libs-perl libyaml-perl \
    libfile-slurp-perl libdigest-sha-perl libxml-writer-perl git apache2

COPY 000-default.conf /etc/apache2/sites-available
COPY 001-default-ssl.conf /etc/apache2/sites-available

RUN rm -f /etc/apache/sites-enabled
RUN a2ensite 000-default && a2ensite 001-default-ssl
RUN a2enmod rewrite

RUN cd /var/www && git clone https://github.com/lancerajee/torupdates && \
    mkdir torbrowser

VOLUME /var/www/torupdates/htdocs/torbrowser
VOLUME /etc/letsencrypt

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
