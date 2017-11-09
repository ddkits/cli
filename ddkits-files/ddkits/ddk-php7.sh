#!/bin/sh

#  Script.sh
#
# PHP7
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
if [[  -f "${DDKITSFL}/ddkits-files/lamp7/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/lamp7/Dockerfile
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[  -f "${DDKITSFL}/ddkits-files/lamp7/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/lamp7/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/lamp7/sites" ]]; then 
  mkdir $DDKITSFL/ddkits-files/lamp7/sites
  chmod -R 777 $DDKITSFL/ddkits-files/lamp7/sites 
fi
#  LAMP PHP 7

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
      Require all granted
      AllowOverride All
      Order allow,deny
      allow from all
  </Directory>
</VirtualHost> ' > $DDKITSFL/ddkits-files/lamp7/sites/$DDKITSHOSTNAME.conf

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
COPY ./sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf 

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >> $DDKITSFL/ddkits-files/lamp7/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: $DDKITSFL/ddkits-files/lamp7
    image: ddkits/lamp7:latest
    
    volumes:
      - $DDKITSFL/lamp7-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: ${DDKITSHOSTNAME}_ddkits_lamp7_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> $DDKITSFL/ddkits.env.yml

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_lamp7_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_lamp7_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/lamp7-deploy

cd $DDKITSFL