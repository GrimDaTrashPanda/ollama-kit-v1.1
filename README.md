Ollama-Kit v1.1 – Portable AI Stack
===================================

WHAT THIS IS:
-------------
This folder is a complete, portable AI stack that runs inside a Podman container.
It includes:
- The Ollama server container (v0.11.4)
- All currently downloaded models (mistral, llama3, phi, gemma, qwen, codellama, etc.)
- Gramified GUI Python script for interacting with models
- Model data mounted to `~/.ollama` inside the container
- Any supporting launch scripts or shortcuts

WHY IT'S COOL:
--------------
- Fully self-contained: copy this folder to another Linux machine with Podman + Python and run without re-downloading models.
- No Docker or systemd required.
- Works offline once copied.
- Preserves exact versions of models and Ollama server.

---

## HOW TO USE ON ANOTHER MACHINE (Generic Linux)

> **IMPORTANT:** Replace `/path/to/ollama-kit-v1.1` with the **actual path** where you put the kit.

1. Install Podman and Python 3 (with Tkinter) on the new machine:
   ```bash
   sudo apt update
   sudo apt install -y podman python3 python3-venv python3-tk
   ```

2. Copy the `ollama-kit-v1.1` folder to your preferred location.

3. Load the container image (if included as `.tar`):
   ```bash
   cd /path/to/ollama-kit-v1.1/container
   podman load -i ollama_v0.11.4.tar
   ```

4. Start the container:
   ```bash
   podman run -d --name ollama -p 11434:11434 \
     -v "$HOME/.ollama:/root/.ollama" \
     --security-opt label=disable \
     docker.io/ollama/ollama:0.11.4
   ```

5. Run the Gramified GUI:
   ```bash
   python3 /path/to/ollama-kit-v1.1/bin/gramified_gui.py
   ```

---

## WSL (Windows Subsystem for Linux) Setup

Follow these steps if you’re running **Debian inside WSL on Windows**.

### 1) Identify your Windows drive and path
If the kit is on a USB drive or secondary disk, **note its drive letter in Windows Explorer** (e.g., `E:`).

In WSL, Windows drives may appear under `/mnt/<driveletter>` **if auto-mount is enabled**. Check:
```bash
ls /mnt
```
If you don’t see your drive letter, you’ll mount it manually in the next step.

### 2) Mount your drive in WSL
Replace `E` with **your actual drive letter**:
```bash
sudo mkdir -p /mnt/e
sudo mount -t drvfs E: /mnt/e
```
Verify:
```bash
ls -la /mnt/e
```
You should see the contents of the Windows drive.

### 3) Copy the kit into WSL
Replace `/mnt/e/path/to/ollama-kit-v1.1` with the **actual folder path on that drive**:
```bash
mkdir -p ~/ai-stack
cp -av /mnt/e/path/to/ollama-kit-v1.1 ~/ai-stack/
```
After this, the kit is at:
```
~/ai-stack/ollama-kit-v1.1
```

### 4) Install required packages in WSL
```bash
sudo apt update
sudo apt install -y podman python3 python3-venv python3-tk
```

### 5) Create and activate a Python virtual environment
```bash
python3 -m venv ~/.venvs/ollama-kit
source ~/.venvs/ollama-kit/bin/activate
pip install --upgrade pip
pip install -r ~/ai-stack/ollama-kit-v1.1/requirements.txt
```

### 6) Load and run the Ollama container
```bash
cd ~/ai-stack/ollama-kit-v1.1/container
podman load -i ollama_v0.11.4.tar
podman run -d --name ollama -p 11434:11434 \
  -v "$PWD/../models:/root/.ollama" \
  --security-opt label=disable \
  docker.io/ollama/ollama:0.11.4
```

### 7) Launch the Gramified GUI
```bash
cd ~/ai-stack/ollama-kit-v1.1
source ~/.venvs/ollama-kit/bin/activate
python bin/gramified_gui.py
```

---

## One-Command Startup (Optional)

Once you’ve completed the initial setup, you can start Ollama + the GUI with a single command using `launch.sh`.

### Create the script
Inside `ollama-kit-v1.1`:
```bash
nano launch.sh
```
Paste:
```bash
#!/bin/bash
# Start Ollama container if not running
if ! podman ps --format '{{.Names}}' | grep -q '^ollama$'; then
  echo "Starting Ollama container..."
  podman start ollama >/dev/null 2>&1 || podman run -d --name ollama -p 11434:11434 \
    -v "$PWD/models:/root/.ollama" \
    --security-opt label=disable \
    docker.io/ollama/ollama:0.11.4
fi

# Activate venv and launch GUI
source ~/.venvs/ollama-kit/bin/activate
python bin/gramified_gui.py
```

Make it executable:
```bash
chmod +x launch.sh
```

Run it anytime:
```bash
cd ~/ai-stack/ollama-kit-v1.1
./launch.sh
```

---

## NOTES

* **Always verify paths** — replace `/mnt/e` and `/path/to/ollama-kit-v1.1` with your actual locations.
* Models are stored in the `models` folder inside the kit – no internet needed unless adding more models.
* To update Ollama inside the container:
  ```bash
  podman pull docker.io/ollama/ollama:<version>
  ```
  (then restart the container)
* If a model isn't showing up in the GUI, check `AVAILABLE_MODELS` in `bin/gramified_gui.py`.

---

## Windows One-Click Launch (Optional)

**Assumes** you completed the WSL setup and created `launch.sh`.

### Finding Your WSL Path
In your **Debian WSL terminal**, go to the kit folder and print the path:
```bash
cd ~/ai-stack/ollama-kit-v1.1
pwd
```
Use the full path it prints (e.g., `/home/youruser/ai-stack/ollama-kit-v1.1`) in the PowerShell variable below.  
**Note:** WSL paths are case-sensitive.

### 1) Create `launch_ollama.ps1` anywhere on Windows
```powershell
# launch_ollama.ps1
# Edit $KitPathWSL to match the path printed by `pwd` in WSL.
$KitPathWSL = "/home/youruser/ai-stack/ollama-kit-v1.1"

Write-Host "Starting Ollama Kit in WSL (Debian) at $KitPathWSL ..."
wsl -d Debian bash -lc "cd $KitPathWSL && ./launch.sh"
```

### 2) Allow PowerShell scripts (once)
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

### 3) Run it
- Double-click `launch_ollama.ps1` in Explorer, **or**
- From PowerShell:
```powershell
.\launch_ollama.ps1
```
