#!/bin/sh

#  Script.sh
#
#
#
# This system built by Mutasem Elayyoub DDKits.com
# insert DDKits alias into anyh system command lines
. ddkits.alias.sh

#  built by  by Mutasem Elayyoub DDKits.com"
# docker-machine create --driver virtualbox ddkits
# docker-machine start ddkits
# eval $(docker-machine env ddkits)
clear
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
  echo -e "Enter your E-mail address that you want to use in your website as an admin: "
read MAIL_ADDRESS 
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
    echo -e "Do you need JENKINS with this Installation? (y/n)"
  read JENKINS_ANSWER
  echo -e "Do you need SOLR with this Installation? (y/n)"
  read SOLR_ANSWER
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
    echo -e "
    <VirtualHost *:80>
      ServerName "$DDKITSSITES"
      ProxyPreserveHost on
      ProxyPass / http://"$DDKITSIP":"$DDKITSWEBPORT"/ 
      ProxyPassReverse / http://"$DDKITSIP":"$DDKITSWEBPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
    </VirtualHost>
    <VirtualHost *:80>
      ServerName solr."$DDKITSSITES"
      ProxyPreserveHost on
      ProxyPass / http://"$DDKITSIP":"$DDKITSSOLRPORT"/ 
      ProxyPassReverse / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
    </VirtualHost>
    <VirtualHost *:80>
      ServerName jenkins."$DDKITSSITES"
      ProxyPreserveHost on
      ProxyPass / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/ 
      ProxyPassReverse / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
    </VirtualHost>
    <VirtualHost *:80>
      ServerName admin."$DDKITSSITES"
      ProxyPreserveHost on
      ProxyPass / http://"$DDKITSIP":"$DDKITSADMINPORT"/ 
      ProxyPassReverse / http://"$DDKITSIP":"$DDKITSADMINPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
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

        echo -e "

        <VirtualHost *:80>
          ServerName "$DDKITSSITES"
          ServerAlias "$DDKITSSITESALIAS"
          ProxyPreserveHost on
          ProxyPass / http://"$DDKITSIP":"$DDKITSWEBPORT"/
          ProxyPassReverse / http://"$DDKITSIP":"$DDKITSWEBPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
        </VirtualHost>
<VirtualHost *:80>
  ServerName solr."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
</VirtualHost>

<VirtualHost *:80>
  ServerName jenkins.ddkits.site
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
</VirtualHost>

<VirtualHost *:80>
  ServerName admin."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSADMINPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSADMINPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
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
          echo -e "

          <VirtualHost *:80>
            ServerName "$DDKITSSITES"
            ProxyPreserveHost on
            ProxyPass / http://"$DDKITSIP":"$DDKITSWEBPORT"/
            ProxyPassReverse / http://"$DDKITSIP":"$DDKITSWEBPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
          </VirtualHost>

          <VirtualHost *:80>
            ServerName "$DDKITSSITESALIAS"
            ProxyPreserveHost on
            ProxyPass / http://"$DDKITSIP":"$DDKITSWEBPORT"/
            ProxyPassReverse / http://"$DDKITSIP":"$DDKITSWEBPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
          </VirtualHost>

          <VirtualHost *:80>
            ServerName "$DDKITSSITESALIAS2"
            ProxyPreserveHost on
            ProxyPass / http://"$DDKITSIP":"$DDKITSWEBPORT"/
            ProxyPassReverse / http://"$DDKITSIP":"$DDKITSWEBPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
          </VirtualHost>

<VirtualHost *:80>
  ServerName solr."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
</VirtualHost>

<VirtualHost *:80>
  ServerName jenkins.ddkits.site
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
</VirtualHost>

<VirtualHost *:80>
  ServerName admin."$DDKITSSITES"
  ProxyPreserveHost on
  ProxyPass / http://"$DDKITSIP":"$DDKITSADMINPORT"/
  ProxyPassReverse / http://"$DDKITSIP":"$DDKITSADMINPORT"/
      Timeout 2400
      ProxyTimeout 2400
      ProxyBadHeader Ignore 
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

