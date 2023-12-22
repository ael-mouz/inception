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

print_default "Creating directory for FTP certificates..."
mkdir -p "${FTP_CERTS_PATH}"
print_color "Directory for FTP certificates created successfully."

print_default "Generate SSL private key..."
openssl genpkey -algorithm RSA -out "${FTP_CERTS_PATH}vsftpd.key" 2>/dev/null
print_color "SSL private key generated successfully."

print_default "Generate SSL certificate..."
openssl req -x509 -new -key "${FTP_CERTS_PATH}vsftpd.key" \
  -out "${FTP_CERTS_PATH}vsftpd.crt" \
  -days 365 -subj "/C=MA/ST=State/L=City/O=Organization/OU=Department/CN=localhost" 2>/dev/null
print_color "SSL certificate generated successfully."

print_default "Creating FTP user..."
if id "$FTP_USER" &>/dev/null; then
    print_default "${magenta}FTP user $FTP_USER already exists.${normal}"
else
    useradd -m -c "${FTP_USER_FULLNAME}" -s /bin/bash "${FTP_USER}"
fi
print_color "FTP user created successfully."

print_default "Setting FTP user password..."
echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
print_color "FTP user password set successfully."

print_default "Adding FTP user to the vsftpd userlist..."
# echo "${FTP_USER}" | tee -a /etc/vsftpd.userlist
echo "${FTP_USER}" >> /etc/vsftpd.userlist
print_color "FTP user added to vsftpd userlist successfully."

print_default "Configuring vsftpd to use SSL certificate and key..."
sed -i "s|rsa_cert_file=.*|rsa_cert_file=${FTP_CERTS_PATH}vsftpd.crt|" /etc/vsftpd.conf
sed -i "s|rsa_private_key_file=.*|rsa_private_key_file=${FTP_CERTS_PATH}vsftpd.key|" /etc/vsftpd.conf
print_color "vsftpd configured to use SSL certificate and key successfully."

print_default "Setting permission ..."
chmod -R 777 /var/www/html
print_color "Set permission ."

print_default "${magenta}Starting vsftpd...${normal}"
vsftpd /etc/vsftpd.conf
