#!/bin/sh

#  Script.sh
#
# Contao
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
if [[  -f "${DDKITSFL}/ddkits-files/contao/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/contao/Dockerfile
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[  -f "${DDKITSFL}/ddkits-files/contao/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/contao/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/contao/sites" ]]; then 
  mkdir $DDKITSFL/ddkits-files/contao/sites
  chmod -R 777 $DDKITSFL/ddkits-files/contao/sites 
fi
#  EE PHP 5

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
</VirtualHost> ' > $DDKITSFL/ddkits-files/contao/sites/$DDKITSHOSTNAME.conf

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
  ' >> $DDKITSFL/ddkits-files/contao/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: $DDKITSFL/ddkits-files/contao
    image: ddkits/contao:latest
    
    volumes:
      - $DDKITSFL/contao-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: ${DDKITSHOSTNAME}_ddkits_contao_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> $DDKITSFL/ddkits.env.yml

if [[ ! -d "contao-deploy/public" ]]; then
  
  echo $DDKITSFL
  cp $DDKITSFL/composer.phar $DDKITSFL/contao-deploy/public/ddkits.phar
  git clone https://github.com/ddkits/contao contao-deploy
  echo $SUDOPASS | sudo -S chmod -R 777 public $DDKITSFL/contao-deploy
  cd $DDKITSFL/contao-deploy
  cd public && php ddkits.phar config --global discard-changes true && php ddkits.phar install -n
  cd $DDKITSFL
  echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/contao-deploy/public
fi

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_contao_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_contao_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/contao-deploy

cd $DDKITSFL