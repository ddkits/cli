#!/bin/sh

#  Script.sh
#
#
#
# This system built by Mutasem Elayyoub DDKits.com
# insert DDKits alias into anyh system command lines
DDKITSFL=$(pwd)
export $DDKITSFL

# create DDKits files to start the installation
mkdir $DDKITSFL/.ddkits-files
mkdir $DDKITSFL/.ddkits-files/ddkits
mkdir $DDKITSFL/.ddkits-files/ddkits/sites
mkdir $DDKITSFL/.ddkits-files/ddkits/ssl
echo -e '.ddkits-files/' >> .gitignore

echo -e "
  Welcome to DDKits Development Version
  "
#  check the container ip
 ddk ip

#  delete ddkits conf file for the custom site if available
if [ -f "./.ddkits-files/ddkits/sites/ddkitscust.conf" ]; then
  rm ./.ddkits-files/ddkits/sites/ddkitscust.conf
fi

echo -e "DDKits required field are all required please make sure to write them correct. \n
  Your DDKits IP is : '$DDKITSIP'\n
  in case of using your localhost then please ignore this ip and use your localhost ip (127.0.0.1)\n
  to cancel anytime use the regular system command ==> ctrl+c
  "
echo -e "Enter your E-mail address that you want to use in your website as an admin: "
read MAIL_ADDRESS

echo -e 'Enter your Domain Name:  '
read DDKITSSITES
echo -e ""
echo -e ' domain alias (ex. www.ddkits.site) if there is no alias just leave this blank '
read DDKITSSITESALIAS
if [[ "$DDKITSSITESALIAS" == "" ]]; then
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
      <IfModule mod_ssl.c>
        <VirtualHost *:443>
                ServerAdmin webmaster@localhost
                DocumentRoot /var/www/html
                ServerName "$DDKITSSITES"
                ProxyPreserveHost on
                # Proxy HTTP requests
                ProxyPass / http://"$DDKITSIP":"$DDKITSWEBPORT"/ 
                ProxyPassReverse / http://"$DDKITSIP":"$DDKITSWEBPORT"/
                
                <Directory /var/www/html/>
                    Options FollowSymLinks
                    AllowOverride All
                    Require all granted
                </Directory>

                ErrorLog /var/www/html/error.log
                CustomLog /var/www/html/access.log combined
                SSLCertificateFile /etc/ssl/certs/"$DDKITSSITES".crt
                SSLCertificateKeyFile /etc/ssl/certs/"$DDKITSSITES".key
        </VirtualHost>
        </IfModule>
      <VirtualHost *:443>
        ServerName "$DDKITSSITES"
        ProxyRequests Off
        ProxyPreserveHost on

        # Enable/Disable SSL for this virtual host.
        SSLEngine on

        SSLProtocol all -SSLv2 -SSLv3
        SSLHonorCipherOrder On
        SSLCipherSuite ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS

        SSLCertificateFile /etc/ssl/certs/"$DDKITSSITES".crt
        SSLCertificateKeyFile /etc/ssl/certs/"$DDKITSSITES".key
        SSLCACertificatePath /etc/ssl/certs/
        
        # Proxy HTTP requests
        ProxyPass / https://"$DDKITSIP":"$DDKITSWEBPORTSSL"/ 
        ProxyPassReverse / https://"$DDKITSIP":"$DDKITSWEBPORTSSL"/

        Timeout 2400
        ProxyTimeout 2400
        ProxyBadHeader Ignore 
      </VirtualHost>
      <VirtualHost *:80>
        ServerName solr."$DDKITSSITES".ddkits.site
        ProxyPreserveHost on
        ProxyPass / http://"$DDKITSIP":"$DDKITSSOLRPORT"/ 
        ProxyPassReverse / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
        Timeout 2400
        ProxyTimeout 2400
        ProxyBadHeader Ignore 
      </VirtualHost>
      <VirtualHost *:80>
        ServerName jenkins."$DDKITSSITES".ddkits.site
        ProxyPreserveHost on
        ProxyPass / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/ 
        ProxyPassReverse / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
        Timeout 2400
        ProxyTimeout 2400
        ProxyBadHeader Ignore 
      </VirtualHost>
      <VirtualHost *:80>
        ServerName admin."$DDKITSSITES".ddkits.site
        ProxyPreserveHost on
        ProxyPass / http://"$DDKITSIP":"$DDKITSADMINPORT"/ 
        ProxyPassReverse / http://"$DDKITSIP":"$DDKITSADMINPORT"/
        Timeout 2400
        ProxyTimeout 2400
        ProxyBadHeader Ignore 
      </VirtualHost>

      " >./.ddkits-files/ddkits/sites/ddkitscust.conf
