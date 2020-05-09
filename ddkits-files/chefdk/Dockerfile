
FROM ddkits/lamp:7.3

MAINTAINER Mutasem Elayyoub "melayyoub@outlook.com"

RUN export TERM=xterm

RUN rm /etc/apache2/sites-enabled/*
COPY sites/chefserver_site.conf /etc/apache2/sites-enabled/chefserver_site.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini
# Chef server starts from here
VOLUME /var/opt/opscode

COPY install.sh /var/www/html/install.sh
RUN source /var/www/html/install.sh

COPY init.rb /init.rb
COPY chef-server.rb /.chef/chef-server.rb
COPY logrotate /opt/opscode/sv/logrotate
COPY knife.rb /etc/chef/knife.rb
COPY backup.sh /usr/local/bin/chef-server-backup

ENV KNIFE_HOME /etc/chef

CMD [ "/opt/opscode/embedded/bin/ruby", "/init.rb" ]
# Fix git user 
RUN git config --global user.name ddk
RUN git config --global user.email m@m.com

# Add ignore for chef
RUN ".chef" > ~/chef-repo/.gitignore
RUN cd ~/chef-repo && git add . && git commit -m "initial commit"

#  Run first cookbook
RUN chef generate cookbook ddkits_cookbook
RUN apt-get -y install tree
# Set the default command to execute

RUN chmod 600 /etc/mysql/my.cnf
RUN chmod -R 777 /var/www/html


# Fixing permissions
RUN chown -R www-data:www-data /var/www/html
RUN usermod -u 1000 www-data
  
