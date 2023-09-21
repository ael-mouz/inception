#!/bin/sh

export TERM=xterm-256color
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)

print_default() {
    echo "${bold}${blue}${1}${normal}"
}
print_color() {
    echo "${bold}${green}${1}${normal}"
}

print_default "Changing to the web root directory..."
cd /var/www/html
print_color "Changed to the web root directory."

if wp core version --allow-root --path=/var/www/html 2> /dev/null; then
    print_default "${magenta}WordPress is already installed in /var/www/html. Skipping installation.${normal}"
else
    print_default "Downloading WordPress core..."
    wp core download --allow-root --path=/var/www/html
    print_color "Downloaded WordPress core."

    print_default "Setting correct ownership..."
    chown -R www-data:www-data /var/www/html
    print_color "Set correct ownership."

    print_default "Configuring WordPress database..."
    wp config create --skip-check --force \
        --dbname="$MYSQL_DB_NAME" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost=mariadb \
        --allow-root \
        --path=/var/www/html
    print_color "Configured WordPress database."

    print_default "Installing WordPress..."
    wp core install --skip-email \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root \
        --path=/var/www/html
    print_color "Installed WordPress."
fi

print_default "Creating WordPress user..."
wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --role="$WP_USER_ROLE" \
    --user_pass="$WP_USER_PASSWORD" \
    --allow-root
print_color "Created WordPress user."

print_default "Listing WordPress users..."
wp user list --allow-root
print_color "Listed WordPress users."

print_default "Activating the theme..."
wp theme activate twentytwentytwo --allow-root
print_color "Activated the theme."

print_default "Configuring WordPress to use Redis as the object cache..."
(wp config set WP_REDIS_HOST redis --allow-root && \
wp config set WP_REDIS_PORT 6379 --allow-root)
print_color "Configured WordPress to use Redis as the object cache."

print_default "Installingthe Redis Object Cache plugin..."
wp plugin install redis-cache --activate --allow-root
print_color "Installed the Redis Object Cache plugin."

print_default "Activating the Redis Object Cache plugin..."
wp redis enable --force --allow-root
print_color "Activated the Redis Object Cache plugin."

print_default "Flushing the cache to ensure Redis caching starts working..."
wp cache flush --allow-root
print_color "Flushed the cache."

print_default "Updating all plugins..."
wp plugin update --all --allow-root
print_color "All plugins are up to date."

print_default "Touching /var/www/html/wordpress_ready..."
touch /var/www/html/wordpress_ready
print_color "Created wordpress_ready file."

print_default "${magenta}Starting PHP-FPM in the foreground...${normal}"
php-fpm7.4 -F