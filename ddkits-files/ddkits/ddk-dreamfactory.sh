#!/bin/sh

#  Script.sh
#
# DreamFactory
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
if [[  -f "${DDKITSFL}/ddkits-files/dreamf/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/dreamf/Dockerfile
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[  -f "${DDKITSFL}/ddkits-files/dreamf/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/dreamf/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/dreamf/sites" ]]; then 
  mkdir $DDKITSFL/ddkits-files/dreamf/sites
  chmod -R 777 $DDKITSFL/ddkits-files/dreamf/sites 
fi
#  DreamFactory setup 
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
</VirtualHost>
' > $DDKITSFL/ddkits-files/dreamf/sites/$DDKITSHOSTNAME.conf

echo -e '

#  Created by mutasem elayyoub ddkits.co#  Created by mutasem elayyoub ddkits.co

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf $DDKITSFL/logs /var/log/nginx/access.log \
    && ln -sf $DDKITSFL/logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf  
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
COPY $DDKITSFL/sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf 

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >> $DDKITSFL/ddkits-files/dreamf/Dockerfile

# echo -e '
# #!/bin/sh

# #  Script.sh
# #
# #
# #  Created by mutasem elayyoub ddkits.com
# #

# composer install --no-dev
# chmod -R 777 /var/www/html/storage /var/www/html/vendor /var/www/html/public
# php artisan cache:clear
# php artisan key:generate
# php artisan cache:clear
# php artisan config:clear
# chmod -R 777 storage
#  ' > $DDKITSFL/ll-deploy/ddkits.fix.sh

echo -e 'version: "3.1"

services:
  web:
    build: $DDKITSFL/ddkits-files/dreamf
    image: ddkits/dreamf:latest
    
    volumes:
      - $DDKITSFL/dreamf-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_dreamf_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" 
      - "'$DDKITSWEBPORTSSL':443" ' >> $DDKITSFL/ddkits.env.yml

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_dreamf_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_dreamf_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/dreamf-deploy


if [[ ! -d "dreamf-deploy" ]]; then
  git clone https://github.com/dreamfactorysoftware/dreamfactory.git $DDKITSFL/dreamf-deploy
  
  echo $DDKITSFL
  cp $DDKITSFL/composer.phar $DDKITSFL/dreamf-deploy/public/ddkits.phar && echo $SUDOPASS | sudo -S chmod 777 $DDKITSFL/dreamf-deploy/public/ddkits.phar
  cd $DDKITSFL/dreamf-deploy/public && php ddkits.phar config --global discard-changes true &&  php ddkits.phar install --no-dev -n
  php artisan df:setup
  echo $SUDOPASS | sudo -S chmod -R 2775 storage/ bootstrap/cache/
  cd $DDKITSFL
# create database variables for dreamfactory
  rm -rf $DDKITSFL/dreamf-deploy/.env
  cat $DDKITSFL/ddkits-files/dreamf/env >> $DDKITSFL/dreamf-deploy/.env
  chmod -R 777 $DDKITSFL/dreamf-deploy/storage/ $DDKITSFL/dreamf-deploy/public/ $DDKITSFL/dreamf-deploy/public/ bootstrap/cache/
else
  
  echo $DDKITSFL
  cp $DDKITSFL/composer.phar $DDKITSFL/dreamf-deploy/public/ddkits.phar && echo $SUDOPASS | sudo -S chmod 777 $DDKITSFL/dreamf-deploy/public/ddkits.phar
  cd $DDKITSFL/dreamf-deploy/public && php ddkits.phar config --global discard-changes true &&  php ddkits.phar install --no-dev -n
  cd $DDKITSFL
fi     
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/dreamf-deploy


cd $DDKITSFL