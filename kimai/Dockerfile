FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  wget unzip apache2 php-mysql libapache2-mod-php php-xml ntp supervisor

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/supervisor
RUN rm -rf /var/www/html/*
RUN wget -O /tmp/kimai.zip https://github.com/kimai/kimai/releases/download/0.9.3/kimai_0.9.3.zip && \
  unzip /tmp/kimai.zip && \
  rm -f /tmp/kimai.zip

RUN chown www-data.www-data /var/www/html

EXPOSE 80

CMD source /etc/apache2/envvars && exec /usr/sbin/apasch2 -DFOREGROUND
