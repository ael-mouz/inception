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

print_color "Changing to the web root directory..."
cd /var/www/html || handle_error "Failed to change to /var/www/html directory"

print_color "Updating WP-CLI..."
wp cli update --allow-root || handle_error "Failed to update WP-CLI"

print_color "Downloading WordPress core..."
wp core download --allow-root || handle_error "Failed to download WordPress core"

print_color "Setting correct ownership..."
chown -R www-data:www-data /var/www/html || handle_error "Failed to set correct ownership"

print_color "Configuring WordPress database..."
wp config create --skip-check --force \
    --dbname="$MYSQL_DB_NAME" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$MYSQL_PASSWORD" \
    --dbhost=mariadb \
    --allow-root \
    --path=/var/www/html || handle_error "Failed to configure WordPress database"

print_color "Installing WordPress..."
wp core install --skip-email --force \
    --url="$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root \
    --path=/var/www/html || handle_error "Failed to install WordPress"

print_color "Creating WordPress user..."
wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --role="$WP_USER_ROLE" \
    --user_pass="$WP_USER_PASSWORD" \
    --allow-root || handle_error "Failed to create WordPress user"

print_color "Listing WordPress users..."
wp user list --allow-root || handle_error "Failed to list WordPress users"

print_color "Activating the theme..."
wp theme activate twentytwentytwo --allow-root || handle_error "Failed to activate the theme"

print_color "Configuring WordPress to use Redis as the object cache..."
wp config set WP_REDIS_HOST redis --allow-root || handle_error "Failed to configure WordPress to use Redis"
wp config set WP_REDIS_PORT 6379 --allow-root || handle_error "Failed to configure WordPress to use Redis"

print_color "Installingthe Redis Object Cache plugin..."
wp plugin install redis-cache --activate --allow-root || handle_error "Failed to install the Redis Object Cache plugin"

print_color "Activating the Redis Object Cache plugin..."
wp redis enable --force --allow-root || handle_error "Failed to activate the Redis Object Cache plugin"

print_color "Flushing the cache to ensure Redis caching starts working..."
wp cache flush --allow-root || handle_error "Failed to flush the cache"

print_color "Touching /var/www/html/wordpress_ready..."
touch /var/www/html/wordpress_ready || handle_error "Failed to create wordpress_ready file"

print_color "Starting PHP-FPM in the foreground..."
php-fpm7.4 -F || handle_error "Failed to start PHP-FPM in the foreground"