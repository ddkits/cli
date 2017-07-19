
#!/bin/sh

#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#

FROM ddkits/lamp:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/sym_dev.conf /etc/apache2/sites-enabled/sym_dev.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 

RUN apt-get update \
  && apt-get install build-essential apt-transport-https  -y --force-yes\
  && echo deb http://get.docker.io/ubuntu docker main\ > /etc/apt/sources.list.d/docker.list \
  && apt-get update \
  && apt-get install -y --force-yes nano \
                   wget \
                   dialog \
                   net-tools \
                   lxc-docker \
                   ufw \
                   sudo \
                   gufw \
                   python-software-properties \
                   software-properties-common \
                   libapache2-mod-php5.6 \
    && apt-get install -y --force-yes apt-transport-https 

RUN add-apt-repository ppa:ondrej/php \
  && apt-get update \
  && apt-get install php5.6-intl
RUN chmod -R 777 /var/www/html 

# installing Symfony on server 
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony \
  && chmod a+x /usr/local/bin/symfony

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
  
