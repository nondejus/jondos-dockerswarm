FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  nagios3 nagios-plugins nsca git apache2 supervisor

RUN rm -f /etc/apache2/sites-enabled/*

COPY service.conf /etc/supervisor/conf.d/service.conf
COPY nagios.conf /etc/apache2/sites-enabled/nagios.conf

VOLUME /etc/nagios3
VOLUME /etc/nagios-plugins

EXPOSE 80

CMD [ "/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf" ]
