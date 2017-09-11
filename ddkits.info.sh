  echo -e "
  Welcome to DDKits Development Version
  "

  echo -e 'Please make sure that you installed your DDKits at the same environment \n(1) Localhost \n(2) virtualbox'
            read DDKITSVER
if [[ $DDKITSVER == 1 ]]; then
    export DDKITSIP='127.0.0.1'
      else
    export DDKITSIP=$(docker-machine ip ddkits)
    ddk go
fi
  if [[ -z "$DDKITSIP" ]]; then
    DDKITSIP='127.0.0.1' 
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
  cat "./ddkits-files/ddkits/logo.txt"

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
  cat "./ddkits-files/ddkits/logo.txt"

  # echo -e "Enter your E-mail address that you want to use in your website as an admin: "
  #   
  # read MAIL_ADDRESS 
  #   echo -e ""
  JENKINS_ONLY='false'
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
  MAIL_ADDRESS='"$MAIL_ADDRESS"'\n" >> ./ddkits-files/ddkitscli.sh
  cat ./ddkits-files/ddkits-drupal.sh >> ./ddkits-files/ddkitscli.sh


  DDKITSFL=$(pwd)
  export DDKITSFL=$(pwd)
  DDKITS_PLATFORM='Please pick which platform you want to install: '
  # 
  # Setup options Please make sure of all options before publish pick list 
  # 

  options=( "Contao" "DreamFactory" "Drupal" "Expression Engine" "Elgg" "Joomla" "Jenkins" "Laravel" "LAMP/PHP5" "LAMP/PHP7" "Magento" "Umbraco" "Wordpress" "Silverstripe" "Cloud" "Symfony"  "ZenCart" "Zend" "Quit")
  select opt in "${options[@]}"
  do
      case $opt in
          "Drupal")
     echo -e ""
    echo -e 'What Drupal Version you want to start with: 7 or 8 ?'
      read DDKITSDRUPALV

      if [[ $DDKITSDRUPALV == '7' ]]; then
      . ./ddkits-files/ddkits/ddk-drupal7.sh
      elif [[  $DDKITSDRUPALV == '8'  ]]; then
      . ./ddkits-files/ddkits/ddk-drupal8.sh
      fi
              break
              ;;
          "Wordpress")
      . ./ddkits-files/ddkits/ddk-wordpress.sh
               break
              ;;
          "Joomla")
      . ./ddkits-files/ddkits/ddk-joomla.sh
               break
              ;;
          "Laravel")
      . ./ddkits-files/ddkits/ddk-laravel.sh
              break
              ;;

          "LAMP/PHP5")
      . ./ddkits-files/ddkits/ddk-php5.sh
              break
              ;;
          "LAMP/PHP7")
      . ./ddkits-files/ddkits/ddk-php7.sh
              break
              ;;

          "Umbraco")
      . ./ddkits-files/ddkits/ddk-umbraco.sh
              break
              ;;
          "Magento")
      . ./ddkits-files/ddkits/ddk-magento.sh
              break
              ;;

          "DreamFactory")
      . ./ddkits-files/ddkits/ddk-dreamfactory.sh
              break
              ;;

           "Contao")
      . ./ddkits-files/ddkits/ddk-contao.sh
              break
              ;;

           "Elgg")
      . ./ddkits-files/ddkits/ddk-elgg.sh
              break
              ;;

           "Silverstripe")
      . ./ddkits-files/ddkits/ddk-silverstripe.sh
              break
              ;;

           "Cloud")
      . ./ddkits-files/ddkits/ddk-cloud.sh
              break
              ;;
           "ZenCart")
      . ./ddkits-files/ddkits/ddk-zencart.sh
              break
              ;;

           "Symfony")
      . ./ddkits-files/ddkits/ddk-symfony.sh
              break
              ;;
           "Expression Engine")
      . ./ddkits-files/ddkits/ddk-eengine.sh
              break
              ;;

           "Zend")
      . ./ddkits-files/ddkits/ddk-zend.sh
              break
              ;;

           "Jenkins")
              JENKINS_ONLY='true'
      . ./ddkits-files/ddkits/ddk-jenkins.sh
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
  ddkits_matches_in_hosts="$(grep -n jenkins.${DDKITSSITES}.ddkits.site admin.${DDKITSSITES}.ddkits.site solr.${DDKITSSITES}.ddkits.site /etc/hosts | cut -f1 -d:)"
  host_entry="${DDKITSIP} ${DDKITSSITES} ${DDKITSSITESALIAS} ${DDKITSSITESALIAS2} ${DDKITSSITESALIAS3}"
  ddkits_host_entry="${DDKITSIP}   ddkits.site jenkins.${DDKITSSITES}.ddkits.site admin.${DDKITSSITES}.ddkits.site solr.${DDKITSSITES}.ddkits.site"

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


  if [[ "$JENKINS_ONLY" == "false" ]]; then
   
  echo -e ""
  echo -e "Do you need extra JENKINS with this Installation? 'pick 'n' in case of installing Jenkins version only.' (y/n)"
  read JENKINS_ANSWER
  export JENKINS_ANSWER=${JENKINS_ANSWER}
  echo -e "Do you need extra SOLR with this Installation? (y/n)"
  read SOLR_ANSWER
  export SOLR_ANSWER=${SOLR_ANSWER}

fi

# export all results
export DDKITSFL=$DDKITSFL
export DDKITSIP=$DDKITSIP 
export JENKINS_ANSWER=${JENKINS_ANSWER}
export JENKINS_ONLY=${JENKINS_ONLY}
export JENKINS_ANSWER=${JENKINS_ANSWER}
export SUDOPASS=${SUDOPASS}
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

echo -e "
#!/bin/sh

#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#

export DDKITSFL=$DDKITSFL
export DDKITSIP=$DDKITSIP 
export JENKINS_ANSWER=${JENKINS_ANSWER}
export JENKINS_ONLY=${JENKINS_ONLY}
export JENKINS_ANSWER=${JENKINS_ANSWER}
export SUDOPASS=${SUDOPASS}
export MAIL_ADDRESS=${MAIL_ADDRESS}
export DDKITSSITES=${DDKITSSITES}
export DDKITSIP=${DDKITSIP}
export MYSQL_USER=${MYSQL_USER}
export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
export MYSQL_DATABASE=${MYSQL_DATABASE}
export MYSQL_PASSWORD=${MYSQL_ROOT_PASSWORD}
export DDKITSWEBPORT=${DDKITSWEBPORT}
export DDKITSHOSTNAME=${DDKITSHOSTNAME}
export MYSQL_PASSWORD=${MYSQL_ROOT_PASSWORD}" >> $DDKITSFL/ddkits-files/ddkitsInfo.dev.sh
