
FROM ddkits/lamp:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/*
COPY sites/cloud_dev.conf /etc/apache2/sites-enabled/cloud_dev.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY get-pip.py /var/www/html/get-pip.py
COPY ddkits-check.sh /var/www/html/ddkits-check.sh
RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 
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

  
