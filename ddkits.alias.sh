#!/bin/sh

#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#


ddk(){
 if [[ $1 == "install" ]]; then
        clear
        cat "./ddkits-files/ddkits/logo.txt"
      echo -e '(1) Localhost \n(2) virtualbox'
          read DDKITSVER
      if [[ $DDKITSVER == 1 ]]; then
        clear
        cat "./ddkits-files/ddkits/logo.txt"
        docker-compose -f ddkits.yml up -d --build
      elif [[ $DDKITSVER == 2 ]]; then
        clear
        cat "./ddkits-files/ddkits/logo.txt"
           echo -e 'Enter your Sudo/Root Password:'
              read SUDOPASS
              docker-machine ip ddkits
              echo $SUDOPASS | sudo -S cp ddkits.alias.sh ddkits_alias
              echo $SUDOPASS | sudo -S cp ddkits_alias ~/.ddkits_alias
              if [ $? -eq 0 ]; then
                clear
              cat "./ddkits-files/ddkits/logo.txt"
                  echo 'DDKits saying it is fine no need to reinstall'
              else
            if [[ "$OSTYPE" == "linux-gnu" ]]; then
              clear
              cat "./ddkits-files/ddkits/logo.txt"
              PLATFORM='linux-gnu'
              echo 'This machine is '$PLATFORM' Docker setup will start now'
              echo $SUDOPASS | sudo -S apt-get install wget curl git -y
              curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
              echo $SUDOPASS | sudo -S chmod +x /tmp/docker-machine &&
              echo $SUDOPASS | sudo -S cp /tmp/docker-machine /usr/local/bin/docker-machine
            elif [[ "$OSTYPE" == "darwin"* ]]; then
              clear
               cat "./ddkits-files/ddkits/logo.txt"
              PLATFORM='MacOS'
              echo 'This machine is '$PLATFORM' Docker setup will start now'
              curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
              echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-machine
            elif [[ "$OSTYPE" == "cygwin" ]]; then
              clear
              cat "./ddkits-files/ddkits/logo.txt"
              PLATFORM='cygwin'
              echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE "Docker, compose and docker-machine" INSTALLED ON YOUR SYSTEM' 
            elif [[ "$OSTYPE" == "msys" ]]; then
              clear
              cat "./ddkits-files/ddkits/logo.txt"
               PLATFORM='msys'
              echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE  "Docker, compose and docker-machine"  INSTALLED ON YOUR SYSTEM'        
            elif [[ "$OSTYPE" == "win32" ]]; then
              clear
              cat "./ddkits-files/ddkits/logo.txt"
                PLATFORM='win32'
              echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE  "Docker, compose and docker-machine"  INSTALLED ON YOUR SYSTEM'         
            elif [[ "$OSTYPE" == "freebsd"* ]]; then
              clear
              cat "./ddkits-files/ddkits/logo.txt"
               PLATFORM='freebsd'
              echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE  "Docker, compose and docker-machine"  INSTALLED ON YOUR SYSTEM'        
            else
              break
          fi
          docker-compose -f ddkits.yml up -d --build
        fi
        if [[ -f  ~/.ddkits_alias ]]; then
          clear
          cat "./ddkits-files/ddkits/logo.txt"
          clear
                docker-compose -f ddkits.yml up -d --build
          cp ddkits.alias.sh ddkits_alias 
          cp ddkits_alias ~/.ddkits_alias 
                docker-machine create --driver virtualbox ddkits
                docker-machine start ddkits
                eval $(docker-machine env ddkits)
          echo -e '\nDDKits Already installed successfully before, \nThank you for using DDKits'
          else
                docker-compose -f ddkits.yml up -d --build
          cp ddkits.alias.sh ddkits_alias 
          cp ddkits_alias ~/.ddkits_alias 
                docker-machine create --driver virtualbox ddkits
                docker-machine start ddkits
                eval $(docker-machine env ddkits)
          echo 'command source ~/.ddkits_alias 2>/dev/null || true ' >> ~/.bash_profile
          echo -e '\nDDKits installed successfully, \nThank you for using DDKits'
        fi
  fi
  elif [[ $1 == "ip" ]]; then
    clear
        cat "./ddkits-files/ddkits/logo.txt"
        docker-machine ip ddkits
  elif [[ $1 == "fix" ]]; then
    clear
        cat "./ddkits-files/ddkits/logo.txt"
    if [[ -f "~/.ddkits_alias" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
      sudo rm ~/.ddkits_alias
      cp ddkits.alias.sh ddkits_alias
      sudo cp ddkits_alias ~/.ddkits_alias
      sudo chmod u+x ~/.ddkits_alias
      if [[ -f "~/.ddkits_alias" ]]; then
        source ~/.ddkits_alias
      fi
      if [[ -f "~/.ddkits_alias_web" ]]; then
        source ~/.ddkits_alias_web
      fi
      if [[ -f "./ddkits.private.sh" ]]; then
        source ./ddkits.private.sh
      fi
    else
      cp ddkits.alias.sh ddkits_alias
      sudo cp ddkits_alias ~/.ddkits_alias
      sudo chmod u+x ~/.ddkits_alias
      if [[ -f "~/.ddkits_alias" ]]; then
        source ~/.ddkits_alias
      fi
      if [[ -f "~/.ddkits_alias_web" ]]; then
        source ~/.ddkits_alias_web
      fi
      if [[ -f "./ddkits.private.sh" ]]; then
        source ./ddkits.private.sh
      fi
  fi
  docker restart $(docker ps -q)
  elif [[ $1 == "com" ]]; then
    clear
        cat "./ddkits-files/ddkits/logo.txt"
        php ddkits.phar install
  elif [[ $1 == "update" ]]; then
    clear
        cat "./ddkits-files/ddkits/logo.txt"
        docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d
    elif [[ $1 == "rebuild" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
        docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d --build --force-recreate
  elif [[ $1 == "start" ]]; then
    clear
        if [[ $2 == "prod" ]]; then
          cat "./ddkits-files/ddkits/logo.txt"
          source ddkitsProd.sh && docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d --force-recreate
        elif [[ $2 == "com" ]]; then
          clear
        cat "./ddkits-files/ddkits/logo.txt"
         source ddkitsLocal.sh && composer install
        else
         source ddkitsLocal.sh && docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d --force-recreate
    fi
  elif [[ $1 == "c" ]]; then
    clear
        cat "./ddkits-files/ddkits/logo.txt"
        docker ps
  elif [[ $1 == "who" ]]; then
    clear
        cat "./ddkits-files/ddkits/logo.txt"
        cat "./ddkits-files/ddkits/site.txt"
    elif [[ $1 == "clean" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
        docker volume rm $(docker volume ls -qf dangling=true)
    elif [[ $1 == "rmn" ]]; then
    clear
        cat "./ddkits-files/ddkits/logo.txt" 
        # remove none images and volumes
        docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
        docker volume rm $(docker volume ls -f dangling=true -q)
    elif [[ $1 == "style" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
        echo "${red}hello ${yellow}this is ${green}coloured${normal}"
    elif [[ $1 == "nostyle" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
        docker ps
  elif [[ $1 == "i" ]]; then
    clear
        cat "./ddkits-files/ddkits/logo.txt"
        docker images
    elif [[ $1 == "go" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
        echo -e ''
        echo ':---)) Welcome back ' && echo "$USER"
        echo -e ''
        source ~/.ddkits_alias
        docker-machine start ddkits
        eval $(docker-machine env ddkits)
    elif [[ $1 == "del" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
        echo -e ''
        echo ':---(( Bye ' && echo "$USER"
        echo -e ''
        docker-machine rm ddkits
        eval $(docker-machine env default)
    elif [[ $1 == "stop" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
        echo -e ''
        echo 'Bye for now  ' && echo "$USER"
        echo -e ''
        eval $(docker-machine env default)
  elif [[ $1 == "r" ]]; then
    clear
        cat "./ddkits-files/ddkits/logo.txt"
        docker run
    elif [[ $1 == "ir" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
        echo -e 'please use "  ddkri  " instead \n or "  ddk rm all  " to delete all dockers images and containers from your machine'
    elif [[ $1 == "cr" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
        echo -e 'please use "  ddkrc  " instead '
     elif [[ $1 == "drush" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
        if [[ $2 == "install" ]]; then
          clear
        cat "./ddkits-files/ddkits/logo.txt"
        # install composer locally for drush needs and other composer packages
        wget https://getcomposer.org/composer.phar
        echo $SUDOPASS | sudo -S mv composer.phar /usr/local/bin/
        chmod  -R 777 /usr/local/bin/composer.phar
        composer global require drush/drush:dev-master
    fi
    elif [[ $1 == "rm" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
        if [[ $2 == "all" ]]; then
          clear
        cat "./ddkits-files/ddkits/logo.txt"
        source $(pwd)/ddkits.rm.sh
        elif [[ $2 == "c" ]]; then
          clear
        cat "./ddkits-files/ddkits/logo.txt"
           # Delete all containers
            docker rm $(docker ps -a -q) -f
        elif [[ $2 == "i" ]]; then
          clear
        cat "./ddkits-files/ddkits/logo.txt"
            # Delete all images
            docker rmi $(docker images -q) -f
      else
      docker-compose -f ddkits.yml -f ddkits.env.yml rm
       fi
     elif [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
      clear
        cat "./ddkits-files/ddkits/logo.txt"
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
          com   - Start installation with compsoer before docker "you need to modify your composer"
          prod  - Start production installation
          dev   - Start production installation
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


    Containers Use:
    Jenkins     http://jenkins.YOUR_DOMAIN.ddkits.site
    SOLR     http://solr.YOUR_DOMAIN.ddkits.site
    PhpMyAdmin     http://admin.YOUR_DOMAIN.ddkits.site

    DDKits v1.20
        '
     else
      echo 'DDkits build by Mutasem Elayyoub and ready to usesource  www.DDKits.com
      To see all commands write " ddk -h / ddk --help "'
      ddk -h
   fi
}
alias ddkrc='docker rm -f '
alias ddkri='docker rmi -f '
