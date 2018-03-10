#!/bin/bash

# inspired by http://arctic.org/~dean/rdiff-backup/unattended.html

# generate host keys
ssh-keygen -A

# generate backup user's ssh key
ssh-keygen -f /home/backup/.ssh/id_rsa -t rsa -N ''

echo command=\"rdiff-backup --server --restrict-read-only /\",no-port-forwarding,no-X11-forwarding,no-pty $(</home/backup/.ssh/id_rsa.pub) >> /home/backup/.ssh/authorized_keys