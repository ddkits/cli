#!/bin/sh

#  Script.sh
# built by Sam Ayoub https://ddkits.com
# insert DDKits alias into anyh system command lines
# source 'ddkits.alias.sh'
DDKITSFL=$(pwd)
export DDKITSFL=$DDKITSFL

echo -ne '#############             (66%)\r'
sleep 1
DDKITSWEBPORT="$(awk -v min=9000 -v max=9999 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
echo -e "  Your new Web port is  ${DDKITSWEBPORT}  "
DDKITSWEBPORTSSL="$(awk -v min=6010 -v max=7000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
echo -e "  Your new Web SSL port is  ${DDKITSWEBPORTSSL}  "
DDKITSDBPORT="$(awk -v min=1510 -v max=2000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
echo -e "Your new DB port is  ${DDKITSDBPORT}  "
DDKITSJENKINSPORT="$(awk -v min=4001 -v max=4999 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
echo -e "Your new Jenkins port is  ${DDKITSJENKINSPORT} "
DDKITSSOLRPORT="$(awk -v min=3010 -v max=4000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
echo -e "Your new Solr port is  ${DDKITSSOLRPORT} "
DDKITSADMINPORT="$(awk -v min=5010 -v max=6000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
echo -e "Your new PhpMyAdmin port is  ${DDKITSADMINPORT} "
DDKITSREDISPORT="$(awk -v min=7010 -v max=8000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
echo -e "Your new Radis port is  ${DDKITSREDISPORT} "
DDKITSPSTGPORT="$(awk -v min=8010 -v max=9000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
echo -e "Your new Radis port is  ${DDKITSPSTGPORT} "
DDKITSVER="$(echo $DDKITSIP)"
echo -e "Your new Server is using ip  ${DDKITSVER} "

export DDKITSVER=$DDKITSVER
export DDKITSPHPVERSION=$DDKITSPHPVERSION
export DDKITSVER=$DDKITSIP
export DDKITSDBPORT=$DDKITSDBPORT
export DDKITSREDISPORT=$DDKITSREDISPORT
export DDKITSSOLRPORT=$DDKITSSOLRPORT
export DDKITSADMINPORT=$DDKITSADMINPORT
export DDKITSWEBPORT=$DDKITSWEBPORT
export DDKITSWEBPORTSSL=$DDKITSWEBPORTSSL
export DDKITSJENKINSPORT=$DDKITSJENKINSPORT
export DDKITSPSTGPORT=$DDKITSPSTGPORT

if [[ -f $DDKITSFL'/ddkits-files/ddkitsInfo.ports.sh' ]]; then
  rm -rf $DDKITSFL/ddkits-files/ddkitsInfo.ports.sh
fi

echo -e '

#!/bin/sh

#  Script.sh
#  Created by Sam Ayoub https://ddkits.com
#

export DDKITSFL='${DDKITSFL}'
export DDKITSPHPVERSION='${DDKITSPHPVERSION}'
export DDKITSDBPORT='${DDKITSDBPORT}'
export SUDOPASS='${SUDOPASS}'
export DDKITSREDISPORT='${DDKITSREDISPORT}'
export DDKITSSOLRPORT='${DDKITSSOLRPORT}'
export DDKITSADMINPORT='${DDKITSADMINPORT}'
export DDKITSWEBPORT='${DDKITSWEBPORT}'
export DDKITSWEBPORTSSL='${DDKITSWEBPORTSSL}'
export DDKITSJENKINSPORT='${DDKITSJENKINSPORT}'
export DDKITSPSTGPORT='${DDKITSPSTGPORT}'
' > $DDKITSFL/ddkits-files/ddkitsInfo.ports.sh

source ~/.ddkits/ddkits.dev.sh

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
  pstgdb:
    image: postgres
    
    container_name: '$DDKITSHOSTNAME'_ddkits_pstgdb
    environment:
     - POSTGRES_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - POSTGRES_USER='$MYSQL_USER'
     - POSTGRES_DB='$MYSQL_DATABASE'
    ports:
        - '$DDKITSPSTGPORT':5432
    networks:
      - ddkits
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
networks:
    ddkits:

  ' > $DDKITSFL/ddkitsnew.yml

