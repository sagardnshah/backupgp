#!/bin/bash

NAME="backupgp"
CREDS_HOST_DIR="$HOME/config/google"
CREDS_MOUNT_DIR="/config"

# 'sudo -v' prompts for password once and caches the credentials (default:15mins).
# If sudo in front of a command, then run as root. Else, run as current user.
sudo -v || { echo "This script requires sudo access. Exiting."; exit 1; }

function clean () {
  sudo docker container prune -f
  sudo docker image rm -f $(sudo docker images -q $NAME)
}

function build () {
  sudo docker build \
  --build-arg NAME="$NAME" \
  -t $NAME .
}

#TODO
# currently bridge network breaks OAuth flow, connection gets reset on redirect to localhost on host machine
# using host network for now, but eventually resolve issue with docker bridge networking
# -p 8080:8080 \
function debug () {
  sudo docker run \
  --network host \
  -v $(pwd):/$NAME \
  -v $CREDS_HOST_DIR:$CREDS_MOUNT_DIR \
  -it $NAME /bin/bash
}

function run () {
  sudo docker run \
  -v $(pwd):/$NAME \
  -v $CREDS_HOST_DIR:$CREDS_MOUNT_DIR \
  $NAME
}

clean
build
debug
#run