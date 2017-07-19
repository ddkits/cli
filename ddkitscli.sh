DDKITSSITES='drupal.dev'

DDKITSIP='192.168.99.100'

MYSQL_USER='ddk'

MYSQL_ROOT_PASSWORD='ddk'

MYSQL_DATABASE='ddk'

MYSQL_PASSWORD='ddk'

MAIL_ADDRESS='m@m.com'

#!/bin/sh

#  Script.sh
#
#
#  Created by mutasem elayyoub ddkits.com
#

# Enable page caching so we can demonstrate Varnish
touch ~/.ssh/config

echo "HostkeyAlgorithms +ssh-dss" >> ~/.ssh/config

chmod 600 ~/.ssh/config

drush sql-drop -y

drush site-install --db-url=mysql://${MYSQL_USER}:${MYSQL_ROOT_PASSWORD}@${MYSQL_DATABASE}/${MYSQL_DATABASE} -y --account-name=admin --account-pass=admin --site-mail=${MAIL_ADDRESS} --account-mail=${MAIL_ADDRESS} --clean-url=1 --site-uri=${DDKITSSITES} --site-name=${DDKITSSITES}

drush en aggregator blog contact token menu_attributes menu_token rules search_api media entity migrate poll statistics syslog logintoboggan tracker trigger views views_ui admin_menu features -y

drush pm-disable update toolbar -y

chmod -Rv 777 sites/default/files

mkdir /tmp

chmod -Rv 777 /tmp

if [ ! -f /etc/phpmyadmin/config.secret.inc.php ] ; then
    cat > /etc/phpmyadmin/config.secret.inc.php <<EOT
<?php
\$cfg['blowfish_secret'] = '$(tr -dc 'a-zA-Z0-9~!@#$%^&*_()+}{?></";.,[]=-' < /dev/urandom | fold -w 32 | head -n 1)';
EOT
fi

if [ ! -f /etc/phpmyadmin/config.user.inc.php ] ; then
  touch /etc/phpmyadmin/config.user.inc.php
fi

find /var/www/html -iname '*.txt' -not -path '*features*' -not -path '*test*' -not -path '*context*' -not -path '*whywebs.txt' -not -path '*zen*' -not -name 'robots.txt' -print -delete


if [ "$1" = 'phpmyadmin' ]; then
    exec supervisord --nodaemon --configuration="/etc/supervisord.conf" --loglevel=info
fi
