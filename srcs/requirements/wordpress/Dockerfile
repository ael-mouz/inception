FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y curl php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-intl php7.4-mbstring php7.4-soap php7.4-xml php7.4-json

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/setup_wordpress.sh ./setup_wordpress.sh

RUN chmod +x /setup_wordpress.sh

EXPOSE 9000

CMD ["/setup_wordpress.sh"]