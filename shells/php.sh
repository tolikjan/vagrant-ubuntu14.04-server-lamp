#!/usr/bin/env bash

#######################
#         PHP         #
#######################

export LANG=C.UTF-8

PHP_TIMEZONE=${1:-UTC}

# Install php5
echo "Installing PHP $PHP_VERSION"
apt-get install php5 php5-common php5-dev php5-cli php5-fpm -y > /dev/null 2>&1

# Install PHP extensions
echo "Installing PHP extensions"
apt-get install php5-mysql php5-pgsql -y > /dev/null 2>&1
apt-get install curl php5-curl php5-gd php5-mcrypt php5-imagick php5-intl php5-xdebug -y > /dev/null 2>&1
apt-get install php5-memcached php5-memcache php5-json > /dev/null 2>&1

# Enable php5-mcrypt mode
php5enmod mcrypt > /dev/null 2>&1

# PHP Error Reporting Timezone Config
echo "Configuring PHP"
# php.ini configuration for displaying errors
for INI in $(find /etc -name 'php.ini')
do
  sed -i 's/^error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' ${INI}
  sed -i 's/^display_errors = Off/display_errors = On/' ${INI}
  sed -i 's/^display_startup_errors = Off/display_startup_errors = On/' ${INI}
  sed -i 's/^html_errors = Off/html_errors = On/' ${INI}
  # Change configuration if you planing to load big files
  sed -i 's/^post_max_size = 8M/post_max_size = 200M/' ${INI}
  sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 200M/' ${INI}
done

# xВebug Config
echo "Configuring Xdebug"
XDEBUG="$(find / -name "xdebug.so" 2> /dev/null)"
sleep 10
for INI in $(find /etc -name 'php.ini')
do
  echo "zend_extension=\"${XDEBUG}\"" >> ${INI}
  echo "memory_limit=-1" >> ${INI}
  echo "xdebug.profiler_enable=1" >> ${INI}
  echo "xdebug.remote_autostart=1" >> ${INI}
  echo "xdebug.remote_enable=1" >> ${INI}
  echo "xdebug_enable=1" >> ${INI}
  echo "xdebug.remote_connect_back=1" >> ${INI}
  echo "xdebug.remote_port=9002" >> ${INI}
  echo "xdebug.idekey=PHP_STORM" >> ${INI}
  echo "xdebug.scream=0" >> ${INI}
  echo "xdebug.cli_color=1" >> ${INI}
  echo "xdebug.show_local_vars=1" >> ${INI}
  echo "xdebug.remote_connect_back = 1" >> ${INI}
  echo ";var_dump display" >> ${INI}
  echo "xdebug.var_display_max_depth = 5" >> ${INI}
  echo "xdebug.var_display_max_children = 256" >> ${INI}
  echo "xdebug.var_display_max_data = 1024" >> ${INI}
done
