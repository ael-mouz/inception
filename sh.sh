#!/bin/bash

# Step 1: Update Operating System
apt update && apt upgrade -y
apt install -y nano wget unzip

# Step 2: Install Nginx
apt install -y nginx
service nginx start
update-rc.d nginx defaults
# 'start nginx' is not needed as 'service nginx start' is already used

# Step 3: Install PHP and PHP Extensions
apt install -y php7.4 php7.4-curl php7.4-fpm php7.4-bcmath php7.4-gd php7.4-soap php7.4-zip php7.4-mbstring php7.4-mysql php7.4-xml php7.4-intl
mkdir -p /run/php
service php7.4-fpm reload
service php7.4-fpm restart

# Step 4: Install MariaDB
apt install -y mariadb-server mariadb-client
service mariadb start
update-rc.d mariadb defaults
# 'service mariadb status' is not needed, as 'service mariadb start' is already used

# Secure MariaDB
mysql_secure_installation <<EOF

Y
Y
Y
Y
Y
EOF

# Step 5: Create a New Database for WordPress
mysql -u root -p <<EOF
CREATE DATABASE wordpress_db;
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EXIT
EOF

# Step 6: Download WordPress
wget https://wordpress.org/latest.zip -P /tmp/
unzip /tmp/latest.zip -d /var/www/html/
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i 's/database_name_here/wordpress_db/' /var/www/html/wordpress/wp-config.php
sed -i 's/username_here/wordpress_user/' /var/www/html/wordpress/wp-config.php
sed -i 's/password_here/password/' /var/www/html/wordpress/wp-config.php

chown -R www-data:www-data /var/www/html/wordpress/

# Step 7: Configure Nginx
cat > /etc/nginx/conf.d/wordpress.conf <<EOF
server {
  listen 80;
  server_name localhost;
  root /var/www/html/wordpress;
  index index.php;

  access_log /var/log/nginx/localhost.access.log;
  error_log /var/log/nginx/localhost.error.log;

  client_max_body_size 100M;

  location / {
    try_files $uri $uri/ /index.php?$args;
  }

  location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    include fastcgi_params;
    fastcgi_intercept_errors on;
  }
}
EOF

service nginx reload
