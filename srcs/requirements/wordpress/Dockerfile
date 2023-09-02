FROM debian:bullseye

COPY ./tools/install-wordpress.sh ./install-wordpress.sh

RUN chmod +x /install-wordpress.sh

EXPOSE 80

CMD ["/install-wordpress.sh"]