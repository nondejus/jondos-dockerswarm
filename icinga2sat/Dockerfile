FROM debian:jessie

ARG TICKET
ARG HOSTNAME

ENV DEBIAN_FRONTEND noninteractive
ENV MASTER monitor.anonymous-proxy-servers.net

RUN apt-get update && apt-get install -y wget supervisor apt-utils \
     && wget --quiet -O - https://packages.icinga.org/icinga.key | apt-key add - \
     && echo "deb http://packages.icinga.org/debian icinga-jessie main" > /etc/apt/sources.list.d/icinga2.list \
     && apt-get update \
     && apt-get install -y --no-install-recommends \
          icinga2 \
          icingacli \
          monitoring-plugins \
          nagios-nrpe-plugin \
          nagios-snmp-plugins \
          nagios-plugins-contrib \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

COPY icinga-supervisor.conf /etc/supervisor/conf.d 

RUN cd /etc/icinga2/pki && \
    icinga2 pki new-cert --cn $HOSTNAME \
      --key $HOSTNAME.key \
      --cert $HOSTNAME.crt && \
    icinga2 pki save-cert \
      --key $HOSTNAME.key \
      --cert $HOSTNAME.crt \
      --trustedcert $MASTER.crt \
      --host $MASTER && \
    icinga2 pki request \
      --ticket $TICKET \
      --key $HOSTNAME.key \
      --cert $HOSTNAME.crt \
      --ca ca.crt \
      --port 5665 \
      --trustedcert $MASTER.crt \
      --host $MASTER                                  

RUN cd /etc/icinga2/pki && \
    icinga2 node setup \
    --cn $HOSTNAME \
    --ticket $TICKET \
    --trustedcert $MASTER.crt \
    --endpoint $MASTER \
    --zone $HOSTNAME \
    --master_host $MASTER \
    --accept-commands \
    --accept-config

EXPOSE 5665

CMD [ "/usr/bin/supervisord", "--configuration", "/etc/supervisor/supervisord.conf", "--nodaemon" ]
