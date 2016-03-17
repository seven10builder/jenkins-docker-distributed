#!/bin/bash


if [ "$#" -eq 0 ] || [ "$#" -gt 2 ]; then
     echo "Usage: ./stop-docker-container.sh <container-name> [timeout-before-force-in-seconds]"
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
     TIMEOUT="5"
     echo "Using default timeout of '$TIMEOUT' seconds"
else
     TIMEOUT="$2"
     echo "Using timout value of '$2'."
fi



STOP_RESULT=$(curl --write-out %{http_code} --silent --output /dev/nul --unix-socket /var/run/docker.sock -X POST http:/containers/$CONTAINER_NAME/stop?t=$TIMEOUT)
case "$STOP_RESULT" in
     500)
          RVAL=5
          echo "Server Error, cannot stop container";;
     404)
          RVAL=4
          echo "Container not Found, cannot stop container";;
     304)
          RVAL=0
          echo "Container already stopped, cannot stop container, ignoring";;
     204)
          RVAL=0
          echo "stop-docker-container executed successfully.";;
     *)
          RVAL=1
          echo "Unknown error '$STOP_RESULT', cannot stop container";;
esac
exit $RVAL
