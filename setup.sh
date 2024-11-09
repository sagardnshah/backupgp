#!/bin/bash

NAME="backupgp"
CLINET_CONFIG_DIR="/client_config"
CLIENT_ID="$HOME/config/google-client-credentials.json"

# 'sudo -v' prompts for password once and caches the credentials (default:15mins).
# If sudo in front of a command, then run as root. Else, run as current user.
sudo -v || { echo "This script requires sudo access. Exiting."; exit 1; }

function clean () {
  sudo docker container prune -f
}

function build () {
  sudo docker build \
  --build-arg NAME="$NAME" \
  --build-arg CLINET_CONFIG_DIR="$CLINET_CONFIG_DIR" \
  -t $NAME .
}

function debug () {
  sudo docker run \
  -v $(pwd):/$NAME \
  -v $CLIENT_ID:/$CLINET_CONFIG_DIR/$(basename $CLIENT_ID) \
  -it $NAME /bin/bash
}

function run () {
  sudo docker run \
  -v $(pwd):/$NAME \
  -v $CLIENT_ID:/$CLINET_CONFIG_DIR/$(basename $CLIENT_ID) \
  $NAME
}

clean
build
debug
#run