elif [[ "$JENKINS_ANSWER" == "y" ]] && [[ "$SOLR_ANSWER" == "y" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
  echo -e 'version: "3.1"

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
  pstgdb:
    image: postgres
    
    container_name: '$DDKITSHOSTNAME'_ddkits_pstgdb
    environment:
     - POSTGRES_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - POSTGRES_USER='$MYSQL_USER'
     - POSTGRES_DB='$MYSQL_DATABASE'
    ports:
        - '$DDKITSPSTGPORT':5432
    networks:
      - ddkits
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

  ' > $DDKITSFL/ddkitsnew.yml

# Create our system ddkits enviroment

elif [[ "$JENKINS_ANSWER" == "n" ]] && [[ "$SOLR_ANSWER" == "y" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
  echo -e 'version: "3.1"

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
  pstgdb:
    image: postgres
    
    container_name: '$DDKITSHOSTNAME'_ddkits_pstgdb
    environment:
     - POSTGRES_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - POSTGRES_USER='$MYSQL_USER'
     - POSTGRES_DB='$MYSQL_DATABASE'
    ports:
        - '$DDKITSPSTGPORT':5432
    networks:
      - ddkits
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

  ' > $DDKITSFL/ddkitsnew.yml

# Create our system ddkits enviroment

elif [[ "$JENKINS_ANSWER" == "y" ]] && [[ "$SOLR_ANSWER" == "n" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
  echo -e 'version: "3.1"

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
  pstgdb:
    image: postgres
    
    container_name: '$DDKITSHOSTNAME'_ddkits_pstgdb
    environment:
     - POSTGRES_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - POSTGRES_USER='$MYSQL_USER'
     - POSTGRES_DB='$MYSQL_DATABASE'
    ports:
        - '$DDKITSPSTGPORT':5432
    networks:
      - ddkits
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

  ' > $DDKITSFL/ddkitsnew.yml

# Create our system ddkits enviroment

elif [[ "$JENKINS_ANSWER" == "n" ]] && [[ "$SOLR_ANSWER" == "n" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
  echo -e 'version: "3.1"

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
  pstgdb:
    image: postgres
    
    container_name: '$DDKITSHOSTNAME'_ddkits_pstgdb
    environment:
     - POSTGRES_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - POSTGRES_USER='$MYSQL_USER'
     - POSTGRES_DB='$MYSQL_DATABASE'
    ports:
        - '$DDKITSPSTGPORT':5432
    networks:
      - ddkits
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

  ' > $DDKITSFL/ddkitsnew.yml

fi
# create alias for the containers
source ~/.ddkits/ddkits.alias.web.sh

#  All information in one file html as a referance

echo -e '#<html><head><!--

# Your Bash script goes here

<<HTML_CONTENT
-->
<body style="background-color:white; margin-top:-1em">
<center><h3>Your DDKits information:</h3></center><br />
<br /><br /><br /><br />
<br />
DDKITSVER = '$DDKITSVER'
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
- Your new Postgres port is: '$DDKITSPSTGPORT'<br />
<br /><br /><br /><br />
<center>Thank you for using DDKits, feel free to contact us @ melayyoub@outlook.com <br />
Copyright @2017 <a href="http://ddkits.com/">DDKits.com</a></center>
<!--
HTML_CONTENT
# --></body></html>' > ./ddkits-$DDKITSHOSTNAME.html

echo -e '
DDKITSVER = '$DDKITSVER'
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
- Your new Postgres port is: '$DDKITSPSTGPORT'

Thank you for using DDKits, feel free to contact us @ melayyoub@outlook.com
Copyright @2017 DDKits.com. sam Ayoub
' > ./ddkits-files/ddkits/site.txt

if [ -f "ddkits.prod.sh" ]; then
  echo -e 'Production'
else
  # Remove the Source from Bash file
  BASHSITE=ddk
  BSHFILE=~/.bash_profile
  matchesbash="$(grep -n ${BASHSITE} ${BSHFILE} | cut -f1 -d:)"
  if [ ! -z "$matchesbash" ]; then
    echo "Updating Hosts file"

    # iterate over the line numbers on which matches were found
    while read -r line_number; do
      # Remove all DDkits entries
      echo ${SUDOPASS} | sudo -S sed -i '' "/${line_number}/d" ${BSHFILE}
    done <<< "$matchesbash"
  fi
  echo $SUDOPASS | sudo -S echo 'source ~/.ddkits/ddkits.alias.sh  ~/.ddkits_alias_web &>/dev/null' >> ~/.bash_profile
  # echo $SUDOPASS | sudo -S cat ~/.ddkits_alias_web
  echo $SUDOPASS | sudo -S chmod u+x ~/.ddkits_alias_web
  source ~/.bash_profile

fi

#  prepare ddkits container for the new websites
echo -e 'copying conf files into ddkits and restart'
docker cp ./ddkits-files/ddkits/sites/ddkitscust.conf ddkits:/etc/apache2/sites-enabled/ddkits_$DDKITSHOSTNAME.conf
# docker cp ./ddkitscli.sh $DDKITSHOSTNAME'_ddkits_joomla_web':/var/www/html/ddkitscli.sh
# copy ssl crt keys to ddkits proxy
docker cp ./ddkits-files/ddkits/ssl/$DDKITSSITES.crt ddkits:/etc/ssl/certs/$DDKITSSITES.crt
docker cp ./ddkits-files/ddkits/ssl/$DDKITSSITES.key ddkits:/etc/ssl/certs/$DDKITSSITES.key
docker restart ddkits
ddk go

echo -e '
###################################################################################################################  make sure to restart the apachectl after fixing the hosts file
#  sudo apachectl restart   OR sudo service apache2 restart OR by manual restart it within the UI panel
###################################################################################################################
'

echo -ne '#######################   (100%)\r'
echo -ne '\n'
