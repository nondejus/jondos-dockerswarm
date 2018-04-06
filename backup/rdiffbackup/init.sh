#!/bin/bash

# inspired by http://arctic.org/~dean/rdiff-backup/unattended.html

# generate host keys
ssh-keygen -A

# generate backup user's ssh key
mkdir -p /etc/rdiffweb/clients
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
