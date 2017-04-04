FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y software-properties-common

RUN LC_ALL=C.UTF-8 apt-add-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y wget unzip apache2 php5.6-mysql libapache2-mod-php5.6 php5.6-xml

RUN mkdir -p /var/lock/apache2 /var/run/apache2
RUN rm -rf /var/www/html/*
RUN wget -O /tmp/kimai.zip "https://downloads.sourceforge.net/project/kimai/0.9.x/kimai.0.9.2.1306-3.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fkimai%2Ffiles%2F0.9.x%2F&ts=1491343628&use_mirror=netix" && \
  unzip -d /var/www/html /tmp/kimai.zip && \
  rm -f /tmp/kimai.zip

COPY autoconf.php /var/www/html/includes/autoconf.php

RUN chown -R www-data.www-data /var/www/html
RUN chmod -R a+w /var/www/html/temporary /var/www/html/includes/
RUN rm -rf /var/www/html/installer

EXPOSE 80

CMD /bin/bash -c  "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"
