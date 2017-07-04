FROM ddkits/lamp:latest
MAINTAINER  Mutasem Elayyoub <melayyoub@outlook.com>

RUN apt-get update \
	&& apt-get install build-essential -y \
	&& apt-get install apache2 libapache2-mod-proxy-html libxml2-dev apt-transport-https --force-yes -y \
	&& rm /etc/apache2/sites-enabled/000-default.conf \
	&& rm /etc/apache2/sites-available/000-default.conf \
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
	&& apt-get update 

# NOT FOUND response
COPY ./custom_404.html /var/www/html/custom_404.html
COPY ./custom_50x.html /var/www/html/custom_50x.html

#  default conf for proxy service

# using vm uncomment the ddkits.vm.conf if not direct localhost, then uncomment ddkits.conf

ADD sites/ddkits.conf /etc/apache2/sites-enabled/ddkits.conf
# ADD sites/ddkitscust.conf /etc/apache2/sites-enabled/ddkitscust.conf

#  default conf for proxy service

RUN a2enmod proxy \
	&& a2enmod proxy_http \
	&& a2enmod proxy_ajp \
	&& a2enmod rewrite \
	&& a2enmod deflate \
	&& a2enmod headers \
	&& a2enmod proxy_balancer \
	&& a2enmod proxy_connect \
	&& a2enmod proxy_html

# Proxy SSL certificates for ssl connections

# COPY ./ssl/ /etc/ssl/certs/

RUN apachectl configtest
RUN apachectl restart

# Expose ports
EXPOSE 80 443