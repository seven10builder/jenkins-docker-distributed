#!/bin/bash
if [ "$#" -eq 0 ] || [ "$#" -gt 4 ]; then
     echo "Usage: ./run-docker-container.sh <container-name> <container-settings> <image-name> [tag]"
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

if [ -z "$3" ]; then
     echo "Must supply an image name"
     exit 1
else
     IMAGE_NAME="$3"
     echo "Using image name '$IMAGE_NAME'"
fi
if [ -z "$4" ]; then
     echo "No tag name specified, implying latest"
     TAG_NAME="latest"
else
     TAG_NAME="$4"
     echo "Using tag '$TAG_NAME'."
fi

echo "--- Creating Docker container ---"
create-docker-container.sh "$CONTAINER_NAME" "$CONTAINER_SETTINGS"
rval=$?
echo $rval
if [ $rval -eq 4 ]; then
     echo "--- Image not found in local repository, pulling from remote ---"
     pull-docker-image.sh "$IMAGE_NAME" "$TAG_NAME"
     if [ $? -ne 0 ]; then
           echo "Image pull failed. Aborting"
           exit 1
     fi
     "--- Attempting to create docker container again ---"
     create-docker-container.sh "$CONTAINER_NAME" "$CONTAINER_SETTINGS"
     if [ $? -ne 0 ]; then
          echo "Could not create container after pull. Aborting."
          exit 1
     fi
fi
echo "--- Starting Docker container ---"
start-docker-container.sh "$CONTAINER_NAME"
exit $?

