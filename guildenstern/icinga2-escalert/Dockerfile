FROM jordan/icinga2

RUN cd /etc/icinga2/ && \
    curl -s -o - https://Escalert.io/static/downloads/escalert_icinga2.tgz | tar xz && \
    mkdir /var/spool/escalert && \
    chmod 755 /var/spool/escalert

RUN crontab -l > /tmp/crontab && \
    echo "*   *   *   *   *    /etc/icinga2/scripts/__check_escalert_queue.sh" >> /tmp/crontab && \
    crontab /tmp/crontab
