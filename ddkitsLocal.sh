#!/bin/sh"

# This system built by Mutasem Elayyoub DDKits.com
# insert DDKits alias into anyh system command lines
. ddkits.alias.sh

#  built by  by Mutasem Elayyoub DDKits.com"
# docker-machine create --driver virtualbox ddkits
# docker-machine start ddkits
# eval $(docker-machine env ddkits)
echo -e 'Please make sure that you installed your DDKits at the same environment \n(1) Localhost \n(2) virtualbox'
          read DDKITSVER
    if [[ $DDKITSVER == 1 ]]; then
  DDKITSIP='127.0.0.1'
    else
  DDKITSIP=$(docker-machine ip ddkits)
  ddk go
fi
  


#  delete ddkits conf file for the custom site if available
if [ -f "ddkits-files/ddkits/sites/ddkitscust.conf" ]
  then 
  rm ddkits-files/ddkits/sites/ddkitscust.conf
fi
# check if the ddkitscli.sh exist and delete it if yes else create new one
if [ -f "ddkits-files/drupal/ddkitscli.sh" ]; then
    rm ./ddkits-files/drupal/ddkitscli.sh
    echo "we deleted the old file and created another one"
else 
    echo "there is no old file we will create new file for you ==> "
fi


echo -e "DDKits required field are all required please make sure to write them correct. \n
Your DDKits IP is : '$DDKITSIP'\n
in case of using your localhost then please ignore this ip and use your localhost ip (127.0.0.1)\n
to cancel anytime use the regular system command ==> ctrl+c
"
  clear
  echo -e "Enter your E-mail address that you want to use in your website as an admin: "
read MAIL_ADDRESS 
clear
  echo -e ' Ports info **IMPORTANT** 
  '
  DDKITSWEBPORT="$(awk -v min=1000 -v max=1500 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
  echo -e "  Your new Web port is  ${DDKITSWEBPORT}  "
  DDKITSDBPORT="$(awk -v min=1501 -v max=2000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
  echo -e "Your new DB port is  ${DDKITSDBPORT}  "
  DDKITSJENKINSPORT="$(awk -v min=4040 -v max=4140 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
  echo -e "Your new Jenkins port is  ${DDKITSJENKINSPORT} "
  DDKITSSOLRPORT="$(awk -v min=3001 -v max=4000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
  echo -e "Your new Solr port is  ${DDKITSSOLRPORT} "
  DDKITSADMINPORT="$(awk -v min=4101 -v max=5000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
  echo -e "Your new PhpMyAdmin port is  ${DDKITSADMINPORT} "
  DDKITSREDISPORT="$(awk -v min=5001 -v max=6000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
  echo -e "Your new Radis port is  ${DDKITSREDISPORT} "
  echo -e ""
  echo -e 'Enter your Domain Name:  '
read DDKITSSITES
  echo -e ""
  echo -e ' domain alias (ex. www.ddkits.site) if there is no alias just leave this blank '
read DDKITSSITESALIAS
  if [[ "$DDKITSSITESALIAS" == "" ]]
    then
    DDKITSSITESALIAS=""
    DDKITSSITESALIAS2=""
    DDKITSSITESALIAS3=""
    #  create ddkits conf file for the custom site
    echo -e "NameVirtualHost *:80

    <VirtualHost *:80>
      ServerName "$DDKITSSITES"
      ProxyPreserveHost on
      ProxyPass / http://"$DDKITSIP":"$DDKITSWEBPORT"/
      ProxyPassReverse / http://"$DDKITSIP":"$DDKITSWEBPORT"/
    </VirtualHost>

<VirtualHost *:80>
  ServerName solr."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
</VirtualHost>

<VirtualHost *:80>
  ServerName jenkins."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
</VirtualHost>

<VirtualHost *:80>
  ServerName admin."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSADMINPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSADMINPORT"/
</VirtualHost>

    " >> ddkits-files/ddkits/sites/ddkitscust.conf
  else
  echo -e ""
  echo -e ' domain alias 2 (ex. www.ddkits.site) if there is no alias just leave this blank'
    read DDKITSSITESALIAS2
      if [[ "$DDKITSSITESALIAS2" == "" ]]
        then
        DDKITSSITESALIAS2=""
        DDKITSSITESALIAS3=""
        #  create ddkits conf file for the custom site

        echo -e "NameVirtualHost *:80

        <VirtualHost *:80>
          ServerName "$DDKITSSITES"
          ServerAlias "$DDKITSSITESALIAS"
          ProxyPreserveHost on
          ProxyPass / http://"$DDKITSIP":"$DDKITSWEBPORT"/
          ProxyPassReverse / http://"$DDKITSIP":"$DDKITSWEBPORT"/
        </VirtualHost>

<VirtualHost *:80>
  ServerName solr."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
</VirtualHost>

<VirtualHost *:80>
  ServerName jenkins."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
</VirtualHost>

<VirtualHost *:80>
  ServerName admin."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSADMINPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSADMINPORT"/
</VirtualHost>

        " >> ddkits-files/ddkits/sites/ddkitscust.conf
      else
      echo -e ""
      echo -e ' domain alias 3 (ex. www.ddkits.site) if there is no alias just leave this blank'
        read DDKITSSITESALIAS3
      if [[ "$DDKITSSITESALIAS3" == "" ]]
        then
          DDKITSSITESALIAS3=""
          #  create ddkits conf file for the custom site
          echo -e "NameVirtualHost *:80

          <VirtualHost *:80>
            ServerName "$DDKITSSITES"
            ProxyPreserveHost on
            ProxyPass / http://"$DDKITSIP":"$DDKITSWEBPORT"/
            ProxyPassReverse / http://"$DDKITSIP":"$DDKITSWEBPORT"/
          </VirtualHost>

          <VirtualHost *:80>
            ServerName "$DDKITSSITESALIAS"
            ProxyPreserveHost on
            ProxyPass / http://"$DDKITSIP":"$DDKITSWEBPORT"/
            ProxyPassReverse / http://"$DDKITSIP":"$DDKITSWEBPORT"/
          </VirtualHost>

          <VirtualHost *:80>
            ServerName "$DDKITSSITESALIAS2"
            ProxyPreserveHost on
            ProxyPass / http://"$DDKITSIP":"$DDKITSWEBPORT"/
            ProxyPassReverse / http://"$DDKITSIP":"$DDKITSWEBPORT"/
          </VirtualHost>

