#!/bin/bash

case $1 in
  --init)
      service nginx stop
      certbot-auto certonly --standalone $(certbot-domains.conf)
      service nginx start
      ;;
  --renew
      service nginx stop
      certbot-auto renew
      service nginx start
      ;;
  *)
      echo Usage: $0 {--init|--renew}
      exit 1
      ;;
esac
