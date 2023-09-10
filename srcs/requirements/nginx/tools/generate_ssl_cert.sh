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

print_color "Setting up SSL certificate and Nginx..."
mkdir -p ${CERTS_PATH} || handle_error "Failed to create directories"
openssl genpkey -algorithm RSA -out ${CERTS_PATH}/private-key.key || handle_error "Failed to generate SSL private key"
openssl req -x509 -new -key ${CERTS_PATH}/private-key.key -out ${CERTS_PATH}/certificate.crt -days 365 -subj "/C=MA/ST=State/L=City/O=Organization/OU=Organizational Unit/CN=localhost" || handle_error "Failed to generate SSL certificate"

print_color "SSL certificate and private key generated successfully."

print_color "Starting Nginx..."
nginx -g "daemon off;" || handle_error "Failed to start Nginx"

print_color "${green}Nginx setup completed successfully.${normal}"
