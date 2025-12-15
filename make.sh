#!/bin/bash

VERS=$(date +"%y%m%d%H%M%S")

ACTION="build"
if [[ ! -z $1 ]]; then
	ACTION=$1
	shift
fi

echo "info: parsing config"
CONF=$(<.config)
for I in $CONF; do
	K=$(echo "$I" | cut -d '=' -f 1)
	V=$(echo "$I" | cut -d '=' -f 2)
	declare "${K}"="${V}"
	echo "${K} = ${!K}"
done
echo "info: action $ACTION"
sleep 2

if [[ ! -z $1 ]]; then
	NAME=$1
	shift
fi

FILE="${NAME}.containerfile"
if [[ ! -f $FILE ]]; then
	echo "error: build file"
	exit 1
fi

if [[ ACTION == "run" ]] && [[ ! -z $1 ]]; then
	VOLUME=$1
	shift
fi

build() {
	$CLI build \
		--build-arg NAME=$NAME \
		--build-arg UIDN=$UIDN \
		--build-arg VERS=$VERS \
		-t $NAME -f $FILE

	$CLI tag $NAME ${NAME}:${VERS}
	$CLI tag ${NAME}:${VERS} ${NAME}:latest
}

run() {
	local com vol
	if [[ ! -z $VOLUME ]] && [[ -d $VOLUME ]]; then
		vol="-v ${VOLUME}:/home/${UIDN}/devine"
	fi

	com="
		$CLI run -itd
		--privileged
		--userns=keep-id
		-u $UIDN
		--name ${NAME}-${RANDOM}
		--hostname $NAME
		-p 1234:1234
		-p 8000:8000
		$vol
		localhost/${NAME}:latest
	"
	$com
}

clean() {
	$CLI container prune -f
	$CLI image prune -af
}

case $ACTION in
"build")
	build
	;;
"run")
	run
	;;
"clean")
	clean
	;;
"deploy")
	clean
	build
	run
	;;
*)
	echo "error: arguments"
	;;
esac
