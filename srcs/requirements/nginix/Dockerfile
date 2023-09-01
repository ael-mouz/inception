FROM debian:stable

RUN apt-get update && apt-get install -y nginx

COPY nginx-config.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]