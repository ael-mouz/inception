FROM debian:bullseye

RUN apt update && apt upgrade -y 

RUN apt install -y php php-mysql mariadb-server wget

COPY ./tools/setup_adminer.sh ./setup_adminer.sh

RUN chmod +x ./setup_adminer.sh

EXPOSE 8080

ENTRYPOINT [ "/setup_adminer.sh" ]