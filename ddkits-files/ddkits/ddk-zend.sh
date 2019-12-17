#!/bin/sh

#  Script.sh
#
# Zend
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
if [[ -f "${DDKITSFL}/ddkits-files/zend/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/zend/Dockerfile
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits-files/zend/composer.json" ]]; then
  rm $DDKITSFL/ddkits-files/zend/composer.json
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[ -f "${DDKITSFL}/ddkits-files/zend/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/zend/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/zend/sites" ]]; then
  mkdir $DDKITSFL/ddkits-files/zend/sites
  chmod -R 777 $DDKITSFL/ddkits-files/zend/sites
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

#  EE PHP 5

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
</VirtualHost>
' >$DDKITSFL/ddkits-files/zend/sites/$DDKITSHOSTNAME.conf

echo -e '

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf $DDKITSFL/logs /var/log/nginx/access.log \
    && ln -sf $DDKITSFL/logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/*
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
COPY $DDKITSFL/sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf


# Fixing permissions
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
' >>$DDKITSFL/ddkits-files/zend/Dockerfile

echo -e 'version: "3.1"

services:
  web:
    build: $DDKITSFL/ddkits-files/zend
    image: ddkits/zend:latest

    volumes:
      - $DDKITSFL/zend-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80"
      - "'$DDKITSWEBPORTSSL':443" ' >>$DDKITSFL/ddkits.env.yml

echo '
{
  "name": "elayyoub/DDKits",
  "description": "DDKits.com",
  "license": "proprietary",
    "authors": [
        {
            "name": "Mutasem Elayyoub",
            "email": "melayyoub@outlook.com"
        }
    ],
  "require": {
    "overtrue/phplint": "^0.2.1",
    "squizlabs/php_codesniffer": "2.*",
    "ext-xml": "*",
    "ext-json": "*",
    "ext-openssl": "*",
    "ext-curl": "*",
    "drush/drush": "~8.0",
    "phing/phing": "^2.16",
    "psy/psysh": "^0.8.5",
    "pear/http_request2": "^2.3"
  },
  "minimum-stability": "dev",
  "prefer-stable": true,
  "scripts": {
    "lint": [
      "${DDKITSFL}/vendor/bin/phplint",
      "${DDKITSFL}/vendor/bin/phpcs --config-set installed_paths $DDKITSFL/.$DDKITSFL/.$DDKITSFL/zend/coder/coder_sniffer",
      "${DDKITSFL}/vendor/bin/phpcs -n --report=full --standard=zend --ignore=*.tpl.php --extensions=install,module,php,inc"
    ],
    "test": [
      "${DDKITSFL}/vendor/bin/phplint --no-cache",
      "${DDKITSFL}/vendor/bin/phpcs --config-set installed_paths $DDKITSFL/.$DDKITSFL/.$DDKITSFL/zend/coder/coder_sniffer",
      "${DDKITSFL}/vendor/bin/phpcs -n --report=full --standard=zend --ignore=*.tpl.php --extensions=php,inc themes || true"
    ]
  }
}

' >>$DDKITSFL/ddkits-files/zend/composer.json

if [[ ! -d "zend-deploy/${WEBROOT}" ]]; then

  cp -R ddkits-files/zend/composer.json $DDKITSFL/
  cp composer.phar $DDKITSFL/ddkits.phar
  php ddkits.phar config --global discard-changes true
  php ddkits.phar require zendframework/zendframework && php ddkits.phar install -n
  php ddkits.phar create-project zendframework/skeleton-application zend-deploy/
  cd $DDKITSFL
  echo $SUDOPASS | sudo -S chmod -R 777 $WEBROOT $DDKITSFL/zend-deploy
  echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/zend-deploy/$WEBROOT
fi

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias >/dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_web /bin/bash'" >>~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/zend-deploy

cd $DDKITSFL
