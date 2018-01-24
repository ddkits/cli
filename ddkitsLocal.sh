#!/bin/sh

#  Script.sh
#
#
#
# This system built by Mutasem Elayyoub DDKits.com
# insert DDKits alias into anyh system command lines
source 'ddkits.alias.sh'
DDKITSFL=$(pwd)
export $DDKITSFL

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

export DDKITSDBPORT=$DDKITSDBPORT
export DDKITSREDISPORT=$DDKITSREDISPORT
export DDKITSSOLRPORT=$DDKITSSOLRPORT
export DDKITSADMINPORT=$DDKITSADMINPORT
export DDKITSWEBPORT=$DDKITSWEBPORT
export DDKITSJENKINSPORT=$DDKITSJENKINSPORT

echo -e '
export DDKITSWEBPORT="'${DDKITSWEBPORT}'"
export DDKITSDBPORT="'${DDKITSDBPORT}'"
export DDKITSJENKINSPORT="'${DDKITSJENKINSPORT}'"
export DDKITSSOLRPORT="'${DDKITSSOLRPORT}'"
export DDKITSADMINPORT="'${DDKITSADMINPORT}'"
export DDKITSREDISPORT="'${DDKITSREDISPORT}'"
  ' > $DDKITSFL/ddkits-files/ddkitsInfo.ports.sh

source $DDKITSFL'/ddkits.dev.sh'

clear
cat "$DDKITSFL/ddkits-files/ddkits/logo.txt"


# Create our system ddkits enviroment
if [[ "$JENKINS_ONLY" == "true" ]]; then
  echo -e 'version: "2"

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

  ' >> $DDKITSFL/ddkitsnew.yml

elif [[ "$JENKINS_ANSWER" == "y" ]] && [[ "$SOLR_ANSWER" == "y" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
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

  ' >> $DDKITSFL/ddkitsnew.yml

# Create our system ddkits enviroment

elif [[ "$JENKINS_ANSWER" == "n" ]] && [[ "$SOLR_ANSWER" == "y" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
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

  ' >> $DDKITSFL/ddkitsnew.yml

# Create our system ddkits enviroment

elif [[ "$JENKINS_ANSWER" == "y" ]] && [[ "$SOLR_ANSWER" == "n" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
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

  ' >> $DDKITSFL/ddkitsnew.yml

# Create our system ddkits enviroment

elif [[ "$JENKINS_ANSWER" == "n" ]] && [[ "$SOLR_ANSWER" == "n" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
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

  ' >> $DDKITSFL/ddkitsnew.yml

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

echo -e '
MAIL_ADDRESS = '$MAIL_ADDRESS'
Website = '$DDKITSSITES'
DDKits ip = '$DDKITSIP' ==> Port = '$DDKITSWEBPORT'
Mysql User = '$MYSQL_USER'
Mysql User Password = '$MYSQL_ROOT_PASSWORD'
Database name =' $MYSQL_DATABASE'
Mysql $MYSQL_USER Password = '$MYSQL_PASSWORD'
Website Alias = '$DDKITSSITESALIAS' '$DDKITSSITESALIAS2' '$DDKITSSITESALIAS3'

Ports:

- Your new '$DDKITSSITES' port is: '$DDKITSWEBPORT'
- Your new DB port is: '$DDKITSDBPORT'
- Your new Jenkins port is: '$DDKITSJENKINSPORT'
- Your new Solr port is: '$DDKITSSOLRPORT'
- Your new PhpMyAdmin port is: '$DDKITSADMINPORT'
- Your new Radis port is: '$DDKITSREDISPORT'

Thank you for using DDKits, feel free to contact us @ melayyoub@outlook.com 
Copyright @2017 DDKits.com. Mutasem Elayyoub 
' > ./ddkits-files/ddkits/site.txt


if [ -f "ddkits.prod.sh" ]
 then
    echo -e 'Production'
  else
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod u+x ~/.ddkits_alias_web
source ~/.ddkits_alias_web
source ~/.ddkits_alias
echo $SUDOPASS | sudo -S echo 'source ~/.ddkits_alias' >> ~/.bashrc_profile
echo $SUDOPASS | sudo -S echo 'source ~/.ddkits_alias_web' >> ~/.bashrc_profile

fi

#  prepare ddkits container for the new websites
echo -e 'copying conf files into ddkits and restart'
docker cp ./ddkits-files/ddkits/sites/ddkitscust.conf ddkits:/etc/apache2/sites-enabled/ddkits_$DDKITSHOSTNAME.conf
# docker cp ./ddkitscli.sh $DDKITSHOSTNAME'_ddkits_joomla_web':/var/www/html/ddkitscli.sh

docker restart ddkits
ddk go
