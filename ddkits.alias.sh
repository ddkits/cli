
ddk(){ 

  if [[ $1 == "install" ]]; then
       
      echo -e '(1) Localhost \n(2) virtualbox'
          read DDKITSVER
      if [[ $DDKITSVER == 2 ]]; then
        clear
           echo -e 'Enter your Sudo/Root Password:'
              read SUDOPASS
              docker-machine ip ddkits
              echo $SUDOPASS | sudo -S cp ddkits.alias.sh ddkits_alias 
              echo $SUDOPASS | sudo -S cp ddkits_alias ~/.ddkits_alias
              if [ $? -eq 0 ]; then
                  echo 'DDKits saying it is fine no need to reinstall'
              else
           
            if [[ "$OSTYPE" == "linux-gnu" ]]; then
              PLATFORM='linux-gnu'
              echo 'This machine is '$PLATFORM' Docker setup will start now'
              echo $SUDOPASS | sudo -S apt-get install wget curl git -y
              curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
              echo $SUDOPASS | sudo -S chmod +x /tmp/docker-machine &&
              echo $SUDOPASS | sudo -S cp /tmp/docker-machine /usr/local/bin/docker-machine
            elif [[ "$OSTYPE" == "darwin"* ]]; then
              PLATFORM='MacOS'
              echo 'This machine is '$PLATFORM' Docker setup will start now'
              curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
              echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-machine
            elif [[ "$OSTYPE" == "cygwin" ]]; then
              PLATFORM='cygwin'
              echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE "Docker, compose and docker-machine" INSTALLED ON YOUR SYSTEM' 
            elif [[ "$OSTYPE" == "msys" ]]; then
               PLATFORM='msys'
              echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE  "Docker, compose and docker-machine"  INSTALLED ON YOUR SYSTEM'        
            elif [[ "$OSTYPE" == "win32" ]]; then
                PLATFORM='win32'
              echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE  "Docker, compose and docker-machine"  INSTALLED ON YOUR SYSTEM'         
            elif [[ "$OSTYPE" == "freebsd"* ]]; then
               PLATFORM='freebsd'
              echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE  "Docker, compose and docker-machine"  INSTALLED ON YOUR SYSTEM'        
            else
              break
          fi
        fi
        if [[ -f  ~/.ddkits_alias ]]; then
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
      docker-compose -f ddkits.yml up -d --build
  fi
        
    
  elif [[ $1 == "ip" ]]; then
        docker-machine ip ddkits
  elif [[ $1 == "fix" ]]; then
        docker restart $(docker ps -q)
  elif [[ $1 == "com" ]]; then
        php ddkits.phar install
  elif [[ $1 == "update" ]]; then
        docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d
    elif [[ $1 == "rebuild" ]]; then
        docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d --build --force-recreate
  elif [[ $1 == "start" ]]; then
        if [[ $2 == "com" ]]; then
         . ddkitsLocal.sh && composer install 
        else
         . ddkitsLocal.sh && docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d --force-recreate
    fi
  elif [[ $1 == "c" ]]; then
        docker ps
    elif [[ $1 == "clean" ]]; then
        docker volume rm $(docker volume ls -qf dangling=true)
    elif [[ $1 == "rmn" ]]; then 
        # remove none images and volumes
        docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
        docker volume rm $(docker volume ls -f dangling=true -q)
    elif [[ $1 == "style" ]]; then
        echo "${red}hello ${yellow}this is ${green}coloured${normal}"
    elif [[ $1 == "nostyle" ]]; then
        docker ps
  elif [[ $1 == "i" ]]; then
        docker images
    elif [[ $1 == "go" ]]; then
        echo -e ''
        echo ':---)) Welcome back ' && echo "$USER"
        echo -e ''
        source ~/.ddkits_alias
        docker-machine start ddkits
        eval $(docker-machine env ddkits)
    elif [[ $1 == "del" ]]; then
        echo -e ''
        echo ':---(( Bye ' && echo "$USER"
        echo -e ''
        docker-machine rm ddkits
        eval $(docker-machine env default)
    elif [[ $1 == "stop" ]]; then
        echo -e ''
        echo 'Bye for now  ' && echo "$USER"
        echo -e ''
        eval $(docker-machine env default)
  elif [[ $1 == "r" ]]; then
        docker run
    elif [[ $1 == "ir" ]]; then
        echo -e 'please use "  ddkri  " instead \n or "  ddk rm all  " to delete all dockers images and containers from your machine'
    elif [[ $1 == "cr" ]]; then
        echo -e 'please use "  ddkrc  " instead '
     elif [[ $1 == "drush" ]]; then
        if [[ $2 == "install" ]]; then
        # install composer locally for drush needs and other composer packages
        wget https://getcomposer.org/composer.phar
        echo $SUDOPASS | sudo -S mv composer.phar /usr/local/bin/
        chmod  -R 777 /usr/local/bin/composer.phar
        composer global require drush/drush:dev-master
    fi
    elif [[ $1 == "rm" ]]; then
        if [[ $2 == "all" ]]; then   
        . $(pwd)/ddkits.rm.sh
        elif [[ $2 == "c" ]]; then
           # Delete all containers
            docker rm $(docker ps -a -q) -f
        elif [[ $2 == "i" ]]; then
            # Delete all images
            docker rmi $(docker images -q) -f
      else
      docker-compose -f ddkits.yml -f ddkits.env.yml rm
       fi
     elif [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
      clear
      echo -e "\033[33;31m "
        echo -e 'DDkits built by Mutasem Elayyoub www.DDKits.com
    List of commands after "ddk <option>":

        -h      - Show comand list
        go      - Start or check your DDKits working or not
        stop    - ACtivate default vm
        del     - Remove DDKits VM and go back to default
        clean   - Clean undefiend or unused Volumes and images
        rmn     - Clean <none> extra images and containers
        fix     - Fix DDKits containers in full for any problem
        start   - Start new your ddkits setup process "this command must be in your project folder"
          com   - Start installation with compsoer before docker "you need to modify your composer"
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
    Jenkins     http://jenkins.YOUR_WEBSITE
    SOLR     http://solr.YOUR_WEBSITE
    PhpMyAdmin     http://admin.YOUR_WEBSITE


    DDKits v1.12
        '
     else
      echo 'DDkits build by Mutasem Elayyoub and ready to use.  www.DDKits.com
      To see all commands write " ddk -h / ddk --help "'
      ddk -h
   fi
}
alias ddkrc='docker rm -f '
alias ddkri='docker rmi -f '
