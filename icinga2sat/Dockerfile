FROM ubuntu

RUN apt-get update && apt-get install -y wget supervisor \
    wget -O - http://packages.icinga.org/icinga.key | apt-key add - && \
    echo 'deb http://packages.icinga.org/ubuntu icinga-xenial main' > /etc/apt/sources.list.d/icinga-main-xenial.list \
    apt-get update && apt-get install -y icinga2
    
COPY icinga-supervisor.conf /etc/supervisor/conf.d 

EXPOSE 5665

CMD [ "/usr/bin/supervisord", "--configuration", "/etc/supervisor/supervisord.conf", "--nodaemon" ]
