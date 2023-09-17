#!/bin/bash

sed -i "s/localhost/$DOMAIN_NAME/g" /var/www/html/index.html

sed -i "s/localhost/$DOMAIN_NAME/g" /var/www/html/index.html

nginx -g "daemon off;"