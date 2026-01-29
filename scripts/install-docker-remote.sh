#!/bin/bash

###############################################################################
# Docker Installation Script for Niko TV Remote Server
# Run this on: kyle@192.168.1.221
# Usage: bash install-docker-remote.sh
###############################################################################

set -e

echo "=========================================="
echo "🐳 Installing Docker on Remote Server"
echo "=========================================="

# Update package index
echo "📦 Updating package index..."
sudo apt-get update

# Install prerequisites
echo "📦 Installing prerequisites..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker GPG key
echo "🔑 Adding Docker GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "📦 Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
echo "🐳 Installing Docker Engine..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify installation
echo ""
echo "✅ Docker installed successfully!"
docker --version
docker compose version

# Add kyle user to docker group
echo ""
echo "👤 Adding kyle user to docker group..."
sudo usermod -aG docker kyle

echo ""
echo "=========================================="
echo "✅ Installation Complete!"
echo "=========================================="
echo ""
echo "⚠️  IMPORTANT: Log out and back in for group changes to take effect"
echo ""
echo "To test Docker without sudo:"
echo "  1. Exit this SSH session"
echo "  2. SSH back in: ssh kyle@192.168.1.221"
echo "  3. Run: docker ps"
echo ""
