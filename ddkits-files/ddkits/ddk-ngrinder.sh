#!/bin/sh

#  Script.sh
#
# ngrinder
#
# This system built by Mutasem Elayyoub DDKits.com

# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits.env.yml" ]]; then
  rm $DDKITSFL/ddkits.env.yml
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkitsnew.yml" ]]; then
  rm $DDKITSFL/ddkitsnew.yml
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits-files/ngrinder/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/ngrinder/Dockerfile
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[ -f "${DDKITSFL}/ddkits-files/ngrinder/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/ngrinder/sites/$DDKITSHOSTNAME.conf
fi
if [[ -f "$DDKITSFL/ddkits-files/ngrinder/ngrinder-agent/__agent.conf" ]]; then
  rm $DDKITSFL/ddkits-files/ngrinder/ngrinder-agent/__agent.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/ngrinder/sites" ]]; then
  mkdir $DDKITSFL/ddkits-files/ngrinder/sites
  chmod -R 777 $DDKITSFL/ddkits-files/ngrinder/sites
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/ddkits/ssl" ]]; then
  mkdir $DDKITSFL/ddkits-files/ddkits/ssl
  chmod -R 777 $DDKITSFL/ddkits-files/ddkits/ssl
fi

cat "./ddkits-files/ddkits/logo.txt"
# create the crt files for ssl
openssl req \
  -newkey rsa:2048 \
  -x509 \
  -nodes \
  -keyout $DDKITSSITES.key \
  -new \
  -out $DDKITSSITES.crt \
  -subj /CN=$DDKITSSITES \
  -reqexts SAN \
  -extensions SAN \
  -config <(cat /System/Library/OpenSSL/openssl.cnf \
    <(printf '[SAN]\nsubjectAltName=DNS:'$DDKITSSITES'')) \
  -sha256 \
  -days 3650
mv $DDKITSSITES.key $DDKITSFL/ddkits-files/ddkits/ssl/
mv $DDKITSSITES.crt $DDKITSFL/ddkits-files/ddkits/ssl/
echo "ssl crt and .key files moved correctly"

#  ngrinder setup
echo -e '
<VirtualHost *:80>
     ServerAdmin melayyoub@outlook.com
     ServerName '$DDKITSSITES'
     '$DDKITSSERVERS'
     DocumentRoot /var/www/html/'$WEBROOT'
      ErrorLog /var/www/html/error.log
     CustomLog /var/www/html/access.log combined
    <Location "/">
      Require all granted
      AllowOverride All
      Order allow,deny
      allow from all
  </Location>
  <Directory "/var/www/html">
      Options Indexes FollowSymLinks MultiViews
      AllowOverride All
      Require all granted
      Order allow,deny
      allow from all
  </Directory>
</VirtualHost>

<VirtualHost *:443>
  ServerAdmin melayyoub@outlook.com
   ServerName '$DDKITSSITES'
   '$DDKITSSERVERS'
    DocumentRoot /var/www/html/'$WEBROOT'

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

  <Location "/">
      Require all granted
      AllowOverride All
      Order allow,deny
      allow from all
  </Location>
  <Directory "/var/www/html">
      Require all granted
      AllowOverride All
      Order allow,deny
      allow from all
  </Directory>
</VirtualHost>' >$DDKITSFL/ddkits-files/ngrinder/sites/$DDKITSHOSTNAME.conf

echo -e '

common.start_mode=agent
agent.controller_host='$DDKITSSITES'
agent.controller_port='$DDKITSWEBPORT'
agent.region=Americas
#agent.host_id=
#agent.server_mode=true

# provide more agent java execution option if necessary.
#agent.java_opt=
# set following false if you want to use more than 1G Xmx memory per a agent process.
agent.limit_xmx=true

# please uncomment the following option if you want to send all logs to the controller.
#agent.all_logs=true
# some jvm is not compatible with DNSJava. If so, set this false.
#agent.enable_local_dns=false

' >$DDKITSFL/ddkits-files/ngrinder/ngrinder-agent/__agent.conf

echo -e 'version: "3.1"

services:
  web:
    image: ngrinder/controller:3.4
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_web
    networks:
      - ddkits
    volumes:
      - $DDKITSFL/ngrinder-deploy:/opt/ngrinder-controller
    links:
      - mariadb
    ports:
      - "'$DDKITSWEBPORT':80"
      - "'$DDKITSWEBPORTSSL':443"
      - "16001:16001"
      - "12000-12009:12000-12009"

  ngrinder-agent:
      image: ddkits/ngrinder-agent:latest
      links:
        - web
      environment:
        - CONTROLLER_ADDR='$DDKITSIP':'$DDKITSWEBPORT'
  ngrinder-agent1:
        image: ddkits/ngrinder-agent:latest
        links:
          - web
        environment:
          - CONTROLLER_ADDR='$DDKITSIP':'$DDKITSWEBPORT'
  ngrinder-agent2:
        image: ddkits/ngrinder-agent:latest
        links:
          - web
        environment:
          - CONTROLLER_ADDR='$DDKITSIP':'$DDKITSWEBPORT'
  ngrinder-agent3:
        image: ddkits/ngrinder-agent:latest
        links:
          - web
        environment:
          - CONTROLLER_ADDR='$DDKITSIP':'$DDKITSWEBPORT'
  ngrinder-agent4:
        image: ddkits/ngrinder-agent:latest
        links:
          - web
        environment:
          - CONTROLLER_ADDR='$DDKITSIP':'$DDKITSWEBPORT'
' >$DDKITSFL/ddkits.env.yml

echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/ngrinder-deploy
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/ddkits-files/ngrinder/ngrinder-agent

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias >/dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_web /bin/bash'" >>~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/ngrinder-deploy

cd $DDKITSFL
