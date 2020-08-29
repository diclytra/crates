#!/bin/bash

podman build -t code -f buildfile --squash-all . && \
podman pod create --name devine --hostname devine --network host && \
podman run --pod devine -itd --userns=keep-id --privileged --name code -v /home/ruslan/code:/home/ruslan/code code && \
podman run --pod devine -d --name postgres -e POSTGRES_PASSWORD=postgres postgres:13-alpine

