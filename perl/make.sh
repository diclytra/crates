#! /bin/bash

. ./vars
VERS="1.0.$(date +%y%m%d%H%M)"

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
  podman build \
  --build-arg VERS=$VERS \
  --build-arg NAME=$NAME \
  --build-arg UIDN=$UIDN \
  --rm --squash-all \
  -f buildfile \
  -t $NAME:$VERS \
  -t $NAME \
  .
}

function deploy {
  mkdir -p $MNTD && chmod -R 700 $MNTD
  podman run \
  -itd \
  --privileged \
  --userns=keep-id \
  --hostname $NAME \
  --name $NAME \
  -v $MNTD:/home/$UIDN/.${MNTD##*/} \
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
