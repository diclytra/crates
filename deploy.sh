#!/bin/bash

. ./variables

docker run -itd --hostname $NAME --name $NAME -v /home/rsendecky/code:/home/ruslan/code -p 1234:1234 $NAME

