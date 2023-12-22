FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y nginx
RUN apt install -y openssl

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

COPY ./tools/setup_nginx.sh ./setup_nginx.sh

RUN chmod +x ./setup_nginx.sh

EXPOSE 443

ENTRYPOINT [ "./setup_nginx.sh" ]
