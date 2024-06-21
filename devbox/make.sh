#!/bin/bash

NAME="devbox"
UIDN="super"
BLDF="${NAME}.build"

if [[ ! -f $BLDF ]]; then
  echo "error: build file"
  exit 1
fi

build() {
  podman build \
  --build-arg NAME=$NAME \
  --build-arg UIDN=$UIDN \
  -t $NAME -f $BLDF
}

run() {
  podman run -itd \
    --privileged \
    --userns=keep-id \
    -u $UIDN \
    --name $NAME \
    --hostname $NAME \
    -p 1234:1234 \
    -v ${HOME}:/home/$UIDN/work \
    localhost/${NAME}
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
  "deploy")
    clean
    build
    run
    ;;
  *)
    echo "error: arguments"
    ;;
esac
