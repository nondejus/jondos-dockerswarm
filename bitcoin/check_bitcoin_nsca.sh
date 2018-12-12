#!/bin/bash

message="$(hostname -f)|Bitcoind|"

if /usr/local/bin/bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getbalance
then
        message="$message$?|OK"
else
        response=$(/usr/local/bin/bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf getbalance 2>&1)
        message="$message$?|$response"
        ps -C bitcoind || su -l bitcoin -c /usr/local/bin/bitcoind
fi

echo $message
echo $message | /usr/sbin/send_nsca -H monitor.anonymous-proxy-servers.net -d "|" -c /etc/send_nsca.cfg
