IMAGE_NAME := nginx-container
CONTAINER_NAME := nginx-container

COLOR_PURPLE := \033[1;35m
COLOR_RESET := \033[0m

.PHONY: all build run clean stop clean-image

all: stop clean build run

build:
	@echo "$(COLOR_PURPLE)Building Docker image $(IMAGE_NAME)...$(COLOR_RESET)";
	@docker build -t $(IMAGE_NAME) .;
	@echo "$(COLOR_PURPLE)Docker image $(IMAGE_NAME) has been built successfully.$(COLOR_RESET)";

run:
	@echo "$(COLOR_PURPLE)Starting Docker container $(CONTAINER_NAME)...$(COLOR_RESET)"
	@docker run --env-file ../../.env -p 443:443 --name $(CONTAINER_NAME) $(IMAGE_NAME)

clean:
	@echo "$(COLOR_PURPLE)Removing Docker container $(CONTAINER_NAME)...$(COLOR_RESET)";
	@docker rm -f $(CONTAINER_NAME);
	@echo "$(COLOR_PURPLE)Docker container $(CONTAINER_NAME) has been removed.$(COLOR_RESET)";

stop:
	@echo "$(COLOR_PURPLE)Stopping Docker container $(CONTAINER_NAME)...$(COLOR_RESET)";
	@docker stop $(CONTAINER_NAME);
	@echo "$(COLOR_PURPLE)Docker container $(CONTAINER_NAME) has been stopped.$(COLOR_RESET)";

clean-image:
	@echo "$(COLOR_PURPLE)Removing Docker image $(IMAGE_NAME)...$(COLOR_RESET)"
	@docker rmi $(IMAGE_NAME);
	@echo "$(COLOR_PURPLE)Docker images $(IMAGE_NAME) have been removed.$(COLOR_RESET)";