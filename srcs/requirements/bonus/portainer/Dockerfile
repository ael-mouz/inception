FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y curl tar

RUN mkdir /portainer

WORKDIR /portainer

RUN curl -L https://github.com/portainer/portainer/releases/download/2.19.0/portainer_linux_arm64.tar.gz -o portainer.tar.gz

RUN tar -xzf portainer.tar.gz

RUN rm portainer.tar.gz

EXPOSE 9009

CMD ["./portainer"]