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

print_default "Starting MariaDB..."
mysqld_safe &
while ! mysqladmin ping --silent; do sleep 1 ; done
print_color "MariaDB started successfully."

print_default "Setting up MySQL root user..."
mysql_secure_installation << EOF > /dev/null 2>&1
n
${MYSQL_ROOT_PASSWORD}
${MYSQL_ROOT_PASSWORD}
y
n
n
n
n
EOF
print_color "MySQL root user set up successfully."

print_default "Creating database '${MYSQL_DB_NAME}'..."
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DB_NAME};"
print_color "Database '${MYSQL_DB_NAME}' created successfully."

print_default "Creating MySQL user ${MYSQL_USER}..."
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS ${MYSQL_USER}@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
print_color "MySQL user '${MYSQL_USER}' created successfully."

print_default "Granting privileges to user ${MYSQL_USER}..."
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL ON ${MYSQL_DB_NAME}.* TO ${MYSQL_USER}@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' WITH GRANT OPTION;"
print_color "Privileges granted to user '${MYSQL_USER}'."

print_default "Creating and granting privileges to 'root' user..."
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;"
print_color "Privileges granted to 'root' user."

print_default "Flushing privileges..."
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
print_color "Privileges flushed successfully."

print_default "Shutdown MariaDB gracefully ..."
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
print_color "MariaDB shutdown."

print_default "${magenta}Starting MariaDB...${normal}"
mysqld_safe
