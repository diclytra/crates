#! /bin/bash

. ./variables
VERS=$(date +%y%m%d%H%M)
TGT="$HOME/stage"
SEC="$HOME/groot"

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
  mkdir -p $TGT && chmod -R 700 $TGT
  if [[ -d $SEC/ssh ]]; then
    find $SEC -type d -exec chmod 700 {} +
    find $SEC -type f -exec chmod 600 {} +
  else
    echo "$SEC is missing"
    exit 1
  fi
  $EXEC run \
  -itd \
  --privileged \
  --userns=keep-id \
  --hostname $NAME \
  --name $NAME \
  -v $TGT:/home/$UIDN/${TGT##*/} \
  -v $SEC:/home/$UIDN/${SEC##*/} \
  -p 1234:1234 -p 7777:7777 -p 8888:8888 \
  $NAME
  $EXEC exec $NAME ln -s /home/$UIDN/${SEC##*/}/ssh /home/$UIDN/.ssh
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
