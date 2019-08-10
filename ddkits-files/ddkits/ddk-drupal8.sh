#!/bin/sh

#  Script.sh
#
# Drupal 8
#
# This system built by Mutasem Elayyoub DDKits.com 
# check if the ddkitscli.sh exist and delete it if yes else create new one
if [ -f "${DDKITSFL}/ddkits-files/drupal/ddkitscli.sh" ]; then
    rm $DDKITSFL/ddkits-files/drupal/ddkitscli.sh
    echo "we deleted the old file and created another one"
else 
    echo "there is no old file we will create new file for you ==> "
fi
export DOCUMENTROOT=$WEBROOT
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits.env.yml" ]]; then
  rm $DDKITSFL/ddkits.env.yml
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkitsnew.yml" ]]; then
  rm $DDKITSFL/ddkitsnew.yml
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/drupal/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/drupal/Dockerfile
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[  -f "${DDKITSFL}/ddkits-files/drupal/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/drupal/sites/$DDKITSHOSTNAME.conf
fi
if [[ $DDKITSSITESALIAS != "" ]]; then
  DDKITSSERVERS='ServerAlias '$DDKITSSITESALIAS' '$DDKITSSITESALIAS2' '$DDKITSSITESALIAS3''
else
  DDKITSSERVERS=''
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/drupal/sites" ]]; then 
  mkdir $DDKITSFL/ddkits-files/drupal/sites
  chmod -R 777 $DDKITSFL/ddkits-files/drupal/sites 
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

echo -e "
#!/bin/sh

#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#

DDKITSSITES='"$DDKITSSITES"'\n
DDKITSIP='"$DDKITSIP"'\n
MYSQL_USER='"$MYSQL_USER"'\n
MYSQL_ROOT_PASSWORD='"$MYSQL_ROOT_PASSWORD"'\n
MYSQL_DATABASE='"$MYSQL_DATABASE"'\n
MYSQL_PASSWORD='"$MYSQL_PASSWORD"'\n
MAIL_ADDRESS='"$MAIL_ADDRESS"'\n" >> ./ddkits-files/drupal/ddkitscli.sh
cat ./ddkits-files/drupal/ddkits-drupal.sh >> ./ddkits-files/drupal/ddkitscli.sh

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
      Options Indexes FollowSymLinks
  AllowOverride All
  Require all granted
  RewriteEngine on
    RewriteBase /
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} !=/favicon.ico
    RewriteRule ^ index.php [L]
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
' > $DDKITSFL/ddkits-files/drupal/sites/$DDKITSHOSTNAME.conf

# Build out docker file to start our install
echo -e '

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
COPY ddkitscli.sh /var/www/html/ddkitscli.sh
COPY php7.ini /usr/local/etc/php/conf.d/php.ini

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf
RUN chmod -R 777 /var/www/html
RUN composer require drush/drush && composer outdated && composer update
RUN export PATH="$HOME/.composer/vendor/bin:$PATH"
RUN echo "export PATH="$HOME/.composer/vendor/bin:$PATH" ">> ~/.bashrc
RUN chmod -R 777 /var/www/html/ddkitscli.sh 
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B188E2B695BD4743
# RUN apt-get update && apt-get install -y libgmp-dev php7.2-gmp
# RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
# RUN docker-php-ext-install gmp
# RUN curl https://drupalconsole.com/installer -L -o drupal.phar
# RUN mv drupal.phar /usr/local/bin/drupal
# RUN chmod +x /usr/local/bin/drupal

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >> $DDKITSFL/ddkits-files/drupal/Dockerfile

#  create ddkits compose file for the new website
echo -e 'version: "3.1"

services:
  web:
    build: $DDKITSFL/ddkits-files/drupal
    image: ddkits/drupal8:latest
    volumes:
      # Mount the local drupal directory in the container
      - $DDKITSFL/deploy:/var/www/html
    
    stdin_open: true
    tty: true
    environment:
      - DDKITSHOSTNAME="'$DDKITSHOSTNAME'"
    container_name: '$DDKITSHOSTNAME'_ddkits_drupal_web
    networks:
      - ddkits      
    ports:
      - "'$DDKITSWEBPORT':80" 
      - "'$DDKITSWEBPORTSSL':443" ' >> $DDKITSFL/ddkits.env.yml
if [[ ! -d "deploy/${WEBROOT}" ]]; then
  git clone https://github.com/ddkits/drupal-8.git $DDKITSFL/deploy1
  cp -r $DDKITSFL/deploy1/ $DDKITSFL/deploy/
  rm -rf $DDKITSFL/deploy1
  echo $DDKITSFL
  mv $DDKITSFL/deploy/public $DDKITSFL/deploy/$WEBROOT
  chmod -R 777 $DDKITSFL/deploy/$WEBROOT
  mkdir $DDKITSFL/deploy/$WEBROOT/sites/default/files
  chmod -R 777 $DDKITSFL/deploy/$WEBROOT/sites/default
  rm -rf $DDKITSFL/deploy/$WEBROOT/vendor
  cp -f $DDKITSFL/deploy/$WEBROOT/sites/default/default.settings.php $DDKITSFL/deploy/$WEBROOT/sites/default/settings.php
  cp -f $DDKITSFL/deploy/$WEBROOT/sites/default/default.services.yml $DDKITSFL/deploy/$WEBROOT/sites/default/services.yml
  cp $DDKITSFL/deploy/composer.phar $DDKITSFL/deploy/$WEBROOT/ddkits.phar
  cd $DDKITSFL/deploy/$WEBROOT && php ddkits.phar self-update && php ddkits.phar config --global discard-changes true && php ddkits.phar update drupal/core --with-dependencies && php ddkits.phar update --lock && php ddkits.phar install -n
  cd $DDKITSFL
  else
      echo 'if you need a new drupal 8 installation please make sure to remove deploy/'$WEBROOT' folder and restart this step again.'
    
    echo $DDKITSFL
    rm -rf $DDKITSFL/deploy/$WEBROOT/vendor
    cd $DDKITSFL/deploy/$WEBROOT && php ddkits.phar self-update && php ddkits.phar config --global discard-changes true && php ddkits.phar update drupal/core --with-dependencies && php ddkits.phar update --lock && php ddkits.phar install -n
    cd $DDKITSFL
    chmod -R 777 $DDKITSFL/deploy/$WEBROOT/sites/default/files
    # chown $(echo "$USER") $DDKITSFL/deploy
  fi   

  # if [[ ! -d "deploy/drush" ]]; then
  #     wget "https://github.com/drush-ops/drush/archive/8.2.2.zip"
  #     unzip 8.2.2.zip
  #     rm 8.2.2.zip
  #     mv drush-8.2.2 drush
  #     cd drush
  #     composer install
  #     cd $DDKITSFL
  # fi     

  echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/deploy 

#  else
#   echo -e 'Not a valid version please try again.'
# fi

alias ddkd-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_drupal_web '$WEBROOT'/drush'

alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_drupal_web /bin/bash'

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_drupal_web /bin/bash'
alias ddkd-$DDKITSSITES='docker exec -i '$DDKITSHOSTNAME'_ddkits_drupal_web /bin/bash -c "cd '$WEBROOT' & drush "'

#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_drupal_web " >> ~/.ddkits_alias_web

echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/drupal-deploy

cd $DDKITSFL
