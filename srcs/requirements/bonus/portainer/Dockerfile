FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y curl tar apache2-utils

RUN curl -sSL https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz -o /tmp/portainer.tar.gz

RUN tar -xzf /tmp/portainer.tar.gz -C /var/lib/

COPY ./tools/setup_portainer.sh ./setup_portainer.sh

RUN chmod +x ./setup_portainer.sh

EXPOSE 9009

ENTRYPOINT [ "./setup_portainer.sh" ]
