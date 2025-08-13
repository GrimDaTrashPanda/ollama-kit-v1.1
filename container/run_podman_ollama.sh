#!/bin/sh
set -e
IMG="docker.io/ollama/ollama:0.11.4"
# Load image from local tar if not present
if ! podman image exists "$IMG"; then
  [ -f "$(dirname "$0")/ollama-0.11.4.tar" ] && podman load -i "$(dirname "$0")/ollama-0.11.4.tar"
fi
# Replace container
podman stop ollama >/dev/null 2>&1 || true
podman rm   ollama >/dev/null 2>&1 || true
mkdir -p "$HOME/.ollama"
exec podman run -d --name ollama -p 11434:11434 \
  -v "$HOME/.ollama:/root/.ollama" \
  --pull=never --security-opt label=disable \
  "$IMG"
