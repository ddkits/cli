

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/d8_dev.conf /etc/apache2/sites-enabled/d8_dev.conf
COPY ddkitscli.sh /var/www/html/ddkitscli.sh
COPY php7.ini /usr/local/etc/php/conf.d/php.ini

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite 
 
RUN chmod -R 777 /var/www/html
RUN apt-get install drush -y --force-yes \
    && drush dl drush --destination="/usr/share" \
    && drush --version
RUN chmod -R 777 /var/www/html/ddkitscli.sh 
RUN apt-get update \
  && apt-get upgrade
# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data


