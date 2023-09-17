#!/bin/bash

mkdir -p "${FTP_CERTS_PATH}"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "${FTP_CERTS_PATH}vsftpd.key" -out "${FTP_CERTS_PATH}vsftpd.crt" -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=Common Name"

chmod 600 "${FTP_CERTS_PATH}vsftpd.key" "${FTP_CERTS_PATH}vsftpd.crt"

useradd -m -c "${FTP_USER_FULLNAME}" -s /bin/bash "${FTP_USER}"

echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd

echo "${FTP_USER}" | tee -a /etc/vsftpd.userlist

sed -i "s|rsa_cert_file=.*|rsa_cert_file=${FTP_CERTS_PATH}vsftpd.crt|" /etc/vsftpd.conf

sed -i "s|rsa_private_key_file=.*|rsa_private_key_file=${FTP_CERTS_PATH}vsftpd.key|" /etc/vsftpd.conf

vsftpd /etc/vsftpd.conf