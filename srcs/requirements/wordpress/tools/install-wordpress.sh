#!/bin/bash

apt-get update && apt-get install -y php-fpm php-mysql php-common php-gd php-json php-curl php-zip php-xml php-mbstring php-bcmath php-json
apt install nano wget unzip

sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.4/fpm/php.ini

sed -i 's~;date.timezone =.*~date.timezone = "Africa/Casablanca"~' /etc/php/7.4/fpm/php.ini

service php7.4-fpm start

wget https://wordpress.org/latest.zip
unzip latest.zip -d /var/www/html/
cd /var/www/html/wordpress
cp wp-config-sample.php wp-config.php

# Define the new database settings
new_db_name='your_new_db_name'
new_db_user='your_new_db_user'
new_db_password='your_new_db_password'
new_db_host='your_new_db_host'

# Define the path to your wp-config.php file
wp_config_file='/path/to/wp-config.php'

# Check if the wp-config.php file exists
if [ ! -f "$wp_config_file" ]; then
  echo "Error: wp-config.php file not found at $wp_config_file"
  exit 1
fi

# Update the database settings in wp-config.php
sed -i "s/define( 'DB_NAME', '.*' );/define( 'DB_NAME', '$new_db_name' );/" "$wp_config_file"
sed -i "s/define( 'DB_USER', '.*' );/define( 'DB_USER', '$new_db_user' );/" "$wp_config_file"
sed -i "s/define( 'DB_PASSWORD', '.*' );/define( 'DB_PASSWORD', '$new_db_password' );/" "$wp_config_file"
sed -i "s/define( 'DB_HOST', '.*' );/define( 'DB_HOST', '$new_db_host' );/" "$wp_config_file"

echo "Database settings updated in wp-config.php"

chown -R www-data:www-data /var/www/html/wordpress/

tail -f /dev/null