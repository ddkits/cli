#!/bin/bash
# Delete all containers
docker rm $(docker ps -a -q) -f
# Delete all images
docker rmi $(docker images -q) -f
clear
docker images
docker ps
# delete the old environment yml file
if [[ -f "ddkits.env.yml" ]]; then
  rm ddkits.env.yml
fi
# delete the old environment yml file
if [[ -f "ddkitsnew.yml" ]]; then
  rm ddkitsnew.yml
fi
if [[ -f "./Dockerfile" ]]; then
  rm ./Dockerfile
fi
#  delete ddkits conf file for the custom site if available
if [ -f "ddkits-files/ddkits/sites/ddkitscust.conf" ]
  then 
  rm ddkits-files/ddkits/sites/ddkitscust.conf
fi

echo "DDkits says : All docker images and containers removed..."