#!/bin/bash

export TERM=xterm-256color

bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)

print_color() {
    echo "${bold}${green}${1}${normal}"
}

handle_error() {
    print_color "${red}Error: $1"
    exit 1
}

print_color "Starting the Redis server..."
echo "bind 0.0.0.0" >> /etc/redis/redis.conf || handle_error "Failed to configure Redis to bind to all interfaces"
echo "CONFIG SET protected-mode no" | redis-cli || handle_error "Failed to disable protected mode"
echo "CONFIG SET requirepass your_redis_password" | redis-cli || handle_error "Failed to set Redis password"

redis-server /etc/redis/redis.conf --daemonize no || handle_error "Failed to start the Redis server in the foreground"
# print_color "Starting the Redis server..."
# echo "daemonize no" >> /etc/redis/redis.conf || handle_error "Failed to modify Redis configuration"
# echo "bind 0.0.0.0" >> /etc/redis/redis.conf || handle_error "Failed to configure Redis to bind to all interfaces"
# echo "protected-mode no" >> /etc/redis/redis.conf || handle_error "Failed to disable protected mode"
# echo "requirepass your_redis_password" >> /etc/redis/redis.conf || handle_error "Failed to set Redis password"
# redis-server /etc/redis/redis.conf || handle_error "Failed to start the Redis server"
# Configure Redis
