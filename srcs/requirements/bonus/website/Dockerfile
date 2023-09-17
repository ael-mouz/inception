FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y nginx

COPY ./site/index.html /var/www/html/
COPY ./site/style.css /var/www/html/
COPY ./site/assets/* /var/www/html/assets/

COPY ./tools/change_host.sh ./change_host.sh

RUN chmod +x ./change_host.sh

EXPOSE 80

ENTRYPOINT [ "./change_host.sh" ]