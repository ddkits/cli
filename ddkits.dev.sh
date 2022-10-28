#!/bin/sh

#  Script.sh
#
#
#
# This system built by Mutasem Elayyoub DDKits.com
# insert DDKits alias into anyh system command lines
# source ddkits.alias.sh
export DDKITSFL=$(pwd)

clear
cat $LOGO
echo -e "
  Welcome to DDKits Development Version
  "
# Check the DDkits container ip
ddk ip

# docker-machine ls | grep ddkits  >/dev/null && export DDKITSIP=$(docker-machine ip ddkits) || export DDKITSIP='127.0.0.1'
# echo -e 'Your DDkits ip: 
#     '${DDKITSIP}
#  delete ddkits conf file for the custom site if available
if [ -f "./ddkits-files/ddkits/sites/ddkitscust.conf" ]; then
  rm ./ddkits-files/ddkits/sites/ddkitscust.conf
fi
# check if the ddkitscli.sh exist and delete it if yes else create new one
if [ -f "ddkits-files/drupal/ddkitscli.sh" ]; then
  rm ./ddkits-files/drupal/ddkitscli.sh
  echo "we deleted the old file and created another one"
else
  echo "there is no old file we will create new file for you ==> "
fi
echo -e "DDKits required field are all required please make sure to write them correct. \n
  to cancel anytime use the regular system command ==> ctrl+c
  "
echo -e 'WHat PHP version to use? ex. 7 or 8'
read DDKITSPHPVERSIONBEFORE
if [[ $DDKITSPHPVERSIONBEFORE = 7 ]]; then
  DDKITSPHPVERSION='7.3'
  export DDKITSPHPVERSION='7.3'
elif [[ $DDKITSPHPVERSIONBEFORE = 8 ]]; then
  DDKITSPHPVERSION='8.1'
  export DDKITSPHPVERSION='8.1' 
fi
echo -e "Enter your E-mail address that you want to use in your website as an admin: "
read MAIL_ADDRESS
echo -e ""

# enter your webroot
echo -e 'What''s your Web root (ex.docroot or web), where would you like to load your index file from:  '
read WEBROOT
echo -e ""
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

      " >./ddkits-files/ddkits/sites/ddkitscust.conf
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

          " >./ddkits-files/ddkits/sites/ddkitscust.conf
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

            " >./ddkits-files/ddkits/sites/ddkitscust.conf
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
  echo $SUDOPASS | sudo -S gem install wget git &>/dev/null
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
export WEBROOT=$WEBROOT
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
systemoptions=("Yes" "No" "Quit")
select opt in "${systemoptions[@]}"; do
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

if [[ -f $DDKITSFL'/ddkits-files/ddkitscli.sh' ]]; then
  rm -rf $DDKITSFL/ddkits-files/ddkitscli.sh
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
  WEBROOT='"$WEBROOT"'
  DDKITSPHPVERSION='"$DDKITSPHPVERSION"'
  MYSQL_PASSWORD='"$MYSQL_PASSWORD"'
  MAIL_ADDRESS='"$MAIL_ADDRESS"'" >$DDKITSFL/ddkits-files/ddkitscli.sh
# cat $DDKITSFL/ddkits-files/ddkits-drupal.sh >> $DDKITSFL/ddkits-files/ddkitscli.sh

