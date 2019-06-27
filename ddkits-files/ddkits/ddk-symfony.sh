#!/bin/sh

#  Script.sh
#
# Symfony
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
if [[  -f "${DDKITSFL}/ddkits-files/symfony/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/symfony/Dockerfile
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[  -f "${DDKITSFL}/ddkits-files/symfony/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/symfony/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/symfony/sites" ]]; then 
  mkdir $DDKITSFL/ddkits-files/symfony/sites
  chmod -R 777 $DDKITSFL/ddkits-files/symfony/sites 
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

#  Symfony setup

echo -e '
<VirtualHost *:80>
     ServerAdmin melayyoub@outlook.com
     ServerName '$DDKITSSITES'
     '$DDKITSSERVERS'
     DocumentRoot /var/www/html/public/web
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
    DocumentRoot /var/www/html/public/web

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
' > $DDKITSFL/ddkits-files/symfony/sites/$DDKITSHOSTNAME.conf

echo -e '
FROM ddkits/lamp:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf 
RUN apt-get update \
  && apt-get install build-essential apt-transport-https  -y --force-yes\
  && echo deb http://get.docker.io/ubuntu docker main\ > /etc/apt/sources.list.d/docker.list \
  && apt-get update \
  && apt-get install -y --force-yes nano \
                   wget \
                   dialog \
                   net-tools \
                   lxc-docker \
                   ufw \
                   sudo \
                   gufw \
                   python-software-properties \
                   software-properties-common \
    && apt-get install -y --force-yes apt-transport-https 

# installing Symfony on server 
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony \
  && chmod a+x /usr/local/bin/symfony


# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
  ' >> $DDKITSFL/ddkits-files/symfony/Dockerfile

echo -e 'version: "3.1"

services:
  web:
    build: $DDKITSFL/ddkits-files/symfony
    image: ddkits/symfony:latest
    
    volumes:
      - $DDKITSFL/symfony-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_symfony_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" 
      - "'$DDKITSWEBPORTSSL':443" ' >> $DDKITSFL/ddkits.env.yml



if [[ ! -d "symfony-deploy/public" ]]; then
  
  echo $DDKITSFL
  echo $SUDOPASS | sudo -S curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
  echo $SUDOPASS | sudo -S chmod a+x /usr/local/bin/symfony
  mkdir symfony-deploy
  echo $SUDOPASS | sudo -S chmod -R 777 public $DDKITSFL/symfony-deploy
  symfony new symfony-deploy/public
  cp $DDKITSFL/composer.phar $DDKITSFL/symfony-deploy/public/ddkits.phar
  cd $DDKITSFL/symfony-deploy
  cd public && php ddkits.phar config --global discard-changes true && php ddkits.phar install -n
  cd $DDKITSFL
  echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/symfony-deploy/public
fi


# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_symfony_web /bin/bash'
alias ddkc-$DDKITSSITES-run='docker exec -it ${DDKITSHOSTNAME}_ddkits_symfony_web /bin/bash php public/bin/console server:run 127.0.0.1:8000'

#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_symfony_web /bin/bash'" >> ~/.ddkits_alias_web
echo "alias ddkc-"$DDKITSSITES"-run='docker exec -it "$DDKITSHOSTNAME"_ddkits_symfony_web /bin/bash php public/bin/console server:run 127.0.0.1:8000'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/symfony-deploy

cd $DDKITSFL
