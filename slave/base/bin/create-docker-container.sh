#!/bin/bash

if [ "$#" -ne 2 ]; then
     echo "Usage: ./create-docker-container.sh <container-name> <container-settings>"
     exit 1
fi
if [ -z "$1" ]; then
     echo "Must supply a container name"
     exit 1
else
     CONTAINER_NAME="$1"
     echo "Using container name '$CONTAINER_NAME'"
fi
if [ -z "$2" ]; then
     echo "Must supply container settings in the form of a json block"
     exit 1
else
     CONTAINER_SETTINGS="$2"
     echo "Using settings '$CONTAINER_SETTINGS'"
fi


# next create the container instance
CREATE_RESULT=$(curl --write-out %{http_code} --silent --output /dev/nul --unix-socket /var/run/docker.sock  -X POST -H "Content-Type: application/json" http:/containers/create?name=$CONTAINER_NAME -d "$CONTAINER_SETTINGS")
case "$CREATE_RESULT" in
     500)
          RVAL=5
          echo "Server Error, cannot create container";;
     404)
          RVAL=4
          echo "Container not Found, cannot create container";;
     406)
          RVAL=6
          echo "Impossible to attach, cannot create container";;
     201)
          RVAL=0
          echo "create-container executed successfully";;
     *)
          RVAL=1
          echo "Unknown error '$CREATE_RESULT', cannot create container";;
esac
exit $RVAL

