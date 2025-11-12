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
}

run() {
	local com vol
	if [[ ! -z $VOLUME ]] && [[ -d $VOLUME ]]; then
		vol="-v ${VOLUME}:/home/${UIDN}/host"
	fi

	com="
		$CLI run -itd
		--privileged
		--userns=keep-id
		-u $UIDN
		--name $NAME
		--hostname $NAME
		-p 1234:1234
		$vol
		localhost/${NAME}
	"
	$com
}

clean() {
	$CLI rm -f $NAME
	$CLI rmi -f $NAME
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
