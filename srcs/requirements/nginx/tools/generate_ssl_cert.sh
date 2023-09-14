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

print_default "Create directories for SSL certificates ..."
mkdir -p ${CERTS_PATH} || handle_error "Failed to create directories"
print_color "Directories created successfully."

print_default "Generate SSL private key ..."
openssl genpkey -algorithm RSA -out "${CERTS_PATH}private-key.key" 2>/dev/null || handle_error "Failed to generate SSL private key"
print_color "SSL private key generated successfully."

print_default "Generate SSL certificate ..."
openssl req -x509 -new -key "${CERTS_PATH}private-key.key" -out "${CERTS_PATH}certificate.crt" -days 365 -subj "/C=MA/ST=State/L=City/O=Organization/OU=Organizational Unit/CN=localhost" 2>/dev/null || handle_error "Failed to generate SSL certificate"
print_color "SSL certificate generated successfully."

print_default "Replace the SSL certificate in the Nginx configuration ..."
sed -i "s|ssl_certificate .*|ssl_certificate ${CERTS_PATH}certificate.crt;|" /etc/nginx/nginx.conf || handle_error "Failed to replace SSL certificate in Nginx config"
print_color "SSL certificate replaced in Nginx config successfully."

print_default "Replace the SSL private key in the Nginx configuration ..."
sed -i "s|ssl_certificate_key .*|ssl_certificate_key ${CERTS_PATH}private-key.key;|" /etc/nginx/nginx.conf || handle_error "Failed to replace SSL certificate key in Nginx config"
print_color "SSL private key key replaced in Nginx config successfully."

print_default "Wait for PHP-FPM to be ready .."
while [ ! -f /var/www/html/wordpress_ready ]; do sleep 5; done
print_color "PHP-FPM is ready."

print_default "${magenta}Starting Nginx...${normal}"
nginx -g "daemon off;" || handle_error "Failed to start Nginx"