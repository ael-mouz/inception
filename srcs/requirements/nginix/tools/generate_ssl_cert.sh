#!/bin/bash

mkdir -p ${CERTS_PATH}

openssl genpkey -algorithm RSA -out ${CERTS_PATH}/private-key.key

openssl req -x509 -new -key ${CERTS_PATH}/private-key.key -out ${CERTS_PATH}/certificate.crt -days 365 -subj "/C=MA/ST=State/L=City/O=Organization/OU=Organizational Unit/CN=localhost"
