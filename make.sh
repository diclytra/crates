#! /bin/bash

. ./variables
VERS=$(date +%y%m%d%H%M)

function usage {
echo "
Usage:
  $(basename $0) [options]

Options:
  build    Build image
  deploy   Deploy image
"
}

function build {
  echo "info: building base $TYPE with name $NAME"
  $EXEC build \
  --build-arg VERS=$VERS \
  --build-arg NAME=$NAME \
  --build-arg UIDN=$UIDN \
  -f blueprints/$TYPE.docker \
  -t $NAME:$VERS \
  -t $NAME \
  .
}

function deploy {
  echo "info: deploying base $TYPE with name $NAME"
  local TGT=$HOME/$MOUNT
  local SEC=$HOME/.groot
  mkdir -p $TGT && chmod -R 700 $TGT
  mkdir -p $SEC/ssh && chmod -R 700 $SEC
  $EXEC run \
  -itd \
  --privileged \
  --userns=keep-id \
  --hostname $NAME \
  --name $NAME \
  -v $TGT:/home/$UIDN/$MOUNT \
  -v $SEC:/home/$UIDN/.groot \
  -p 1234:1234 -p 7777:7777 -p 8888:8888 \
  $NAME
}

[[ $# == 0  ]] && usage

while (( "$#" )); do
  case "$1" in
    build)
      build
      shift
      ;;
    deploy)
      deploy
      shift
      ;;
    *)
      usage
      shift
      ;;
  esac
done