else
  echo -e ""

  echo -e ' domain alias 2 (ex. www.ddkits.site) if there is no alias just leave this blank'
  read DDKITSSITESALIAS2
  if [[ "$DDKITSSITESALIAS2" == "" ]]; then
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
            <VirtualHost *:443>
        ServerName "$DDKITSSITES"
        ProxyPreserveHost on
        ProxyPass / https://"$DDKITSIP":"$DDKITSWEBPORTSSL"/ 
        ProxyPassReverse / https://"$DDKITSIP":"$DDKITSWEBPORTSSL"/
        Timeout 2400
        ProxyTimeout 2400
        ProxyBadHeader Ignore 
      </VirtualHost>
        <VirtualHost *:80>
          ServerName solr."$DDKITSSITES".ddkits.site
          ProxyPreserveHost on
          ProxyPass / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
          ProxyPassReverse / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
              Timeout 2400
              ProxyTimeout 2400
              ProxyBadHeader Ignore 
        </VirtualHost>

        <VirtualHost *:80>
          ServerName jenkins."$DDKITSSITES".ddkits.site
          ProxyPreserveHost on
          ProxyPass / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
          ProxyPassReverse / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
              Timeout 2400
              ProxyTimeout 2400
              ProxyBadHeader Ignore 
        </VirtualHost>

        <VirtualHost *:80>
          ServerName admin."$DDKITSSITES".ddkits.site
          ProxyPreserveHost on
          ProxyPass / http://"$DDKITSIP":"$DDKITSADMINPORT"/
          ProxyPassReverse / http://"$DDKITSIP":"$DDKITSADMINPORT"/
              Timeout 2400
              ProxyTimeout 2400
              ProxyBadHeader Ignore 
        </VirtualHost>

          " >./.ddkits-files/ddkits/sites/ddkitscust.conf
  else
    echo -e ""
    echo -e ' domain alias 3 (ex. www.ddkits.site) if there is no alias just leave this blank'
    read DDKITSSITESALIAS3
    if [[ "$DDKITSSITESALIAS3" == "" ]]; then
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
            <VirtualHost *:443>
        ServerName "$DDKITSSITES"
        ProxyPreserveHost on
        ProxyPass / https://"$DDKITSIP":"$DDKITSWEBPORTSSL"/ 
        ProxyPassReverse / https://"$DDKITSIP":"$DDKITSWEBPORTSSL"/
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
    ServerName solr."$DDKITSSITES".ddkits.site
    ProxyPreserveHost on
    ProxyPass / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
    ProxyPassReverse / http://"$DDKITSIP":"$DDKITSSOLRPORT"/
        Timeout 2400
        ProxyTimeout 2400
        ProxyBadHeader Ignore 
  </VirtualHost>

  <VirtualHost *:80>
    ServerName jenkins."$DDKITSSITES".ddkits.site
    ProxyPreserveHost on
    ProxyPass / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
    ProxyPassReverse / http://"$DDKITSIP":"$DDKITSJENKINSPORT"/
        Timeout 2400
        ProxyTimeout 2400
        ProxyBadHeader Ignore 
  </VirtualHost>

  <VirtualHost *:80>
    ServerName admin."$DDKITSSITES".ddkits.site
    ProxyPreserveHost on
    ProxyPass / http://"$DDKITSIP":"$DDKITSADMINPORT"/
    ProxyPassReverse / http://"$DDKITSIP":"$DDKITSADMINPORT"/
        Timeout 2400
        ProxyTimeout 2400
        ProxyBadHeader Ignore 
  </VirtualHost>

            " >./.ddkits-files/ddkits/sites/ddkitscust.conf
    fi
  fi
