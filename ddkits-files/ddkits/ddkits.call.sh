#!/bin/sh

#  call.sh
#
# This system Powered by Mutasem Elayyoub DDKits.com 
MYIP='dig @resolver1.opendns.com ANY myip.opendns.com +short'
curl -v --request POST \
  --url 'https://getfreeapi.com/api/ddk/1_ddkits?domain='${DDKITSSITES}'&platform='${PLATFORM}'&opt='${opt}'&email='${MAIL_ADDRESS}'' \
  --header 'Accept: application/json' \
  --header 'Authorization: Bearer '${TO}'' \
  --header 'Host: getfreeapi.com' \
  --header 'cache-control: no-cache'