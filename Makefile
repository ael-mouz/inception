COLOR_BOLD := \033[1m
COLOR_RESET := \033[0m
COLOR_GREEN := \033[32m

.PHONY: up down stop-containers remove-containers remove-images remove-volumes remove-network \
		image-ls container-ls network-ls volume-ls volume-inspect fclean re prune

up:
	@reset
	@mkdir -p /home/ael-mouz/data/DB /home/ael-mouz/data/wordpress /home/ael-mouz/data/adminer /home/ael-mouz/data/website
	@echo "$(COLOR_BOLD)Starting the project...$(COLOR_RESET)"
	@-docker-compose -f srcs/docker-compose.yml --project-name inception up --build

down:
	@echo "$(COLOR_BOLD)Stopping and removing the project...$(COLOR_RESET)"
	@-docker-compose -f srcs/docker-compose.yml --project-name inception down --rmi all --volumes --remove-orphans
	@echo "$(COLOR_GREEN)Project has been stopped and removed.$(COLOR_RESET)"

stop-containers:
	@echo "$(COLOR_BOLD)Stopping all containers...$(COLOR_RESET)"
	@-docker stop $$(docker ps -qa)
	@echo "$(COLOR_GREEN)All containers have been stopped.$(COLOR_RESET)"

remove-containers:
	@echo "$(COLOR_BOLD)Removing all stopped containers...$(COLOR_RESET)"
	@-docker rm -f $$(docker ps -qa)
	@echo "$(COLOR_GREEN)All stopped containers have been removed.$(COLOR_RESET)"

remove-images:
	@echo "$(COLOR_BOLD)Removing all Docker images...$(COLOR_RESET)"
	@-docker rmi -f $$(docker images -qa)
	@echo "$(COLOR_GREEN)All Docker images have been removed.$(COLOR_RESET)"

remove-volumes:
	@echo "$(COLOR_BOLD)Removing all Docker volumes...$(COLOR_RESET)"
	@-docker volume rm $$(docker volume ls -q)
	@echo "$(COLOR_GREEN)All Docker volumes have been removed.$(COLOR_RESET)"

remove-network:
	@echo "$(COLOR_BOLD)Removing all Docker Network...$(COLOR_RESET)"
	@-docker network rm $$(docker network ls --filter type=custom -q)
	@echo "$(COLOR_GREEN)All Docker Network have been removed.$(COLOR_RESET)"

image-ls:
	@echo "$(COLOR_BOLD)Listing Docker images...$(COLOR_RESET)"
	@-docker image ls
	@echo "$(COLOR_GREEN)Docker images listed.$(COLOR_RESET)"

container-ls:
	@echo "$(COLOR_BOLD)Listing Docker containers...$(COLOR_RESET)"
	@-docker container ls -a
	@echo "$(COLOR_GREEN)Docker containers listed.$(COLOR_RESET)"

network-ls:
	@echo "$(COLOR_BOLD)Listing Docker networks...$(COLOR_RESET)"
	@-docker network ls
	@echo "$(COLOR_GREEN)Docker networks listed.$(COLOR_RESET)"

volume-ls:
	@echo "$(COLOR_BOLD)Listing Docker volumes...$(COLOR_RESET)"
	@-docker volume ls
	@echo "$(COLOR_GREEN)Docker volumes listed.$(COLOR_RESET)"

volume-inspect:
	@echo "$(COLOR_BOLD)Inspecting Docker volumes...$(COLOR_RESET)"
	@-docker volume ls --quiet | xargs -I {} docker volume inspect {}
	@echo "$(COLOR_GREEN)Docker volumes inspected.$(COLOR_RESET)"

clean: stop-containers remove-containers remove-images remove-volumes remove-network

fclean: clean
	@-rm -rf /home/ael-mouz/data

re: fclean up

prune:
	@-docker system prune --all --force --volumes
