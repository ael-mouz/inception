#!/bin/bash

# Step 1: Update Operating System
apt update && apt upgrade -y
apt install -y nano wget unzip

# Step 2: Install Nginx
apt install -y nginx
service nginx start
update-rc.d nginx defaults

# Step 3: Install PHP and PHP Extensions
apt install -y php php-curl php-fpm php-bcmath php-gd php-soap php-zip php-curl php-mbstring php-mysqlnd php-gd php-xml php-intl php-zip
mkdir -p /var/run/php
service php7.4-fpm reload
service php7.4-fpm restart

# Step 4: Install MariaDB
apt install -y mariadb-server mariadb-client
service mariadb start
update-rc.d mariadb defaults
service mariadb status

# Secure MariaDB
mysql_secure_installation <<EOF

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

  location / {
    try_files $uri $uri/ /index.php?$args;
  }

  location ~ \.php$ {
    try_files \$uri =404;
    fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    include fastcgi_params;
  }
}
EOF
# include snippets/fastcgi-php.conf;
service nginx reload
