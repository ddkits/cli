#!/bin/sh"

# This system built by Mutasem Elayyoub DDKits.com
# insert DDKits alias into anyh system command lines
. ddkits.alias.sh

#  built by  by Mutasem Elayyoub DDKits.com"
DDKITSIP=$(docker-machine ip)

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

echo -e "\033[33;32m"
echo -e "DDKits required field are all required please make sure to write them correct. \n
Your docker IP is : '$DDKITSIP'\n
to cancel anytime use the regular system command ==> ctrl+c
"

  echo -e "\033[33;30m" 
	echo -e "Enter your E-mail address that you want to use in your website as an admin: "
	echo -e "\033[33;30m "
read MAIL_ADDRESS 
	echo -e "\033[33;30m"	
	DDKITSWEBPORT="$(awk -v min=1000 -v max=1500 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
  echo -e "Your new Web port is \033[33;31m ${DDKITSWEBPORT}  \033[33;30m"
  DDKITSDBPORT="$(awk -v min=1501 -v max=2000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
  echo -e "Your new DB port is \033[33;31m ${DDKITSDBPORT}  \033[33;30m"
  DDKITSJENKINSPORT="$(awk -v min=4040 -v max=4140 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
  echo -e "Your new Jenkins port is \033[33;31m ${DDKITSJENKINSPORT} \033[33;30m"
  DDKITSSOLRPORT="$(awk -v min=3001 -v max=4000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
  echo -e "Your new Solr port is \033[33;31m ${DDKITSSOLRPORT} \033[33;30m"
  DDKITSADMINPORT="$(awk -v min=4101 -v max=5000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
  echo -e "Your new PhpMyAdmin port is \033[33;31m ${DDKITSADMINPORT} \033[33;30m"
  DDKITSREDISPORT="$(awk -v min=5001 -v max=6000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
  echo -e "Your new Radis port is \033[33;31m ${DDKITSREDISPORT} \033[33;30m"
	echo -e "\033[33;31m"
	echo -e 'Enter your Domain Name: \033[33;32m '
	echo -e "\033[33;30m "
read DDKITSSITES
	echo -e "\033[33;31m"
	echo -e ' domain alias (ex. www.ddkits.site) if there is no alias just leave this blank'
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
	echo -e "\033[33;31m"
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
			echo -e "\033[33;31m"
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
	echo -e "\033[33;31m"
	echo -e 'Enter your Sudo Password: \033[33;32m '
	echo -e "\033[33;30m "
read SUDOPASS
	echo -e "\033[33;31m"
	echo -e 'Enter your MYSQL ROOT USER: \033[33;32m '
	echo -e "\033[33;30m "
read MYSQL_USER
	echo -e "\033[33;31m"
	echo -e 'Enter your MYSQL ROOT USER Password: \033[33;32m '
	echo -e "\033[33;30m "
read MYSQL_ROOT_PASSWORD
	echo -e "\033[33;31m"
	echo -e 'Enter your MYSQL DataBase: \033[33;32m '
	echo -e "\033[33;30m "
read MYSQL_DATABASE
	echo -e "\033[33;30m "
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
#   echo -e "\033[33;30m "
# read MAIL_ADDRESS 
#   echo -e "\033[33;31m"
DDKITSHOSTNAME=${DDKITSSITES//./_}
echo -e "DDKITSSITES='"$DDKITSSITES"'\n
DDKITSIP='"$DDKITSIP"'\n
MYSQL_USER='"$MYSQL_USER"'\n
MYSQL_ROOT_PASSWORD='"$MYSQL_ROOT_PASSWORD"'\n
MYSQL_DATABASE='"$MYSQL_DATABASE"'\n
MYSQL_PASSWORD='"$MYSQL_PASSWORD"'\n
MAIL_ADDRESS='"$MAIL_ADDRESS"'\n" >> ./ddkits-files/drupal/ddkitscli.sh
cat ddkits-drupal.sh >> ./ddkits-files/drupal/ddkitscli.sh
DDKITS_PLATFORM='Please pick which platform you want to install: '
options=("Drupal" "Wordpress" "Joomla" "Laravel" "LAMP/PHP5" "LAMP/PHP7" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        # case of drupal
        "Drupal")
DOCUMENTROOT="public"
# delete the old environment yml file
        if [[ -f "ddkits.env.yml" ]]; then
          rm ddkits.env.yml
        fi

# delete the old environment yml file
        if [[ -f "ddkitsnew.yml" ]]; then
          rm ddkitsnew.yml
        fi
# delete the old settings file
        # if [[ -f "ddkits-files/drupal/settings.php" ]]; then
        #   rm ./ddkits-files/drupal/settings.php
        # fi
        
if [[ -f "ddkits-files/drupal/Dockerfile" ]]; then
  rm ./ddkits-files/drupal/Dockerfile
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

RUN chmod -R 777 /var/www/html/ddkitscli.sh ' >> ./ddkits-files/drupal/Dockerfile

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
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw ' >> ./ddkits-files/wordpress/Dockerfile


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
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw ' >> ./ddkits-files/joomla/Dockerfile


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
    container_name: '$DDKITSHOSTNAME'_ddkits_wp_web
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
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw \
  && chmod -Rv 755 /var/www/html 

COPY php.ini /etc/php/7.0/fpm/php.ini
COPY ./sites/'$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf ' >> ./ddkits-files/Laravel/Dockerfile

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

alias ddklf="docker exec -d "$DDKITSHOSTNAME"_ddkits_laravel_web bash ddkits.fix.sh"
            break
            ;;
        "LAMP/PHP5")
echo -e 'version: "2"

services:
  web:
    image: ddkits/lamp:latest
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
        break
        ;;
        "LAMP/PHP7")
echo -e 'version: "2"

services:
  web:
    image: ddkits/lamp:7
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
export MYSQL_PASSWORD=$MYSQL_PASSWORD
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
      - "'$DDKITSJENKINSPORT':4040"
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



#  prepare ddkits container for the new websites
echo -e 'copying conf files into ddkits and restart'
docker cp ./ddkits-files/ddkits/sites/ddkitscust.conf ddkits:/etc/apache2/sites-enabled/ddkits_$DDKITSHOSTNAME.conf
# docker cp ./ddkitscli.sh $DDKITSHOSTNAME'_ddkits_joomla_web':/var/www/html/ddkitscli.sh

docker restart ddkits

