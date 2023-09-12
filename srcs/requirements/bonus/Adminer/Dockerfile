FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y php php-curl php-cli php-mysql php-gd mariadb-server wget

COPY ./tools/setup_adminer.sh ./setup_adminer.sh

RUN chmod +x ./setup_adminer.sh

EXPOSE 8080

ENTRYPOINT [ "/setup_adminer.sh" ]