#!/bin/sh

#  Script.sh
#
# Chef Development Kits
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
if [[ -f "${DDKITSFL}/ddkits-files/chefdk/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/chefdk/Dockerfile
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[ -f "${DDKITSFL}/ddkits-files/chefdk/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/chefdk/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/chefdk/sites" ]]; then
  mkdir $DDKITSFL/ddkits-files/chefdk/sites
  chmod -R 777 $DDKITSFL/ddkits-files/chefdk/sites
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
  -config <(cat /System/Library/OpenSSL/openssl.cnf <(printf '[SAN]\nsubjectAltName=DNS:'$DDKITSSITES'')) \
  -sha256 \
  -days 3650
mv $DDKITSSITES.key $DDKITSFL/ddkits-files/ddkits/ssl/
mv $DDKITSSITES.crt $DDKITSFL/ddkits-files/ddkits/ssl/
echo "ssl crt and .key files moved correctly"

DOCUMENTROOT=$WEBROOT

# Build out docker file to start our install
echo -e '
FROM ddkits/lamp:7.3

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/*
COPY sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini
RUN curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable
RUN apt-get install tree
# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf
RUN chmod -R 777 /var/www/html


# Fixing permissions
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
  ' >>$DDKITSFL/ddkits-files/chefdk/Dockerfile

# create different containers files for conf
echo -e '
<VirtualHost *:80>
     ServerAdmin melayyoub@outlook.com
     ServerName '$DDKITSSITES'
     '$DDKITSSERVERS'
     DocumentRoot /var/www/html/'$DOCUMENTROOT'
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
</VirtualHost>
<VirtualHost *:443>
  ServerAdmin melayyoub@outlook.com
   ServerName '$DDKITSSITES'
   '$DDKITSSERVERS'
    DocumentRoot /var/www/html/'$DOCUMENTROOT'

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
</VirtualHost>
' >$DDKITSFL/ddkits-files/chefdk/sites/$DDKITSHOSTNAME.conf

echo -e 'version: "3.1"

services:
  web:
    build: $DDKITSFL/ddkits-files/chefdk
    image: ddkits/chefdk:latest

    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_web
    volumes:
      - $DDKITSFL/chef-deploy:/var/www/html
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80"
      - "'$DDKITSWEBPORTSSL':443"
    environment:
       chefdk_DB_HOST: '$DDKITSIP':'$DDKITSDBPORT'
       chefdk_DB_USER: '$MYSQL_USER'
       chefdk_DB_PASSWORD: '$MYSQL_ROOT_PASSWORD' ' >>$DDKITSFL/ddkits.env.yml

# check if wget command exist

mkdir $DDKITSFL/chef-deploy
mkdir $DDKITSFL/chef-deploy/$WEBROOT
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/chef-deploy

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias >/dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_web /bin/bash'" >>~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/chef-deploy

cd $DDKITSFL
