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

print_default "Create directories for SSL certificates..."
mkdir -p ${NGINX_CERTS_PATH}
print_color "Directories created successfully."

print_default "Generate SSL private key..."
openssl genpkey -algorithm RSA -out "${NGINX_CERTS_PATH}private-key.key" 2>/dev/null
print_color "SSL private key generated successfully."

print_default "Generate SSL certificate..."
openssl req -x509 -new -key "${NGINX_CERTS_PATH}private-key.key" \
	-out "${NGINX_CERTS_PATH}certificate.crt" \
	-days 365 -subj "/C=MA/ST=State/L=City/O=Organization/OU=Organizational Unit/CN=localhost" 2>/dev/null
print_color "SSL certificate generated successfully."

print_default "Configuring Nginx to use SSL certificate and key..."
sed -i 's/server_name localhost;/server_name ${DOMAIN_NAME};/g' /etc/nginx/nginx.conf
sed -i "s|ssl_certificate .*|ssl_certificate ${NGINX_CERTS_PATH}certificate.crt;|" /etc/nginx/nginx.conf
sed -i "s|ssl_certificate_key .*|ssl_certificate_key ${NGINX_CERTS_PATH}private-key.key;|" /etc/nginx/nginx.conf
print_color "vsftpd configured to use SSL certificate and key successfully."

print_default "Wait for PHP-FPM to be ready..."
while [ ! -f /var/www/html/wordpress_ready ]; do sleep 5; done
print_color "PHP-FPM is ready."

print_default "Setting permission ..."
chmod -R 777 /var/www/html
print_color "Set permission ."

print_default "${magenta}Starting Nginx...${normal}"
nginx -g "daemon off;"
