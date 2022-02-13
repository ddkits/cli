echo 'Would you like to send usage (No private information will be shared ever from or to GetFreeAPI, just to count how many developers like you would love more from DDKits to grow)
      of DDKits on GetfreeApi.com "Get Free API is owned by DDKits for APIs" ? ex. yes, y, YES would accept to send your domain name and email used in this process only'
read ANSWERSEND

if[[ $ANSWERSEND == 'y' || $ANSWERSEND == 'yes' || $ANSWERSEND == 'YES' ]];then 
curl -v --request POST \
  --url 'https://rest.reallexi.com/api/ddk/1_ddkits_api?web='${DDKITSSITES}'&platform='${PLATFORM}'&email='${MAIL_ADDRESS}'' \
  --header 'Accept: application/json' \
  --header 'Authorization: Bearer '$TTDD \
  --header 'Cache-Control: no-cache' \
  --header 'Connection: keep-alive' \
  --header 'Host: rest.reallexi.com' \
  --header 'accept-encoding: gzip, deflate' \
  --header 'cache-control: no-cache'
fi
