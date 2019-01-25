#!/bin/sh

#  Script.sh
#
# Laravel
#
# This system built by Mutasem Elayyoub DDKits.com 

export DOCUMENTROOT=$DDKITSHOSTNAME
# create different containers files for conf
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits.env.yml" ]]; then
  rm $DDKITSFL/ddkits.env.yml
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkitsnew.yml" ]]; then
  rm $DDKITSFL/ddkitsnew.yml
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/Laravel/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/Laravel/Dockerfile
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[  -f "${DDKITSFL}/ddkits-files/Laravel/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/Laravel/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/laravel/sites" ]]; then 
  mkdir $DDKITSFL/ddkits-files/laravel/sites
  chmod -R 777 $DDKITSFL/ddkits-files/laravel/sites 
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
</VirtualHost>' > $DDKITSFL/ddkits-files/Laravel/sites/$DDKITSHOSTNAME.conf

echo -e '

#  Script.s#  Script.s

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf $DDKITSFL/logs /var/log/nginx/access.log \
    && ln -sf $DDKITSFL/logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && rm /etc/apache2/sites-enabled/000-default.conf 
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
COPY $DDKITSFL/sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

 ' >> $DDKITSFL/ddkits-files/Laravel/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: $DDKITSFL/ddkits-files/Laravel
    image: ddkits/laravel:latest
    
    volumes:
      - $DDKITSFL/ll-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_laravel_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" 
      - "'$DDKITSWEBPORTSSL':443" ' >> $DDKITSFL/ddkits.env.yml

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_laravel_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_laravel_web /bin/bash'" >> ~/.ddkits_alias_web


if [[ ! -f "composer.phar" ]]; then
  wget https://getcomposer.org/composer.phar
fi

echo $SUDOPASS | sudo -S chmod 777 composer.phar

echo -e 'Now installing Laravel through composer '
php composer.phar create-project laravel/laravel ll-deploy "5.7.*" --prefer-dist
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/ll-deploy

if [[ -f "ll-deploy/storage/logs/laravel.logs" ]]; then
 rm -rf $DDKITSFL/ll-deploy/storage/logs/laravel.logs
fi

if [[ -d "ll-deploy" ]]; then
  cd ll-deploy
  php artisan cache:clear
cat "${DDKITSFL}/ddkits-files/ddkits/logo.txt"
  php artisan config:cache
  cd ..
  echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/ll-deploy
  echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/ll-deploy/storage
fi

if [[ -f "ll-deploy/.env" ]]; then
  rm $DDKITSFL/ll-deploy/.env
fi

echo -e 'APP_NAME="DDKits Laravel"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_LOG_LEVEL=debug
APP_URL=http://'$DDKITSSITES'

DB_CONNECTION=mysql
DB_HOST='$DDKITSIP'
DB_PORT='$DDKITSDBPORT'
DB_DATABASE='$MYSQL_DATABASE'
DB_USERNAME='$MYSQL_USER'
DB_PASSWORD='$MYSQL_ROOT_PASSWORD'

BROADCAST_DRIVER=log
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_DRIVER=sync

REDIS_HOST='$DDKITSIP'
REDIS_PASSWORD=null
REDIS_PORT='$DDKITSREDISPORT'

MAIL_DRIVER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
' >> $DDKITSFL/ll-deploy/.env

echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/ll-deploy
alias ddkf-$DDKITSSITES="docker exec -d "$DDKITSHOSTNAME"_ddkits_laravel_web /bin/bash ddkits.fix.sh"
#  fixed the alias for machine
echo "alias ddkf-"$DDKITSSITES"='docker exec -d "$DDKITSHOSTNAME"_ddkits_laravel_web /bin/bash ddkits.fix.sh'" >> ~/.ddkits_alias_web

echo -e '
#!/bin/sh

#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#

php artisan cache:clear
php artisan key:generate
php artisan make:auth -n
php artisan migrate
php artisan config:clear
php artisan cache:clear
php artisan db:seed
chmod -R 777 storage
 ' > $DDKITSFL/ll-deploy/ddkits.fix.sh
 
cd $DDKITSFL
