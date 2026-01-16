#!/bin/bash

# Run Alpine development container with persistent volumes
# Builds image if not exists, runs or starts container as needed

IMAGE_NAME="alpine-dev"
CONTAINER_NAME="alpine-dev-container"
DOCKERFILE="Dockerfile.alpine"

# Check if image exists, build if not
if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    echo "Building $IMAGE_NAME from $DOCKERFILE..."
    docker build -f "$DOCKERFILE" -t "$IMAGE_NAME" .
fi

# Check if container exists
if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
    # Container exists, check if running
    if [ "$(docker container inspect -f '{{.State.Status}}' "$CONTAINER_NAME")" = "exited" ]; then
        echo "Starting existing container $CONTAINER_NAME..."
        docker start -i "$CONTAINER_NAME"
    elif [ "$(docker container inspect -f '{{.State.Status}}' "$CONTAINER_NAME")" = "running" ]; then
        echo "Container $CONTAINER_NAME is already running. Attaching..."
        docker attach "$CONTAINER_NAME"
    else
        echo "Container $CONTAINER_NAME is in an unknown state."
    fi
else
    # Container doesn't exist, create and run
    echo "Running new container $CONTAINER_NAME..."
    docker run -it \
      --name "$CONTAINER_NAME" \
      -v "$(pwd):/workspace" \
      -v "$HOME/.local/share/alpine-dev/usr-local:/usr/local" \
      -v "$HOME/.local/share/alpine-dev/root-local:/root/.local" \
      "$IMAGE_NAME"
fi
