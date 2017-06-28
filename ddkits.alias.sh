
ddk(){ 
	if [[ $1 == "install" ]]; then
		if [[ -f  ~/.ddkits_alias ]]; then
            docker-compose -f ddkits.yml up -d --build
			cp ddkits.alias.sh ddkits_alias -f
			cp ddkits_alias ~/.ddkits_alias -f
			echo -e '\nDDKits Already installed successfully before, \nThank you for using DDKits'
			else
            docker-compose -f ddkits.yml up -d --build
			cp ddkits.alias.sh ddkits_alias -f
			cp ddkits_alias ~/.ddkits_alias -f
			echo 'command source ~/.ddkits_alias 2>/dev/null || true ' >> ~/.bash_profile
			echo -e '\nDDKits installed successfully, \nThank you for using DDKits'
		fi
		
	elif [[ $1 == "update" ]]; then
		docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d
    elif [[ $1 == "rebuild" ]]; then
        docker-compose -f ddkitsnew.yml -f ddkits.env.yml up -d --build --force-recreate
	elif [[ $1 == "start" ]]; then
        if [[ $2 == "com" ]]; then
         . ddkitsLocal.sh && composer install && composer install 
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
     	echo -e "\033[33;31m "
        echo -e 'DDkits built by Mutasem Elayyoub www.DDKits.com
    List of commands after "ddk <option>":

        -h      show comand list

        start   start new your ddkits setup process "this command must be in your project folder"
          com Start installation with compsoer before docker "you need to modify your composer
                depending on your platform choice."
       
        update  update your ddkits setup process "this command must be in your project folder"
       
        rebuild update your ddkits rebuild and build your project images and containers
                process "this command must be in your project folder"
       
        i       show all your docker images
        c       show all your docker containers
        r       docker run\n
        rm      act like docker-compose rm in your
        rm all  restore docker images and containers "Important this command remove all your containers and images"

    List of commands after "ddk<option>":
        ri      remove an image from docker images
        rc      remove a continer from docker containers

    Containers Use:
    Jenkins     http://jenkins.YOUR_WEBSITE
    SOLR     http://solr.YOUR_WEBSITE
    PhpMyAdmin     http://admin.YOUR_WEBSITE

        '
        echo -e "\033[33;30m "
     else
     	echo -e "\033[33;31m "
     	echo 'DDkits build by Mutasem Elayyoub and ready to use.  www.DDKits.com
     	To see all commands write " ddk -h / ddk --help "'
     	ddk -h
     	echo -e "\033[33;30m "
   fi
}
alias ddkrc='docker rm -f '
alias ddkri='docker rmi -f '


