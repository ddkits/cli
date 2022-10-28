#!/bin/sh

#  Script.sh
#
# Jenkins
#
# This system built by Mutasem Elayyoub DDKits.com

# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits.env.yml" ]]; then
  rm $DDKITSFL/ddkits.env.yml
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkitsnew.yml" ]]; then
  rm $DDKITSFL/ddkitsnew.yml
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits-files/jenkins/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/jenkins/Dockerfile
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits-files/jenkins/composer.json" ]]; then
  rm $DDKITSFL/ddkits-files/jenkins/composer.json
fi
# delete the old environment yml file
if [[ -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[ -f "${DDKITSFL}/ddkits-files/jenkins/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/jenkins/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/jenkins/sites" ]]; then
  mkdir $DDKITSFL/ddkits-files/jenkins/sites
  chmod -R 777 $DDKITSFL/ddkits-files/jenkins/sites
fi
echo -e '

FROM whywebs/jenkins:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

' >>$DDKITSFL/ddkits-files/jenkins/Dockerfile

echo -e 'version: "3.1"

services:
  web:
    build: $DDKITSFL/ddkits-files/jenkins
    image: ddkits/jenkins:latest

    volumes:
      - $DDKITSFL/jenkins-deploy:/var/jenkins_home
      - $DDKITSFL/logs/jenkins.log:/var/log/jenkins/
    stdin_open: true
    tty: true
    container_name: '$DDKITSHOSTNAME'_ddkits_jenkins_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80"
      - "'$DDKITSWEBPORTSSL':443" ' >>$DDKITSFL/ddkits.env.yml

if [[ ! -d "jenkins" ]]; then

fi

# create get into ddkits container
echo $SUDOPASS | sudo -S cat ~/.ddkits_alias >/dev/null
alias ddkc-$DDKITSSITES='docker exec -it ${DDKITSHOSTNAME}_ddkits_jenkins_web /bin/bash'
alias ddkc-$DDKITSSITES-pass='cat "${DDKITSFL}/jenkins-deploy/secrets/initialAdminPassword"'
#  fixed the alias for machine
echo "alias ddkc-"$DDKITSSITES"='ddk go && docker exec -it "$DDKITSHOSTNAME"_ddkits_jenkins_web /bin/bash'" >>~/.ddkits_alias_web
echo "alias ddkc-"$DDKITSSITES"-pass='cat '"$DDKITSFL"/jenkins-deploy/secrets/initialAdminPassword''" >>~/.ddkits_alias_web
echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/jenkins

cd $DDKITSFL
