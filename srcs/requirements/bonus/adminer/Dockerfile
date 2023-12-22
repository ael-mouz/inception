FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y curl php7.4-fpm php7.4-mysql

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY ./tools/setup_adminer.sh ./setup_adminer.sh

RUN mkdir -p /run/php

RUN chmod +x ./setup_adminer.sh

EXPOSE 8080

ENTRYPOINT [ "./setup_adminer.sh" ]
