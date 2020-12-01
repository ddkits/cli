#!/bin/sh

#  Script.sh
#
#
#
# This system built by Mutasem Elayyoub DDKits.com

DDKITSFL=$(pwd)
export $DDKITSFL
export $DDKITSSITES
WORDTOREMOVE='.site'
DDKITSSSL=${DDKITSSITES//$WORDTOREMOVE/}
# Check DDKits ENV file
if [[ -f '.ddkenv' ]]; then
  source .ddkenv

  #
  mkdir .ddkits
  cat "~/.ddkits/ddkits-files/ddkits/logo.txt"
  # create the crt files for ssl
  openssl req \
    -newkey rsa:2048 \
    -x509 \
    -nodes \
    -keyout $DDKITSSSL.key \
    -new \
    -out $DDKITSSSL.crt \
    -subj /CN=$DDKITSSSL \
    -reqexts SAN \
    -extensions SAN \
    -config <(cat /System/Library/OpenSSL/openssl.cnf \
      <(printf '[SAN]\nsubjectAltName=DNS:'$DDKITSSITES'')) \
    -sha256 \
    -days 3650

  # SSL
  mkdir .ddkits/ssl
  mv $DDKITSSITES.key $DDKITSFL/.ddkits/ssl
  mv $DDKITSSITES.crt $DDKITSFL/.ddkits/ssl
  echo "ssl crt and .key files moved correctly"

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
MAIL_ADDRESS='"$MAIL_ADDRESS"'\n" >.ddkits/ddkitscli.sh

  # create different containers files for conf
  echo -e '
<VirtualHost *:80>
     ServerAdmin melayyoub@outlook.com
     ServerName '$DDKITSSITES'
     '$DDKITSSERVERS'
     DocumentRoot /var/www/html/'$DOCUMENTROOT'
      ErrorLog /var/www/html/error.log
     CustomLog /var/www/html/access.log combined
    <Location "/">
      Require all granted
      AllowOverride All
      Order allow,deny
      allow from all
  </Location>
  <Directory "/var/www/html">
      Options Indexes FollowSymLinks
  AllowOverride All
  Require all granted
  RewriteEngine on
    RewriteBase /
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} !=/favicon.ico
    RewriteRule ^ index.php [L]
  </Directory>
</VirtualHost>

<VirtualHost *:443>
  ServerAdmin melayyoub@outlook.com
   ServerName '$DDKITSSITES'
   '$DDKITSSERVERS'
    DocumentRoot /var/www/html/'$DOCUMENTROOT'

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

  <Location "/">
      Require all granted
      AllowOverride All
      Order allow,deny
      allow from all
  </Location>
  <Directory "/var/www/html">
      Require all granted
      AllowOverride All
      Order allow,deny
      allow from all
  </Directory>
</VirtualHost>
' >.ddkits/$DDKITSHOSTNAME.conf

  # Build out docker file to start our install
  echo -e '

