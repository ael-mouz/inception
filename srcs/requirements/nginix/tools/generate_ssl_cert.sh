#!/bin/bash

mkdir -p $CERTS_PATH
openssl genrsa -out $CERTS_PATH/$DOMAIN_NAME.key 2048
openssl req -new -key $CERTS_PATH/$DOMAIN_NAME.key -out $CERTS_PATH/$DOMAIN_NAME.csr -subj "/CN=$DOMAIN_NAME"
openssl x509 -req -days 365 -in $CERTS_PATH/$DOMAIN_NAME.csr -signkey $CERTS_PATH/$DOMAIN_NAME.key -out $CERTS_PATH/$DOMAIN_NAME.crt

tail -f /dev/null