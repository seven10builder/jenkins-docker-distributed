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
case "$START_RESULT" in
     500)
          RVAL=5
          echo "Server Error, cannot start container";;
     404)
          RVAL=4
          echo "Container not Found, cannot start container";;
     304)
          RVAL=3
          echo "Container already started, cannot start container";;
     204)
          RVAL=0
          echo "start-docker-container executed successfully.";;
     *)
          RVAL=1
          echo "Unknown error '$START_RESULT', cannot start container";;
esac
exit $RVAL
