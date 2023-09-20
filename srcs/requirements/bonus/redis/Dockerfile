FROM debian:bullseye

RUN apt update && apt upgrade -y 

RUN apt install -y redis-server

COPY ./tools/setup_redis.sh ./setup_redis.sh

RUN chmod +x ./setup_redis.sh

EXPOSE 6379

ENTRYPOINT ["./setup_redis.sh"]