FROM httpd:latest

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME=/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64
ENV TOMCAT_VERSION=9.0.24

ARG GIT_USER
ARG GIT_PASSWORD

RUN mkdir -p /usr/share/man/man1

RUN apt-get update && \
    apt-get install -y \
    mariadb-server \
    git \
#    openjdk-11-jre-headless \
    rsyslog \
    postfix \
    wget \
    build-essential \
    apt-transport-https ca-certificates dirmngr gnupg software-properties-common 

# Install PERL dependencies
RUN cpan install CGI::EncryptForm XML::Bare LWP::Simple JSON::RPC::Client Email::Valid

# Install old Java
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
    apt-get update && apt-get install -y adoptopenjdk-8-hotspot

# Install Tomcat 9
RUN wget https://www-us.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    mkdir /opt/tomcat9 && \
    tar xzf apache-tomcat-*.tar.gz -C /opt/tomcat9 --strip-components=1 && \
    useradd -r -d /opt/tomcat9/ -s /bin/false tomcat && \
    chown -R :tomcat /opt/tomcat9/ && \
    chmod -R g+r /opt/tomcat9/conf && \
    chmod g+x /opt/tomcat9/conf && \
    rm apache-tomcat*

COPY apache2/shop.conf /tmp/shop.conf
COPY perl/aplog_anon.pl /usr/local/bin/
COPY java/paysafecardclient.war /opt/tomcat9/webapps/
COPY tomcat/tomcat-users.xml /opt/tomcat9/conf/
COPY postfix/* /etc/postfix/
COPY aliases /etc/
COPY docker-entrypoint.sh /

RUN chmod a+x /usr/local/bin/aplog_anon.pl

RUN grep -vh "^[ ]*#" /usr/local/apache2/conf/httpd.conf /tmp/shop.conf | grep -v "^$" >> /tmp/httpd.conf
RUN mv -f /tmp/httpd.conf /usr/local/apache2/conf

RUN rm -rf /opt/tomcat9/webapps/manager

VOLUME /var/lib/mysql

RUN git clone https://${GIT_USER}:${GIT_PASSWORD}@github.com/jondos/jondos-shop /var/www/shop && \
    chown -R daemon /var/www/shop

ENTRYPOINT [ "/docker-entrypoint.sh" ]

