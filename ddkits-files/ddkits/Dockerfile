FROM ddkits/lamp:cli

MAINTAINER  Mutasem Elayyoub <melayyoub@outlook.com>

RUN sudo apt-get --allow-unauthenticated upgrade -y 

# NOT FOUND response
COPY ./custom_404.html /var/www/html/custom_404.html
COPY ./custom_50x.html /var/www/html/custom_50x.html

#  default conf for proxy service

# using vm uncomment the ddkits.vm.conf if not direct localhost, then uncomment ddkits.conf

ADD sites/ddkits.conf /etc/apache2/sites-enabled/ddkits.conf
ADD ssl/ddkits.site.crt /etc/ssl/certs/ddkits.site.crt
ADD ssl/ddkits.site.key /etc/ssl/certs/ddkits.site.key

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
	&& a2enmod proxy_html \
	&& a2enmod ssl

RUN apachectl configtest
RUN apachectl restart

# Expose ports
EXPOSE 80 443
