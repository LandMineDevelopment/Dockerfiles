# Docker Development Environments

A collection of Docker-based development environments for different Linux distributions, each pre-configured with essential development tools and custom configurations.

## Available Environments

### Debian (`run-debian.sh`)
- **Base Image**: `debian:latest`
- **Package Manager**: apt
- **Tools**: Python3, Node.js, Neovim, Git, Build tools

### Ubuntu (`run-ubuntu.sh`)
- **Base Image**: `ubuntu:latest`
- **Package Manager**: apt
- **Tools**: Python3, Node.js, Neovim, Git, Build tools

### Arch Linux (`run-arch.sh`)
- **Base Image**: `archlinux:latest`
- **Package Manager**: pacman
- **Tools**: Python3, Node.js, Neovim, Git, Build tools

### Alpine Linux (`run-alpine.sh`)
- **Base Image**: `alpine:latest`
- **Package Manager**: apk
- **Tools**: Python3, Node.js, Neovim, Git, Build tools, Yazi file manager, LazyGit

## Pre-installed Tools

All environments include:
- **Languages**: Python 3 with pip, Node.js with npm
- **Editors**: Neovim (with custom config), Vim, Nano
- **Development**: Git, curl, wget, build-essential/build-base
- **OpenCode AI**: AI-powered coding assistant
- **Custom Configs**: Neovim and Yazi configurations from [omarchy_configs](https://github.com/LandMineDevelopment/omarchy_configs)

## Quick Start

### Prerequisites

1. **Docker**: Ensure Docker is installed and running on your system
   ```bash
   # Check if Docker is installed
   docker --version

   # On Linux, you might need to start Docker service
   sudo systemctl start docker
   ```

2. **SSH Setup** (Recommended for Git operations):
   ```bash
   # Check existing SSH keys
   ls -la ~/.ssh/

   # Generate new SSH key if needed
   ssh-keygen -t ed25519 -C "your_email@example.com"

   # Add to SSH agent
   ssh-add ~/.ssh/id_ed25519

   # Copy public key to add to GitHub/GitLab
   cat ~/.ssh/id_ed25519.pub
   ```

### Running an Environment

Choose your preferred Linux distribution and run the corresponding script:

```bash
# Run Debian environment
./run-debian.sh

# Run Ubuntu environment
./run-ubuntu.sh

# Run Arch Linux environment
./run-arch.sh

# Run Alpine Linux environment (includes Yazi + LazyGit)
./run-alpine.sh
```

By default, these scripts will:
- Use your current directory as the workspace
- Mount it to `/workspace` inside the container
- Provide persistent storage for installed packages and configurations

### Custom Workspace Directory

You can specify a different workspace directory:

```bash
# Use a specific directory as workspace
./run-debian.sh /path/to/your/project

# Use home directory
./run-debian.sh ~

# Use a project subdirectory
./run-debian.sh ./my-project
```

## Container Management

### Persistent Volumes

Each environment uses persistent volumes stored in `~/.local/share/{distro}-dev/`:

- **`/usr/local`**: System-wide installations persist between sessions
- **`/root/.local`**: User-specific data and configurations persist
- **`/workspace`**: Your project files (mounted from host)

### Container Lifecycle

The run scripts handle container management automatically:

- **First run**: Builds the Docker image and creates a new container
- **Subsequent runs**: Starts the existing container or attaches to running one
- **Container naming**: `{distro}-dev-container` (e.g., `debian-dev-container`)

### Manual Container Management

If needed, you can manage containers manually:

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Stop a container
docker stop debian-dev-container

# Remove a container
docker rm debian-dev-container

# Remove an image
docker rmi debian-dev

# View container logs
docker logs debian-dev-container
```

## Development Workflow

### Inside the Container

Once inside a container, you have access to:

```bash
# Your workspace files
cd /workspace
ls -la

# Pre-installed tools
python3 --version
node --version
nvim --version
opencode --help

# Git operations (SSH should work if configured)
git clone git@github.com:user/repo.git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Install additional packages
# Debian/Ubuntu:
apt-get update && apt-get install -y package-name

# Alpine:
apk add package-name

# Arch:
pacman -S package-name
```

### Yazi File Manager (Alpine only)

The Alpine environment includes Yazi file manager with custom keybindings:

```bash
# Launch Yazi
yazi
# or use alias
y

# Keybindings:
# Ctrl+Y: Open Yazi file manager
# Ctrl+L: Open LazyGit
```

### OpenCode AI Integration

All environments include OpenCode AI for enhanced development:

```bash
# Get AI assistance
opencode --help

# Use in your development workflow
opencode analyze file.py
```

## Customization

### Modifying Dockerfiles

Each `Dockerfile.{distro}` can be customized to add:

- Additional packages
- Custom configurations
- Development tools
- Environment variables

Example additions to a Dockerfile:
```dockerfile
# Add more development tools
RUN apt-get install -y \
    postgresql-client \
    redis-tools \
    docker-compose

# Set environment variables
ENV EDITOR=nvim
ENV LANG=C.UTF-8

# Add custom scripts
COPY custom-scripts/ /usr/local/bin/
```

### Custom Run Scripts

You can create custom run scripts for specific projects:

```bash
#!/bin/bash
# Custom development environment for web projects
./run-ubuntu.sh "$1" --additional-flags
```

## Troubleshooting

### Common Issues

1. **Permission denied on Docker socket**:
   ```bash
   # Add user to docker group
   sudo usermod -aG docker $USER
   # Logout and login again
   ```

2. **SSH key not working**:
   ```bash
   # Test SSH connection
   ssh -T git@github.com

   # Check SSH agent
   ssh-add -l

   # Re-add key if needed
   ssh-add ~/.ssh/id_ed25519
   ```

3. **Container won't start**:
   ```bash
   # Check Docker service
   sudo systemctl status docker

   # Clean up old containers
   docker system prune
   ```

4. **Port conflicts** (if running services):
   ```bash
   # Check used ports
   netstat -tulpn | grep :PORT

   # Run with port mapping
   docker run -p 3000:3000 your-image
   ```

### Getting Help

- Check container logs: `docker logs {container-name}`
- Inspect container: `docker inspect {container-name}`
- View running processes: `docker exec -it {container-name} ps aux`

### Adding a New Distribution

1. Create `Dockerfile.{distro}` based on existing templates
2. Create `run-{distro}.sh` script following the existing pattern
3. Update this README with the new environment details
4. Test the new environment thoroughly

## License

This project is open source. Please check individual tool licenses for compliance.
