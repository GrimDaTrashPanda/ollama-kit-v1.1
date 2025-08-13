#!/bin/sh
set -e
"$HOME/bin/ollama-up.sh"
export OLLAMA_HOST=http://127.0.0.1:11434
exec "$HOME/venv/bin/python" "$HOME/bin/gramified_gui.py"
