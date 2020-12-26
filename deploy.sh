#!/bin/bash

. ./variables

docker run -itd --hostname $NAME --name $NAME -v /home/rsendecky/code:/home/ruslan/code -p 1234:1234 -p 7777:7777 -p 8888:8888 $NAME