fi
echo -e ""
# echo -e 'Enter your Sudo Password:  '
# read -s SUDOPASS
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
cat $LOGO

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

echo -e "'Do you have docker, docker compose and machine installed properly on your machine? (if you said No DDKits will install all the required to make sure they are working fine.)'"
DDKITS_DOCKER='Do you have docker'
options=("Yes" "No" "Quit")
select opt in "${options[@]}"; do
  case $opt in
  "Yes")
    echo 'This machine is '$PLATFORM' No need to install Docker then :-)'
    break
    ;;
  "No")
    echo 'This machine is '$PLATFORM' Docker setup will start now'
    if [[ $PLATFORM == 'linux-gnu' ]]; then
      curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m) >/usr/local/bin/docker-compose
      curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
        chmod +x /tmp/docker-machine &&
        echo $SUDOPASS | sudo -S cp /tmp/docker-machine /usr/local/bin/docker-machine
      echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-compose
    elif [[ $PLATFORM == 'MacOS' ]]; then
      curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m) >/usr/local/bin/docker-compose
      curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-$(uname -s)-$(uname -m) >/usr/local/bin/docker-machine &&
        echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-machine
      echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-compose
    elif [[ $PLATFORM == 'linux-gnu' ]]; then
      echo 'This machine is '$PLATFORM' Docker setup will start now'
    elif [[ $PLATFORM == 'cygwin' ]]; then
      echo 'This machine is '$PLATFORM' Docker setup will start now'
    elif [[ $PLATFORM == 'msys' ]]; then
      echo 'This machine is '$PLATFORM' Docker setup will start now'
    elif [[ $PLATFORM == 'win32' ]]; then
      if [[ ! -d "$HOME/bin" ]]; then mkdir -p "$HOME/bin"; fi &&
        curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m) >/usr/local/bin/docker-compose
      curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-Windows-x86_64.exe >"$HOME/bin/docker-machine.exe" &&
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
  *) echo invalid option ;;
  esac
done

clear
cat $LOGO

