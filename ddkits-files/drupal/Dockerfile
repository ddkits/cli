

FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY sites/ddk8_site.conf /etc/apache2/sites-enabled/ddk8_site.conf
COPY ddkitscli.sh /var/www/html/ddkitscli.sh
COPY php7.ini /usr/local/etc/php/conf.d/php.ini

# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf
RUN chmod -R 777 /var/www/html
RUN composer require drush/drush && composer outdated && composer update
RUN export PATH="$HOME/.composer/vendor/bin:$PATH"
RUN echo "export PATH="$HOME/.composer/vendor/bin:$PATH" ">> ~/.bashrc
RUN chmod -R 777 /var/www/html/ddkitscli.sh 
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B188E2B695BD4743
# RUN apt-get update && apt-get install -y libgmp-dev php7.2-gmp
# RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
# RUN docker-php-ext-install gmp
# RUN curl https://drupalconsole.com/installer -L -o drupal.phar
# RUN mv drupal.phar /usr/local/bin/drupal
# RUN chmod +x /usr/local/bin/drupal

# Fixing permissions 
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data


