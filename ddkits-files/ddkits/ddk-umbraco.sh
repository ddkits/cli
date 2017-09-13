#!/bin/sh

#  Script.sh
#
# Umbraco
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
if [[  -f "${DDKITSFL}/ddkits-files/umbraco/Dockerfile" ]]; then
  rm $DDKITSFL/ddkits-files/umbraco/Dockerfile
fi
# delete the old environment yml file
if [[  -f "${DDKITSFL}/ddkits-files/ddkits.fix.sh" ]]; then
  rm $DDKITSFL/ddkits-files/ddkits.fix.sh
fi
if [[  -f "${DDKITSFL}/ddkits-files/umbraco/sites/$DDKITSHOSTNAME.conf" ]]; then
  rm $DDKITSFL/ddkits-files/umbraco/sites/$DDKITSHOSTNAME.conf
fi
if [[ ! -d "${DDKITSFL}/ddkits-files/umbraco/sites" ]]; then 
  mkdir $DDKITSFL/ddkits-files/umbraco/sites
  chmod -R 777 $DDKITSFL/ddkits-files/umbraco/sites 
fi
# Umbraco with ASPNET server


echo -e 'FROM kevinobee/umbraco:latest ' >> $DDKITSFL/ddkits-files/umbraco/Dockerfile

echo -e 'version: "2"

services:
  web:
    build: $DDKITSFL/ddkits-files/umbraco
    image: ddkits/umbraco:latest
    
    volumes:
      - $DDKITSFL/um-deploy:/var/www/html
    stdin_open: true
    tty: true
    container_name: ${DDKITSHOSTNAME}_ddkits_umbraco_web
    networks:
      - ddkits
    ports:
      - "'$DDKITSWEBPORT':80" ' >> $DDKITSFL/ddkits.env.yml

echo $SUDOPASS | sudo -S chmod -R 777 $DDKITSFL/um-deploy


cd $DDKITSFL