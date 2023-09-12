FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y curl php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-intl php7.4-mbstring php7.4-soap php7.4-xml php7.4-json

COPY ./tools/install-wordpress.sh ./install-wordpress.sh

RUN chmod +x /install-wordpress.sh

EXPOSE 9000

CMD ["/install-wordpress.sh"]