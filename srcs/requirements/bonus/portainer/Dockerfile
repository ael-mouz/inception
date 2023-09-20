FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y curl tar apache2-utils

COPY ./tools/setup_portainer.sh ./setup_portainer.sh

RUN chmod +x ./setup_portainer.sh

EXPOSE 9009

ENTRYPOINT [ "./setup_portainer.sh" ]