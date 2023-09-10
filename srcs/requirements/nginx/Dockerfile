FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

COPY ./conf/nginx-config.conf /etc/nginx/nginx.conf

COPY ./tools/generate_ssl_cert.sh ./generate_ssl_cert.sh

RUN chmod +x /generate_ssl_cert.sh

EXPOSE 443

ENTRYPOINT [ "./generate_ssl_cert.sh" ]