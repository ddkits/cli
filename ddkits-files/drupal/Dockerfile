FROM ddkits/lamp:latest

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/DOMAIN.conf /etc/apache2/sites-enabled/DOMAIN.conf
COPY ddkitscli.sh /var/www/html/ddkitscli.sh
COPY php5.ini /usr/local/etc/php/conf.d/php.ini

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 

RUN chmod -R 777 /var/www/html/ddkitscli.sh 

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data


