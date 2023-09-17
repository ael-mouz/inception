FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y vsftpd openssl

RUN mkdir -p /var/www/html

RUN chmod 555 /var/www/

COPY ./conf/vsftpd.conf /etc/vsftpd.conf

COPY ./tools/setup_ftp.sh ./setup_ftp.sh

RUN chmod +x ./setup_ftp.sh

EXPOSE 21
EXPOSE 20
EXPOSE 40000:40005

ENTRYPOINT ["./setup_ftp.sh"]