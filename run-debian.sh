#!/bin/bash

# Run Debian development container with persistent volumes
# Container will not be removed when stopped (--rm not used)

docker run -it \
  --name my-debian-dev-container \
  -v $(pwd):/workspace \
  -v ~/.local/share/my-debian-dev/usr-local:/usr/local \
  -v ~/.local/share/my-debian-dev/root-local:/root/.local \
  my-debian-dev