FROM fedora

ENV port 5950

RUN dnf install -y gdm tigervnc-server tigervnc xinet && \
    systemctl enable xinetd.service && \
    systemctl set-default graphical.target

RUN sed -i s/Enable=.*/Enable=true/ /etc/gdm/custom.conf
RUN echo xvncserver $port/tcp >> /etc/services

COPY terminal/xvncserver /etc/xinetd.d/xvncserver

RUN cd /home ; for user in * ; do useradd -M -G users $user ; done

EXPOSE $port

VOLUME /home

CMD /sbin/init
