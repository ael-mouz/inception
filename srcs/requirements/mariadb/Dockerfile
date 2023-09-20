FROM debian:bullseye

RUN apt update && apt upgrade -y 

RUN apt install -y mariadb-server

COPY ./conf/50-server.conf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/setup_mariadb.sh ./setup_mariadb.sh

RUN chmod +x ./setup_mariadb.sh

EXPOSE 3306

ENTRYPOINT [ "./setup_mariadb.sh" ]