<VirtualHost *:80>
  ServerName solr."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
</VirtualHost>

<VirtualHost *:80>
  ServerName jenkins."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
</VirtualHost>

<VirtualHost *:80>
  ServerName admin."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSADMINPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSADMINPORT"/
</VirtualHost>

          " >> ddkits-files/ddkits/sites/ddkitscust.conf
      fi
    fi
  fi
  echo -e ""
  echo -e 'Enter your Sudo Password:  '
  
read SUDOPASS
  echo -e ""
  echo -e 'Enter your MYSQL ROOT USER:  '
  
read MYSQL_USER
  echo -e ""
  echo -e 'Enter your MYSQL ROOT USER Password:  '
  
read MYSQL_ROOT_PASSWORD
  echo -e ""
  echo -e 'Enter your MYSQL DataBase:  '
  
read MYSQL_DATABASE
  
if [[ "$OSTYPE" == "linux-gnu" ]]; then
          PLATFORM='linux-gnu'
          echo 'This machine is '$PLATFORM' Docker setup will start now'
          echo $SUDOPASS | sudo -S apt-get install wget git -y
        elif [[ "$OSTYPE" == "darwin"* ]]; then
          PLATFORM='MacOS'
          echo 'This machine is '$PLATFORM' Docker setup will start now'
          echo $SUDOPASS | sudo -S gem install wget git -y
        elif [[ "$OSTYPE" == "cygwin" ]]; then
          PLATFORM='cygwin'
          echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE "WGET" INSTALLED ON YOUR SYSTEM' 
        elif [[ "$OSTYPE" == "msys" ]]; then
           PLATFORM='msys'
          echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE "WGET" INSTALLED ON YOUR SYSTEM'        
        elif [[ "$OSTYPE" == "win32" ]]; then
            PLATFORM='win32'
          echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE "WGET" INSTALLED ON YOUR SYSTEM'         
        elif [[ "$OSTYPE" == "freebsd"* ]]; then
           PLATFORM='freebsd'
          echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE "WGET" INSTALLED ON YOUR SYSTEM'        
        else
          break
fi
# make user the main owner of the files
# echo $SUDOPASS | sudo -S chown $(echo "$USER") ./
echo $SUDOPASS | sudo -S chmod -R 777 ./
clear
  echo -e "'Do you have docker, docker compose and machine installed properly on your machine? (if you said No DDKits will install all the required to fully function)'"
DDKITS_DOCKER='Do you have docker'
options=("Yes" "No" "Quit")
select opt in "${options[@]}"
do
    case $opt in
      "Yes")
        echo 'This machine is '$PLATFORM' No need to install Docker then :-)'
        break
        ;;
      "No")
        echo 'This machine is '$PLATFORM' Docker setup will start now'
        if [[ $PLATFORM == 'linux-gnu' ]]; then
          curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
          curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
          chmod +x /tmp/docker-machine &&
          echo $SUDOPASS | sudo -S cp /tmp/docker-machine /usr/local/bin/docker-machine
          echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-compose
        elif [[ $PLATFORM == 'MacOS' ]]; then
          curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
          curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
          echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-machine
          echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-compose
        elif [[ $PLATFORM == 'linux-gnu' ]]; then
          echo 'This machine is '$PLATFORM' Docker setup will start now'
        elif [[ $PLATFORM == 'cygwin' ]]; then
          echo 'This machine is '$PLATFORM' Docker setup will start now'
        elif [[ $PLATFORM == 'msys' ]]; then
         echo 'This machine is '$PLATFORM' Docker setup will start now'
        elif [[ $PLATFORM == 'win32' ]]; then
          if [[ ! -d "$HOME/bin" ]]; then mkdir -p "$HOME/bin"; fi && \
            curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
            curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" && \
            chmod +x "$HOME/bin/docker-machine.exe"
        else
          echo 'Unknown system please download and install docker from https://docker.com/'
          break
        fi
        break
        ;;
      "Quit")
        break
        ;;
        *) echo invalid option;;
    esac
done


