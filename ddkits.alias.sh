#!/bin/sh
#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#
# Copy the new Alias system and making sure of the DDKits installation
ddk() {
  # Check if the file exist
  FILE=~/.ddkits/ddkits-files/ddkits/p.sh
  if test -f "$FILE"; then
    source $FILE
  fi

  if [[ $1 == "install" ]]; then
    echo -e 'Enter your Sudo/Root Password "just for setup purposes":'
    read -s SUDOPASS
    echo $SUDOPASS | sudo -S ifconfig vboxnet0 down && sudo ifconfig vboxnet0 up
    # Downlaod all files into a seperate folder for ddkits only
    echo -e 'Creating DDkits folder .ddkits'
    DIRECTORY="$(echo ~/.ddkits)"
    echo $SUDOPASS | sudo -S rm -rf ~/.ddkits
    if [ ! -d "$DIRECTORY" ]; then
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
    chmod 700 ~/.ddkits/ddkits-files/ddkits/p.sh
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    echo -e 'Welcome to DDKits world...'
    export COMPOSE_TLS_VERSION=TLSv1_2

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
      -config <(cat /System/Library/OpenSSL/openssl.cnf \
        <(printf '[SAN]\nsubjectAltName=DNS:ddkits.site')) \
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
      docker-machine ip ddkits
      echo $SUDOPASS | sudo -S cp ~/.ddkits/ddkits.alias.sh ddkits_alias
      echo $SUDOPASS | sudo -S cp ddkits_alias ~/.ddkits_alias
      if [ $? -eq 0 ]; then
        echo $SUDOPASS | sudo -S cat $LOGO
        echo 'DDKits saying it is fine no need to reinstall'
      else
        if [[ "$OSTYPE" == "linux-gnu" ]]; then
          clear
          echo $SUDOPASS | sudo -S cat $LOGO
          PLATFORM='linux-gnu'
          echo 'This machine is '$PLATFORM' Docker setup will start now'
          echo $SUDOPASS | sudo -S apt-get install wget curl git -y
          curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
            echo $SUDOPASS | sudo -S chmod +x /tmp/docker-machine &&
            echo $SUDOPASS | sudo -S cp /tmp/docker-machine /usr/local/bin/docker-machine
        elif [[ "$OSTYPE" == "darwin"* ]]; then
          clear
          echo $SUDOPASS | sudo -S cat $LOGO
          PLATFORM='MacOS'
          echo 'This machine is '$PLATFORM' Docker setup will start now'
          curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-$(uname -s)-$(uname -m) >/usr/local/bin/docker-machine &&
            echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-machine
        elif [[ "$OSTYPE" == "cygwin" ]]; then
          clear
          echo $SUDOPASS | sudo -S cat $LOGO
          PLATFORM='cygwin'
          echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE "Docker, compose and docker-machine" INSTALLED ON YOUR SYSTEM'
        elif [[ "$OSTYPE" == "msys" ]]; then
          clear
          echo $SUDOPASS | sudo -S cat $LOGO
          PLATFORM='msys'
          echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE  "Docker, compose and docker-machine"  INSTALLED ON YOUR SYSTEM'
        elif [[ "$OSTYPE" == "win32" ]]; then
          clear
          echo $SUDOPASS | sudo -S cat $LOGO
          PLATFORM='win32'
          echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE  "Docker, compose and docker-machine"  INSTALLED ON YOUR SYSTEM'
        elif [[ "$OSTYPE" == "freebsd"* ]]; then
          clear
          echo $SUDOPASS | sudo -S cat $LOGO
          PLATFORM='freebsd'
          echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE  "Docker, compose and docker-machine"  INSTALLED ON YOUR SYSTEM'
        else
          break
        fi
      fi
      clear
        echo $SUDOPASS | sudo -S cat $LOGO
      if [[ -f ~/.ddkits_alias ]]; then
        echo $SUDOPASS | sudo -S cp ~/.ddkits/ddkits.alias.sh ddkits_alias
        echo $SUDOPASS | sudo -S cp ddkits_alias ~/.ddkits_alias
        docker restart $(docker ps -q)
        docker-machine create --driver virtualbox --virtualbox-hostonly-cidr "192.168.55.55/24" ddkits
        docker-machine start ddkits
        eval "$(docker-machine env ddkits)"
        docker-compose -f ~/.ddkits/ddkits.yml up -d --build
        echo 'command source ~/.ddkits_alias  ~/.ddkits_alias_web 2>/dev/null || true ' >>~/.bash_profile
        echo -e '\nDDKits Already installed successfully before, \nThank you for using DDKits'
      else
        echo $SUDOPASS | sudo -S cp ~/.ddkits/ddkits.alias.sh ddkits_alias
        echo $SUDOPASS | sudo -S cp ddkits_alias ~/.ddkits_alias
        docker restart $(docker ps -q)
        docker-machine create --driver virtualbox --virtualbox-hostonly-cidr "192.168.55.55/24" ddkits
        docker-machine start ddkits
        eval "$(docker-machine env ddkits)"
        docker-compose -f ~/.ddkits/ddkits.yml up -d --build
        echo 'command source ~/.ddkits_alias  ~/.ddkits_alias_web 2>/dev/null || true ' >>~/.bash_profile
        echo -e '\nDDKits installed successfully, \nThank you for using DDKits'
      fi
    fi
  elif [[ $1 == "ip" ]]; then
    Docker-machine ls | grep ddkits  >/dev/null && export DDKMACHINE=1 || echo 'DDKits container is not using DDKits Docker Machine'
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
    # Alias file
    ALIASFILE=~/.ddkits_alias
    if [[ -f $ALIASFILE ]]; then
      clear
      echo $SUDOPASS | sudo -S cat $LOGO
      echo -e 'ifconfig Refresh ->'
      echo $SUDOPASS | sudo -S ifconfig vboxnet0 down && sudo ifconfig vboxnet0 up
      echo -e 'ifconfig Refresh -> done ifconfig'
      echo $SUDOPASS | sudo -S  rm ~/.ddkits_alias
      echo $SUDOPASS | sudo -S cp ~/.ddkits/ddkits.alias.sh ~/.ddkits/ddkits_alias
      echo $SUDOPASS | sudo -S  cp ~/.ddkits/ddkits_alias ~/.ddkits_alias
      echo $SUDOPASS | sudo -S  chmod u+x ~/.ddkits_alias
      source ~/.ddkits_alias
      source ~/.ddkits_alias_web
      docker restart $(docker ps -q)
    else
      clear
      echo $SUDOPASS | sudo -S cat $LOGO
      echo $SUDOPASS | sudo -S cp ~/.ddkits/ddkits.alias.sh ddkits_alias
      echo $SUDOPASS | sudo -S  cp ddkits_alias ~/.ddkits_alias
      echo $SUDOPASS | sudo -S  chmod u+x ~/.ddkits_alias
      source ~/.ddkits_alias
      source ~/.ddkits_alias_web
      docker restart $(docker ps -q)
      ddk c | grep ddkits  >/dev/null && ddk install || echo -e 'DDkits Ready to go, well done :-)'

    fi

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
    docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d
  elif [[ $1 == "rebuild" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    source ddkits-files/ddkitsInfo.dev.sh ddkits-files/ddkitsInfo.ports.sh ddkits-files/ddkitscli.sh
    source ~/.ddkits_alias ~/.ddkits_alias_web
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
      -config <(cat /System/Library/OpenSSL/openssl.cnf \
        <(printf '[SAN]\nsubjectAltName=DNS:'$DDKITSSITES'')) \
      -sha256 \
      -days 3650
    mv $DDKITSSITES.key $DDKITSFL/ddkits-files/ddkits/ssl/
    mv $DDKITSSITES.crt $DDKITSFL/ddkits-files/ddkits/ssl/
    echo "ssl crt and .key files moved correctly"

    docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d --build --force-recreate
    sudo rm ~/.ddkits_alias
    echo $SUDOPASS | sudo -S cp ~/.ddkits/ddkits.alias.sh ddkits_alias
    echo $SUDOPASS | sudo -S cp ~/.ddkits/ddkits_alias ~/.ddkits_alias
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

    if [ ! -z "$matches_in_hosts" ]; then
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
      SITEDEL=ddkits
      # echo ${SUDOPASS} | sudo -S cat /etc/hosts
      # Remove the Source from Bash file
      matches="$(grep -n ${SITEDEL} /etc/hosts | cut -f1 -d:)"
      if [ ! -z "$matches" ]; then
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
      matchesbash="$(grep -n ${BASHSITE} ~/.bash_profile | cut -f1 -d:)"
      if [ ! -z "$matchesbash" ]; then
        echo "Updating bash profile file"
        # iterate over the line numbers on which matches were found
        while read -r line_numbers; do
          # Remove all DDkits entries
          echo ${line_numbers}
          echo ${SUDOPASS} | sudo -S sed -i '' "/${line_numbers}/d" ~/.bash_profile

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
  elif [[ $1 == "init" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    echo $SUDOPASS | sudo -S cp ~/.ddkits/ddkits.init.sh .ddkits-files/ddkits.init.sh
    source .ddkits-files/ddkits.init.sh
  elif [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
    clear
    echo $SUDOPASS | sudo -S cat $LOGO
    clear
    echo -e 'DDkits built by Mutasem Elayyoub www.DDKits.com
    List of commands after "ddk <option>":

        -h      - Show comand list
        who     - Show all details about your site
        go      - Start or check your DDKits working or not
        stop    - ACtivate default vm
        del     - Remove DDKits VM and go back to default
        clean   - Clean undefiend or unused Volumes and images
        rmn     - Clean <none> extra images and containers
        fix     - Fix DDKits containers in full for any problem
        start   - Start new your ddkits setup process "this command must be in your project folder"
        prod    - Start production installation   // available with DDKits PRO only 
            **************************
        update  - Update your ddkits setup process "this command must be in your project folder"
            **************************
        rebuild - Update your ddkits rebuild and build your project images and containers
                process "this command must be in your project folder"
            **************************
        i       - Show all your docker images
        c       - Show all your docker containers
        r       - Docker run\n
        rm      - Remove your compose extra unused containers or containers with error
            **************************
        rm all  - Restore docker images and containers "Important this command remove all your containers and images"
            **************************
    List of commands after "ddk<option>":
        ri      remove an image from docker images
        rc      remove a continer from docker containers
            **************************
    Docker special commands
      new       
           c       Create a container from an image ex. ( ddk new c ddkits/lamp:7)   
           run     Docker exec the new container ex. ( ddk new run 5d05535340b8 /bin/bash )
    Containers DNS:
    Jenkins     http://jenkins.YOUR_DOMAIN.ddkits.site
    SOLR     http://solr.YOUR_DOMAIN.ddkits.site
    PhpMyAdmin     http://admin.YOUR_DOMAIN.ddkits.site

    DDKits v3.01
        '
  else
    echo 'DDkits build by Mutasem Elayyoub and ready to usesource  www.DDKits.com
      To see all commands write " ddk -h / ddk --help "'
    ddk -h
  fi
}
alias ddkrc='docker rm -f '
alias ddkri='docker rmi -f '
