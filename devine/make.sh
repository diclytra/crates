#! /bin/bash

. ./variables
VERS=$(date +%y%m%d%H%M)
STG="$HOME/stage"

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
  --rm --squash-all \
  -f blueprints/$TYPE.docker \
  -t $NAME:$VERS \
  -t $NAME \
  .
}

function deploy {
  echo "info: deploying base $TYPE with name $NAME"
  mkdir -p $STG && chmod -R 700 $STG
  $EXEC run \
  -itd \
  --privileged \
  --userns=keep-id \
  --hostname $NAME \
  --name $NAME \
  -v $STG:/home/$UIDN/${STG##*/} \
  -v $HOME/.ssh:/home/$UIDN/.ssh \
  -p 1234:1234 \
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
