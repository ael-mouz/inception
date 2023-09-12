#!/bin/bash

export TERM=xterm-256color

bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)

print_color() {
    echo "${bold}${green}${1}${normal}"
}

handle_error() {
    print_color "${red}Error: $1"
    exit 1
}

print_color "Creating necessary directories..."
mkdir -p /var/run/php || handle_error "Failed to create /var/run/php directory"
mkdir -p /var/www/html || handle_error "Failed to create /var/www/html directory"

print_color "Starting PHP-FPM service..."
service php7.4-fpm start || handle_error "Failed to start PHP-FPM service"

print_color "Configuring PHP-FPM..."
sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php/7.4/fpm/pool.d/www.conf || handle_error "Failed to configure PHP-FPM"

print_color "Downloading and installing WP-CLI..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar || handle_error "Failed to download WP-CLI"
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp || handle_error "Failed to install WP-CLI"

print_color "Changing to the web root directory..."
cd /var/www/html || handle_error "Failed to change to /var/www/html directory"

print_color "Updating WP-CLI..."
wp cli update --allow-root || handle_error "Failed to update WP-CLI"

print_color "Downloading WordPress core..."
wp core download --allow-root --path=/var/www/html || handle_error "Failed to download WordPress core"

print_color "Configuring WordPress database..."
wp config create --dbname="$MYSQL_DB_NAME" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost="$MYSQL_DB_HOST" --path=/var/www/html --allow-root --skip-check|| handle_error "Failed to configure WordPress database"

print_color "Installing WordPress..."
wp core install --url="$WP_URL" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PASSWORD" --admin_email=$WP_ADMIN_EMAIL --path=/var/www/html --allow-root || handle_error "Failed to install WordPress"

print_color "Setting correct ownership..."
chown -R www-data:www-data /var/www/html || handle_error "Failed to set correct ownership"

print_color "Starting PHP-FPM in the foreground..."
php-fpm7.4 -F || handle_error "Failed to start PHP-FPM in the foreground"

print_color "${green}Setup completed successfully.${normal}"
