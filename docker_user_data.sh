#!/bin/bash
set -euo pipeline
echo "Updating System"
sudo yum update -y 

if command -v docker &>/dev/null 2>&1; then
    echo "Installing -y docker"
else
    echo "Docker already installed..."
fi

echo "Starting Docker..."
sudo systemctl enable --now docker

echo "Installing Git...."
if ! command -v git >/dev/null 2>&1; then
    sudo yum install -y git
fi

echo "installing Docker Compose....."
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL \
https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) \
-o /usr/local/lib/docker/cli-plugins/docker-compose

sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

echo "Adding user to docker group..."
sudo usermod -aG docker "$USER"

echo
echo "Installation complete!"
echo

docker --version
docker compose version
git --version

echo
echo "Log out and back in for docker group changes to take effect."