clear

# echo -e "Enter your E-mail address that you want to use in your website as an admin: "
#   
# read MAIL_ADDRESS 
#   echo -e ""
DDKITSHOSTNAME=${DDKITSSITES//./_}
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
DDKITS_PLATFORM='Please pick which platform you want to install: '
# 
# Setup options Please make sure of all options before publish pick list 
# 
options=( "Contao" "DreamFactory" "Drupal" "Expression Engine" "Elgg" "Joomla" "Laravel" "LAMP/PHP5" "LAMP/PHP7" "Magento" "Umbraco" "Wordpress" "Silverstripe" "Cloud" "Symfony"  "ZenCart" "Zend" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        # case of drupal
        "Drupal")

  echo -e ""
  echo -e 'What Drupal Version you want to start with: 7 or 8 ?'
read DDKITSDRUPALV

if [[ ! -d "ddkits-files/drupal/sites" ]]; then
  mkdir ddkits-files/drupal/sites
  chmod -R 777 ddkits-files/drupal/sites
fi
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
    
    stdin_open: true
    tty: true
    environment:
      - DDKITSHOSTNAME="'$DDKITSHOSTNAME'"
    container_name: '$DDKITSHOSTNAME'_ddkits_drupal_web
    networks:
      - ddkits      
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml
if [[ ! -d "deploy/public" ]]; then
  git clone https://github.com/ddkits/drupal-7.git ./deploy
  DDKITSFL=$(pwd)
  cp -R deploy/deploy/* deploy
  rm -rf deploy/deploy
  echo $DDKITSFL
  chmod -R 755 ./deploy/public
  mkdir ./deploy/public/sites/default/files
  chmod -R 777 ./deploy/public/sites/default/files
elif [[ -d "deploy/public" ]]; then
  echo 'if you need a new drupal7 installation please make sure to remove deploy/public folder and restart this step again.'
fi  
echo $SUDOPASS | sudo -S chmod -R 777 ./deploy   



alias ddkd-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_drupal_web public/drush '

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_drupal_web /bin/bash'
# alias ddkd-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_drupal_web /bin/bash -c "cd public && drush"'

#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_drupal_web /bin/bash'" >> ~/.ddkits_alias_web
# echo "alias ddkd-"$DDKITSSITES"='docker exec -it "$DDKITSHOSTNAME"_ddkits_drupal_web /bin/bash -c 'cd public && drush''" >> ~/.ddkits_alias_web
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
RUN echo "alias drush=/var/www/html/drush/drush" >> ~/.bashrc
RUN chmod -R 777 /var/www/html
RUN apt-get install drush -y --force-yes 
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
    
    stdin_open: true
    tty: true
    environment:
      - DDKITSHOSTNAME="'$DDKITSHOSTNAME'"
    container_name: '$DDKITSHOSTNAME'_ddkits_drupal_web
    networks:
      - ddkits      
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml
if [[ ! -d "deploy/public" ]]; then
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
    echo 'if you need a new drupal 8 installation please make sure to remove deploy/public folder and restart this step again.'
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  rm -rf ./deploy/public/vendor
  cd ./deploy/public && php ddkits.phar config --global discard-changes true && php ddkits.phar install -n
  cd $DDKITSFL
  chmod -R 777 ./deploy/public/sites/default/files
  # chown $(echo "$USER") ./deploy
fi   

if [[ ! -d "deploy/drush" ]]; then
       wget https://github.com/drush-ops/drush/archive/8.x.zip
        unzip 8.x.zip
        rm 8.x.zip
        mv drush-8.x drush
        cd drush
        composer install
       cd $DDKITSFL
fi     

echo $SUDOPASS | sudo -S chmod -R 777 ./deploy 

 else
  echo -e 'Not a valid version please try again.'
fi

alias ddkd-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_drupal_web drush'

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_drupal_web /bin/bash'
# alias ddkd-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_drupal_web /bin/bash -c "cd public & drush "'

#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_drupal_web /bin/bash" >> ~/.ddkits_alias_web
# echo "alias ddkd-"$DDKITSSITES"='docker exec -it "$DDKITSHOSTNAME"_ddkits_drupal_web /bin/bash -c 'cd public & drush " >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./drupal-deploy
             break
            ;;
            # case of wordpress 
        "Wordpress")

if [[ ! -d "ddkits-files/wp/sites" ]]; then
  mkdir ddkits-files/wp/sites
  chmod -R 777 ddkits-files/wp/sites
fi
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
 
RUN chmod -R 777 /var/www/html 


# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
  ' >> ./ddkits-files/wordpress/Dockerfile


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
</VirtualHost> ' > ./ddkits-files/wordpress/sites/$DDKITSHOSTNAME.conf

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/wordpress
    image: ddkits/wordpress:latest
    
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
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_wp_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_wp_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./wp-deploy


             break
            ;;
            # case of joomla
        "Joomla")

if [[ ! -d "ddkits-files/joomla/sites" ]]; then
  mkdir ddkits-files/joomla/sites
  chmod -R 777 ddkits-files/joomla/sites
fi


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
  ' >> ./ddkits-files/joomla/Dockerfile


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
</VirtualHost> ' > ./ddkits-files/joomla/sites/$DDKITSHOSTNAME.conf

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/joomla
    image: ddkits/joomla:latest
    
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
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_jom_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_jom_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./jom-deploy


             break
            ;;
        "Laravel")

if [[ ! -d "ddkits-files/laravel/sites" ]]; then
  mkdir ddkits-files/laravel/sites
  chmod -R 777 ddkits-files/laravel/sites
fi


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
#!/bin/sh

#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#

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

echo -e '

#  Script.s#  Script.s

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf ./logs /var/log/nginx/access.log \
    && ln -sf ./logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf 
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
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_laravel_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_laravel_web /bin/bash'" >> ~/.ddkits_alias_web
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

if [[ ! -d "ddkits-files/lamp5/sites" ]]; then
  mkdir ddkits-files/lamp5/sites
  chmod -R 777 ddkits-files/lamp5/sites
fi


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
  ' >> ./ddkits-files/lamp5/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/lamp5
    image: ddkits/lamp5:latest
    
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
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_lamp5_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_lamp5_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./lamp5-deploy

        break
        ;;
        "LAMP/PHP7")

if [[ ! -d "ddkits-files/lamp7/sites" ]]; then
  mkdir ddkits-files/lamp7/sites
  chmod -R 777 ddkits-files/lamp7/sites
fi


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

echo -e '

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf ./logs /var/log/nginx/access.log \
    && ln -sf ./logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf 
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
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_lamp7_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_lamp7_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./lamp7-deploy



        break
        ;;

        "Umbraco")

if [[ ! -d "ddkits-files/umbracco/sites" ]]; then
  mkdir ddkits-files/umbracco/sites
  chmod -R 777 ddkits-files/umbracco/sites
fi

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

if [[ ! -d "ddkits-files/magento/sites" ]]; then
  mkdir ddkits-files/magento/sites
  chmod -R 777 ddkits-files/magento/sites
fi

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

echo -e '

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf ./logs /var/log/nginx/access.log \
    && ln -sf ./logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf 
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
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_magento_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_magento_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./magento-deploy


        break
        ;;


"DreamFactory")

if [[ ! -d "ddkits-files/dreamf/sites" ]]; then
  mkdir ddkits-files/dreamf/sites
  chmod -R 777 ddkits-files/dreamf/sites
fi

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

echo -e '

#  Created by mutasem elayyoub ddkits.co#  Created by mutasem elayyoub ddkits.co

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf ./logs /var/log/nginx/access.log \
    && ln -sf ./logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf  
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
COPY ./sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf 

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >> ./ddkits-files/dreamf/Dockerfile

echo -e '
#!/bin/sh

#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#

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
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_dreamf_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_dreamf_web /bin/bash'" >> ~/.ddkits_alias_web
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

if [[ ! -d "ddkits-files/contao/sites" ]]; then
  mkdir ddkits-files/contao/sites
  chmod -R 777 ddkits-files/contao/sites
fi


    # delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/contao/Dockerfile" ]]; then
          rm ddkits-files/contao/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/contao/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/contao/sites/$DDKITSHOSTNAME.conf
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
</VirtualHost> ' > ./ddkits-files/contao/sites/$DDKITSHOSTNAME.conf

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
  ' >> ./ddkits-files/contao/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/contao
    image: ddkits/contao:latest
    
    volumes:
      - ./contao-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_contao_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml

if [[ ! -d "contao-deploy/public" ]]; then
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  cp ./composer.phar ./contao-deploy/public/ddkits.phar
  git clone https://github.com/ddkits/contao contao-deploy
  echo $SUDOPASS | sudo -S chmod -R 777 public ./contao-deploy
  cd ./contao-deploy
  cd public && php ddkits.phar config --global discard-changes true && php ddkits.phar install -n
  cd $DDKITSFL
  echo $SUDOPASS | sudo -S chmod -R 777 ./contao-deploy/public
fi

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_contao_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_contao_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./contao-deploy

            break
            ;;

"Elgg")

if [[ ! -d "ddkits-files/elgg/sites" ]]; then
  mkdir ddkits-files/elgg/sites
  chmod -R 777 ddkits-files/elgg/sites
fi


    # delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/elgg/Dockerfile" ]]; then
          rm ddkits-files/elgg/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/elgg/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/elgg/sites/$DDKITSHOSTNAME.conf
        fi

#  Elgg PHP 5

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
</VirtualHost> ' > ./ddkits-files/elgg/sites/$DDKITSHOSTNAME.conf

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
  ' >> ./ddkits-files/elgg/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/elgg
    image: ddkits/elgg:latest
    
    volumes:
      - ./elgg-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_elgg_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml

if [[ ! -d "elgg-deploy/public" ]]; then
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  cp ./composer.phar ./elgg-deploy/public/ddkits.phar
  git clone https://github.com/ddkits/elgg elgg-deploy
  echo $SUDOPASS | sudo -S chmod -R 777 public ./elgg-deploy
  cd ./elgg-deploy
  cd public && php ddkits.phar config --global discard-changes true && php ddkits.phar install -n
  cd $DDKITSFL
  echo $SUDOPASS | sudo -S chmod -R 777 ./elgg-deploy/public
fi

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_elgg_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_elgg_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./elgg-deploy

            break
            ;;

"Silverstripe")

if [[ ! -d "ddkits-files/ss/sites" ]]; then
  mkdir ddkits-files/ss/sites
  chmod -R 777 ddkits-files/ss/sites
fi

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

echo -e '

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf ./logs /var/log/nginx/access.log \
    && ln -sf ./logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf  
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
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_ss_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_ss_web /bin/bash'" >> ~/.ddkits_alias_web
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

if [[ ! -d "ddkits-files/cloud/sites" ]]; then
  mkdir ddkits-files/cloud/sites
  chmod -R 777 ddkits-files/cloud/sites
fi

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
fi' > ./ddkits-files/cloud/ddkits-check.sh



echo -e '
FROM ddkits/lamp:latest

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
  && apt-get install -y --force-yes apt-transport-https 

RUN chmod -R 777 /var/www/html 
RUN chmod u+x /var/www/html/ddkits-check.sh
RUN apt-get -f install -y 
RUN a2enmod headers \
  && a2enmod env \
  && a2enmod dir \
  && a2enmod mime \
  && service apache2 reload 
  RUN apt-get update \
    && apt-get upgrade
  # Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

  ' > ./ddkits-files/cloud/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/cloud
    image: ddkits/cloud:latest
    
    volumes:
      - ./cloud-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_cloud_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml




# Installing ownCloud9 on local host 

   
if [[ ! -d "cloud-deploy/public" ]]; then
  DDKITSFL=$(pwd)
  echo $DDKITSFL
mkdir ./cloud-deploy
chmod -R 777 ./cloud-deploy/public
cd ./cloud-deploy
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
chmod -R 777 ./cloud-deploy/public
fi

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_cloud_web /bin/bash'
alias ddkc-$DDKITSSITES-fix='docker exec -it '$DDKITSHOSTNAME'_ddkits_cloud_web /bin/bash /var/www/html/ddkits-check.sh'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_cloud_web /bin/bash'" >> ~/.ddkits_alias_web
echo "alias ddkc-"$DDKITSSITES"-fix='docker exec -it "$DDKITSHOSTNAME"_ddkits_cloud_web /bin/bash /var/www/html/ddkits-check.sh'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./cloud-deploy
echo $SUDOPASS | sudo -S chmod -R 0770 ./cloud-deploy/public/data

            break
            ;;
"ZenCart")

if [[ ! -d "ddkits-files/zenc/sites" ]]; then
  mkdir ddkits-files/zenc/sites
  chmod -R 777 ddkits-files/zenc/sites
fi


    # delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/zenc/Dockerfile" ]]; then
          rm ddkits-files/zenc/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/zenc/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/zenc/sites/$DDKITSHOSTNAME.conf
        fi

#  zenc PHP 5

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
</VirtualHost> ' > ./ddkits-files/zenc/sites/$DDKITSHOSTNAME.conf

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
  ' >> ./ddkits-files/zenc/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/zenc
    image: ddkits/zenc:latest
    
    volumes:
      - ./zenc-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_zenc_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml

if [[ ! -d "zenc-deploy/public" ]]; then
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  cp ./composer.phar ./zenc-deploy/public/ddkits.phar
  git clone https://github.com/ddkits/zencart zenc-deploy
  echo $SUDOPASS | sudo -S chmod -R 777 public ./zenc-deploy
  cd ./zenc-deploy
  cd public && php ddkits.phar config --global discard-changes true && php ddkits.phar install -n
  cd $DDKITSFL
  echo $SUDOPASS | sudo -S chmod -R 777 ./zenc-deploy/public
fi

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_zenc_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_zenc_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./zenc-deploy

            break
            ;;

"Symfony")


if [[ ! -d "ddkits-files/symfony/sites" ]]; then
  mkdir ddkits-files/symfony/sites
  chmod -R 777 ddkits-files/symfony/sites
fi

    # delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/symfony/Dockerfile" ]]; then
          rm ddkits-files/symfony/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/symfony/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/symfony/sites/$DDKITSHOSTNAME.conf
        fi

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
</VirtualHost> ' > ./ddkits-files/symfony/sites/$DDKITSHOSTNAME.conf

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
  ' >> ./ddkits-files/symfony/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/symfony
    image: ddkits/symfony:latest
    
    volumes:
      - ./symfony-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_symfony_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml



if [[ ! -d "symfony-deploy/public" ]]; then
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  echo $SUDOPASS | sudo -S curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
  echo $SUDOPASS | sudo -S chmod a+x /usr/local/bin/symfony
  mkdir symfony-deploy
  echo $SUDOPASS | sudo -S chmod -R 777 public ./symfony-deploy
  symfony new symfony-deploy/public
  cp ./composer.phar ./symfony-deploy/public/ddkits.phar
  cd ./symfony-deploy
  cd public && php ddkits.phar config --global discard-changes true && php ddkits.phar install -n
  cd $DDKITSFL
  echo $SUDOPASS | sudo -S chmod -R 777 ./symfony-deploy/public
fi


# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_symfony_web /bin/bash'
alias ddkc-$DDKITSSITES-run='docker exec -it '$DDKITSHOSTNAME'_ddkits_symfony_web /bin/bash php public/bin/console server:run 127.0.0.1:8000'

#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_symfony_web /bin/bash'" >> ~/.ddkits_alias_web
echo "alias ddkc-"$DDKITSSITES"-run='docker exec -it "$DDKITSHOSTNAME"_ddkits_symfony_web /bin/bash php public/bin/console server:run 127.0.0.1:8000'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./symfony-deploy

        break
        ;;
"Expression Engine")

if [[ ! -d "ddkits-files/eengine/sites" ]]; then
  mkdir ddkits-files/eengine/sites
  chmod -R 777 ddkits-files/eengine/sites
fi


    # delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/eengine/Dockerfile" ]]; then
          rm ddkits-files/eengine/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/eengine/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/eengine/sites/$DDKITSHOSTNAME.conf
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
</VirtualHost> ' > ./ddkits-files/eengine/sites/$DDKITSHOSTNAME.conf

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
  ' >> ./ddkits-files/eengine/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/eengine
    image: ddkits/eengine:latest
    
    volumes:
      - ./eengine-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_eengine_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml

if [[ ! -d "eengine-deploy/public" ]]; then
  DDKITSFL=$(pwd)
  echo $DDKITSFL
  cp ./composer.phar ./eengine-deploy/public/ddkits.phar
  git clone https://github.com/ddkits/eengine eengine-deploy
  echo $SUDOPASS | sudo -S chmod -R 777 public ./eengine-deploy
  cd ./eengine-deploy
  cd public && php ddkits.phar config --global discard-changes true && php ddkits.phar install -n
  cd $DDKITSFL
  echo $SUDOPASS | sudo -S chmod -R 777 ./eengine-deploy/public
fi

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_eengine_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_eengine_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./eengine-deploy

        break
            ;;


"Zend")

if [[ ! -d "ddkits-files/zend/sites" ]]; then
  mkdir ddkits-files/zend/sites
  chmod -R 777 ddkits-files/zend/sites
fi


    # delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/zend/Dockerfile" ]]; then
          rm ddkits-files/zend/Dockerfile
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/zend/composer.json" ]]; then
          rm ddkits-files/zend/composer.json
        fi
        # delete the old environment yml file
        if [[ -f "ddkits-files/ddkits.fix.sh" ]]; then
          rm ddkits-files/ddkits.fix.sh
        fi
        if [[ -f "ddkits-files/zend/sites/$DDKITSHOSTNAME.conf" ]]; then
          rm ddkits-files/zend/sites/$DDKITSHOSTNAME.conf
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
</VirtualHost> ' > ./ddkits-files/zend/sites/$DDKITSHOSTNAME.conf

echo -e '

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN ln -sf ./logs /var/log/nginx/access.log \
    && ln -sf ./logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf  
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
COPY ./sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf 


# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
' >> ./ddkits-files/zend/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: ./ddkits-files/zend
    image: ddkits/zend:latest
    
    volumes:
      - ./zend-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_zend_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> ddkits.env.yml


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
      "./vendor/bin/phplint",
      "./vendor/bin/phpcs --config-set installed_paths ./../../drupal/coder/coder_sniffer",
      "./vendor/bin/phpcs -n --report=full --standard=Drupal --ignore=*.tpl.php --extensions=install,module,php,inc"
    ],
    "test": [
      "./vendor/bin/phplint --no-cache",
      "./vendor/bin/phpcs --config-set installed_paths ./../../drupal/coder/coder_sniffer",
      "./vendor/bin/phpcs -n --report=full --standard=Drupal --ignore=*.tpl.php --extensions=php,inc themes || true"
    ]
  }  
}

' >> ./ddkits-files/zend/composer.json



if [[ ! -d "zend-deploy/public" ]]; then
  DDKITSFL=$(pwd)
  cp -R ddkits-files/zend/composer.json ./
  cp composer.phar ./ddkits.phar
  php ddkits.phar config --global discard-changes true
  php ddkits.phar require zendframework/zendframework && php ddkits.phar install -n
  php ddkits.phar create-project zendframework/skeleton-application zend-deploy/
  cd $DDKITSFL
  echo $SUDOPASS | sudo -S chmod -R 777 public ./zend-deploy
  echo $SUDOPASS | sudo -S chmod -R 777 ./zend-deploy/public
fi

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias > /dev/null
alias ddkc-$DDKITSSITES='docker exec -it '$DDKITSHOSTNAME'_ddkits_zend_web /bin/bash'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_zend_web /bin/bash'" >> ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 ./zend-deploy

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
# find existing instances in the host file and save the line numbers


matches_in_hosts="$(grep -n ${DDKITSSITES} /etc/hosts | cut -f1 -d:)"
ddkits_matches_in_hosts="$(grep -n jenkins.${DDKITSSITES} admin.${DDKITSSITES} solr.${DDKITSSITES} /etc/hosts | cut -f1 -d:)"
host_entry="${DDKITSIP} ${DDKITSSITES} ${DDKITSSITESALIAS} ${DDKITSSITESALIAS2} ${DDKITSSITESALIAS3}"
ddkits_host_entry="${DDKITSIP}  ddkits.site jenkins.${DDKITSSITES} admin.${DDKITSSITES} solr.${DDKITSSITES}"

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
echo ${SUDOPASS} | sudo -S cat /etc/hosts

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

if [[ "$JENKINS_ANSWER" == "y" ]] && [[ "$SOLR_ANSWER" == "y" ]]; then
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
    build: ./ddkits-files/jenkins
    image: ddkits/jenkins:latest
    ports:
      - "'$DDKITSJENKINSPORT':8080"
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

fi

# Create our system ddkits enviroment

if [[ "$JENKINS_ANSWER" == "n" ]] && [[ "$SOLR_ANSWER" == "y" ]]; then
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
  
networks:
    ddkits:

  ' >> ddkitsnew.yml

fi

# Create our system ddkits enviroment

if [[ "$JENKINS_ANSWER" == "y" ]] && [[ "$SOLR_ANSWER" == "n" ]]; then
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
    build: ./ddkits-files/jenkins
    image: ddkits/jenkins:latest
    ports:
      - "'$DDKITSJENKINSPORT':8080"
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

fi

# Create our system ddkits enviroment

if [[ "$JENKINS_ANSWER" == "n" ]] && [[ "$SOLR_ANSWER" == "n" ]]; then
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

networks:
    ddkits:

  ' >> ddkitsnew.yml

fi

# create get into ddkits container
alias ddkc-$DDKITSSITES-cache='docker exec -it '$DDKITSHOSTNAME'_ddkits_cache /bin/bash'
alias ddkc-$DDKITSSITES-jen='docker exec -it ddkits_jenkins /bin/bash'
alias ddkc-$DDKITSSITES-solr='docker exec -it '$DDKITSHOSTNAME'_ddkits_solr /bin/bash'
alias ddkc-$DDKITSSITES-admin='docker exec -it '$DDKITSHOSTNAME'_ddkits_admin /bin/bash'
alias ddkc-ddkits='docker exec -it ddkits /bin/bash'

echo "alias ddkc-"$DDKITSSITES"-cache='docker exec -it "$DDKITSHOSTNAME"_ddkits_cache /bin/bash'" >> ~/.ddkits_alias_web
echo "alias ddkc-"$DDKITSSITES"-jen='docker exec -it ddkits_jenkins /bin/bash'" >> ~/.ddkits_alias_web
echo "alias ddkc-"$DDKITSSITES"-solr='docker exec -it "$DDKITSHOSTNAME"_ddkits_solr /bin/bash'" >> ~/.ddkits_alias_web
echo "alias ddkc-"$DDKITSSITES"-admin='docker exec -it "$DDKITSHOSTNAME"_ddkits_admin /bin/bash'" >> ~/.ddkits_alias_web



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

echo $SUDOPASS | sudo -S cat ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod u+x ~/.ddkits_alias_web
source ~/.ddkits_alias_web
source ~/.ddkits_alias
echo $SUDOPASS | sudo -S echo 'source ~/.ddkits_alias' >> ~/.bashrc_profile
echo $SUDOPASS | sudo -S echo 'source ~/.ddkits_alias_web' >> ~/.bashrc_profile

#  prepare ddkits container for the new websites
echo -e 'copying conf files into ddkits and restart'
docker cp ./ddkits-files/ddkits/sites/ddkitscust.conf ddkits:/etc/apache2/sites-enabled/ddkits_$DDKITSHOSTNAME.conf
# docker cp ./ddkitscli.sh $DDKITSHOSTNAME'_ddkits_joomla_web':/var/www/html/ddkitscli.sh

docker restart ddkits
ddk go
