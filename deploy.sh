#!/bin/bash

. ./variables

podman pod exists stack
POD=$?
if [[ $POD -ne 0 ]]; then
  podman pod create --name stack -p 1234:1234 -p 8888:8888 --hostname $NAME
fi

podman run -itd --pod stack -u $UNAME --userns=keep-id --name $NAME -v /home/ruslan/code:/home/ruslan/code $NAME
podman run --pod stack -d --name postgres -e POSTGRES_PASSWORD=postgres postgres:13-alpine

