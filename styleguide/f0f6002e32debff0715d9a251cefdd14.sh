#!/bin/sh

#  Script.sh
# built by Sam Ayoub https://ddkits.com

echo $SUDOPASS | sudo -S cat $LOGO
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  PLATFORM='linux-gnu'
  echo 'This machine is '$PLATFORM' Docker setup will start now'
  echo $SUDOPASS | sudo -S apt-get install wget git -y
  curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose
  curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-$(uname -s)-$(uname -m) > /tmp/docker-machine \
    && chmod +x /tmp/docker-machine \
    && echo $SUDOPASS | sudo -S cp /tmp/docker-machine /usr/local/bin/docker-machine
  echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-compose
  PLATFORM='linux-gnu'
  echo 'This machine is '$PLATFORM' Docker setup will start now'
  echo $SUDOPASS | sudo -S apt-get install wget curl git -y
  curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-$(uname -s)-$(uname -m) > /tmp/docker-machine \
    && echo $SUDOPASS | sudo -S chmod +x /tmp/docker-machine \
    && echo $SUDOPASS | sudo -S cp /tmp/docker-machine /usr/local/bin/docker-machine
elif [[ "$OSTYPE" == "darwin"* ]]; then
  PLATFORM='MacOS'
  echo 'This machine is '$PLATFORM' Docker setup will start now'
  echo $SUDOPASS | sudo -S gem install wget git -y
  curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose
  curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-$(uname -s)-$(uname -m) > /usr/local/bin/docker-machine \
    && echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-machine
  echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-compose
  PLATFORM='MacOS'
  echo 'This machine is '$PLATFORM' Docker setup will start now'
  curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-$(uname -s)-$(uname -m) > /usr/local/bin/docker-machine \
    && echo $SUDOPASS | sudo -S chmod +x /usr/local/bin/docker-machine
  echo "-- Starting Docker.app, if necessary..."

  open -g -a Docker.app || exit

  # Wait for the server to start up, if applicable.
  i=0
  while ! docker system info &> /dev/null; do
    ((i++ == 0)) && printf %s '-- Waiting for Docker to finish starting up...' || printf '.'
    sleep 1
  done
  ((i)) && printf '\n'
  echo "-- Docker is ready."
elif [[ "$OSTYPE" == "cygwin" ]]; then
  PLATFORM='cygwin'
  echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE "WGET" INSTALLED ON YOUR SYSTEM'
  PLATFORM='cygwin'
  echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE "Docker, compose and docker-machine" INSTALLED ON YOUR SYSTEM'
elif [[ "$OSTYPE" == "msys" ]]; then
  PLATFORM='msys'
  echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE "WGET" INSTALLED ON YOUR SYSTEM'
elif [[ "$OSTYPE" == "win32" ]]; then
  PLATFORM='win32'
  echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE "WGET" INSTALLED ON YOUR SYSTEM'
  if [[ ! -d "$HOME/bin" ]]; then mkdir -p "$HOME/bin"; fi \
    && curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose
  curl -L https://github.com/docker/machine/releases/download/v0.12.0/docker-machine-Windows-x86_64.exe > "$HOME/bin/docker-machine.exe" \
    && chmod +x "$HOME/bin/docker-machine.exe"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
  PLATFORM='freebsd'
  echo 'This machine is '$PLATFORM' Docker setup will start now PLEASE MAKE SURE TO HAVE "WGET" INSTALLED ON YOUR SYSTEM'
else
  echo 'Unknown system please download and install docker from https://docker.com/'
  break
fi
