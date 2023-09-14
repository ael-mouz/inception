FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y nginx openssl

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

COPY ./tools/generate_ssl_cert.sh ./generate_ssl_cert.sh

RUN chmod +x ./generate_ssl_cert.sh

EXPOSE 443

ENTRYPOINT [ "./generate_ssl_cert.sh" ]