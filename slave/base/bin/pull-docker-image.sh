#!/bin/bash
if [ "$#" -eq 0 ] || [ "$#" -gt 2 ]; then
     echo "Usage: ./pull-docker-image.sh <image-name> [tag]"
     exit 1
fi
if [ -z "$1" ]; then
     echo "Must supply an image name"
     exit 1
else
     IMAGE_NAME="$1"
     echo "Using image name '$IMAGE_NAME'"
fi
if [ -z "$2" ]; then
     echo "No tag name specified, implying latest"
     TAG_NAME="latest"
else
     TAG_NAME="$2"
     echo "Using tag '$TAG_NAME'."
fi


PULL_RESULT=$(curl --write-out %{http_code} --silent --output /dev/nul --unix-socket /var/run/docker.sock -X POST http:/images/create?fromImage=$IMAGE_NAME:$TAG_NAME)
case "$PULL_RESULT" in
     500) 
          RVAL=5
          echo "Server Error, cannot pull image";;
     200)
          RVAL=0
          echo "pull-docker-image completed successfully";;
     *)
          RVAL=1
          echo "Unknown error '$PULL_RESULT', cannot pull image";;
esac
exit $RVAL
