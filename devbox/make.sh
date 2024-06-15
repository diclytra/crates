#!/bin/bash

NAME="devbox"
UIDN="super"

build() {
  podman build -t $NAME -f build.manifest
}

run() {
  podman run -itd \
    --privileged \
    --userns=keep-id \
    -u $UIDN \
    --name $NAME \
    --hostname $NAME \
    -v ~/code:/home/$UIDN/code \
    $NAME
}

clean() {
  podman rm -f $NAME
  podman rmi -f $NAME
}

case $1 in
  "build")
    build
    ;;
  "run")
    run
    ;;
  "clean")
    clean
    ;;
  *)
    echo "error: arguments"
    ;;
esac
