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
handle_error() {
    echo "${bold}${red}Error: $1${normal}"
    exit 1
}

print_default "Downloading Portainer..."
curl -sSL https://github.com/portainer/portainer/releases/download/2.19.0/portainer-2.19.0-linux-amd64.tar.gz -o /tmp/portainer.tar.gz || handle_error "Failed to download Portainer"
print_color "Downloaded Portainer successfully."

print_default "Extracting Portainer..."
tar -xzf /tmp/portainer.tar.gz -C /var/lib/ || handle_error "Failed to extract Portainer"
print_color "Extracted Portainer successfully."

print_default "Generating ADMIN_PASSWORD_HASH..."
ADMIN_PASSWORD_HASH=$(htpasswd -nbB admin "${PORTAINER_ADMIN_PASSWORD}" | cut -d ":" -f 2) || handle_error "Failed to generate ADMIN_PASSWORD_HASH"
print_color "ADMIN_PASSWORD_HASH generated successfully."

print_default "${magenta}Starting Portainer...${normal}"
/var/lib/portainer/portainer --bind 0.0.0.0:9009 --admin-password ${ADMIN_PASSWORD_HASH} || handle_error "Failed to start portainer"