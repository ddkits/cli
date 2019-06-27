#!/bin/sh

#  Script.sh
#
# PHP7
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
if [[  -f "${DDKITSFL}/ddkits-files/git/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/git/Dockerfile
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[  -f "${DDKITSFL}/ddkits-files/git/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/git/sites/$DDKITSHOSTNAME.conf
fi
if [[  -f "${DDKITSFL}/ddkits-files/git/sites/gitlab.rb" ]]; then
  rm $DDKITSFL/ddkits-files/git/sites/gitlab.rb
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/git/sites" ]]; then 
  mkdir $DDKITSFL/ddkits-files/git/sites
  chmod -R 777 $DDKITSFL/ddkits-files/git/sites 
fi
#  LAMP PHP 7
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
     DocumentRoot /opt/gitlab/embedded/service/gitlab-rails/public
      ErrorLog /opt/gitlab/embedded/service/gitlab-rails/public/error.log
     CustomLog /opt/gitlab/embedded/service/gitlab-rails/public/access.log combined
    <Location "/">
      Require all granted
      AllowOverride All
      Order allow,deny
      allow from all
  </Location>
  <Directory "/opt/gitlab">
      Require all granted
      AllowOverride All
      Order allow,deny
      allow from all
  </Directory>
</VirtualHost> <VirtualHost *:443>
  ServerAdmin melayyoub@outlook.com
   ServerName '$DDKITSSITES'
   '$DDKITSSERVERS'
    DocumentRoot /opt/gitlab/embedded/service/gitlab-rails/public

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
' > $DDKITSFL/ddkits-files/git/sites/$DDKITSHOSTNAME.conf

cat $DDKITSFL/ddkits-files/git/sites/gitlab-example.rb > $DDKITSFL/ddkits-files/git/sites/gitlab.rb

echo -e "## GitLab URL
##! URL on which GitLab will be reachable.
##! For more details on configuring external_url see:
##! https://docs.gitlab.com/omnibus/settings/configuration.html#configuring-the-external-url-for-gitlab
external_url 'http://"$DDKITSSITES"'

# Give apache user privileges to listen to GitLab
web_server['external_users'] = ['www-data']

### GitLab database settings
###! Docs: https://docs.gitlab.com/omnibus/settings/database.html
###! **Only needed if you use an external database.**
 gitlab_rails['db_adapter'] = 'mysql'
 gitlab_rails['db_encoding'] = 'unicode'
# gitlab_rails['db_collation'] = nil
 gitlab_rails['db_database'] = '"$MYSQL_DATABASE"'
 gitlab_rails['db_pool'] = 10
 gitlab_rails['db_username'] = '"${MYSQL_USER}"'
 gitlab_rails['db_password'] = '"$MYSQL_ROOT_PASSWORD"'
 gitlab_rails['db_host'] = '"${DDKITSIP}"'
 gitlab_rails['db_port'] = "${DDKITSDBPORT}"
# gitlab_rails['db_socket'] = nil
# gitlab_rails['db_sslmode'] = nil
# gitlab_rails['db_sslrootcert'] = nil
# gitlab_rails['db_prepared_statements'] = false
# gitlab_rails['db_statements_limit'] = 1000
#### Redis TCP connection
gitlab_rails['redis_host'] = '"${DDKITSIP}"'
gitlab_rails['redis_port'] = "${DDKITSREDISPORT}"
# gitlab_rails['redis_password'] = nil
# gitlab_rails['redis_database'] = 0

" >> $DDKITSFL/ddkits-files/git/sites/gitlab.rb


echo -e '
FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf $DDKITSFL/logs /var/log/nginx/access.log \
    && ln -sf $DDKITSFL/logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf 

COPY ./sites/gitlab.rb /var/www/html/gitlab.rb
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
COPY ./sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf 

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
 
' > $DDKITSFL/ddkits-files/git/Dockerfile


echo -e '
apt-get install -y curl openssh-server ca-certificates --force-yes -y
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
apt-get install gitlab-ce -y
cp /var/www/html/gitlab.rb /etc/gitlab/gitlab.rb
chown -R www-data:www-data /opt/gitlab
chown -R www-data:www-data /etc/gitlab
usermod -u 1000 www-data
apt-get install -y postfix
systemctl restart gitlab-runsvdir \
  && systemctl start sshd postfix \
  && systemctl enable sshd postfix \
  && iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT \
  && /etc/init.d/iptables save \
  && gitlab-ctl reconfigure ' > $DDKITSFL/git-deploy/ddkits.fix.sh

echo -e 'version: "3.1"

services:
  web:
    build: '${DDKITSFL}'/ddkits-files/git
    image: ddkits/git:latest
    
    volumes:
      - '${DDKITSFL}'/git-deploy:/opt/gitlab
    stdin_open: true
    tty: true
    container_name: '${DDKITSHOSTNAME}'_ddkits_git_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" 
      - "'$DDKITSWEBPORTSSL':443" 

      ' >> $DDKITSFL/ddkits.env.yml

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_git_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_git_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/git-deploy

cd $DDKITSFL