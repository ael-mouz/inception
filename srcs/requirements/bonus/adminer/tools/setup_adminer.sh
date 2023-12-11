#!/bin/bash

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

print_default "Download the latest Adminer..."
curl -sSL "https://www.adminer.org/latest.php" -o /var/www/html/index.php
print_color "Adminer downloaded successfully."

print_default "Download theme CSS file for Adminer..."
curl -sSL "https://raw.githubusercontent.com/Niyko/Hydra-Dark-Theme-for-Adminer/master/adminer.css" -o /var/www/html/adminer.css
# curl -sSL "https://raw.githubusercontent.com/pepa-linha/Adminer-Design-Dark/master/adminer.css" -o /var/www/html/adminer.css
print_color "Theme CSS file downloaded successfully."

print_default "${magenta}Start the PHP built-in web server ...${normal}"
php -S 0.0.0.0:8080 -t /var/www/html