DDKITSFL=$(pwd)
export DDKITSFL=$(pwd)
DDKITS_PLATFORM='Please pick which platform you want to install: '
#
# Setup options Please make sure of all options before publish pick list
#
startoptions=("Custom" "Contao" "ChefDK" "Chef-server" "DreamFactory" "Drupal" "Expression Engine" "Elgg" "Git Server" "Joomla" "Jenkins" "Laravel" "LAMP/PHP5" "LAMP/PHP7" "Magento" "nGrinder" "Umbraco" "Wordpress" "Silverstripe" "Cloud" "Symfony" "ZenCart" "Zend" "Quit")
select opt in "${startoptions[@]}"; do
  case $opt in
  "Drupal")
    echo -e ""
    echo -e 'What Drupal Version you want to start with: 7 or 8 ?'
    read DDKITSDRUPALV

    if [[ $DDKITSDRUPALV == '7' ]]; then
      source ./ddkits-files/ddkits/ddk-drupal7.sh
    elif [[ $DDKITSDRUPALV == '8' ]]; then
      source ./ddkits-files/ddkits/ddk-drupal8.sh
    fi
    break
    ;;
  "Wordpress")
    source ./ddkits-files/ddkits/ddk-wordpress.sh

    break
    ;;
  "ChefDK")
    source ./ddkits-files/ddkits/ddk-chefdk.sh

    break
    ;;
  "Chef-server")
    source ./ddkits-files/ddkits/ddk-chef-server.sh

    break
    ;;
  "Git Server")
    source ./ddkits-files/ddkits/ddk-git.sh
    break
    ;;
  "Joomla")
    source ./ddkits-files/ddkits/ddk-joomla.sh
    break
    ;;
  "Laravel")
    source ./ddkits-files/ddkits/ddk-laravel.sh
    break
    ;;

  "LAMP/PHP5")
    source ./ddkits-files/ddkits/ddk-php5.sh
    break
    ;;
  "LAMP/PHP7")
    source ./ddkits-files/ddkits/ddk-php7.sh
    break
    ;;

  "Umbraco")
    source ./ddkits-files/ddkits/ddk-umbraco.sh
    break
    ;;
  "Magento")
    source ./ddkits-files/ddkits/ddk-magento.sh
    break
    ;;
  "Custom")
    source ./ddkits-files/ddkits/custom.sh
    break
    ;;
  "nGrinder")
    source ./ddkits-files/ddkits/ddk-ngrinder.sh
    break
    ;;

  "DreamFactory")
    source ./ddkits-files/ddkits/ddk-dreamfactory.sh
    break
    ;;

  "Contao")
    source ./ddkits-files/ddkits/ddk-contao.sh
    break
    ;;

  "Elgg")
    source ./ddkits-files/ddkits/ddk-elgg.sh
    break
    ;;

  "Silverstripe")
    source ./ddkits-files/ddkits/ddk-silverstripe.sh
    break
    ;;

  "Cloud")
    source ./ddkits-files/ddkits/ddk-cloud.sh
    break
    ;;
  "ZenCart")
    source ./ddkits-files/ddkits/ddk-zencart.sh
    break
    ;;

  "Symfony")
    source ./ddkits-files/ddkits/ddk-symfony.sh
    break
    ;;
  "Expression Engine")
    source ./ddkits-files/ddkits/ddk-eengine.sh
    break
    ;;

  "Zend")
    source ./ddkits-files/ddkits/ddk-zend.sh
    break
    ;;

  "Jenkins")
    JENKINS_ONLY='true'
    source ./ddkits-files/ddkits/ddk-jenkins.sh
    break
    ;;

  "Quit")
    break
    ;;
  *) echo invalid option ;;
  esac
done

MYSQL_PASSWORD=${MYSQL_ROOT_PASSWORD}
# echo $SUDOPASS | sudo -S gem install autoprefixer-rails sass compass breakpoint singularitygs toolkit bower
# echo $SUDOPASS | sudo -S gem install breakpoint
# find existing instances in the host file and save the line numbers
# find existing instances in the host file and save the line numbers

ddkits_matches_in_hosts="$(grep -n jenkins.${DDKITSSITES}.ddkits.site admin.${DDKITSSITES}.ddkits.site solr.${DDKITSSITES}.ddkits.site /etc/hosts | cut -f1 -d:)"
host_entry="${DDKITSIP} ${DDKITSSITES} ${DDKITSSITESALIAS} ${DDKITSSITESALIAS2} ${DDKITSSITESALIAS3}"
ddkits_host_entry="${DDKITSIP} ${DDKITSSITES} ${DDKITSSITESALIAS} ${DDKITSSITESALIAS2} ${DDKITSSITESALIAS3} ddkits.site jenkins.${DDKITSSITES}.ddkits.site admin.${DDKITSSITES}.ddkits.site solr.${DDKITSSITES}.ddkits.site"
pat="jenkins.${DDKITSSITES}.ddkits.site"
# echo "Please enter your password if requested."

