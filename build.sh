#!/bin/bash

. ./variables

podman build --rm --squash-all \
--build-arg USERID=$USERID \
--build-arg VERS=$VERS \
--build-arg NAME=$NAME \
--build-arg UNAME=$UNAME \
-f blueprint.$BASE -t $NAME:$VERS .

podman tag $NAME:$VERS $NAME:latest

if [[ $? -eq 0 ]];then
  printf "$VERS" > version
fi

