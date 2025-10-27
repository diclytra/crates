#!/bin/bash

ACTION="build"
if [[ ! -z $1 ]]; then
  ACTION=$1
  shift
fi
echo "info: action $ACTION"
sleep 2

CONF=$(<config)
for I in $CONF; do
  K=$(echo "$I" | cut -d '=' -f 1)
  V=$(echo "$I" | cut -d '=' -f 2)
  declare "${K}"="${V}"
  if [[ -z ${!K} ]]; then
    echo "error: ${!K}"
    exit 1
  fi
  # echo "${K} = ${!K}"
done

if [[ $ACTION == "build" ]]; then
  if [[ ! -z $1 ]]; then
    IMAGE=$1
    shift
  fi
  echo "info: image $IMAGE" 
  sleep 2
fi

if [[ ! -z $1 ]]; then
  NAME=$1
  shift
fi
echo "info: name $NAME" 
sleep 2

FILE="${IMAGE}.containerfile"
if [[ ! -f $FILE ]]; then
  echo "error: build file"
  exit 1
fi

UIDN="super"
CLI="podman"
VERS=$(date +"%y%m%d%H%M%S")

build() {
  $CLI build \
  --build-arg NAME=$NAME \
  --build-arg UIDN=$UIDN \
  --build-arg VERS=$VERS \
  -t $NAME -f $FILE
}

run() {
  $CLI run -itd \
    --privileged \
    --userns=keep-id \
    -u $UIDN \
    --name $NAME \
    --hostname $NAME \
    -p 1234:1234 \
    localhost/${NAME}
}

clean() {
  $CLI rm -f $NAME
  $CLI rmi -f $NAME
}

case $ACTION in
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
