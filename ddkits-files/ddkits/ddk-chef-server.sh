#!/bin/sh

#  Script.sh
#
# Chef Server
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
if [[ -f "${DDKITSFL}/ddkits-files/chefserver/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/chefserver/Dockerfile
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[ -f "${DDKITSFL}/ddkits-files/chefserver/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/chefserver/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/chefserver/sites" ]]; then
  mkdir $DDKITSFL/ddkits-files/chefserver/sites
  chmod -R 777 $DDKITSFL/ddkits-files/chefserver/sites
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
FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/*
COPY sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini
# Chef server starts from here
VOLUME /var/opt/opscode

COPY install.sh /tmp/install.sh

RUN [ "/bin/sh", "/tmp/install.sh" ]

COPY init.rb /init.rb
COPY chef-server.rb /.chef/chef-server.rb
COPY logrotate /opt/opscode/sv/logrotate
COPY knife.rb /etc/chef/knife.rb
COPY backup.sh /usr/local/bin/chef-server-backup

ENV KNIFE_HOME /etc/chef

CMD [ "/opt/opscode/embedded/bin/ruby", "/init.rb" ]
RUN chmod 600 /etc/mysql/my.cnf
RUN chmod -R +rwx /var/opt/opscode 

# # Fixing permissions
RUN chown -R www-data:www-data /var/opt/opscode 
RUN usermod -u 1000 www-data


# Fixing permissions
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
  ' >$DDKITSFL/ddkits-files/chefserver/Dockerfile

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
' >$DDKITSFL/ddkits-files/chefserver/sites/$DDKITSHOSTNAME.conf

echo -e 'version: "3.1"

services:
  web:
    build: $DDKITSFL/ddkits-files/chefserver
    image: ddkits/chefserver:latest

    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_web
    volumes:
      - $DDKITSFL/chef-server-deploy:/var/www/html
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80"
      - "'$DDKITSWEBPORTSSL':443"
    environment:
       chefserver_DB_HOST: '$DDKITSIP':'$DDKITSDBPORT'
       chefserver_DB_USER: '$MYSQL_USER'
       chefserver_DB_PASSWORD: '$MYSQL_ROOT_PASSWORD' ' >>$DDKITSFL/ddkits.env.yml

# check if wget command exist

mkdir $DDKITSFL/chef-server-deploy
mkdir $DDKITSFL/chef-server-deploy/$WEBROOT
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/chef-server-deploy

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias >/dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_web /bin/bash'" >>~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/chef-server-deploy

cd $DDKITSFL
