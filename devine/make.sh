#!/bin/bash

NAME="devine"
UIDN="super"
BLDF="container.build"
CLI="podman"

if [[ ! -f $BLDF ]]; then
  echo "error: build file"
  exit 1
fi

build() {
  $CLI build \
  --build-arg NAME=$NAME \
  --build-arg UIDN=$UIDN \
  -t $NAME -f $BLDF
}

run() {
  $CLI run -itd \
    --privileged \
    --userns=keep-id \
    -u $UIDN \
    --name $NAME \
    --hostname $NAME \
    -v ${HOME}:/home/$UIDN/host \
    localhost/${NAME}
}

clean() {
  $CLI rm -f $NAME
  $CLI rmi -f $NAME
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
