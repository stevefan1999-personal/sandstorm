#!/bin/bash

# Start an example server on a directory specified as argument 1
# Pass additional arguments after the config directory to Docker
# THIS IS NOT SUPPOSED TO BE USED IN PRODUCTION, YOU'RE ON YOUR OWN

if [[ $# -eq 0 ]]; then
  echo 'Error: need one master directory to mount'
  exit 1
fi

# These envs are defined in Dockerfile
HOME=/home/steam
SERVERDIR=$HOME/insserver/Insurgency

# Change the directory permission to rwx/rwx/rwx
mkdir -p $1
chmod 777 -R $1

docker run \
  -v $1/Config/:$SERVERDIR/Config/ \
  -v $1/Saved/:$SERVERDIR/Saved/ \
  ${@:2} \
  stevefan1999/sandstorm 