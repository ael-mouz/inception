COLOR_BOLD := \033[1m
COLOR_RED := \033[1;31m
COLOR_GREEN := \033[1;32m
COLOR_YELLOW := \033[1;33m
COLOR_RESET := \033[0m

IP := ael-mouz.42.fr

HEADER ="                                                                     \n"\
		"██╗███╗   ██╗ ██████╗███████╗██████╗ ████████╗██╗ ██████╗ ███╗   ██╗\n"\
		"██║████╗  ██║██╔════╝██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║\n"\
		"██║██╔██╗ ██║██║     █████╗  ██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║\n"\
		"██║██║╚██╗██║██║     ██╔══╝  ██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║\n"\
		"██║██║ ╚████║╚██████╗███████╗██║        ██║   ██║╚██████╔╝██║ ╚████║\n"\
		"╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝\n"\

all: build up

build:
	@sudo mkdir -p /home/ael-mouz/data/DB
	@sudo mkdir -p /home/ael-mouz/data/wordpress
	@sudo mkdir -p /home/ael-mouz/data/adminer
	@sudo mkdir -p /home/ael-mouz/data/website
	@reset
	@echo "$(COLOR_BOLD)Building the project...$(COLOR_RESET)"
	@docker-compose -f srcs/docker-compose.yml --project-name inception build || true
	@echo "$(COLOR_GREEN)Build completed successfully.$(COLOR_RESET)"

up:
	@echo "$(COLOR_BOLD)Starting the project...$(COLOR_RESET)"
	@docker-compose -f srcs/docker-compose.yml --project-name inception up || true
	@reset
	@echo ${HEADER}
	@echo "$(COLOR_GREEN)Project is up and running ${COLOR_YELLOW}http://${IP}:8000$(COLOR_RESET)"

down: stop-containers remove-containers
	@echo "$(COLOR_BOLD)Stopping and removing the project...$(COLOR_RESET)"
	@docker-compose -f srcs/docker-compose.yml down --remove-orphans || true
	@echo "$(COLOR_GREEN)Project has been stopped and removed.$(COLOR_RESET)"

stop-containers:
	@echo "$(COLOR_BOLD)Stopping all containers...$(COLOR_RESET)"
	@docker stop $$(docker ps -qa) || true
	@echo "$(COLOR_GREEN)All containers have been stopped.$(COLOR_RESET)"

remove-containers:
	@echo "$(COLOR_BOLD)Removing all stopped containers...$(COLOR_RESET)"
	@docker rm -f $$(docker ps -qa) || true
	@echo "$(COLOR_GREEN)All stopped containers have been removed.$(COLOR_RESET)"

remove-images:
	@echo "$(COLOR_BOLD)Removing all Docker images...$(COLOR_RESET)"
	@docker rmi -f $$(docker images -qa) || true
	@echo "$(COLOR_GREEN)All Docker images have been removed.$(COLOR_RESET)"

remove-volumes:
	@echo "$(COLOR_BOLD)Removing all Docker volumes...$(COLOR_RESET)"
	@docker volume rm $$(docker volume ls -q) || true
	@echo "$(COLOR_GREEN)All Docker volumes have been removed.$(COLOR_RESET)"

remove-network:
	@echo "$(COLOR_BOLD)Removing all Docker Network...$(COLOR_RESET)"
	@docker network rm $$(docker network ls -q) || true
	@echo "$(COLOR_GREEN)All Docker Network have been removed.$(COLOR_RESET)"

network-ls:
	@echo "$(COLOR_BOLD)Listing Docker networks...$(COLOR_RESET)"
	@docker network ls || true
	@echo "$(COLOR_GREEN)Docker networks listed.$(COLOR_RESET)"

clean:
	@sudo rm -rf /home/ael-mouz/data || true
	@sudo rm -rf docker-build.log || true

fclean: down remove-images remove-volumes remove-network clean

re: fclean all

purne:
	@docker system prune --all --force --volumes

.PHONY: all build up down stop-containers remove-containers remove-images remove-volumes remove-network network-ls docker-compose test fclean purne ip