# echo -e "Enter your E-mail address that you want to use in your website as an admin: "
#   
# read MAIL_ADDRESS 
#   echo -e ""
DDKITSHOSTNAME=${DDKITSSITES//./_}
echo -e "DDKITSSITES='"$DDKITSSITES"'\n
DDKITSIP='"$DDKITSIP"'\n
MYSQL_USER='"$MYSQL_USER"'\n
MYSQL_ROOT_PASSWORD='"$MYSQL_ROOT_PASSWORD"'\n
MYSQL_DATABASE='"$MYSQL_DATABASE"'\n
MYSQL_PASSWORD='"$MYSQL_PASSWORD"'\n
MAIL_ADDRESS='"$MAIL_ADDRESS"'\n" >> ./ddkits-files/drupal/ddkitscli.sh
cat ./ddkits-files/drupal/ddkits-drupal.sh >> ./ddkits-files/drupal/ddkitscli.sh
DDKITS_PLATFORM='Please pick which platform you want to install: '
# 
# Setup options Please make sure of all options before publish
# 
options=("Drupal" "Wordpress" "Joomla" "Laravel" "LAMP/PHP5" "LAMP/PHP7" "Umbraco" "Magento" "DreamFactory" "Contao" "Silverstripe" "Cloud" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        # case of drupal
        "Drupal")

  echo -e ""
  echo -e 'What Drupal Version you want to start with: 7 or 8 ?'
read DDKITSDRUPALV

if [[ $DDKITSDRUPALV == '7' ]]; then
  DOCUMENTROOT="public"
# delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/drupal/Dockerfile" ]]; then
          rm ddkits-files/drupal/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/drupal/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/drupal/sites/$DDKITSHOSTNAME.conf
        fi
if [[ $DDKITSSITESALIAS != "" ]]; then
  DDKITSSERVERS='ServerAlias '$DDKITSSITESALIAS' '$DDKITSSITESALIAS2' '$DDKITSSITESALIAS3''
else
  DDKITSSERVERS=''
fi



# create different containers files for conf
echo -e '
NameVirtualHost *:80

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
</VirtualHost> ' > ./ddkits-files/drupal/sites/$DDKITSHOSTNAME.conf

# Build out docker file to start our install
echo -e '
FROM ddkits/lamp:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
COPY ddkitscli.sh /var/www/html/ddkitscli.sh
COPY php5.ini /usr/local/etc/php/conf.d/php.ini

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 

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
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw

RUN chmod -R 777 /var/www/html/ddkitscli.sh 
# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >> ./ddkits-files/drupal/Dockerfile

#  create ddkits compose file for the new website
echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/drupal
    image: ddkits/drupal7:latest
    volumes:
      # Mount the local drupal directory in the container
      - ./deploy:/var/www/html
    depends_on:
      # Link the Solr container:
      - "solr"
      # Link the mariaDB container:
      - "mariadb"
    stdin_open: true
    tty: true
    environment:
      - DDKITSHOSTNAME="'$DDKITSHOSTNAME'"
    container_name: '$DDKITSHOSTNAME'_ddkits_drupal_web
    networks:
      - ddkits      
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml
if [[ ! -d "deploy" ]]; then
  git clone https://github.com/ddkits/drupal-7.git ./deploy
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  mv -f ./deploy/deploy/* ./deploy
  chmod -R 755 ./deploy/public
  mkdir ./deploy/public/sites/default/files
  chmod -R 777 ./deploy/public/sites/default/files
fi  
echo $SUDOPASS | sudo -S chmod -R 777 ./deploy   

#  Drush setup for this enviroment

# ddkd(){
#   if [[ $1 == $DDKITSSITES ]]; then
#     docker exec -it $DDKITSHOSTNAME'_ddkits_drupal_web' drush 
#   elif [[ $1 == "-h" ]]; then
#     docker exec -it $DDKITSHOSTNAME'_ddkits_drupal_web' drush
#   elif [[ $1 == "rsync" ]]; then
#     rsync -rLcpzv --exclude=.git --exclude=.idea --exclude=settings.php --exclude=**/bower_components --exclude=**/node_modules --exclude=**/.sass-cache --exclude=/sites/*/files  ./deploy/public/ ./public/
#   else
#     # echo -e 'Please make sure to specify the domain you want to use drush with
#     # ex. ddkd ddkits.dev cc all # to clear cache from ddkits drupal site' 
#     docker exec -it $DDKITSHOSTNAME'_ddkits_drupal_web' drush
#   fi
# } 

alias ddkd-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_drupal_web drush'

# create get into ddkits container
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_drupal_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_drupal_web /bin/bash'" >> ~/.ddkits_alias
echo "alias ddkd-"$DDKITSSITES"='docker exec -it "$DDKITSHOSTNAME"_ddkits_drupal_web drush'" >> ~/.ddkits_alias
echo $SUDOPASS | sudo -S chmod -R 777 ./drupal-deploy

ln -sfn ./deploy/sites ./deploy/public/sites/default

elif [[  $DDKITSDRUPALV == '8'  ]]; then
    
  DOCUMENTROOT="public"
# delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/drupal/Dockerfile" ]]; then
          rm ddkits-files/drupal/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/drupal/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/drupal/sites/$DDKITSHOSTNAME.conf
        fi
if [[ $DDKITSSITESALIAS != "" ]]; then
  DDKITSSERVERS='ServerAlias '$DDKITSSITESALIAS' '$DDKITSSITESALIAS2' '$DDKITSSITESALIAS3''
else
  DDKITSSERVERS=''
fi

     
# create different containers files for conf
echo -e '
NameVirtualHost *:80

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
</VirtualHost> ' > ./ddkits-files/drupal/sites/$DDKITSHOSTNAME.conf

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

RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 

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
                   git \
                   libapache2-mod-php7.0 \
                   php7.0 \
                   php7.0-common \
                   php7.0-gd \
                   php7.0-mysql \
                   php7.0-mcrypt \
                   php7.0-curl \
                   php7.0-intl \
                   php7.0-xsl \
                   php7.0-mbstring \
                   php7.0-zip \
                   php7.0-bcmath \
                   php7.0-iconv \
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw  
RUN chmod -R 777 /var/www/html

RUN chmod -R 777 /var/www/html/ddkitscli.sh 
# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >> ./ddkits-files/drupal/Dockerfile

#  create ddkits compose file for the new website
echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/drupal
    image: ddkits/drupal8:latest
    volumes:
      # Mount the local drupal directory in the container
      - ./deploy:/var/www/html
    depends_on:
      # Link the Solr container:
      - "solr"
      # Link the mariaDB container:
      - "mariadb"
    stdin_open: true
    tty: true
    environment:
      - DDKITSHOSTNAME="'$DDKITSHOSTNAME'"
    container_name: '$DDKITSHOSTNAME'_ddkits_drupal_web
    networks:
      - ddkits      
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml
if [[ ! -d "deploy" ]]; then
  git clone https://github.com/ddkits/drupal-8.git ./deploy
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  mv -f ./deploy/deploy/* ./deploy
  chmod -R 777 ./deploy/public
  mkdir ./deploy/public/sites/default/files
  chmod -R 777 ./deploy/public/sites/default
  rm -rf ./deploy/public/vendor
  cp -f ./deploy/public/sites/default/default.settings.php ./deploy/public/sites/default/settings.php
  cp -f ./deploy/public/sites/default/default.services.yml ./deploy/public/sites/default/services.yml
  cp ./deploy/composer.phar ./deploy/public/ddkits.phar
  cd ./deploy/public && php ddkits.phar config --global discard-changes true && php ddkits.phar install -n
  cd $DDKITSFL
else
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  rm -rf ./deploy/public/vendor
  cd ./deploy/public && php ddkits.phar config --global discard-changes true && php ddkits.phar install -n
  cd $DDKITSFL
  chmod -R 777 ./deploy/public/sites/default/files
  # chown $(echo "$USER") ./deploy
fi        

echo $SUDOPASS | sudo -S chmod -R 777 ./deploy 

 else
  echo -e 'Not a valid version please try again.'
fi

#  Drush setup for this enviroment

# ddkd(){
#   if [[ $1 == $DDKITSSITES ]]; then
#     docker exec -it $DDKITSHOSTNAME'_ddkits_drupal_web' drush 
#   elif [[ $1 == "-h" ]]; then
#     docker exec -it $DDKITSHOSTNAME'_ddkits_drupal_web' drush
#   elif [[ $1 == "rsync" ]]; then
#     rsync -rLcpzv --exclude=.git --exclude=.idea --exclude=settings.php --exclude=**/bower_components --exclude=**/node_modules --exclude=**/.sass-cache --exclude=/sites/*/files  ./deploy/public/ ./public/
#   else
#     # echo -e 'Please make sure to specify the domain you want to use drush with
#     # ex. ddkd ddkits.dev cc all # to clear cache from ddkits drupal site' 
#     docker exec -it $DDKITSHOSTNAME'_ddkits_drupal_web' drush
#   fi
# } 
alias ddkd-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_drupal_web drush'

# create get into ddkits container
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_drupal_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_drupal_web /bin/bash'" >> ~/.ddkits_alias
echo "alias ddkd-"$DDKITSSITES"='docker exec -it "$DDKITSHOSTNAME"_ddkits_drupal_web drush'" >> ~/.ddkits_alias
echo $SUDOPASS | sudo -S chmod -R 777 ./drupal-deploy


             break
            ;;
            # case of wordpress 
        "Wordpress")
        # delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/wordpress/Dockerfile" ]]; then
          rm ddkits-files/wordpress/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/wordpress/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/wordpress/sites/$DDKITSHOSTNAME.conf
        fi
  
DOCUMENTROOT='public'

# Build out docker file to start our install
echo -e '
FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 

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
                   git \
                   libapache2-mod-php7.0 \
                   php7.0 \
                   php7.0-common \
                   php7.0-gd \
                   php7.0-mysql \
                   php7.0-mcrypt \
                   php7.0-curl \
                   php7.0-intl \
                   php7.0-xsl \
                   php7.0-mbstring \
                   php7.0-zip \
                   php7.0-bcmath \
                   php7.0-iconv \
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw  
RUN chmod -R 777 /var/www/html 

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
  ' >> ./ddkits-files/wordpress/Dockerfile


# create different containers files for conf
echo -e '
NameVirtualHost *:80

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
</VirtualHost> ' > ./ddkits-files/wordpress/sites/$DDKITSHOSTNAME.conf

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/wordpress
    image: ddkits/wordpress:latest
    depends_on:
      # Link the Solr container:
      - "solr"
      # Link the mariaDB container:
      - "mariadb"
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_wp_web
    volumes:
      - ./wp-deploy:/var/www/html
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" 
    environment:
       WORDPRESS_DB_HOST: '$DDKITSIP':'$DDKITSDBPORT'
       WORDPRESS_DB_USER: '$MYSQL_USER'
       WORDPRESS_DB_PASSWORD: '$MYSQL_ROOT_PASSWORD' ' >> ddkits.env.yml  

wget http://wordpress.org/latest.tar.gz
tar xfz latest.tar.gz  
mkdir ./wp-deploy
mkdir ./wp-deploy/public
mv wordpress/* ./wp-deploy/public
rmdir ./wordpress/
rm -f latest.tar.gz
echo $SUDOPASS | sudo -S chmod -R 777 ./wp-deploy  

# create get into ddkits container
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_wp_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_wp_web /bin/bash'" >> ~/.ddkits_alias
echo $SUDOPASS | sudo -S chmod -R 777 ./wp-deploy


             break
            ;;
            # case of joomla
        "Joomla")
        # delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/joomla/Dockerfile" ]]; then
          rm ddkits-files/joomla/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/joomla/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/joomla/sites/$DDKITSHOSTNAME.conf
        fi
DOCUMENTROOT='public'

# Build out docker file to start our install
echo -e 'FROM ddkits/lamp:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 

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
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw  
RUN chmod -R 777 /var/www/html 

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
  ' >> ./ddkits-files/joomla/Dockerfile


# create different containers files for conf
echo -e '
NameVirtualHost *:80

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
</VirtualHost> ' > ./ddkits-files/joomla/sites/$DDKITSHOSTNAME.conf

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/joomla
    image: ddkits/joomla:latest
    depends_on:
      # Link the Solr container:
      - "solr"
      # Link the mariaDB container:
      - "mariadb"
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_jom_web
    volumes:
      - ./jom-deploy:/var/www/html
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" 
    environment:
       JOOMLA_DB_HOST: '$DDKITSIP':'$DDKITSDBPORT'
       JOOMLA_DB_USER: '$MYSQL_USER'
       JOOMLA_DB_PASSWORD: '$MYSQL_ROOT_PASSWORD' ' >> ddkits.env.yml  

mkdir ./jom-deploy
mkdir ./jom-deploy/public
git clone https://github.com/ddkits/Joomla.git ./jom-deploy/public

echo $SUDOPASS | sudo -S chmod -R 777 ./jom-deploy  

# create get into ddkits container
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_jom_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_jom_web /bin/bash'" >> ~/.ddkits_alias
echo $SUDOPASS | sudo -S chmod -R 777 ./jom-deploy


             break
            ;;
        "Laravel")
        DOCUMENTROOT=$DDKITSHOSTNAME
  # create different containers files for conf
   # delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/Laravel/Dockerfile" ]]; then
          rm ddkits-files/Laravel/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/Laravel/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/Laravel/sites/$DDKITSHOSTNAME.conf
        fi
echo -e '
php artisan key:generate
php artisan cache:clear
php artisan config:clear
chmod -R 777 storage
 ' > ./ll-deploy/ddkits.fix.sh


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
</VirtualHost> ' > ./ddkits-files/Laravel/sites/$DDKITSHOSTNAME.conf

echo -e 'FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf ./logs /var/log/nginx/access.log \
    && ln -sf ./logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf
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
                   git \
                   libapache2-mod-php7.0 \
                   php7.0 \
                   php7.0-common \
                   php7.0-gd \
                   php7.0-mysql \
                   php7.0-mcrypt \
                   php7.0-curl \
                   php7.0-intl \
                   php7.0-xsl \
                   php7.0-mbstring \
                   php7.0-zip \
                   php7.0-bcmath \
                   php7.0-iconv \
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw  
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
COPY ./sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

 ' >> ./ddkits-files/Laravel/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/Laravel
    image: ddkits/laravel:latest
    depends_on:
      # Link the Solr container:
      - "solr"
      # Link the mariaDB container:
      - "mariadb"
    volumes:
      - ./ll-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_laravel_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml

# create get into ddkits container
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_laravel_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_laravel_web /bin/bash'" >> ~/.ddkits_alias
echo $SUDOPASS | sudo -S chmod -R 777 ./laravel-deploy

if [[ ! -f "composer.phar" ]]; then
  wget https://getcomposer.org/composer.phar
fi

echo $SUDOPASS | sudo -S chmod 777 composer.phar

echo -e 'Now installing Laravel through composer '
php composer.phar create-project laravel/laravel --prefer-dist ll-deploy


if [[ -f "ll-deploy/storage/logs/laravel.logs" ]]; then
 rm -rf ./ll-deploy/storage/logs/laravel.logs
fi

if [[ -d "ll-deploy" ]]; then
  cd ll-deploy
  php artisan cache:clear
  php artisan config:cache
  cd ..
  echo $SUDOPASS | sudo -S chmod -R 777 ./ll-deploy
  echo $SUDOPASS | sudo -S chmod -R 777 ./ll-deploy/storage
fi

if [[ -f "ll-deploy/.env" ]]; then
  rm ./ll-deploy/.env
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
' >> ./ll-deploy/.env

echo $SUDOPASS | sudo -S chmod -R 777 ./ll-deploy
alias ddklf="docker exec -d "$DDKITSHOSTNAME"_ddkits_laravel_web bash ddkits.fix.sh"
            break
            ;;
        "LAMP/PHP5")
    # delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/lamp5/Dockerfile" ]]; then
          rm ddkits-files/lamp5/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/lamp5/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/lamp5/sites/$DDKITSHOSTNAME.conf
        fi

#  LAMP PHP 5

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
</VirtualHost> ' > ./ddkits-files/lamp5/sites/$DDKITSHOSTNAME.conf

echo -e 'FROM ddkits/lamp:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 

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
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw  
RUN chmod -R 777 /var/www/html 

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
  ' >> ./ddkits-files/lamp5/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/lamp5
    image: ddkits/lamp5:latest
    depends_on:
      # Link the Solr container:
      - "solr"
      # Link the mariaDB container:
      - "mariadb"
    volumes:
      - ./lamp5-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_lamp5_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml

# create get into ddkits container
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_lamp5_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_lamp5_web /bin/bash'" >> ~/.ddkits_alias
echo $SUDOPASS | sudo -S chmod -R 777 ./lamp5-deploy

        break
        ;;
        "LAMP/PHP7")

    # delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/lamp7/Dockerfile" ]]; then
          rm ddkits-files/lamp7/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/lamp7/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/lamp7/sites/$DDKITSHOSTNAME.conf
        fi
#  LAMP PHP 7

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
</VirtualHost> ' > ./ddkits-files/lamp7/sites/$DDKITSHOSTNAME.conf

echo -e 'FROM ddkits/lamp:7

RUN ln -sf ./logs /var/log/nginx/access.log \
    && ln -sf ./logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf
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
                   git \
                   libapache2-mod-php7.0 \
                   php7.0 \
                   php7.0-common \
                   php7.0-gd \
                   php7.0-mysql \
                   php7.0-mcrypt \
                   php7.0-curl \
                   php7.0-intl \
                   php7.0-xsl \
                   php7.0-mbstring \
                   php7.0-zip \
                   php7.0-bcmath \
                   php7.0-iconv \
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw  
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
COPY ./sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf 
# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >> ./ddkits-files/lamp7/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/lamp7
    image: ddkits/lamp7:latest
    depends_on:
      # Link the Solr container:
      - "solr"
      # Link the mariaDB container:
      - "mariadb"
    volumes:
      - ./lamp7-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_lamp7_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml

# create get into ddkits container
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_lamp7_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_lamp7_web /bin/bash'" >> ~/.ddkits_alias
echo $SUDOPASS | sudo -S chmod -R 777 ./lamp7-deploy



        break
        ;;

        "Umbraco")

# delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/umbraco/Dockerfile" ]]; then
          rm ddkits-files/umbraco/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/umbraco/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/umbraco/sites/$DDKITSHOSTNAME.conf
        fi

# Umbraco with ASPNET server


echo -e 'FROM kevinobee/umbraco:latest ' >> ./ddkits-files/umbraco/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/umbraco
    image: ddkits/umbraco:latest
    depends_on:
      # Link the Solr container:
      - "solr"
      # Link the mariaDB container:
      - "mariadb"
    volumes:
      - ./um-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_umbraco_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml

echo $SUDOPASS | sudo -S chmod -R 777 ./um-deploy

            break
            ;;
      "Magento")
# delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/magento/Dockerfile" ]]; then
          rm ddkits-files/magento/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/magento/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/magento/sites/$DDKITSHOSTNAME.conf
        fi

#  Magento setup 
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
      Options Indexes FollowSymLinks MultiViews
      AllowOverride All
      Require all granted
      Order allow,deny
      allow from all
  </Directory>
</VirtualHost> ' > ./ddkits-files/magento/sites/$DDKITSHOSTNAME.conf

echo -e 'FROM ddkits/lamp:7

RUN ln -sf ./logs /var/log/nginx/access.log \
    && ln -sf ./logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf
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
                   git \
                   libapache2-mod-php7.0 \
                   php7.0 \
                   php7.0-common \
                   php7.0-gd \
                   php7.0-mysql \
                   php7.0-mcrypt \
                   php7.0-curl \
                   php7.0-intl \
                   php7.0-xsl \
                   php7.0-mbstring \
                   php7.0-zip \
                   php7.0-bcmath \
                   php7.0-iconv \
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw  
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
RUN chmod o+rw /var/www/html
COPY ./sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf 
# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >> ./ddkits-files/magento/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/magento
    image: ddkits/magento:latest
    depends_on:
      # Link the Solr container:
      - "solr"
      # Link the mariaDB container:
      - "mariadb"
    volumes:
      - ./mag-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_magento_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml

if [[ ! -d "mag-deploy/public" ]]; then
  mkdir ./mag-deploy
  git clone https://github.com/ddkits/magento.git ./mag-deploy/public
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  cp -f ./composer.phar ./mag-deploy/public/ddkits.phar
  cp ./composer.phar ./mag-deploy/public/ddkits.phar && echo $SUDOPASS | sudo -S chmod 777 ./mag-deploy/public/ddkits.phar
  cd ./mag-deploy/public && php ddkits.phar config --global discard-changes true &&  php ddkits.phar install -n
  cd $DDKITSFL
else
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  cp ./composer.phar ./mag-deploy/public/ddkits.phar && echo $SUDOPASS | sudo -S chmod 777 ./mag-deploy/public/ddkits.phar
  cd ./mag-deploy/public && php ddkits.phar config --global discard-changes true &&  php ddkits.phar install -n
  cd $DDKITSFL
fi        
echo $SUDOPASS | sudo -S chmod -R 777 ./mag-deploy


# create get into ddkits container
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_magento_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_magento_web /bin/bash'" >> ~/.ddkits_alias
echo $SUDOPASS | sudo -S chmod -R 777 ./magento-deploy


        break
        ;;


"DreamFactory")
# delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/dreamf/Dockerfile" ]]; then
          rm ddkits-files/dreamf/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/dreamf/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/dreamf/sites/$DDKITSHOSTNAME.conf
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
</VirtualHost> ' > ./ddkits-files/dreamf/sites/$DDKITSHOSTNAME.conf

echo -e 'FROM ddkits/lamp:7

RUN ln -sf ./logs /var/log/nginx/access.log \
    && ln -sf ./logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf
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
                   git \
                   libapache2-mod-php7.0 \
                   php7.0 \
                   php7.0-common \
                   php7.0-gd \
                   php7.0-mysql \
                   php7.0-mcrypt \
                   php7.0-curl \
                   php7.0-intl \
                   php7.0-xsl \
                   php7.0-mbstring \
                   php7.0-zip \
                   php7.0-bcmath \
                   php7.0-iconv \
                   php7.0-mongodb \
                   php7.0-ssh2 \
                   php7.0-json \
                   memcached \
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw  
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
COPY ./sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf 
# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >> ./ddkits-files/dreamf/Dockerfile

echo -e '
composer install --no-dev
chmod -R 777 /var/www/html/storage /var/www/html/vendor /var/www/html/public
php artisan key:generate
php artisan cache:clear
php artisan config:clear
chmod -R 777 storage
 ' > ./ll-deploy/ddkits.fix.sh

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/dreamf
    image: ddkits/dreamf:latest
    depends_on:
      # Link the Solr container:
      - "solr"
      # Link the mariaDB container:
      - "mariadb"
    volumes:
      - ./dreamf-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_dreamf_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml

# create get into ddkits container
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_dreamf_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_dreamf_web /bin/bash'" >> ~/.ddkits_alias
echo $SUDOPASS | sudo -S chmod -R 777 ./dreamf-deploy


if [[ ! -d "dreamf-deploy" ]]; then
  git clone https://github.com/dreamfactorysoftware/dreamfactory.git ./dreamf-deploy
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  cp ./composer.phar ./dreamf-deploy/public/ddkits.phar && echo $SUDOPASS | sudo -S chmod 777 ./dreamf-deploy/public/ddkits.phar
  cd ./dreamf-deploy/public && php ddkits.phar config --global discard-changes true &&  php ddkits.phar install --no-dev -n
  php artisan df:setup
  echo $SUDOPASS | sudo -S chmod -R 2775 storage/ bootstrap/cache/
  cd $DDKITSFL
# create database variables for dreamfactory
  rm -rf ./dreamf-deploy/.env
  cat ./ddkits-files/dreamf/env >> ./dreamf-deploy/.env
  chmod -R 777 ./dreamf-deploy/storage/ ./dreamf-deploy/public/ ./dreamf-deploy/public/ bootstrap/cache/
else
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  cp ./composer.phar ./dreamf-deploy/public/ddkits.phar && echo $SUDOPASS | sudo -S chmod 777 ./dreamf-deploy/public/ddkits.phar
  cd ./dreamf-deploy/public && php ddkits.phar config --global discard-changes true &&  php ddkits.phar install --no-dev -n
  cd $DDKITSFL
fi     
echo $SUDOPASS | sudo -S chmod -R 777 ./dreamf-deploy


            break
            ;;

"Contao")

#  Contao setup 
echo -e ' Comming soon!!'

            break
            ;;

"Silverstripe")

#  Silverstripe setup 
# delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ss/Dockerfile" ]]; then
          rm ddkits-files/ss/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/ss/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/ss/sites/$DDKITSHOSTNAME.conf
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
</VirtualHost> ' > ./ddkits-files/ss/sites/$DDKITSHOSTNAME.conf

echo -e 'FROM ddkits/lamp:7

RUN ln -sf ./logs /var/log/nginx/access.log \
    && ln -sf ./logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf
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
                   git \
                   libapache2-mod-php7.0 \
                   php7.0 \
                   php7.0-common \
                   php7.0-gd \
                   php7.0-mysql \
                   php7.0-mcrypt \
                   php7.0-curl \
                   php7.0-intl \
                   php7.0-xsl \
                   php7.0-mbstring \
                   php7.0-zip \
                   php7.0-bcmath \
                   php7.0-iconv \
                   php7.0-mongodb \
                   php7.0-ssh2 \
                   php7.0-json \
                   memcached \
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw  
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
COPY ./sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf 

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
' >> ./ddkits-files/ss/Dockerfile


echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/ss
    image: ddkits/ss:latest
    depends_on:
      # Link the Solr container:
      - "solr"
      # Link the mariaDB container:
      - "mariadb"
    volumes:
      - ./ss-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_ss_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' > ddkits.env.yml

# create get into ddkits container
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_ss_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_ss_web /bin/bash'" >> ~/.ddkits_alias
echo $SUDOPASS | sudo -S chmod -R 777 ./ss-deploy

if [[ ! -d "ss-deploy/public" ]]; then
  DDKITSFL=$(pwd)
  echo $DDKITSFL
mkdir ./ss-deploy
mkdir ./ss-deploy/public
cd ./ss-deploy/public
wget https://silverstripe-ssorg-releases.s3.amazonaws.com/sssites-ssorg-prod/assets/releases/SilverStripe-cms-v3.6.1.tar.gz
tar -xvzf SilverStripe-cms-v3.6.1.tar.gz 
rm -rf SilverStripe-cms-v3.6.1.tar.gz
cd $DDKITSFL
cp ./composer.phar ./ss-deploy/public/ddkits.phar && echo $SUDOPASS | sudo -S chmod 777 ./ss-deploy/public/ddkits.phar
fi

            break
            ;;

"Cloud")

#  Contao setup 
# delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/cloud/Dockerfile" ]]; then
          rm ddkits-files/cloud/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/cloud/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/cloud/sites/$DDKITSHOSTNAME.conf
        fi
        if [[ -f "ddkits-files/cloud/ddkits-check.sh" ]]; then
          rm ddkits-files/cloud/ddkits-check.sh
        fi


# create entrypoints
# echo -e '
# chown -R $USER:$USER $VOLUME_ROOT
# su -s /bin/bash - $USER -c "cd $repo/build; $@"
# ' > ./ddkits-files/cloud/entrypoints.sh

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
</VirtualHost> ' > ./ddkits-files/cloud/sites/$DDKITSHOSTNAME.conf


echo -e '#!/bin/bash
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
fi' > ./ddkits-files/cloud/ddkits-check.sh



echo -e 'FROM ddkits/lamp:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY get-pip.py /var/www/html/get-pip.py
COPY ddkits-check.sh /var/www/html/ddkits-check.sh


# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 

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
                   snap \
                   python \
                   python-dev \
                   pacman \
                   python-software-properties \
                   apt-file \
                   software-properties-common \
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw 

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

  ' > ./ddkits-files/cloud/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/cloud
    image: ddkits/cloud:latest
    depends_on:
      # Link the Solr container:
      - "solr"
      # Link the mariaDB container:
      - "mariadb"
    volumes:
      - ./cloud-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_cloud_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml

# create get into ddkits container
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_cloud_web /bin/bash'
alias ddkc-$DDKITSSITES-fix='docker exec -it '$DDKITSHOSTNAME'_ddkits_cloud_web /bin/bash /var/www/html/ddkits-check.sh'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_cloud_web /bin/bash'" >> ~/.ddkits_alias
echo "alias ddkc-"$DDKITSSITES"-fix='docker exec -it "$DDKITSHOSTNAME"_ddkits_cloud_web /bin/bash /var/www/html/ddkits-check.sh'" >> ~/.ddkits_alias
echo $SUDOPASS | sudo -S chmod -R 777 ./cloud-deploy
echo $SUDOPASS | sudo -S chmod -R 0770 ./cloud-deploy/public/data



# Installing ownCloud9 on local host 

   
if [[ ! -d "/var/www/html/public" ]]; then
  DDKITSFL=$(pwd)
  echo $DDKITSFL
mkdir ./cloud-deploy
chmod -R 777 ./cloud-deploy/public
cd ./cloud-deploy
wget https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
wget https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2.sha256
wget https://owncloud.org/owncloud.asc
wget https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2.asc
sha256sum -c owncloud-9.0.0.tar.bz2.sha256
gpg --import owncloud.asc
gpg --verify owncloud-9.0.0.tar.bz2.asc
tar xjvf owncloud-9.0.0.tar.bz2 
cp -r owncloud public
rm -rf owncloud
cd $DDKITSFL
chmod -R 777 ./cloud-deploy/public
fi

            break
            ;;

        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

MYSQL_PASSWORD=${MYSQL_ROOT_PASSWORD}

# echo $SUDOPASS | sudo -S gem install autoprefixer-rails sass compass breakpoint singularitygs toolkit bower
# echo $SUDOPASS | sudo -S gem install breakpoint
# find existing instances in the host file and save the line numbers
matches_in_hosts="$(grep -n $DDKITSSITES /etc/hosts | cut -f1 -d:)"
ddkits_matches_in_hosts="$(grep -n jenkins.${DDKITSSITES} /etc/hosts | cut -f1 -d:)"
host_entry="${DDKITSIP} ${DDKITSSITES} ${DDKITSSITESALIAS} ${DDKITSSITESALIAS2} ${DDKITSSITESALIAS3}"
ddkits_host_entry="${DDKITSIP} jenkins.${DDKITSSITES} admin.${DDKITSSITES} solr.${DDKITSSITES}"

# echo "Please enter your password if requested."

echo ${SUDOPASS} | sudo -S cat /etc/hosts

if [ ! -z "$matches_in_hosts" ]
then
    echo "Updating existing hosts entry."
   
    # iterate over the line numbers on which matches were found
    while read -r line_number; do
        # replace the text of each line with the desired host entry
      echo ${SUDOPASS} | sudo -S sed -i '' "${line_number}s/.*/${host_entry} /" /etc/hosts
    done <<< "$matches_in_hosts"
else
    echo "Adding new hosts entry."
    echo "$host_entry" | sudo tee -a /etc/hosts > /dev/null
fi

if [ ! -z "$ddkits_matches_in_hosts" ]
then
   # iterate over the line numbers on which matches were found
    while read -r line_number; do
        # replace the text of each line with the desired host entry
      echo ${SUDOPASS} | sudo -S sed -i '' "${line_number}s/.*/${ddkits_host_entry} /" /etc/hosts
    done <<< "$ddkits_matches_in_hosts"
    else
    echo "Adding new hosts entry."
    echo "$ddkits_host_entry" | sudo tee -a /etc/hosts > /dev/null
fi
# echo '"'${DDKITSIP}' '${DDKITSSITES}'" saved into your /etc/hosts'

#  export all values the user insert into his bash system
export MAIL_ADDRESS=$MAIL_ADDRESS
export DDKITSSITES=$DDKITSSITES
export DDKITSIP=$DDKITSIP
export MYSQL_USER=$MYSQL_USER
export MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
export MYSQL_DATABASE=$MYSQL_DATABASE
export MYSQL_PASSWORD=$MYSQL_ROOT_PASSWORD
export DDKITSSITESALIAS=$DDKITSSITESALIAS
export DDKITSWEBPORT=$DDKITSWEBPORT
export DDKITSSITESALIAS2=$DDKITSSITESALIAS2
export DDKITSSITESALIAS3=$DDKITSSITESALIAS3
export DDKITSHOSTNAME=$DDKITSHOSTNAME


# Create our system ddkits enviroment
echo -e 'version: "2"

services:
  mariadb:
    build: ./ddkits-files/db
    image: ddkits/mariadb:latest
    volumes:
      - /var/lib/mysql
    container_name: '$DDKITSHOSTNAME'_ddkits_db
    ports:
        - '$DDKITSDBPORT':3306
    networks:
      - ddkits
    environment:
     - MYSQL_ROOT_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - MYSQL_DATABASE='$MYSQL_DATABASE'
     - MYSQL_USER='$MYSQL_USER'
     - MYSQL_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - MYSQL_HOST='$DDKITSIP'

  solr:
    build: ./ddkits-files/solr
    image: ddkits/solr:latest
    container_name: '$DDKITSHOSTNAME'_ddkits_solr
    networks:
      - ddkits
    ports:
      - "'$DDKITSSOLRPORT':8983"

  phpmyadmin:
    build: ./ddkits-files/phpmyadmin
    image: ddkits/phpmyadmin
    container_name: '$DDKITSHOSTNAME'_ddkits_phpadmin
    environment:
     - PMA_ARBITRARY=1
     - MYSQL_ROOT_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - MYSQL_DATABASE='$MYSQL_DATABASE'
     - MYSQL_USER='$MYSQL_USER'
     - MYSQL_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - MYSQL_HOST='$DDKITSIP'
    volumes:
     - ./deploy/phpmyadmin:/etc/phpmyadmin
    links:
      - mariadb
    ports:
      - '$DDKITSADMINPORT':80
    networks:
      - ddkits

  cache:
    image: redis:latest
    container_name: '$DDKITSHOSTNAME'_ddkits_cache
    networks:
      - ddkits
    ports:
      - "'$DDKITSREDISPORT':'$DDKITSREDISPORT'"

  jenkins:
    image: whywebs/jenkins:latest
    ports:
      - "'$DDKITSJENKINSPORT':50000"
    volumes:
      - ./jenkins:/var/jenkins_home 
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_jenkins
    networks:
      - ddkits

networks:
    ddkits:

  ' >> ddkitsnew.yml

# create get into ddkits container
alias ddkc-$DDKITSSITES-cache='docker exec -it '$DDKITSHOSTNAME'_ddkits_cache /bin/bash'
alias ddkc-$DDKITSSITES-jen='docker exec -it '$DDKITSHOSTNAME'_ddkits_jenkins /bin/bash'
alias ddkc-$DDKITSSITES-solr='docker exec -it '$DDKITSHOSTNAME'_ddkits_solr /bin/bash'
alias ddkc-$DDKITSSITES-admin='docker exec -it '$DDKITSHOSTNAME'_ddkits_admin /bin/bash'

echo "alias ddkc-"$DDKITSSITES"-cache='docker exec -it "$DDKITSHOSTNAME"_ddkits_cache /bin/bash'" >> ~/.ddkits_alias
echo "alias ddkc-"$DDKITSSITES"-jen='docker exec -it "$DDKITSHOSTNAME"_ddkits_jenkins /bin/bash'" >> ~/.ddkits_alias
echo "alias ddkc-"$DDKITSSITES"-solr='docker exec -it "$DDKITSHOSTNAME"_ddkits_solr /bin/bash'" >> ~/.ddkits_alias
echo "alias ddkc-"$DDKITSSITES"-admin='docker exec -it "$DDKITSHOSTNAME"_ddkits_admin /bin/bash'" >> ~/.ddkits_alias



#  All information in one file html as a referance

echo -e '#<html><head><!--

# Your Bash script goes here

<<HTML_CONTENT 
-->
<body style="background-color:white; margin-top:-1em">
<center><h3>Your DDKits information:</h3></center><br />
<br /><br /><br /><br />
<br />
MAIL_ADDRESS = '$MAIL_ADDRESS'<br />
Website = '$DDKITSSITES'<br />
DDKits ip = '$DDKITSIP' ==> Port = '$DDKITSWEBPORT'<br />
Mysql User = '$MYSQL_USER'<br />
Mysql User Password = '$MYSQL_ROOT_PASSWORD'<br />
Database name =' $MYSQL_DATABASE'<br />
Mysql $MYSQL_USER Password = '$MYSQL_PASSWORD'<br />
Website Alias = '$DDKITSSITESALIAS' '$DDKITSSITESALIAS2' '$DDKITSSITESALIAS3'<br />
<br />
Ports:<br />
<br />
- Your new '$DDKITSSITES' port is: '$DDKITSWEBPORT'<br />
- Your new DB port is: '$DDKITSDBPORT'<br />
- Your new Jenkins port is: '$DDKITSJENKINSPORT'<br />
- Your new Solr port is: '$DDKITSSOLRPORT'<br />
- Your new PhpMyAdmin port is: '$DDKITSADMINPORT'<br />
- Your new Radis port is: '$DDKITSREDISPORT'<br />
<br /><br /><br /><br />
<center>Thank you for using DDKits, feel free to contact us @ melayyoub@outlook.com <br />
Copyright @2017 <a href="http://ddkits.com/">DDKits.com</a></center> 
<!--
HTML_CONTENT
# --></body></html>' > ./ddkits-$DDKITSHOSTNAME.html

echo $SUDOPASS | sudo -S cat ~/.bashrc_profile
echo $ddkc-$DDKITSSITES >> ~/.bashrc

#  prepare ddkits container for the new websites
echo -e 'copying conf files into ddkits and restart'
docker cp ./ddkits-files/ddkits/sites/ddkitscust.conf ddkits:/etc/apache2/sites-enabled/ddkits_$DDKITSHOSTNAME.conf
# docker cp ./ddkitscli.sh $DDKITSHOSTNAME'_ddkits_joomla_web':/var/www/html/ddkitscli.sh

docker restart ddkits
ddk go


