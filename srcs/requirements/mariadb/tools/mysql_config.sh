#!/bin/sh

export TERM=xterm-256color

bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)

print_color() {
    echo "${bold}${1}${normal}"
}

handle_error() {
    print_color "${red}Error: $1"
    exit 1
}

print_color "Updating MariaDB configuration..."
sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mariadb.conf.d/50-server.cnf
print_color "Starting MariaDB in the background..."
mysqld_safe &
while ! mysqladmin ping --silent; do
    sleep 1
done
print_color "Creating database 'wpdb'..."
mysql -u root -e "CREATE DATABASE wpdb;" || handle_error "Failed to create database 'wpdb'"
print_color "Creating MySQL user '${MYSQL_USER}'..."
mysql -u root -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" || handle_error "Failed to create MySQL user '${MYSQL_USER}'"
print_color "Granting privileges to user '${MYSQL_USER}'..."
mysql -u root -e "GRANT ALL ON wpdb.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' WITH GRANT OPTION;" || handle_error "Failed to grant privileges to user '${MYSQL_USER}'"
print_color "Creating and granting privileges to 'root' user..."
mysql -u root -e "CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" || handle_error "Failed to create 'root' user"
mysql -u root -e "GRANT ALL ON wpdb.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' WITH GRANT OPTION;" || handle_error "Failed to grant privileges to 'root' user"
print_color "Flushing privileges..."
mysql -u root -e "FLUSH PRIVILEGES;" || handle_error "Failed to flush privileges"
print_color "${green}MySQL setup completed successfully.${normal}"
tail -f /dev/null