#!/bin/bash

apt update && apt upgrade -y
apt install -y curl
apt install -y php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-intl php7.4-mbstring php7.4-soap php7.4-xml php7.4-json

mkdir -p /var/run/php
mkdir -p /var/www/html/

service php7.4-fpm start

sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php/7.4/fpm/pool.d/www.conf

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

cd /var/www/html
wp cli version --allow-root
wp cli update
wp core download --allow-root --path=/var/www/html
wp config create --dbname=wpdb --dbuser=user --dbpass=password --dbhost=mariadb --allow-root --path=/var/www/html --skip-check
wp core install --url=localhost --title=Site_Title --admin_user=admin --admin_password=password --admin_email=your@email.com --allow-root --path=/var/www/html

chown -R www-data:www-data /var/www/html/

php-fpm7.4 -F