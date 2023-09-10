FROM debian:bullseye

COPY ./tools/install-wordpress.sh ./install-wordpress.sh

RUN chmod +x /install-wordpress.sh

EXPOSE 9000

CMD ["/install-wordpress.sh"]