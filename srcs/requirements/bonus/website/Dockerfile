FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y php7.4

COPY ./site/index.html /var/www/html/website/

COPY ./site/style.css /var/www/html/website/

COPY ./site/assets/* /var/www/html/website/assets/

COPY ./tools/setup_website.sh ./setup_website.sh

RUN chmod +x ./setup_website.sh

EXPOSE 8000

ENTRYPOINT [ "./setup_website.sh" ]
