FROM ubuntu

ARG TICKET
ARG HOSTNAME

ENV DEBIAN_FRONTEND noninteractive
ENV MASTER monitor.anonymous-proxy-servers.net

RUN apt-get update && apt-get install -y wget apt-utils supervisor && \
    wget -O - http://packages.icinga.org/icinga.key | apt-key add - && \
    echo 'deb http://packages.icinga.org/ubuntu icinga-xenial main' > /etc/apt/sources.list.d/icinga-main-xenial.list && \
    apt-get update && apt-get install -y icinga2
    
COPY icinga-supervisor.conf /etc/supervisor/conf.d 

RUN mkdir -p /etc/icinga2/pki && \
    chmod -R a+rw /etc/icinga2/pki && \
    icinga2 pki new-cert --cn $HOSTNAME \
      --key /etc/icinga2/pki/$HOSTNAME.key \
      --cert /etc/icinga2/pki/$HOSTNAME.crt && \
    icinga2 pki save-cert \
      --key /etc/icinga2/pki/$HOSTNAME.key \
      --cert /etc/icinga2/pki/$HOSTNAME.crt \
      --trustedcert /etc/icinga2/pki/$MASTER.crt \
      --host $MASTER                                  

RUN icinga2 node setup \
    --cn $HOSTNAME \
    --ticket $TICKET \
    --trustedcert /etc/icinga2/pki/$MASTER.crt \
    --endpoint $MASTER \
    --zone $HOSTNAME \
    --master_host $MASTER \
    --accept-commands \
    --accept-config

EXPOSE 5665

CMD [ "/usr/bin/supervisord", "--configuration", "/etc/supervisor/supervisord.conf", "--nodaemon" ]
