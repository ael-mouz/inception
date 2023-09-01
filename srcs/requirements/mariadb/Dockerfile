FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

COPY ./tools/mysql_config.sh ./

RUN chmod +x mysql_config.sh

EXPOSE 3306

ENTRYPOINT [ "./mysql_config.sh" ]