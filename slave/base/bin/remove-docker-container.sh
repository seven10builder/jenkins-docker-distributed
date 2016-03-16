#!/bin/bash


if [ "$#" -eq 0 ] || [ "$#" -gt 3 ]; then
     echo "Usage: ./stop-docker-container.sh <container-name> [remove-volumes] [force]"
     exit 1
fi
# Validate container name
if [ -z "$1" ]; then
     echo "Must supply a container name"
     exit 1
else
     CONTAINER_NAME="$1"
     echo "Using container name '$CONTAINER_NAME'"
fi
# Validate or default Remove Volumes
if [ -z "$2" ]; then
     REMOVE_VOLUMES="false"
     echo "Using default for 'remove volumes'"
elif [ "$2" != "true" ] && [ "$2" != "false" ]; then
     echo "invalid value for 'remove volumes': '$2' (Must be 'true' or 'false')"
     exit 1
else
     REMOVE_VOLUMES="$2"
fi
echo "Remove Volumes='$REMOVE_VOLUMES'"

# Validate or default Force Stop
if [ -z "$3" ]; then
     FORCE_STOP="false"
     echo "Using default for 'force stop' = false"

elif [ "$3" != "true" ] && [ "$3" != "false" ]; then
     echo "invalid value for 'force stop': '$3' (Must be 'true' or 'false')"
     exit 1
else
     FORCE_STOP="$3"
fi
echo "Force Stop ='$FORCE_STOP'"


STOP_RESULT=$(curl --write-out %{http_code} --silent --output /dev/nul --unix-socket /var/run/docker.sock -X DELETE http:/containers/$CONTAINER_NAME?v=$REMOVE_VOLUMES&force=$FORCE_STOP)
RVAL=$STOP_RESULT
case "$STOP_RESULT" in
     500)
          echo "Server Error, cannot stop container";;
     404)
            echo "Container not Found, cannot stop container";;
     304)
          echo "Container already stopped, cannot stop container, ignoring"
          RVAL=0;;
     204)
          echo "remove-docker-container executed successfully."
          RVAL=0;;
     *)
          echo "Unknown error '$STOP_RESULT', cannot stop container";;
esac
exit $RVAL
