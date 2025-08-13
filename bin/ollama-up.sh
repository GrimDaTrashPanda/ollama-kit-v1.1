#!/bin/sh
# Start existing container if stopped; run if missing.
if podman ps --format '{{.Names}}' | grep -qx ollama; then
  exit 0
fi
if podman ps -a --format '{{.Names}}' | grep -qx ollama; then
  podman start ollama >/dev/null 2>&1 || true
else
  podman run -d --name ollama -p 11434:11434 --pull=never --security-opt label=disable docker.io/library/ollama-preloaded:latest
fi
