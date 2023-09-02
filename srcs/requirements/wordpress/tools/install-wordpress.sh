#!/bin/bash

apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-gd \
    mysql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.4/fpm/php.ini

service php7.4-fpm start

curl -O https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
mv wordpress/* /var/www/html/
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

tail -f /dev/null