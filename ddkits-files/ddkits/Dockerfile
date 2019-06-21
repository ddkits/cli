FROM ddkits/lamp:cli

MAINTAINER  Mutasem Elayyoub <melayyoub@outlook.com>

RUN export TERM=xterm

RUN sudo apt-get --allow-unauthenticated upgrade -y 

#  default conf for proxy service

ADD sites/ddkits.conf /etc/apache2/sites-enabled/ddkits.conf
ADD ssl/ddkits.site.crt /etc/ssl/certs/ddkits.site.crt
ADD ssl/ddkits.site.key /etc/ssl/certs/ddkits.site.key

# NOT FOUND response
COPY sites/custom_404.html /var/www/html/custom_404.html
COPY sites/custom_50x.html /var/www/html/custom_50x.html
COPY sites/index.php /var/www/html/index.php

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
RUN rm -rf /var/lib/apt/lists/* \
	&& apt-cache dump \
	&& apt purge -y `dpkg --list | grep ^rc | awk '{ print $2; }'` \
	&& apt-get autoremove --purge
RUN dpkg-query -Wf '${Package;-40}${Priority}\n' | sort -b -k2,2 -k1,1
RUN sudo apt-get --simulate purge $(dpkg-query -Wf '${Package;-40}${Priority}\n' | awk '$2 ~ /optional|extra/ { print $1 }')
RUN apt-get autoremove

RUN apachectl configtest
RUN apachectl restart

# Expose ports
EXPOSE 80 443
