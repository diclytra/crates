#!/bin/bash

. ./variables
VERS=$(date +%y%m%d%H%M)

docker build --rm \
--build-arg VERS=$VERS \
--build-arg NAME=$NAME \
--build-arg UIDN=$UIDN \
-f blueprint -t $NAME:$VERS .
if [[ $? -ne 0 ]];then
  exit $?
fi

docker tag $NAME:$VERS $NAME:latest
if [[ $? -eq 0 ]];then
  printf "$VERS" > version
fi

