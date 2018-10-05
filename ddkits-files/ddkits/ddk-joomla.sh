#!/bin/sh

#  Script.sh
#
# Joomla
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
if [[  -f "${DDKITSFL}/ddkits-files/joomla/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/joomla/Dockerfile
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[  -f "${DDKITSFL}/ddkits-files/joomla/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/joomla/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/joomla/sites" ]]; then 
  mkdir $DDKITSFL/ddkits-files/joomla/sites
  chmod -R 777 $DDKITSFL/ddkits-files/joomla/sites 
fi
DOCUMENTROOT='public'
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
          
# Build out docker file to start our install
echo -e '
FROM ddkits/lamp:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 
  
RUN chmod -R 777 /var/www/html 


# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
  ' >> $DDKITSFL/ddkits-files/joomla/Dockerfile


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
</VirtualHost> <VirtualHost *:443>
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
' > $DDKITSFL/ddkits-files/joomla/sites/$DDKITSHOSTNAME.conf

echo -e 'version: "2"

services:
  web:
    build: $DDKITSFL/ddkits-files/joomla
    image: ddkits/joomla:latest
    
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_jom_web
    volumes:
      - $DDKITSFL/jom-deploy:/var/www/html
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" 
      - "'$DDKITSWEBPORTSSL':443"
    environment:
       JOOMLA_DB_HOST: '$DDKITSIP':'$DDKITSDBPORT'
       JOOMLA_DB_USER: '$MYSQL_USER'
       JOOMLA_DB_PASSWORD: '$MYSQL_ROOT_PASSWORD' ' >> $DDKITSFL/ddkits.env.yml  

mkdir $DDKITSFL/jom-deploy
mkdir $DDKITSFL/jom-deploy/public
git clone https://github.com/ddkits/Joomla.git $DDKITSFL/jom-deploy/public

echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/jom-deploy  

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_jom_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_jom_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/jom-deploy

cd $DDKITSFL