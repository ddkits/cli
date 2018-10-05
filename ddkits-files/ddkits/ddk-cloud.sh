#!/bin/sh

#  Script.sh
#
# Cloud
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
if [[ -f "${DDKITSFL}/ddkits-files/cloud/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/cloud/Dockerfile
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[ -f "${DDKITSFL}/ddkits-files/cloud/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/cloud/sites/$DDKITSHOSTNAME.conf
fi
if [[ -f "${DDKITSFL}/ddkits-files/cloud/ddkits-check.sh" ]]; then
  rm $DDKITSFL/ddkits-files/cloud/ddkits-check.sh
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/cloud/sites" ]]; then 
  mkdir $DDKITSFL/ddkits-files/cloud/sites
  chmod -R 777 $DDKITSFL/ddkits-files/cloud/sites 
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
  <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /var/www/html/public
 SetEnv HTTP_HOME /var/www/html/public
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
' > $DDKITSFL/ddkits-files/cloud/sites/$DDKITSHOSTNAME.conf


echo -e '
#!/bin/sh

#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#

ocpath="/var/www/html/public"
htuser="www-data"
htgroup="www-data"
rootuser="www-data"

printf "Creating possible missing Directories\n"
mkdir -p $ocpath/data
mkdir -p $ocpath/assets

printf "chmod Files and Directories\n"
find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750
chmod -R 0770 /var/www/html/public/data

printf "chown Directories\n"
chown -R ${rootuser}:${htgroup} ${ocpath}/
chown -R ${htuser}:${htgroup} ${ocpath}/apps/
chown -R ${htuser}:${htgroup} ${ocpath}/config/
chown -R ${htuser}:${htgroup} ${ocpath}/data/
chown -R ${htuser}:${htgroup} ${ocpath}/themes/
chown -R ${htuser}:${htgroup} ${ocpath}/assets/

chmod +x ${ocpath}/occ

printf "chmod/chown .htaccess\n"
if [ -f ${ocpath}/.htaccess ]
 then
  chmod 0644 ${ocpath}/.htaccess
  chown ${rootuser}:${htgroup} ${ocpath}/.htaccess
fi
if [ -f ${ocpath}/data/.htaccess ]
 then
  chmod 0644 ${ocpath}/data/.htaccess
  chown ${rootuser}:${htgroup} ${ocpath}/data/.htaccess
fi' > $DDKITSFL/ddkits-files/cloud/ddkits-check.sh

echo -e '
FROM ddkits/lamp:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY get-pip.py /var/www/html/get-pip.py
COPY ddkits-check.sh /var/www/html/ddkits-check.sh
RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 
RUN chmod -R 777 /var/www/html 
RUN chmod u+x /var/www/html/ddkits-check.sh
RUN apt-get -f install -y 
RUN a2enmod headers \
  && a2enmod env \
  && a2enmod dir \
  && a2enmod mime \
  && service apache2 reload 

  # Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

  ' > $DDKITSFL/ddkits-files/cloud/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: $DDKITSFL/ddkits-files/cloud
    image: ddkits/cloud:latest
    
    volumes:
      - $DDKITSFL/cloud-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_cloud_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" 
      - "'$DDKITSWEBPORTSSL':443" ' >> $DDKITSFL/ddkits.env.yml

# Installing ownCloud9 on local host 

   
if [[ ! -d "cloud-deploy/public" ]]; then
  
  echo $DDKITSFL
mkdir $DDKITSFL/cloud-deploy
chmod -R 777 $DDKITSFL/cloud-deploy/public
cd $DDKITSFL/cloud-deploy
wget https://download.owncloud.org/community/owncloud-9.0.4.tar.bz2
wget https://download.owncloud.org/community/owncloud-9.0.4.tar.bz2.sha256
wget https://owncloud.org/owncloud.asc
wget https://download.owncloud.org/community/owncloud-9.0.4.tar.bz2.asc
sha256sum -c owncloud-9.0.4.tar.bz2.sha256
gpg --import owncloud.asc
gpg --verify owncloud-9.0.4.tar.bz2.asc
tar xjvf owncloud-9.0.4.tar.bz2 
cp -r owncloud public
rm -rf owncloud
cd $DDKITSFL
chmod -R 777 $DDKITSFL/cloud-deploy/public
fi

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_cloud_web /bin/bash'
alias ddkc-$DDKITSSITES-fix='docker exec -it ${DDKITSHOSTNAME}_ddkits_cloud_web /bin/bash /var/www/html/ddkits-check.sh'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_cloud_web /bin/bash'" >> ~/.ddkits_alias_web
echo "alias ddkc-"$DDKITSSITES"-fix='docker exec -it "$DDKITSHOSTNAME"_ddkits_cloud_web /bin/bash /var/www/html/ddkits-check.sh'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/cloud-deploy
echo $SUDOPASS | sudo -S chmod -R 0770 $DDKITSFL/cloud-deploy/public/data

cd $DDKITSFL