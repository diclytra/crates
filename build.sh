#!/bin/bash

. ./variables
VERS=$(date +%y%m%d%H%M)

podman build --rm --squash-all \
--build-arg VERS=$VERS \
--build-arg NAME=$NAME \
--build-arg UIDN=$UIDN \
-f blueprint.$TYPE -t $NAME .

