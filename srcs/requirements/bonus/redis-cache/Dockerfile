FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y redis-server 

COPY ./tools/start_redis.sh ./start_redis.sh

RUN chmod +x ./start_redis.sh

EXPOSE 6379

ENTRYPOINT ["/start_redis.sh"]