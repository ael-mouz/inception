FROM debian:bullseye

RUN apt update && apt upgrade -y 

RUN apt install -y mariadb-server

COPY ./conf/50-server.conf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/mysql_config.sh ./mysql_config.sh

RUN chmod +x ./mysql_config.sh

EXPOSE 3306

ENTRYPOINT [ "./mysql_config.sh" ]