FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y nginx

COPY ./tools/index.html /var/www/html/

CMD ["nginx", "-g" , "daemon off;"]