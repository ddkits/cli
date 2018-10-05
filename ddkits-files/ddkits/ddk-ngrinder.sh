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
if [[  -f "${DDKITSFL}/ddkits-files/ngrinder/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/ngrinder/Dockerfile
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[  -f "${DDKITSFL}/ddkits-files/ngrinder/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/ngrinder/sites/$DDKITSHOSTNAME.conf
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
     DocumentRoot /var/www/html/public
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
    DocumentRoot /var/www/html/public

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
</VirtualHost>' > $DDKITSFL/ddkits-files/ngrinder/sites/$DDKITSHOSTNAME.conf

echo -e '

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf $DDKITSFL/logs /var/log/nginx/access.log \
    && ln -sf $DDKITSFL/logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf 
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
RUN chmod o+rw /var/www/html
COPY $DDKITSFL/sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf 

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >> $DDKITSFL/ddkits-files/ngrinder/Dockerfile

echo -e 'version: "2"

services:
  web:
    image: ngrinder/controller:3.4
    stdin_open: true
    tty: true
    container_name: ${DDKITSHOSTNAME}_ddkits_ngrinder_web
    networks:
      - ddkits
    volumes:
      - $DDKITSFL/ngrinder-deploy:/opt/ngrinder-controller
    links:
      - mariadb
    ports:
      - "16001:16001"
      - "12000-12009:12000-12009"
      - "'$DDKITSWEBPORT':80"
      - "'$DDKITSWEBPORTSSL':443"
    networks:
      - ddkits
  ngrinder-agent:
      image: ngrinder/agent:3.4
      links:
        - web
      environment:
        - CONTROLLER_ADDR='$DDKITSSITES':16001
      networks:
        - ddkits
' >> $DDKITSFL/ddkits.env.yml
    
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/ngrinder-deploy


# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_ngrinder_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_ngrinder_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/ngrinder-deploy

cd $DDKITSFL