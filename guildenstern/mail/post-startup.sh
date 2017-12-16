#!/bin/bash

test -x /home/mail-files/setup-mail.sh || wget -q -O /home/mail-files/setup-mail.sh https://raw.githubusercontent.com/tomav/docker-mailserver/master/setup.sh && chmod a+x /home/mail-files/setup-mail.sh

# create local unix users (otherwise login will fail)
for i in $(ls /root/mail-files/data/jondos.de) ; do 
    echo Setting up mail user $i 
    docker exec mail useradd $i 
done

# 1. enforce encryption 2. replace texthash by hash 3. set our IP as mydestination
docker exec mail postconf \
    smtp_tls_security_level=may \
    alias_database=hash:/etc/aliases \
    alias_maps=hash:/etc/aliases \
    strict_mailbox_ownership=no \
    smtpd_tls_auth_only=yes \
    smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination \
    "mydestination=\$myhostname localhost 78.129.167.102"

# exempt comm with amavis from encryption
docker exec mail postconf -P \
    127.0.0.1:10025/inet/smtpd_tls_security_level=none \
    smtp-amavis/unix/smtpd_tls_security_level=none

# enable SMTPS over port 465 (deprecatd but still expected by some clients)
docker cp mail:/etc/postfix/master.cf /tmp/master.cf
grep ^smtp.*inet /tmp/master.cf | sed -e s/smtp/smtps/ > /tmp/master.cf_
cat /tmp/master.cf_ >> /tmp/master.cf
cat >> /tmp/master.cf <<EOF
  -o syslog_name=postfix/smtps
  -o smtpd_tls_wrappermode=yes
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
  -o content_filter=smtp-amavis:[127.0.0.1]:10024
  -o milter_macro_daemon_name=ORIGINATING
EOF

docker cp /tmp/master.cf mail:/etc/postfix/master.cf

echo "\$undecipherable_subject_tag = undef;" > /tmp/70-unchecked 
docker cp /tmp/70-unchecked mail:/etc/amavis/conf.d