FROM ddkits/lamp:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/cloud_dev.conf /etc/apache2/sites-enabled/cloud_dev.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY get-pip.py /var/www/html/get-pip.py
COPY ddkits-check.sh /var/www/html/ddkits-check.sh


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
                   snap \
                   python \
                   python-dev \
                   pacman \
                   python-software-properties \
                   apt-file \
                   software-properties-common \
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw 

RUN chmod -R 777 /var/www/html 
RUN chmod u+x /var/www/html/ddkits-check.sh
RUN apt-get -f install -y 
RUN a2enmod headers \
  && a2enmod env \
  && a2enmod dir \
  && a2enmod mime \
  && service apache2 reload 
  # Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data

  
