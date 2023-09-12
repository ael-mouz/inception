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

print_color "Download the latest Adminer PHP script from the official website and save it as index.php"
wget "http://www.adminer.org/latest.php" -O /var/www/html/index.php || handle_error "Failed to download Adminer"

print_color "Change the current working directory to the web root"
cd /var/www/html || handle_error "Failed to change to /var/www/html directory"

print_color "Start the PHP built-in web server, binding it to all available network interfaces (0.0.0.0) on port 8080"
php -S 0.0.0.0:8080 || handle_error "Failed to start PHP server"