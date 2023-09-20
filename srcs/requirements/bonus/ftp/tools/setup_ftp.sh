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

print_default "Creating directory for FTP certificates..."
mkdir -p "${FTP_CERTS_PATH}" || handle_error "Error creating directory for FTP certificates."
print_color "Directory for FTP certificates created successfully."

print_default "Generating SSL certificate and key..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "${FTP_CERTS_PATH}vsftpd.key" -out "${FTP_CERTS_PATH}vsftpd.crt" -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=Common Name" 2>/dev/null || handle_error "Error generating SSL certificate and key."
print_color "SSL certificate and key generated successfully."

print_default "Setting permissions for SSL certificate and key..."
chmod 600 "${FTP_CERTS_PATH}vsftpd.key" "${FTP_CERTS_PATH}vsftpd.crt" || handle_error "Error setting permissions for SSL certificate and key."
print_color "Permissions for SSL certificate and key set successfully."

print_default "Creating FTP user..."
useradd -m -c "${FTP_USER_FULLNAME}" -s /bin/bash "${FTP_USER}" || handle_error "Error creating FTP user."
print_color "FTP user created successfully."

print_default "Setting FTP user password..."
echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd || handle_error "Error setting FTP user password."
print_color "FTP user password set successfully."

print_default "Adding FTP user to the vsftpd userlist..."
echo "${FTP_USER}" | tee -a /etc/vsftpd.userlist || handle_error "Error adding FTP user to vsftpd userlist."
print_color "FTP user added to vsftpd userlist successfully."

print_default "Configuring vsftpd to use SSL certificate and key..."
sed -i "s|rsa_cert_file=.*|rsa_cert_file=${FTP_CERTS_PATH}vsftpd.crt|" /etc/vsftpd.conf || handle_error "Error configuring vsftpd to use SSL certificate."
sed -i "s|rsa_private_key_file=.*|rsa_private_key_file=${FTP_CERTS_PATH}vsftpd.key|" /etc/vsftpd.conf || handle_error "Error configuring vsftpd to use SSL key."
print_color "vsftpd configured to use SSL certificate and key successfully."

print_default "${magenta}Starting vsftpd...${normal}"
vsftpd /etc/vsftpd.conf || handle_error "Error starting vsftpd."
