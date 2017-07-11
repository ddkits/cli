FROM ddkits/lamp:7

RUN ln -sf ./logs /var/log/nginx/access.log \
    && ln -sf ./logs /var/log/nginx/error.log \
    && chmod 600 /etc/mysql/my.cnf \
    && a2enmod rewrite \
    && rm /etc/apache2/sites-enabled/000-default.conf
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
                   git \
                   libapache2-mod-php7.0 \
                   php7.0 \
                   php7.0-common \
                   php7.0-gd \
                   php7.0-mysql \
                   php7.0-mcrypt \
                   php7.0-curl \
                   php7.0-intl \
                   php7.0-xsl \
                   php7.0-mbstring \
                   php7.0-zip \
                   php7.0-bcmath \
                   php7.0-iconv \
                   php7.0-mongodb \
                   php7.0-ssh2 \
                   php7.0-json \
  && apt-get install -y --force-yes apt-transport-https lxc-docker ufw sudo gufw  
RUN chmod -R 777 /var/www/html

COPY php.ini /etc/php/7.0/fpm/php.ini
COPY ./sites/dreamf_dev.conf /etc/apache2/sites-enabled/dreamf_dev.conf 
