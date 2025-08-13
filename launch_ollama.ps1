# launch_ollama.ps1
# Detect WSL Debian and run the launch script inside your kit folder

# Change this to match the actual folder name INSIDE your WSL home
$KitPathWSL = "~/ai-stack/ollama-kit-v1.1"

Write-Host "Starting Ollama Kit in WSL (Debian)..."

wsl -d Debian bash -lc "cd $KitPathWSL && ./launch.sh"
