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
handle_error() {
    echo "${bold}${red}Error: $1${normal}"
    exit 1
}

print_default "Starting MariaDB in the background..."
mysqld_safe &
while ! mysqladmin ping --silent; do sleep 1 ; done
print_color "MariaDB started successfully."

print_default "Creating database '${MYSQL_DB_NAME}'..."
mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DB_NAME};" || handle_error "Failed to create database '${MYSQL_DB_NAME}'"
print_color "Database '${MYSQL_DB_NAME}' created successfully."

print_default "Creating MySQL user ${MYSQL_USER}..."
mysql -u root -e "CREATE USER IF NOT EXISTS ${MYSQL_USER}@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" || handle_error "Failed to create MySQL user ${MYSQL_USER}"
print_color "MySQL user '${MYSQL_USER}' created successfully."

print_default "Granting privileges to user ${MYSQL_USER}..."
mysql -u root -e "GRANT ALL ON ${MYSQL_DB_NAME}.* TO ${MYSQL_USER}@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' WITH GRANT OPTION;" || handle_error "Failed to grant privileges to user ${MYSQL_USER}"
print_color "Privileges granted to user '${MYSQL_USER}'."

print_default "Creating and granting privileges to 'root' user..."
mysql -u root -e "CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" || handle_error "Failed to create 'root' user"
mysql -u root -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;" || handle_error "Failed to grant privileges to 'root' user"
print_color "Privileges granted to 'root' user."

print_default "Flushing privileges..."
mysql -u root -e "FLUSH PRIVILEGES;" || handle_error "Failed to flush privileges"
print_color "Privileges flushed successfully."

print_default "Shutdown MariaDB gracefully ..."
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown || handle_error "Failed to shut down MariaDB"
print_color "MariaDB shutdown."

print_default "${magenta}Starting MariaDB in the background...${normal}"
mysqld_safe