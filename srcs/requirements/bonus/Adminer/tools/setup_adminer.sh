#!/bin/bash

# Download Adminer and configure Nginx location for it
wget "http://www.adminer.org/latest.php" -O /var/www/html/index.php
cd /var/www/html
php -S 0.0.0.0:8080
