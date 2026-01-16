#!/bin/bash

# Run Arch Linux development container with persistent volumes
# Container will not be removed when stopped (--rm not used)

docker run -it \
  --name my-arch-dev-container \
  -v $(pwd):/workspace \
  -v ~/.local/share/my-arch-dev/usr-local:/usr/local \
  -v ~/.local/share/my-arch-dev/root-local:/root/.local \
  my-arch-dev