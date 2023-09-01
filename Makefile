COLOR_BOLD := \033[1m
COLOR_RED := \033[1;31m
COLOR_GREEN := \033[1;32m
COLOR_YELLOW := \033[1;33m
COLOR_RESET := \033[0m

all: build up

build:
	@echo "$(COLOR_BOLD)Building the project...$(COLOR_RESET)"
	@mkdir -p data/mariadb
	@docker-compose -f srcs/docker-compose.yml build
	@echo "$(COLOR_GREEN)Build completed successfully.$(COLOR_RESET)"

up:
	@echo "$(COLOR_BOLD)Starting the project...$(COLOR_RESET)"
	@mkdir -p data/mariadb
	@docker-compose -f srcs/docker-compose.yml up -d
	@echo "$(COLOR_GREEN)Project is up and running.$(COLOR_RESET)"

down:
	@echo "$(COLOR_BOLD)Stopping and removing the project...$(COLOR_RESET)"
	@docker-compose -f srcs/docker-compose.yml down
	@echo "$(COLOR_GREEN)Project has been stopped and removed.$(COLOR_RESET)"

stop-containers:
	@echo "$(COLOR_BOLD)Stopping all containers...$(COLOR_RESET)"
	@docker stop $(docker ps -q)
	@echo "$(COLOR_GREEN)All containers have been stopped.$(COLOR_RESET)"

remove-containers:
	@echo "$(COLOR_BOLD)Removing all stopped containers...$(COLOR_RESET)"
	@docker rm -f $$(docker ps -aq)
	@echo "$(COLOR_GREEN)All stopped containers have been removed.$(COLOR_RESET)"

remove-images:
	@echo "$(COLOR_BOLD)Removing all Docker images...$(COLOR_RESET)"
	@docker rmi $$(docker images -q)
	@echo "$(COLOR_GREEN)All Docker images have been removed.$(COLOR_RESET)"

remove-volumes:
	@echo "$(COLOR_BOLD)Removing all Docker volumes...$(COLOR_RESET)"
	@docker volume rm $$(docker volume ls -q)
	@echo "$(COLOR_GREEN)All Docker volumes have been removed.$(COLOR_RESET)"

.PHONY: all build up down clean stop-containers remove-containers remove-images remove-volumes