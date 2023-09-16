FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y curl tar

RUN mkdir -p /var/lib/portainer

ARG PORTAINER_VERSION=2.19.0

ARG PORTAINER_URL=https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz

RUN curl -sSL ${PORTAINER_URL} | tar -xzo -C /usr/local

EXPOSE 9000

CMD ["/usr/local/portainer/portainer", "--data", "/var/lib/portainer/data"]