#! /bin/bash
set -e

UIDN=$(whoami)

function usage {
echo "
Usage:
  $(basename $0) <directory> [options]
  $(basename $0) help

Options:
  build    - build image
  run      - run image
  deploy   - build and run image
"
}

CS=()
if [[ -z "$1" ]]; then
  echo "missing directory. building all"
  for d in $(ls -d */); do
    CS+=($(basename $d))
  done
else
  if [[ $1 == "help" ]]; then
    usage
    exit 0
  fi
  CS+=("$1")
fi

VB="deploy"
if [[ ! -z "$2" ]]; then
  VB=$2
fi

for c in ${CS[@]}; do
  if [[ ! -d $c ]]; then
    echo "$c is not a directory"
    exit 1
  fi
  cd $c

  if [[ ! -f ./functions  ]]; then
    echo "missing functions file"
    exit 1
  fi
  . functions

  case "$VB" in
    build)
      build
      ;;
    run)
      run
      ;;
    deploy)
      build && run
      ;;
    *)
      usage
      ;;
  esac
  cd ../
done

