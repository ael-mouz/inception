#!/bin/sh

export TERM=xterm-256color
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)

print_default() {
	echo "${bold}${blue}${1}${normal}"
}
print_color() {
	echo "${bold}${green}${1}${normal}"
}

wait_for_mariadb() {
	while ! mysqladmin -h mariadb -u root -p"$MYSQL_ROOT_PASSWORD" ping --silent; do
		print_default "${yellow}MariaDB server is not ready ...${normal}"
		sleep 1
	done
	print_color "MariaDB server is ready."
}

print_default "Changing to the web root directory..."
cd /var/www/html
print_color "Changed to the web root directory."

print_default "Setting correct ownership..."
chown -R www-data:www-data /var/www/html
print_color "Set correct ownership."

wait_for_mariadb

if wp core version --allow-root --path=/var/www/html 2> /dev/null; then
	print_default "${yellow}WordPress is already installed in /var/www/html. Skipping installation.${normal}"
else
	print_default "Downloading WordPress core..."
	wp core download --allow-root --path=/var/www/html
	print_color "Downloaded WordPress core."
fi

wait_for_mariadb

if wp config path --allow-root --path=/var/www/html 2> /dev/null; then
	print_default "${yellow}WordPress database is already configured.${normal}"
else
	print_default "Configuring WordPress database..."
	wp config create --skip-check --force \
		--dbname="$MYSQL_DB_NAME" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost=mariadb \
		--allow-root \
		--path=/var/www/html
	print_color "Configured WordPress database."
fi

wait_for_mariadb

print_default "Installing WordPress..."
wp core install --skip-email \
	--url="$DOMAIN_NAME" \
	--title="$WP_TITLE" \
	--admin_user="$WP_ADMIN_USER" \
	--admin_password="$WP_ADMIN_PASSWORD" \
	--admin_email="$WP_ADMIN_EMAIL" \
	--allow-root \
	--path=/var/www/html
print_color "Installed WordPress."

wait_for_mariadb

if wp user list --role="$WP_USER_ROLE" --field=user_login --allow-root --path=/var/www/html | grep -q "^$WP_USER$"; then
	print_default "${yellow}WordPress user '$WP_USER' already exists.${normal}"
else
	print_default "Creating WordPress user..."
	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--role="$WP_USER_ROLE" \
		--user_pass="$WP_USER_PASSWORD" \
		--allow-root \
		--path=/var/www/html
	print_color "Created WordPress user."
fi


print_default "Configuring WordPress to use Redis as the object cache..."
wp config set WP_REDIS_HOST redis --allow-root --path=/var/www/html
wp config set WP_REDIS_PORT 6379 --allow-root --path=/var/www/html
print_color "Configured WordPress to use Redis as the object cache."

if wp plugin is-installed redis-cache --allow-root --path=/var/www/html; then
	print_default "${yellow}Redis Object Cache plugin is already installed."
else
	print_default "Installing the Redis Object Cache plugin..."
	wp plugin install redis-cache --activate --allow-root --path=/var/www/html
	print_color "Installed the Redis Object Cache plugin."
fi

print_default "Activating the Redis Object Cache plugin..."
wp redis enable --force --allow-root --path=/var/www/html
print_color "Activated the Redis Object Cache plugin."

print_default "Updating all plugins..."
wp plugin update --all --allow-root --path=/var/www/html
print_color "All plugins are up to date."

print_default "Flushing the cache to ensure Redis caching starts working..."
wp cache flush --allow-root --path=/var/www/html
print_color "Flushed the cache."

print_default "Setting permission ..."
chmod -R 777 /var/www/html
print_color "Set permission ."

print_default "Touching /var/www/html/wordpress_ready..."
touch /var/www/html/wordpress_ready
print_color "Created wordpress_ready file."

print_default "${magenta}Starting PHP-FPM ...${normal}"
php-fpm7.4 -F
