#!/bin/sh

#  Script.sh
#
# Silverstripe
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
if [[  -f "${DDKITSFL}/ddkits-files/ss/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/ss/Dockerfile
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[  -f "${DDKITSFL}/ddkits-files/ss/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/ss/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/ss/sites" ]]; then 
  mkdir $DDKITSFL/ddkits-files/ss/sites
  chmod -R 777 $DDKITSFL/ddkits-files/ss/sites 
fi

#  DreamFactory setup 

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
</VirtualHost> ' > $DDKITSFL/ddkits-files/ss/sites/$DDKITSHOSTNAME.conf

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
COPY $DDKITSFL/sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf 


# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
' >> $DDKITSFL/ddkits-files/ss/Dockerfile


echo -e 'version: "2"

services:
  web:
    build: $DDKITSFL/ddkits-files/ss
    image: ddkits/ss:latest
    
    volumes:
      - $DDKITSFL/ss-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: ${DDKITSHOSTNAME}_ddkits_ss_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' > $DDKITSFL/ddkits.env.yml

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_ss_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_ss_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/ss-deploy

if [[ ! -d "ss-deploy/public" ]]; then
  
  echo $DDKITSFL
mkdir $DDKITSFL/ss-deploy
mkdir $DDKITSFL/ss-deploy/public
cd $DDKITSFL/ss-deploy/public
wget https://silverstripe-ssorg-releases.s3.amazonaws.com/sssites-ssorg-prod/assets/releases/SilverStripe-cms-v3.6.1.tar.gz
tar -xvzf SilverStripe-cms-v3.6.1.tar.gz 
rm -rf SilverStripe-cms-v3.6.1.tar.gz
cd $DDKITSFL
cp $DDKITSFL/composer.phar $DDKITSFL/ss-deploy/public/ddkits.phar && echo $SUDOPASS | sudo -S chmod 777 $DDKITSFL/ss-deploy/public/ddkits.phar
fi

cd $DDKITSFL