#!/bin/sh
if [ ! -f /var/www/roundcube/config/config.inc.php ]; then
  cp /etc/roundcube/* /var/www/roundcube/config
fi

chown -R nobody:nobody /var/www/roundcube/config \
  && chown -R nobody:nobody /var/www/roundcube/logs \
  && chown -R nobody:nobody /var/www/roundcube/temp \
  && supervisord --nodaemon

