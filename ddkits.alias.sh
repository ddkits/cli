#!/bin/sh
#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#
shopt -s extglob
# Copy the new Alias system and making sure of the DDKits installation
ddk() {
  # Check if the file exist
  RED='\033[0;31m'
  NC='\033[0m'
  FILE=~/.ddkits/ddkits-files/ddkits/p.sh
  FILEALIAS=~/.ddkits/ddkits-files/ddkits/p.sh
  # check if the sudo variable exist for use
  if test -z "$SUDOPASS"
  then
      echo -e 'Enter your Sudo/Root Password "just for setup purposes":'
      read -s SUDOPASS      
  fi
  # check the file if exist
  if test -f "$FILE"
  then
    source $FILE
  fi
  # check if the alias file exist in root
  if test -f "$FILEALIAS"
  then
      echo $SUDOPASS | sudo -S rm ~/.ddkits_alias ddkits_alias
      echo $SUDOPASS | sudo -S cp ddkits.alias.sh ddkits_alias
      echo $SUDOPASS | sudo -S cp ddkits_alias ~/.ddkits_alias
      echo $SUDOPASS | sudo -S chmod u+x ~/.ddkits_alias
  fi
  FILE2=ddkits-files/ddkitsInfo.dev.sh
  # checking if the site has a root
  if test -f "$FILE2" 
  then
    # source the information needed to import
    source ddkits-files/ddkitsInfo.dev.sh ddkits-files/ddkitsInfo.ports.sh ddkits-files/ddkitscli.sh
  fi
  
  if [[ $1 == "install" ]]; then
      # check if the sudo variable exist for use
      if [ -z "$SUDOPASS" ]
      then
          echo -e 'Enter your Sudo/Root Password "just for setup purposes":'
          read -s SUDOPASS      
      fi
      echo $SUDOPASS | sudo -S ifconfig vboxnet0 down && sudo ifconfig vboxnet0 up
      # Downlaod all files into a seperate folder for ddkits only
      echo -e 'Creating DDkits folder .ddkits'
      DIRECTORY="$(echo ~/.ddkits)"
      echo $SUDOPASS | sudo -S rm -rf ~/.ddkits
      if [[ ! -d "$DIRECTORY" ]]; then
        # Control will enter here if $DIRECTORY doesn't exist.
        git clone https://github.com/ddkits/base.git ~/.ddkits
        chmod -R 744 ~/.ddkits
      else
        DIRIS=$(echo "${DIRECTORY}/.git")
        git --git-dir=${DIRIS} checkout -f
        git --git-dir=${DIRIS} pull
      fi
      # make the logo file from source
      LOGO=~/.ddkits/ddkits-files/ddkits/logo.txt
      echo -e 'export SUDOPASS='${SUDOPASS}'
              export LOGO='${LOGO}'' >~/.ddkits/ddkits-files/ddkits/p.sh
      echo $SUDOPASS | sudo -S chmod u+x ~/.ddkits/ddkits-files/ddkits/p.sh
       docker-machine ip ddkits
      echo $SUDOPASS | sudo -S rm ~/.ddkits_alias ddkits_alias
      echo $SUDOPASS | sudo -S cp ddkits.alias.sh ddkits_alias
      echo $SUDOPASS | sudo -S cp ddkits_alias ~/.ddkits_alias
      echo $SUDOPASS | sudo -S chmod u+x ~/.ddkits_alias
      echo $SUDOPASS | sudo -S cat $LOGO
      echo -e 'Welcome to DDKits world...'
      export COMPOSE_TLS_VERSION=TLSv1_2
      export CONFIGIS=<(cat /System/Library/OpenSSL/openssl.cnf <(printf '[SAN]\nsubjectAltName=DNS:ddkits.site'))
      # create the crt files for ssl
      echo -e 'Creating Self assigned KEY & CRT'
      openssl req \
        -newkey rsa:2048 \
        -x509 \
        -nodes \
        -keyout ~/.ddkits/ddkits.site.key \
        -new \
        -out ~/.ddkits/ddkits.site.crt \
        -subj /CN=ddkits.site \
        -reqexts SAN \
        -extensions SAN \
        -config $CONFIGIS \
        -sha256 \
        -days 3650
      mkdir ~/.ddkits/ddkits-files/ddkits/ssl
      mv ~/.ddkits/ddkits.site.key ~/.ddkits/ddkits-files/ddkits/ssl/
      mv ~/.ddkits/ddkits.site.crt ~/.ddkits/ddkits-files/ddkits/ssl/
      chmod -R 777 ~/.ddkits/ddkits-files/ddkits/ssl
      echo "ssl crt and .key files moved correctly"
      echo -e 'DDkits web
      ' > ~/.ddkits_alias_web
      # ddk c | grep ddkits  >/dev/null && export DDKITSIP='127.0.0.1' || export DDKITSIP='Please make sure your DDKits container is installed and running'
      echo -e '(1) Localhost \n(2) virtualbox'
      read DDKITSVER
      if [[ $DDKITSVER == 1 ]]; then
        clear
        echo $SUDOPASS | sudo -S cat $LOGO
        docker-compose -f ~/.ddkits/ddkits.yml up -d --build
      elif [[ $DDKITSVER == 2 ]]; then
        clear
        echo $SUDOPASS | sudo -S cat $LOGO
        source ~/.ddkits/ddkitsStart.sh
      fi
      # after check from here
      clear
      echo $SUDOPASS | sudo -S cat $LOGO
      docker-machine ip ddkits
      echo $SUDOPASS | sudo -S rm ~/.ddkits_alias ddkits_alias
      echo $SUDOPASS | sudo -S cp ddkits.alias.sh ddkits_alias
      echo $SUDOPASS | sudo -S cp ddkits_alias ~/.ddkits_alias
      echo $SUDOPASS | sudo -S chmod u+x ~/.ddkits_alias
      docker restart $(docker ps -q)
      docker-machine create --driver virtualbox --virtualbox-hostonly-cidr "192.168.55.55/24" ddkits
      docker-machine start ddkits
      eval "$(docker-machine env ddkits)"
      docker-compose -f ~/.ddkits/ddkits.yml up -d --build
      source ~/.ddkits_alias  ~/.ddkits_alias_web
      echo 'command source ~/.ddkits_alias  ~/.ddkits_alias_web 2>/dev/null || true ' >> ~/.bash_profile
      echo -e '\nDDKits installed successfully, \nThank you for using DDKits'
  elif [[ $1 == "ip" ]]; then
    Docker-machine ls | grep ddkits >/dev/null && export DDKMACHINE=1 || echo 'DDKits container is not using DDKits Docker Machine'
    # export DDKITSIP=$(docker-machine ip ddkits)
    if [[ $DDKMACHINE == "1" ]]; then
      ddk go
      ddk c | grep ddkits >/dev/null && export DDKITSIP=$(docker-machine ip ddkits) || export DDKITSIP='Please make sure your DDKits container is installed and running'
    else
      ddk c | grep ddkits >/dev/null && export DDKITSIP='127.0.0.1' || export DDKITSIP='Please make sure your DDKits container is installed and running'
      # docker-machine ls | grep error >/dev/null && docker-machine create --driver virtualbox default || echo -e 'DDkits need to be installed first'
    fi
    echo -e 'Your DDkits ip: 
      '${DDKITSIP}
  elif [[ $1 == "check" ]]; then
    docker ps --filter "name=ddkits"
  elif [[ $1 == "fix" ]]; then
    # check if the sudo variable exist for use
      if test -z "$SUDOPASS"
      then
          echo -e 'Enter your Sudo/Root Password "just for setup purposes":'
          read -s SUDOPASS      
      fi
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    echo -e 'ifconfig Refresh ->'
    echo $SUDOPASS | sudo -S ifconfig vboxnet0 down && sudo ifconfig vboxnet0 up
    echo -e 'ifconfig Refresh -> done ifconfig'
    DIRECTORY="$(echo ~/.ddkits)"
    # remove the directory first to pull it again
    echo $SUDOPASS | sudo -S rm -rf $DIRECTORY
    if [ ! -d "$DIRECTORY" ]; then
      # Control will enter here if $DIRECTORY doesn't exist.
      git clone https://github.com/ddkits/base.git $DIRECTORY
      chmod -R 744 ~/.ddkits
    else
      DIRIS=$(echo "${DIRECTORY}/.git")
      git --git-dir=${DIRIS} checkout -f
      git --git-dir=${DIRIS} pull
    fi
    echo $SUDOPASS | sudo -S chmod u+x $DIRECTORY
    # build the bash files for different browsers
    echo $SUDOPASS | sudo -S rm ~/.ddkits_alias ddkits_alias
    echo $SUDOPASS | sudo -S cp ddkits.alias.sh ddkits_alias
    echo $SUDOPASS | sudo -S cp ddkits_alias ~/.ddkits_alias
    source ~/.ddkits_alias ~/.ddkits_alias_web
    echo $SUDOPASS | sudo -S chmod u+x ~/.ddkits_alias
    source ~/.ddkits_alias
    source ~/.ddkits_alias_web
    docker restart $(docker ps -q)
    ddk c | grep ddkits >/dev/null && echo -e 'DDkits Ready to go, well done :-)' || ddk install
  elif [[ $1 == "com" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    php ddkits.phar install
  elif [[ $1 == "new" && $2 == "c" ]]; then
    clear
    docker run -d $3 $4 $5
  elif [[ $1 == "new" && $2 == "run" ]]; then
    clear
    docker exec -it $3 $4 $5
  elif [[ $1 == "update" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    DIRECTORY="$(echo ~/.ddkits)"
    echo $SUDOPASS | sudo -S rm -rf ~/.ddkits
    if [[ ! -d "$DIRECTORY" ]]; then
      # Control will enter here if $DIRECTORY doesn't exist.
      git clone https://github.com/ddkits/base.git ~/.ddkits
      chmod -R 744 ~/.ddkits
    else
      DIRIS=$(echo "${DIRECTORY}/.git")
      git --git-dir=${DIRIS} checkout -f
      git --git-dir=${DIRIS} pull
    fi
    echo -e 'Now updating this website containers'
    docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d
  elif [[ $1 == "rebuild" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    source ddkits-files/ddkitsInfo.dev.sh ddkits-files/ddkitsInfo.ports.sh ddkits-files/ddkitscli.sh
    echo $SUDOPASS | sudo -S rm ~/.ddkits_alias ddkits_alias
    echo $SUDOPASS | sudo -S cp ddkits.alias.sh ddkits_alias
    echo $SUDOPASS | sudo -S cp ddkits_alias ~/.ddkits_alias
    source ~/.ddkits_alias ~/.ddkits_alias_web
    export CONFIGREBUILD=<(cat /System/Library/OpenSSL/openssl.cnf <(printf '[SAN]\nsubjectAltName=DNS:'$DDKITSSITES''))
    # create the crt files for ssl
    openssl req \
      -newkey rsa:2048 \
      -x509 \
      -nodes \
      -keyout $DDKITSSITES.key \
      -new \
      -out $DDKITSSITES.crt \
      -subj /CN=$DDKITSSITES.site \
      -reqexts SAN \
      -extensions SAN \
      -config $CONFIGREBUILD \
      -sha256 \
      -days 3650
    mv $DDKITSSITES.key $DDKITSFL/ddkits-files/ddkits/ssl/
    mv $DDKITSSITES.crt $DDKITSFL/ddkits-files/ddkits/ssl/
    echo "ssl crt and .key files moved correctly"

    docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d --build --force-recreate
    sudo rm ~/.ddkits_alias
    echo $SUDOPASS | sudo -S cp ddkits.alias.sh ddkits_alias
    echo $SUDOPASS | sudo -S cp ddkits_alias ~/.ddkits_alias
    echo $SUDOPASS | sudo -S chmod u+x ~/.ddkits_alias
    source ~/.ddkits_alias
    source ~/.ddkits_alias_web
    # export DDKITSIP=$(docker-machine ip ddkits)
    #  prepare ddkits container for the new websites
    echo -e 'copying conf files into ddkits and restart'
    docker cp ./ddkits-files/ddkits/sites/ddkitscust.conf ddkits:/etc/apache2/sites-enabled/ddkits_$DDKITSHOSTNAME.conf
    # docker cp ~/.ddkits/ddkitscli.sh $DDKITSHOSTNAME'_ddkits_joomla_web':/var/www/html/ddkitscli.sh
    # copy ssl crt keys to ddkits proxy
    docker cp ./ddkits-files/ddkits/ssl/$DDKITSSITES.crt ddkits:/etc/ssl/certs/$DDKITSSITES.crt
    docker cp ./ddkits-files/ddkits/ssl/$DDKITSSITES.key ddkits:/etc/ssl/certs/$DDKITSSITES.key

    docker restart ddkits
    ddk ip

    matches_in_hosts="$(grep -n ${DDKITSSITES} /etc/hosts | cut -f1 -d:)"
    host_entry="${DDKITSIP}  ${DDKITSSITES} ${DDKITSSITESALIAS} ${DDKITSSITESALIAS2} ${DDKITSSITESALIAS3} ddkits.site jenkins.${DDKITSSITES}.ddkits.site admin.${DDKITSSITES}.ddkits.site solr.${DDKITSSITES}.ddkits.site"
    # echo "Please enter your password if requested."

    # echo ${SUDOPASS} | sudo -S cat /etc/hosts

    if [[ ! -z "$matches_in_hosts" ]]; then
      echo "Updating existing hosts entry."

      # iterate over the line numbers on which matches were found
      while read -r line_number; do
        # replace the text of each line with the desired host entry
        echo ${SUDOPASS} | sudo -S sed -i '' "${line_number}s/.*/${host_entry} /" /etc/hosts
      done <<<"$matches_in_hosts"
    else
      echo "Adding new hosts entry."
      echo "$host_entry" | sudo tee -a /etc/hosts >/dev/null
    fi
    echo ${SUDOPASS} | sudo -S cat /etc/hosts
    echo -e 'copying conf files into ddkits and restart'
    docker cp ./ddkits-files/ddkits/sites/ddkitscust.conf ddkits:/etc/apache2/sites-enabled/ddkits_$DDKITSHOSTNAME.conf
    # docker cp ~/.ddkits/ddkitscli.sh $DDKITSHOSTNAME'_ddkits_joomla_web':/var/www/html/ddkitscli.sh
    docker restart $(docker ps -q)
    ddk go
  elif [[ $1 == "start" ]]; then
    if [[ $2 == "com" ]]; then
      echo $SUDOPASS | sudo -S cat $LOGO
      source ddkitsLocal.sh && composer install
    else
      export COMPOSE_TLS_VERSION=TLSv1_2
      echo $SUDOPASS | sudo -S cat $LOGO
      source ddkitsLocal.sh && docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d --force-recreate
    fi
  elif [[ $1 == "c" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    docker ps
  elif [[ $1 == "test" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    source ddkitstest.sh
  elif [[ $1 == "who" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    cat "./ddkits-files/ddkits/site.txt"
  elif [[ $1 == "clean" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    docker volume rm $(docker volume ls -qf dangling=true)
  elif [[ $1 == "rmn" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    # remove none images and volumes
    docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
    docker rm $(docker ps --filter=status=exited --filter=status=created -q)
    docker volume rm $(docker volume ls -f dangling=true -q)
    echo 'y' | docker image prune --all
    clear
  elif [[ $1 == "style" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    echo "${red}hello ${yellow}this is ${green}coloured${normal}"
  elif [[ $1 == "nostyle" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    docker ps
  elif [[ $1 == "i" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    docker images
  elif [[ $1 == "go" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    echo -e ''
    echo ':---)) Welcome back ' && echo "$USER"
    echo -e ''
    source ~/.ddkits_alias
    docker-machine start ddkits
    eval $(docker-machine env ddkits)
  elif [[ $1 == "del" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    read -p "Are you sure you want to remove DDkits from your system? " -n 1 -r
    echo # (optional) move to a new line
    if [[ ! $REPLY == ^[Yy]$ ]]; then
      echo -e 'Removing DDKits files'
      echo $SUDOPASS | sudo -S rm -rf ~/.ddkits
      echo ${SUDOPASS} | sudo -S rm ~/.ddkits_alias
      echo ${SUDOPASS} | sudo -S rm ~/.ddkits_alias_web
      # echo "Please enter your password if requested."
      SITEDEL="ddkits.site"
      # echo ${SUDOPASS} | sudo -S cat /etc/hosts
      # Remove the Source from Bash file
      matches="$(grep -n ${SITEDEL} /etc/hosts | cut -f1 -d:)"
      if [[ ! -z "$matches" ]]; then
        echo "Updating Hosts file"
        # iterate over the line numbers on which matches were found
        while read -r line_number; do
          # Remove all DDkits entries
          echo ${line_number}
          echo ${SUDOPASS} | sudo -S sed -i '' "/${line_number}/d" /etc/hosts
        done <<<"$matches"
      fi
      # Remove the Source from Bash file
      BASHSITE=ddkits_alias
      BSHFILE=~/.bash_profile
      matchesbash="$(grep -n ${BASHSITE} ${BSHFILE} | cut -f1 -d:)"
      if [[ ! -z "$matchesbash" ]]; then
        echo "Updating bash profile file"
        # iterate over the line numbers on which matches were found
        while read -r line_numbers; do
          # Remove all DDkits entries
          echo ${line_numbers}
          echo ${SUDOPASS} | sudo -S sed -i '' "/${line_numbers}/d" ${BSHFILE}

        done <<<"$matchesbash"
      fi
      source ~/.bash_profile
      docker-machine rm ddkits
      echo -e ''
      echo ':---(( Bye ' && echo "$USER"
      echo -e ''
      eval $(docker-machine env default)
    fi

  elif [[ $1 == "stop" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    echo -e ''
    echo 'Bye for now  ' && echo "$USER"
    echo -e ''
    eval $(docker-machine env default)
  elif [[ $1 == "r" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    docker run
  elif [[ $1 == "db-import" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    # source the information needed to import
    source ddkits-files/ddkitsInfo.dev.sh ddkits-files/ddkitsInfo.ports.sh ddkits-files/ddkitscli.sh
    MARIADB=$DDKITSHOSTNAME'_ddkits_db'
    export MARIADB=$DDKITSHOSTNAME'_ddkits_db'
    echo $MARIADB
    docker exec -i $MARIADB mysql -h 127.0.0.1 -P 3306 -u$MYSQL_USER -p$MYSQL_ROOT_PASSWORD --database=$MYSQL_DATABASE < $2 
  elif [[ $1 == "db-export" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    # source the information needed to import
    source ddkits-files/ddkitsInfo.dev.sh ddkits-files/ddkitsInfo.ports.sh ddkits-files/ddkitscli.sh
    MARIADB=$DDKITSHOSTNAME'_ddkits_db'
    export MARIADB=$DDKITSHOSTNAME'_ddkits_db'
    echo $MARIADB
    docker exec -i $MARIADB mysql -h 127.0.0.1 -P 3306 -u$MYSQL_USER -p$MYSQL_ROOT_PASSWORD --database=$MYSQL_DATABASE > $2 
  elif [[ $1 == "ir" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    echo -e 'please use "  ddkri  " instead \n or "  ddk rm all  " to delete all dockers images and containers from your machine'
  elif [[ $1 == "cr" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    echo -e 'please use "  ddkrc  " instead '
  elif [[ $1 == "drush" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    if [[ $2 == "install" ]]; then
      clear
      echo $SUDOPASS | sudo -S cat $LOGO
      # install composer locally for drush needs and other composer packages
      wget https://getcomposer.org/composer.phar
      echo $SUDOPASS | sudo -S mv composer.phar /usr/local/bin/
      chmod -R 777 /usr/local/bin/composer.phar
      composer global require drush/drush:dev-master
    fi
  elif [[ $1 == "rm" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    if [[ $2 == "all" ]]; then
      clear
      echo $SUDOPASS | sudo -S cat $LOGO
      source ~/.ddkits/ddkits.rm.sh
    elif [[ $2 == "c" ]]; then
      clear
      echo $SUDOPASS | sudo -S cat $LOGO
      # Delete all containers
      docker rm $(docker ps -a -q) -f
    elif [[ $2 == "i" ]]; then
      clear
      echo $SUDOPASS | sudo -S cat $LOGO
      # Delete all images
      docker rmi $(docker images -q) -f
    else
      docker-compose -f ~/.ddkits/ddkits.yml -f ddkits.env.yml rm
    fi
  elif [[ $1 == "docker" ]]; then
        if bash --login '/Applications/Docker/Docker Quickstart Terminal.app/Contents/Resources/Scripts/start.sh'; then
          echo 'Docker started'
        elseddk caller
          echo 'Check your docker'
        fi
  elif [[ $1 == "init" ]]; then
    echo $SUDOPASS | sudo -S cat $LOGO
    mkdir .ddkits-files
    chmod -R 777 .ddkits-files
    echo $SUDOPASS | sudo -S cp ~/.ddkits/ddkits.init.sh .ddkits-files/ddkits.init.sh
    clear
    source .ddkits-files/ddkits.init.sh
  elif [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
    clear
    RED='\033[0;31m'
    NC='\033[0m'
    echo $SUDOPASS | sudo -S cat $LOGO
    echo -e "DDkits built by Mutasem Elayyoub (Sam Elayyoub) www.DDKits.com
    List of commands after 'ddk <option>':
        ${red}docker${normal}  - Mac users can start their docker by using this command
        ${red}-h${normal}       - Show comand list
        ${red}who${normal}      - Show all details about your site
        ${red}go${normal}       - Start or check your DDKits working or not
        ${red}stop${normal}     - ACtivate default vm
        ${red}del${normal}      - Remove DDKits VM and go back to default
        ${red}clean${normal}    - Clean undefiend or unused Volumes and images
        ${red}rmn${normal}      - Clean <none> extra images and containers
        ${red}fix${normal}      - Fix DDKits containers in full for any problem
        ${red}start${normal}    - Start new your ddkits setup process 'this command must be in your project folder'
        ${red}prod${normal}     - Start production installation   // available with DDKits PRO only 
            **************************
        // Database with DDkits
        ${red}db-import${normal} - Direct import DB into your Database 
              ex. ddk db-import FILE_NAME.sql
        ${red}db-export${normal} - Direct export DB into your Database 
              ex. ddk db-export FILE_NAME.sql
            **************************
        ${red}update${normal}  - Update your ddkits setup process 'this command must be in your project folder'
            **************************
        ${red}rebuild${normal} - Update your ddkits rebuild and build your project images and containers
                process 'this command must be in your project folder'
            **************************
        ${red}i${normal}       - Show all your docker images
        ${red}c${normal}       - Show all your docker containers
        ${red}r${normal}       - Docker run
        ${red}rm${normal}      - Remove your compose extra unused containers or containers with error
            **************************
        ${red}rm all${normal}  - Restore docker images and containers 
                                'Important this command remove all your containers and images'
            **************************
        ${red}test${normal}  - CI/CD phplint checking all php files without vendors for a secure depoloyment
            **************************
    List of commands after 'ddk<option>':
        ${red}ri${normal}      remove an image from docker images
        ${red}rc${normal}      remove a continer from docker containers
            **************************
    Docker special commands
      new       
           ${red}c${normal}       Create a container from an image ex. ( ddk new c ddkits/lamp:7)   
           ${red}run${normal}     Docker exec the new container ex. ( ddk new run 5d05535340b8 /bin/bash )
    ${yellow}Containers DNS:${normal}
    Jenkins     http://jenkins.YOUR_DOMAIN.ddkits.site
    SOLR     http://solr.YOUR_DOMAIN.ddkits.site
    PhpMyAdmin     http://admin.YOUR_DOMAIN.ddkits.site

    DDKits v4.21
        "
  else
    echo "DDkits build by Mutasem Elayyoub and ready to usesource  www.DDKits.com
      To see all commands write ${red}'ddk -h / ddk --help'${normal} "
    ddk -h
  fi
}
alias ddkrc='docker rm -f '
alias ddkri='docker rmi -f '
