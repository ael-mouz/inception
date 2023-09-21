COLOR_BOLD := \033[1m
COLOR_RED := \033[1;31m
COLOR_GREEN := \033[1;32m
COLOR_YELLOW := \033[1;33m
COLOR_RESET := \033[0m

IP := $(shell ifconfig | grep inet | awk 'NR == 5 {print $$2}')

HEADER ="                                                                     \n"\
		"██╗███╗   ██╗ ██████╗███████╗██████╗ ████████╗██╗ ██████╗ ███╗   ██╗\n"\
		"██║████╗  ██║██╔════╝██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║\n"\
		"██║██╔██╗ ██║██║     █████╗  ██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║\n"\
		"██║██║╚██╗██║██║     ██╔══╝  ██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║\n"\
		"██║██║ ╚████║╚██████╗███████╗██║        ██║   ██║╚██████╔╝██║ ╚████║\n"\
		"╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝\n"\

all: build up

build: ip
	@mkdir -p data/DB
	@mkdir -p data/wordpress
	@mkdir -p data/adminer
	@mkdir -p data/website
	@clear
	@echo "$(COLOR_BOLD)Building the project...$(COLOR_RESET)"
	@docker-compose -f srcs/docker-compose.yml --project-name inception build --progress=plain > docker-build.log 2>&1 || true
	@echo "$(COLOR_GREEN)Build completed successfully.$(COLOR_RESET)"

up:
	@echo "$(COLOR_BOLD)Starting the project...$(COLOR_RESET)"
	@docker-compose -f srcs/docker-compose.yml --project-name inception up -d > /dev/null 2>&1 || true
	@clear
	@echo ${HEADER}
	@echo "$(COLOR_GREEN)Project is up and running ${COLOR_YELLOW}http://${IP}$(COLOR_RESET)"

down: stop-containers remove-containers
	@echo "$(COLOR_BOLD)Stopping and removing the project...$(COLOR_RESET)"
	@docker-compose -f srcs/docker-compose.yml down --remove-orphans > /dev/null 2>&1 || true
	@echo "$(COLOR_GREEN)Project has been stopped and removed.$(COLOR_RESET)"

stop-containers:
	@echo "$(COLOR_BOLD)Stopping all containers...$(COLOR_RESET)"
	@docker stop $$(docker ps -qa) > /dev/null 2>&1 || true
	@echo "$(COLOR_GREEN)All containers have been stopped.$(COLOR_RESET)"

remove-containers:
	@echo "$(COLOR_BOLD)Removing all stopped containers...$(COLOR_RESET)"
	@docker rm -f $$(docker ps -qa) > /dev/null 2>&1 || true
	@echo "$(COLOR_GREEN)All stopped containers have been removed.$(COLOR_RESET)"

remove-images:
	@echo "$(COLOR_BOLD)Removing all Docker images...$(COLOR_RESET)"
	@docker rmi -f $$(docker images -qa) > /dev/null 2>&1 || true
	@echo "$(COLOR_GREEN)All Docker images have been removed.$(COLOR_RESET)"

remove-volumes:
	@echo "$(COLOR_BOLD)Removing all Docker volumes...$(COLOR_RESET)"
	@docker volume rm $$(docker volume ls -q) > /dev/null 2>&1 || true
	@echo "$(COLOR_GREEN)All Docker volumes have been removed.$(COLOR_RESET)"

remove-network:
	@echo "$(COLOR_BOLD)Removing all Docker Network...$(COLOR_RESET)"
	@docker network rm $$(docker network ls -q) > /dev/null 2>&1 || true
	@echo "$(COLOR_GREEN)All Docker Network have been removed.$(COLOR_RESET)"

network-ls:
	@echo "$(COLOR_BOLD)Listing Docker networks...$(COLOR_RESET)"
	@docker network ls
	@echo "$(COLOR_GREEN)Docker networks listed.$(COLOR_RESET)"

clean:
	@rm -rf data
	@rm -rf docker-build.log

fclean: down remove-images remove-volumes remove-network clean

re: fclean all

purne:
	@docker system prune --all --force --volumes > /dev/null 2>&1 || true

ip:
	@echo "Updating IP address in .env file..."
	@if [ -n "$(IP)" ]; then \
		sed -i "" "s#DOMAIN_NAME=.*#DOMAIN_NAME=$(IP)#" srcs/.env; \
		sed -i "" "s#WP_URL=.*#WP_URL=$(IP)#" srcs/.env; \
		echo "Updated .env file with IP address: $(IP)"; \
	else \
		echo "Failed to extract IP address."; \
	fi

.PHONY: all build up down stop-containers remove-containers remove-images remove-volumes remove-network network-ls docker-compose test fclean purne ip