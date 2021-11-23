#!/bin/bash

. ./variables
VERS=$(date +%y%m%d%H%M)

podman build --rm --squash-all \
--build-arg VERS=$VERS \
--build-arg NAME=$NAME \
--build-arg UIDN=$UIDN \
-f blueprint.$TYPE -t $NAME:$VERS .
if [[ $? -ne 0 ]];then
  exit $?
fi

podman tag $NAME:$VERS $NAME:latest
if [[ $? -eq 0 ]];then
  printf "$VERS" > version
fi

