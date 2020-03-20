
FROM ddkits/lamp:7

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/*
COPY sites/chefserver_site.conf /etc/apache2/sites-enabled/chefserver_site.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini
# Chef server starts from here
VOLUME /var/opt/opscode

COPY install.sh /tmp/install.sh

RUN [ "/bin/sh", "/tmp/install.sh" ]

COPY init.rb /init.rb
COPY chef-server.rb /.chef/chef-server.rb
COPY logrotate /opt/opscode/sv/logrotate
COPY knife.rb /etc/chef/knife.rb
COPY backup.sh /usr/local/bin/chef-server-backup

ENV PUBLIC_URL chefserver.site
ENV KNIFE_HOME /etc/chef


RUN chmod 600 /etc/mysql/my.cnf
RUN chmod -R 777 /var/opt/opscode /etc/chef

# # Fixing permissions
RUN chown -R www-data:www-data /var/opt/opscode  /etc/chef
RUN usermod -u 1000 www-data

# clean up Chef for new version
RUN chef-server-ctl cleanup
CMD [ "/opt/opscode/embedded/bin/ruby", "/init.rb" ]
RUN chef-server-ctl upgrade

# Fixing permissions
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
  
