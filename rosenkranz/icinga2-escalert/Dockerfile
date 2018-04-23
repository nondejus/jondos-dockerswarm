FROM jordan/icinga2

RUN apt-get update && apt-get install -y cron && apt-get clean

RUN cd /etc/icinga2/ && \
    curl -s -o - https://Escalert.io/static/downloads/escalert_icinga2.tgz | tar xz && \
    mkdir /var/spool/escalert && \
    chmod 755 /var/spool/escalert

RUN echo "*   *   *   *   *    /etc/icinga2/scripts/__check_escalert_queue.sh" | crontab -