# echo -e "Enter your E-mail address that you want to use in your website as an admin: "
#
# read MAIL_ADDRESS
#   echo -e ""
JENKINS_ONLY='false'
DDKITSHOSTNAME=${DDKITSSITES//./_}

if [[ -f $DDKITSFL'/.ddkits-files/ddkitscli.sh' ]]; then
  rm -rf $DDKITSFL/.ddkits-files/ddkitscli.sh
fi

echo -e "
  #!/bin/sh

  #  Script.sh
  #
  #
  #  Created by mutasem elayyoub ddkits.com
  #

  DDKITSSITES='"$DDKITSSITES"'
  DDKITSIP='"$DDKITSIP"'
  MYSQL_USER='"$MYSQL_USER"'
  MYSQL_ROOT_PASSWORD='"$MYSQL_ROOT_PASSWORD"'
  MYSQL_DATABASE='"$MYSQL_DATABASE"'
  MYSQL_PASSWORD='"$MYSQL_PASSWORD"'
  MAIL_ADDRESS='"$MAIL_ADDRESS"'" >$DDKITSFL/.ddkits-files/ddkitscli.sh
# cat $DDKITSFL/.ddkits-files/ddkits-drupal.sh >> $DDKITSFL/.ddkits-files/ddkitscli.sh



DDKITSWEBPORT="$(awk -v min=1000 -v max=1500 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
echo -e "  Your new Web port is  ${DDKITSWEBPORT}  "
DDKITSWEBPORTSSL="$(awk -v min=6001 -v max=7000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
echo -e "  Your new Web SSL port is  ${DDKITSWEBPORTSSL}  "
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

export DDKITSDBPORT=$DDKITSDBPORT
export DDKITSREDISPORT=$DDKITSREDISPORT
export DDKITSSOLRPORT=$DDKITSSOLRPORT
export DDKITSADMINPORT=$DDKITSADMINPORT
export DDKITSWEBPORT=$DDKITSWEBPORT
export DDKITSWEBPORTSSL=$DDKITSWEBPORTSSL
export DDKITSJENKINSPORT=$DDKITSJENKINSPORT
export DDKITSFL=$(pwd)

if [[ -f $DDKITSFL'/.ddkits-files/ddkitsInfo.ports.sh' ]]; then
  rm -rf $DDKITSFL/.ddkits-files/ddkitsInfo.ports.sh
fi

echo -e '

#!/bin/sh

#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#

export DDKITSFL='${$DDKITSFL}'
export DDKITSDBPORT='${DDKITSDBPORT}'
export SUDOPASS='${SUDOPASS}'
export DDKITSREDISPORT='${DDKITSREDISPORT}'
export DDKITSSOLRPORT='${DDKITSSOLRPORT}'
export DDKITSADMINPORT='${DDKITSADMINPORT}'
export DDKITSWEBPORT='${DDKITSWEBPORT}'
export DDKITSWEBPORTSSL='${DDKITSWEBPORTSSL}'
export DDKITSJENKINSPORT='${DDKITSJENKINSPORT}'
' >$DDKITSFL/.ddkits-files/ddkitsInfo.ports.sh

source $DDKITSFL'/ddkits.dev.sh'

cat $LOGO

# Create our system ddkits enviroment
if [[ "$JENKINS_ONLY" == "true" ]]; then
  echo -e 'version: "3.1"

services:
  cache:
    image: redis:latest
    container_name: '$DDKITSHOSTNAME'_ddkits_cache
    networks:
      - ddkits
    ports:
      - "'$DDKITSREDISPORT':'$DDKITSREDISPORT'"

networks:
    ddkits:

  ' >$DDKITSFL/ddkitsnew.yml

elif [[ "$JENKINS_ANSWER" == "y" ]] && [[ "$SOLR_ANSWER" == "y" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
  echo -e 'version: "3.1"

services:
  mariadb:
    build: ./.ddkits-files/db
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
    build: ./.ddkits-files/solr
    image: ddkits/solr:latest
    container_name: '$DDKITSHOSTNAME'_ddkits_solr
    networks:
      - ddkits
    ports:
      - "'$DDKITSSOLRPORT':8983"

  phpmyadmin:
    build: ./.ddkits-files/phpmyadmin
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
    build: ./.ddkits-files/jenkins
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

  ' >$DDKITSFL/ddkitsnew.yml

# Create our system ddkits enviroment

elif [[ "$JENKINS_ANSWER" == "n" ]] && [[ "$SOLR_ANSWER" == "y" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
  echo -e 'version: "3.1"

services:
  mariadb:
    build: ./.ddkits-files/db
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
    build: ./.ddkits-files/solr
    image: ddkits/solr:latest
    container_name: '$DDKITSHOSTNAME'_ddkits_solr
    networks:
      - ddkits
    ports:
      - "'$DDKITSSOLRPORT':8983"

  phpmyadmin:
    build: ./.ddkits-files/phpmyadmin
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

  ' >$DDKITSFL/ddkitsnew.yml

# Create our system ddkits enviroment

elif [[ "$JENKINS_ANSWER" == "y" ]] && [[ "$SOLR_ANSWER" == "n" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
  echo -e 'version: "3.1"

services:
  mariadb:
    build: ./.ddkits-files/db
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
    build: ./.ddkits-files/phpmyadmin
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
    build: ./.ddkits-files/jenkins
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

  ' >$DDKITSFL/ddkitsnew.yml

# Create our system ddkits enviroment

elif [[ "$JENKINS_ANSWER" == "n" ]] && [[ "$SOLR_ANSWER" == "n" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
  echo -e 'version: "3.1"

services:
  mariadb:
    build: ./.ddkits-files/db
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
    build: ./.ddkits-files/phpmyadmin
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

  ' >$DDKITSFL/ddkitsnew.yml

fi

# create get into ddkits container
alias ddkc-$DDKITSSITES-cache='docker exec -it '$DDKITSHOSTNAME'_ddkits_cache /bin/bash'
alias ddkc-$DDKITSSITES-jen='docker exec -it ddkits_jenkins /bin/bash'
alias ddkc-$DDKITSSITES-solr='docker exec -it '$DDKITSHOSTNAME'_ddkits_solr /bin/bash'
alias ddkc-$DDKITSSITES-admin='docker exec -it '$DDKITSHOSTNAME'_ddkits_admin /bin/bash'
alias ddkc-ddkits='docker exec -it ddkits /bin/bash'

# echo "alias ddkc-"$DDKITSSITES"-cache='docker exec -it "$DDKITSHOSTNAME"_ddkits_cache /bin/bash'" >> ~/.ddkits_alias_web
# echo "alias ddkc-"$DDKITSSITES"-jen='docker exec -it ddkits_jenkins /bin/bash'" >> ~/.ddkits_alias_web
# echo "alias ddkc-"$DDKITSSITES"-solr='docker exec -it "$DDKITSHOSTNAME"_ddkits_solr /bin/bash'" >> ~/.ddkits_alias_web
# echo "alias ddkc-"$DDKITSSITES"-admin='docker exec -it "$DDKITSHOSTNAME"_ddkits_admin /bin/bash'" >> ~/.ddkits_alias_web

# New entry check to stay out of duplications
entry1="alias ddkc-"$DDKITSSITES"-cache='docker exec -it "$DDKITSHOSTNAME"_ddkits_cache /bin/bash' \n"
entry2="alias ddkc-"$DDKITSSITES"-jen='docker exec -it "$DDKITSHOSTNAME"_ddkits_jenkins /bin/bash' \n"
entry3="alias ddkc-"$DDKITSSITES"-solr='docker exec -it "$DDKITSHOSTNAME"_ddkits_solr /bin/bash' \n"
entry4="alias ddkc-"$DDKITSSITES"-admin='docker exec -it "$DDKITSHOSTNAME"_ddkits_admin /bin/bash' \n"
entry=($entry1 $entry2 $entry3 $entry4)
matches="$(grep -n ${DDKITSSITES} ~/.ddkits_alias_web | cut -f1 -d:)"

if [ ! -z "$matches" ]; then
  echo "Updating existing entry."

  # iterate over the line numbers on which matches were found
  while read -r line_number; do
    # replace the text of each line with the desired entry
    echo ${SUDOPASS} | sudo -S sed -i '' "/${line_number}/d" ~/.ddkits_alias_web
  done <<<"$matches"
fi
echo "Adding new entry."
  echo "${entry1}" | sudo tee -a ~/.ddkits_alias_web >/dev/null
  echo "${entry2}" | sudo tee -a ~/.ddkits_alias_web >/dev/null
  echo "${entry3}" | sudo tee -a ~/.ddkits_alias_web >/dev/null
  echo "${entry4}" | sudo tee -a ~/.ddkits_alias_web >/dev/null
  echo "alias ddkc-ddkits='docker exec -it ddkits /bin/bash' \n" | sudo tee -a ~/.ddkits_alias_web >/dev/null
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
DDKits SSL ip = '$DDKITSIP' ==> Port = '$DDKITSWEBPORTSSL'<br />
Mysql User = '$MYSQL_USER'<br />
Mysql User Password = '$MYSQL_ROOT_PASSWORD'<br />
Database name =' $MYSQL_DATABASE'<br />
Mysql $MYSQL_USER Password = '$MYSQL_PASSWORD'<br />
Website Alias = '$DDKITSSITESALIAS' '$DDKITSSITESALIAS2' '$DDKITSSITESALIAS3'<br />
<br />
Ports:<br />
<br />
- Your new '$DDKITSSITES' port is: '$DDKITSWEBPORT'<br />
- Your new SSL port is: '$DDKITSWEBPORT'<br />
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
# --></body></html>' >./ddkits-$DDKITSHOSTNAME.html

echo -e '
MAIL_ADDRESS = '$MAIL_ADDRESS'
Website = '$DDKITSSITES'
DDKits ip = '$DDKITSIP' ==> Port = '$DDKITSWEBPORT'
DDKits SSL ip = '$DDKITSIP' ==> Port = '$DDKITSWEBPORTSSL'
Mysql User = '$MYSQL_USER'
Mysql User Password = '$MYSQL_ROOT_PASSWORD'
Database name =' $MYSQL_DATABASE'
Mysql $MYSQL_USER Password = '$MYSQL_PASSWORD'
Website Alias = '$DDKITSSITESALIAS' '$DDKITSSITESALIAS2' '$DDKITSSITESALIAS3'

Ports:

- Your new '$DDKITSSITES' port is: '$DDKITSWEBPORT'
- Your new '$DDKITSSITES' port SSL is: '$DDKITSWEBPORTSSL'
- Your new DB port is: '$DDKITSDBPORT'
- Your new Jenkins port is: '$DDKITSJENKINSPORT'
- Your new Solr port is: '$DDKITSSOLRPORT'
- Your new PhpMyAdmin port is: '$DDKITSADMINPORT'
- Your new Radis port is: '$DDKITSREDISPORT'

Thank you for using DDKits, feel free to contact us @ melayyoub@outlook.com 
Copyright @2017 DDKits.com. Mutasem Elayyoub 
' >./.ddkits-files/ddkits/site.txt

if [ -f "ddkits.prod.sh" ]; then
  echo -e 'Production'
else
  # Remove the Source from Bash file
  BASHSITE=ddk
  matchesbash="$(grep -n ${BASHSITE} ~/.bash_profile | cut -f1 -d:)"
  if [ ! -z "$matchesbash" ]; then
    echo "Updating Hosts file"

    # iterate over the line numbers on which matches were found
    while read -r line_number; do
      # Remove all DDkits entries
      echo ${SUDOPASS} | sudo -S sed -i '' "/${line_number}/d" ~/.bash_profile
    done <<<"$matchesbash"
  fi
  echo $SUDOPASS | sudo -S echo 'source ~/.ddkits_alias' >>~/.bashrc_profile
  echo $SUDOPASS | sudo -S echo 'source ~/.ddkits_alias_web' >>~/.bashrc_profile
  # echo $SUDOPASS | sudo -S cat ~/.ddkits_alias_web
  echo $SUDOPASS | sudo -S chmod u+x ~/.ddkits_alias_web
  source ~/.bash_profile

fi

#  prepare ddkits container for the new websites
echo -e 'copying conf files into ddkits and restart'
docker cp ./.ddkits-files/ddkits/sites/ddkitscust.conf ddkits:/etc/apache2/sites-enabled/ddkits_$DDKITSHOSTNAME.conf
# docker cp ./ddkitscli.sh $DDKITSHOSTNAME'_ddkits_joomla_web':/var/www/html/ddkitscli.sh
# copy ssl crt keys to ddkits proxy
docker cp ./.ddkits-files/ddkits/ssl/$DDKITSSITES.crt ddkits:/etc/ssl/certs/$DDKITSSITES.crt
docker cp ./.ddkits-files/ddkits/ssl/$DDKITSSITES.key ddkits:/etc/ssl/certs/$DDKITSSITES.key

docker restart ddkits
ddk go

echo -e '
###################################################################################################################
#  make sure to restart the apachectl after fixing the hosts file
#  sudo apachectl restart   OR sudo service apache2 restart OR by manual restart it within the UI panel
###################################################################################################################
'