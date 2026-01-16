#!/bin/bash

# Run Alpine development container with persistent volumes
# Container will not be removed when stopped (--rm not used)

docker run -it \
  --name my-alpine-dev-container \
  -v $(pwd):/workspace \
  -v ~/.local/share/my-alpine-dev/usr-local:/usr/local \
  -v ~/.local/share/my-alpine-dev/root-local:/root/.local \
  my-alpine-dev