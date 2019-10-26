curl -v --request POST \
  --url 'https://getfreeapi.com/api/ddk/1_ddkits?domain='${DDKITSSITES}'&platform='${PLATFORM}'&email='${MAIL_ADDRESS}'' \
  --header 'Accept: application/json' \
  --header 'Authorization: Bearer '${TO}'' \
  --header 'Cache-Control: no-cache' \
  --header 'Host: getfreeapi.com' \
  --header 'User-Agent: PostmanRuntime/7.13.0' \
  --header 'accept-encoding: gzip, deflate' \
  --header 'cache-control: no-cache'