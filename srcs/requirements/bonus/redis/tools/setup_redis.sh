#!/bin/bash

export TERM=xterm-256color
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)

print_default() {
    echo "${bold}${blue}${1}${normal}"
}
print_color() {
    echo "${bold}${green}${1}${normal}"
}
handle_error() {
    echo "${bold}${red}Error: $1${normal}"
    exit 1
}

print_default "${magenta}Starting the Redis server...${normal}"
redis-server --bind 0.0.0.0 --protected-mode no || handle_error "Failed to start the Redis server"