#!/bin/sh

#  Script.sh
#
#Drupal 7
#
# This system built by Mutasem Elayyoub DDKits.com
# check if the ddkitscli.sh exist and delete it if yes else create new one
if [ -f "${DDKITSFL}/ddkits-files/drupal/ddkitscli.sh" ]; then
    rm $DDKITSFL/ddkits-files/drupal/ddkitscli.sh
    echo "we deleted the old file and created another one"
else 
    echo "there is no old file we will create new file for you ==> "
fi
export DOCUMENTROOT="public"
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
' > $DDKITSFL/ddkits-files/drupal/sites/$DDKITSHOSTNAME.conf

# Build out docker file to start our install
echo -e 'FROM ddkits/lamp:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
COPY ddkitscli.sh /var/www/html/ddkitscli.sh
COPY php5.ini /usr/local/etc/php/conf.d/php.ini

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 

RUN chmod -R 777 /var/www/html/ddkitscli.sh 

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >> $DDKITSFL/ddkits-files/drupal/Dockerfile

#  create ddkits compose file for the new website
echo -e 'version: "2"

services:
  web:
    build: $DDKITSFL/ddkits-files/drupal
    image: ddkits/drupal7:latest
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
if [[ ! -d "deploy/public" ]]; then
  git clone https://github.com/ddkits/drupal-7.git $DDKITSFL/deploy
  
  cp -R deploy/deploy/* deploy
  rm -rf deploy/deploy
  echo $DDKITSFL
  chmod -R 755 $DDKITSFL/deploy/public
  mkdir $DDKITSFL/deploy/public/sites/default/files
  chmod -R 777 $DDKITSFL/deploy/public/sites/default/files
elif [[ -d "deploy/public" ]]; then
  echo 'if you need a new drupal7 installation please make sure to remove deploy/public folder and restart this step again.'
fi  
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/deploy   



alias ddkd-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_drupal_web public/drush '

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_drupal_web /bin/bash'
alias ddkd-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_drupal_web /bin/bash -c "cd public && drush"'

#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_drupal_web /bin/bash'" >> ~/.ddkits_alias_web
# echo "alias ddkd-"$DDKITSSITES"='docker exec -it "$DDKITSHOSTNAME"_ddkits_drupal_web /bin/bash -c 'cd public && drush''" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/drupal-deploy

ln -sfn $DDKITSFL/deploy/sites $DDKITSFL/deploy/public/sites/default

cd $DDKITSFL