FROM ddkits/lamp:'$PHPVERSION'

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/*
COPY '$DDKITSHOSTNAME'.conf /etc/apache2/sites-enabled/'$DDKITSHOSTNAME'.conf

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf
RUN chmod -R 777 /var/www/html
RUN composer require drush/drush && composer outdated && composer update
RUN export PATH="$HOME/.composer/vendor/bin:$PATH"
RUN echo "export PATH="$HOME/.composer/vendor/bin:$PATH" ">> ~/.bashrc
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B188E2B695BD4743

# Fixing permissions
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

' >.ddkits/Dockerfile

  #  create ddkits compose file for the new website
  echo -e 'version: "3.1"

services:
  web:
    build: .ddkits/
    volumes:
      # Mount the local directory in the container
      - .:/var/www/html
    stdin_open: true
    tty: true
    environment:
      - DDKITSHOSTNAME="'$DDKITSHOSTNAME'"
    container_name: '$DDKITSHOSTNAME'_ddkits_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80"
      - "'$DDKITSWEBPORTSSL':443" ' >ddkits.env.yml

  #

  echo -ne '#############             (66%)\r'
  sleep 1
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

  if [[ -f $DDKITSFL'/ddkits-files/ddkitsInfo.ports.sh' ]]; then
    rm -rf $DDKITSFL/ddkits-files/ddkitsInfo.ports.sh
  fi

  echo -e '

#!/bin/sh

#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#

export DDKITSFL='$(pwd)'
export DDKITSDBPORT='${DDKITSDBPORT}'
export SUDOPASS='${SUDOPASS}'
export DDKITSREDISPORT='${DDKITSREDISPORT}'
export DDKITSSOLRPORT='${DDKITSSOLRPORT}'
export DDKITSADMINPORT='${DDKITSADMINPORT}'
export DDKITSWEBPORT='${DDKITSWEBPORT}'
export DDKITSWEBPORTSSL='${DDKITSWEBPORTSSL}'
export DDKITSJENKINSPORT='${DDKITSJENKINSPORT}'
' >$DDKITSFL/ddkits-files/ddkitsInfo.ports.sh

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
    image: mariadb:latest
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
    image: solr:5.5.4-alpine
    container_name: '$DDKITSHOSTNAME'_ddkits_solr
    networks:
      - ddkits
    ports:
      - "'$DDKITSSOLRPORT':8983"

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: '$DDKITSHOSTNAME'_ddkits_phpadmin
    environment:
     - PMA_ARBITRARY=1
     - MYSQL_ROOT_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - MYSQL_DATABASE='$MYSQL_DATABASE'
     - MYSQL_USER='$MYSQL_USER'
     - MYSQL_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - MYSQL_HOST='$DDKITSIP'
    volumes:
     - ./phpmyadmin:/etc/phpmyadmin
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
    image: whywebs/jenkins:latest
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

  ' >ddkitsnew.yml

  # Create our system ddkits enviroment

  elif [[ "$JENKINS_ANSWER" == "n" ]] && [[ "$SOLR_ANSWER" == "y" ]] && [[ "$JENKINS_ONLY" == "false" ]]; then
    echo -e 'version: "3.1"

services:
  mariadb:
    image: mariadb:latest
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
    image: solr:5.5.4-alpine
    container_name: '$DDKITSHOSTNAME'_ddkits_solr
    networks:
      - ddkits
    ports:
      - "'$DDKITSSOLRPORT':8983"

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: '$DDKITSHOSTNAME'_ddkits_phpadmin
    environment:
     - PMA_ARBITRARY=1
     - MYSQL_ROOT_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - MYSQL_DATABASE='$MYSQL_DATABASE'
     - MYSQL_USER='$MYSQL_USER'
     - MYSQL_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - MYSQL_HOST='$DDKITSIP'
    volumes:
     - ./phpmyadmin:/etc/phpmyadmin
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
    image: mariadb:latest
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
    image: phpmyadmin/phpmyadmin
    container_name: '$DDKITSHOSTNAME'_ddkits_phpadmin
    environment:
     - PMA_ARBITRARY=1
     - MYSQL_ROOT_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - MYSQL_DATABASE='$MYSQL_DATABASE'
     - MYSQL_USER='$MYSQL_USER'
     - MYSQL_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - MYSQL_HOST='$DDKITSIP'
    volumes:
     - ./phpmyadmin:/etc/phpmyadmin
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
    image: whywebs/jenkins:latest
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
    image: mariadb:latest
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
    image: phpmyadmin/phpmyadmin
    container_name: '$DDKITSHOSTNAME'_ddkits_phpadmin
    environment:
     - PMA_ARBITRARY=1
     - MYSQL_ROOT_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - MYSQL_DATABASE='$MYSQL_DATABASE'
     - MYSQL_USER='$MYSQL_USER'
     - MYSQL_PASSWORD='$MYSQL_ROOT_PASSWORD'
     - MYSQL_HOST='$DDKITSIP'
    volumes:
     - ./phpmyadmin:/etc/phpmyadmin
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
# --></body></html>' >~/.ddkits/ddkits-$DDKITSHOSTNAME.html

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
' >~/.ddkits/ddkits-files/ddkits/site.txt

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
      done <<<"$matchesbash"
    fi
    echo $SUDOPASS | sudo -S echo 'source ~/.ddkits/ddkits.alias.sh' >>~/.bash_profile
    echo $SUDOPASS | sudo -S echo 'source ~/.ddkits_alias_web' >>~/.bash_profile
    # echo $SUDOPASS | sudo -S cat ~/.ddkits_alias_web
    echo $SUDOPASS | sudo -S chmod u+x ~/.ddkits_alias_web
    source ~/.bash_profile

  fi

  #

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

      " >.ddkits/ddkitscust.conf
  echo -ne '\n'

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

  #  prepare ddkits container for the new websites
  echo -e 'copying conf files into ddkits and restart'
  docker cp .ddkits/ddkitscust.conf ddkits:/etc/apache2/sites-enabled/ddkits_$DDKITSHOSTNAME.conf
  # docker cp ~/.ddkits/ddkitscli.sh $DDKITSHOSTNAME'_ddkits_joomla_web':/var/www/html/ddkitscli.sh
  # copy ssl crt keys to ddkits proxy
  docker cp ~/.ddkits/ddkits-files/ddkits/ssl/$DDKITSSITES.crt ddkits:/etc/ssl/certs/$DDKITSSITES.crt
  docker cp ~/.ddkits/ddkits-files/ddkits/ssl/$DDKITSSITES.key ddkits:/etc/ssl/certs/$DDKITSSITES.key
  docker restart ddkits
  ddk go

################################# DO NOT START #################################
else
  echo '.ddkenv file must exist to run ready installation, or start a new installation by running '
  command || exit 1
fi
