FROM jshridha/rdiffweb

# configure SSHD
EXPOSE 22
RUN sed -i s/".*PasswordAuthentication .*"/"PasswordAuthentication no"/ /etc/ssh/sshd_config && \
    update-rc.d ssh defaults

# Create remote backup user
RUN adduser --shell /bin/false backup

ADD *.sh /root/
ADD *.conf /etc/supervisor/conf.d/

VOLUME /home/backup/.ssh