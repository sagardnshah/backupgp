#!/bin/bash

source ./env

# 'sudo -v' prompts for password once and caches the credentials (default:15mins).
# If sudo in front of a command, then run as root. Else, run as current user.
sudo -v || { echo "This script requires sudo access. Exiting."; exit 1; }

function build () {
  sudo docker build --build-arg NAME="$NAME" -t $NAME .
}

function debug () {
  sudo docker run --env-file env -v $(pwd):/$NAME -it $NAME /bin/bash
}

function run () {
  sudo docker run --env-file env -v $(pwd):/$NAME $NAME
}

build
debug
#run