FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y nginx

COPY ./site/index.html /var/www/html/

COPY ./site/style.css /var/www/html/

COPY ./site/assets/* /var/www/html/assets/

COPY ./tools/setup_website.sh ./setup_website.sh

RUN chmod +x ./setup_website.sh

EXPOSE 80

ENTRYPOINT [ "./setup_website.sh" ]