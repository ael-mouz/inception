FROM debian:bullseye

RUN apt update && apt upgrade -y 

RUN apt install -y curl php7.4-fpm php7.4-mysql

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
RUN chmod +x wp-cli.phar 
RUN mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php

# /*******************
WORKDIR /var/www/html
RUN wp cli update --allow-root
RUN wp core download --allow-root
RUN chown -R www-data:www-data /var/www/html
# /*******************

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY ./tools/setup_wordpress.sh ./setup_wordpress.sh

RUN chmod +x ./setup_wordpress.sh

EXPOSE 9000

CMD ["./setup_wordpress.sh"]