#!/bin/bash

if [ "$#" -ne 1 ]; then
     echo "Usage: ./start-docker-container.sh <container-name>"
     exit 1
fi
if [ -z "$1" ]; then
     echo "Must supply a container name"
     exit 1
else
     CONTAINER_NAME="$1"
     echo "Using image name '$CONTAINER_NAME'"
fi

START_RESULT=$(curl --write-out %{http_code} --silent --output /dev/nul --unix-socket /var/run/docker.sock -X POST http:/containers/$CONTAINER_NAME/start)
RVAL=$START_RESULT
case "$START_RESULT" in
     500)
          echo "Server Error, cannot start container";;
     404)
          echo "Container not Found, cannot start container";;
     304)
          echo "Container already started, cannot start container";;
     204)
          echo "start-docker-container executed successfully."
          RVAL=0;;
     *)
          echo "Unknown error '$START_RESULT', cannot start container";;
esac
exit $RVAL
