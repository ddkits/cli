#!/bin/bash
set -e

# Set up our certs for the appserver with nginx
if [ ! -f "/certs/appserver.pem" ]; then
  openssl genrsa -out /certs/appserver.key 2048 && \
  openssl req -new -x509 -key /certs/appserver.key -out /certs/appserver.crt -days 365 -subj "/C=US/ST=California/L=San Francisco/O=WhyWebs/OU=KB/CN=appserver" && \
  cat /certs/appserver.crt /certs/appserver.key > /certs/appserver.pem
fi

# Run the NGINX
nginx "$@"
