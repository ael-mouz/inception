FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y mariadb-server

COPY ./tools/mysql_config.sh ./

RUN chmod +x mysql_config.sh

EXPOSE 3306

ENTRYPOINT [ "./mysql_config.sh" ]