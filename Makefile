COLOR_BOLD := \033[1m
COLOR_RED := \033[1;31m
COLOR_GREEN := \033[1;32m
COLOR_YELLOW := \033[1;33m
COLOR_RESET := \033[0m

all: build up

build:
	@mkdir -p data/DB
	@mkdir -p data/wordpress
	@echo "$(COLOR_BOLD)Building the project...$(COLOR_RESET)"
	@docker-compose -f srcs/docker-compose.yml build
	@echo "$(COLOR_GREEN)Build completed successfully.$(COLOR_RESET)"

up:
	@echo "$(COLOR_BOLD)Starting the project...$(COLOR_RESET)"
	@docker-compose -f srcs/docker-compose.yml up
	@echo "$(COLOR_GREEN)Project is up and running.$(COLOR_RESET)"

down:
	@rm -rf data
	@echo "$(COLOR_BOLD)Stopping and removing the project...$(COLOR_RESET)"
	@docker-compose -f srcs/docker-compose.yml down > /dev/null 2>&1 || true
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

docker-compose:
	@echo "$(COLOR_BOLD)Displaying Docker Compose services...$(COLOR_RESET)"
	@docker-compose ps
	@echo "$(COLOR_GREEN)Docker Compose services displayed.$(COLOR_RESET)"

test:
	@echo "$(COLOR_BOLD)Pulling and running a test container...$(COLOR_RESET)"
	@docker pull debian:bullseye > /dev/null 2>&1 || (echo "$(COLOR_RED)Error: Failed to pull the test container image.$(COLOR_RESET)" && exit 1)
	@docker run -it debian:bullseye /bin/bash
	@echo "$(COLOR_GREEN)Test container executed.$(COLOR_RESET)"

fclean: down stop-containers remove-containers remove-images remove-volumes remove-network

.PHONY: all build up down stop-containers remove-containers remove-images remove-volumes remove-network network-ls docker-compose test fclean
