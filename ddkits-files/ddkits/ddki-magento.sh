#!/bin/sh

#  Script.sh
#
# Magento
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
if [[ -f "${DDKITSFL}/ddkits-files/magento/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/magento/Dockerfile
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[ -f "${DDKITSFL}/ddkits-files/magento/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/magento/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/magento/sites" ]]; then
  mkdir $DDKITSFL/ddkits-files/magento/sites
  chmod -R 777 $DDKITSFL/ddkits-files/magento/sites
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

#  Magento setup
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
</VirtualHost>' >$DDKITSFL/ddkits-files/magento/sites/$DDKITSHOSTNAME.conf

echo -e '

FROM ddkits/lamp:'$DDKITSPHPVERSION'

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf $DDKITSFL/logs /var/log/nginx/access.log \
    && ln -sf $DDKITSFL/logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/*
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
RUN chmod o+rw /var/www/html
COPY $DDKITSFL/sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf

# Fixing permissions
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >>$DDKITSFL/ddkits-files/magento/Dockerfile

echo -e 'version: "3.1"

services:
  web:
    build: $DDKITSFL/ddkits-files/magento
    image: ddkits/magento:latest

    volumes:
      - $DDKITSFL/mag-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80"
      - "'$DDKITSWEBPORTSSL':443" ' >>$DDKITSFL/ddkits.env.yml

if [[ ! -d "mag-deploy/${WEBROOT}" ]]; then
  mkdir $DDKITSFL/mag-deploy
  git clone https://github.com/ddkits/magento.git $DDKITSFL/mag-deploy/$WEBROOT

  echo $DDKITSFL
  cp -f $DDKITSFL/composer.phar $DDKITSFL/mag-deploy/$WEBROOT/ddkits.phar
  cp $DDKITSFL/composer.phar $DDKITSFL/mag-deploy/$WEBROOT/ddkits.phar && echo $SUDOPASS | sudo -S chmod 777 $DDKITSFL/mag-deploy/$WEBROOT/ddkits.phar
  cd $DDKITSFL/mag-deploy/$WEBROOT && php ddkits.phar config --global discard-changes true && php ddkits.phar install -n
  cd $DDKITSFL
else

  echo $DDKITSFL
  cp $DDKITSFL/composer.phar $DDKITSFL/mag-deploy/$WEBROOT/ddkits.phar && echo $SUDOPASS | sudo -S chmod 777 $DDKITSFL/mag-deploy/$WEBROOT/ddkits.phar
  cd $DDKITSFL/mag-deploy/$WEBROOT && php ddkits.phar config --global discard-changes true && php ddkits.phar install -n
  cd $DDKITSFL
fi
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/mag-deploy

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias >/dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_web /bin/bash'" >>~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/magento-deploy

cd $DDKITSFL
