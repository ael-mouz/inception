#!/bin/bash

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

print_default "Generating ADMIN_PASSWORD_HASH..."
ADMIN_PASSWORD_HASH=$(htpasswd -nbB admin "${PORTAINER_ADMIN_PASSWORD}" | cut -d ":" -f 2)
print_color "ADMIN_PASSWORD_HASH generated successfully."

print_default "${magenta}Starting Portainer...${normal}"
/var/lib/portainer/portainer --bind 0.0.0.0:9009 --admin-password ${ADMIN_PASSWORD_HASH}
