FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

COPY ./tools/generate_ssl_cert.sh ./generate_ssl_cert.sh

RUN chmod +x /generate_ssl_cert.sh

RUN ./generate_ssl_cert.sh

COPY ./conf/nginx-config.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]