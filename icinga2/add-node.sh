#!/bin/bash

eval $(docker exec icinga2 grep TicketSalt /etc/icinga2/constants.conf | cut -f 2- -d " " | tr -d " ")
docker exec icinga2 icinga2 pki ticket --cn $1 --salt $TicketSalt
