FROM jshridha/rdiffweb

ADD *.sh /root/
ADD *.conf /etc/supervisor/conf.d/
ADD getkey /usr/local/bin

RUN mkdir -p /root/.ssh
RUN echo "0 0 * * *   /root/rdiff-backup.sh" | crontab
