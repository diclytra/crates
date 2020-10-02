#!/bin/bash

podman build -t code -f blueprint --squash-all . && \
# podman pod create --name devine --hostname devine --network host && \
podman run -itd -u ruslan --userns=keep-id --privileged --name code --hostname code --network host -v /data/devel:/home/ruslan/devel code
#podman run --pod devine -d --name postgres -e POSTGRES_PASSWORD=postgres postgres:13-alpine

