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

print_default "Replace 'localhost' with the value of '$DOMAIN_NAME' in the index.html file..."
sed -i "s/localhost/$DOMAIN_NAME/g" /var/www/html/index.html
print_color "Replaced 'localhost' with '$DOMAIN_NAME' in index.html."

print_default "${magenta}Start the Nginx server in daemon mode ...${normal}"
nginx -g "daemon off;"