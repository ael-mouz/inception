#!/bin/bash

apt update && apt upgrade -y
apt install -y curl
apt install -y php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-intl php7.4-mbstring php7.4-soap php7.4-xml php7.4-json

mkdir -p /var/run/php
mkdir -p /var/www/html/

service php7.4-fpm restart

#cd /var/www/html/
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

wp cli version --allow-root
wp cli update
wp core download --allow-root --path=/var/www/html
wp config create --dbname=wordpress_db --dbuser=wordpress_user --dbpass=password --dbhost=localhost --dbprefix=wp_ --allow-root --path=/var/www/html
wp core install --url=localhost --title=Site_Title --admin_user=admin_username --admin_password=admin_password --admin_email=your@email.com --allow-root --path=/var/www/html

chown -R www-data:www-data /var/www/html/