# echo ${SUDOPASS} | sudo -S cat /etc/hosts
matches_in_hosts="$(grep -n ${DDKITSSITES} /etc/hosts | cut -f1 -d:)"
if [ ! -z "$matches_in_hosts" ]; then
  echo "Updating existing hosts entry."
  # iterate over the line numbers on which matches were found
  while read -r line_number; do
    # replace the text of each line with the desired host entry
    # echo ${SUDOPASS} | sudo -S sed -i '' "${line_number}s/.*/${host_entry} /" /etc/hosts
    echo ${SUDOPASS} | sudo -S sed "/${host_entry}/d" /etc/hosts >~/hosts
    echo ${SUDOPASS} | sudo -S sed "/${pat}/d" /etc/hosts >~/hosts
    echo ${SUDOPASS} | sudo -S mv ~/hosts /etc/hosts
  done <<<"$matches_in_hosts"
  echo "Adding new hosts entry."
  echo "${ddkits_host_entry}" | sudo tee -a /etc/hosts >/dev/null
else
  echo "Adding new hosts entry."
  echo "${ddkits_host_entry}" | sudo tee -a /etc/hosts >/dev/null
fi
echo ${SUDOPASS} | sudo -S cat /etc/hosts

if [[ "$JENKINS_ONLY" == "false" ]]; then

  echo -e ""
  echo -e "Do you need extra JENKINS with this Installation? (y/n)"
  read JENKINS_ANSWER
  export JENKINS_ANSWER=${JENKINS_ANSWER}
  echo -e "Do you need extra SOLR with this Installation? (y/n)"
  read SOLR_ANSWER
  export SOLR_ANSWER=${SOLR_ANSWER}

fi

echo -ne '#####                     (33%)\r'
sleep 1

# export all results
export DDKITSFL=$DDKITSFL
export DDKITSVER=$DDKITSVER
export DDKITSIP=$DDKITSIP
export JENKINS_ANSWER=${JENKINS_ANSWER}
export JENKINS_ONLY=${JENKINS_ONLY}
export JENKINS_ANSWER=${JENKINS_ANSWER}
export SUDOPASS=${SUDOPASS}
export WEBROOT=${WEBROOT}
export MAIL_ADDRESS=${MAIL_ADDRESS}
export DDKITSSITES=${DDKITSSITES}
export DDKITSIP=${DDKITSIP}
export MYSQL_USER=${MYSQL_USER}
export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
export MYSQL_DATABASE=${MYSQL_DATABASE}
export MYSQL_PASSWORD=${MYSQL_ROOT_PASSWORD}
export DDKITSWEBPORT=${DDKITSWEBPORT}
export DDKITSHOSTNAME=${DDKITSHOSTNAME}
export MYSQL_PASSWORD=${MYSQL_ROOT_PASSWORD}

if [[ -f $DDKITSFL'/ddkits-files/ddkitsInfo.dev.sh' ]]; then
  rm -rf $DDKITSFL/ddkits-files/ddkitsInfo.dev.sh
fi

echo -e "
#!/bin/sh

#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#

# export all results
export DDKITSVER="${DDKITSIP}"
export WEBROOT="${WEBROOT}"
export DDKITSFL="${DDKITSFL}"
export DDKITSIP="${DDKITSIP} "
export JENKINS_ANSWER='"${JENKINS_ANSWER}"'
export JENKINS_ONLY='"${JENKINS_ONLY}"'
export JENKINS_ANSWER='"${JENKINS_ANSWER}"'
export SUDOPASS='"${SUDOPASS}"'
export MAIL_ADDRESS='"${MAIL_ADDRESS}"'
export DDKITSSITES='"${DDKITSSITES}"'
export DDKITSIP="${DDKITSIP}"
export MYSQL_USER='"${MYSQL_USER}"'
export MYSQL_ROOT_PASSWORD='"${MYSQL_ROOT_PASSWORD}"'
export MYSQL_DATABASE='"${MYSQL_DATABASE}"'
export MYSQL_PASSWORD='"${MYSQL_ROOT_PASSWORD}"'
export DDKITSWEBPORT="${DDKITSWEBPORT}"
export DDKITSHOSTNAME='"${DDKITSHOSTNAME}"'
export MYSQL_PASSWORD='"${MYSQL_ROOT_PASSWORD}"'
" >$DDKITSFL/ddkits-files/ddkitsInfo.dev.sh
