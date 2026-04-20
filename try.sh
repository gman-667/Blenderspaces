#!/bin/bash

# 1. Install dependencies (only if missing)
sudo apt-get update
sudo apt-get install -y x11vnc xvfb fluxbox blender python3-pip

# 2. Setup noVNC
if [ ! -d "$HOME/noVNC" ]; then
    git clone https://github.com/novnc/noVNC.git $HOME/noVNC
fi

# 3. Cleanup any old sessions to prevent "Port in use" errors
echo "Cleaning up old sessions..."
pkill -f Xvfb
pkill -f x11vnc
pkill -f novnc

# 4. Start the Virtual Display
echo "Starting Virtual Display on :1..."
Xvfb :1 -screen 0 1280x720x24 &
export DISPLAY=:1

# Give Xvfb 2 seconds to initialize before connecting VNC
sleep 2

# 5. Start the Window Manager
echo "Starting Window Manager..."
fluxbox &

# 6. Start the VNC Server
echo "Starting VNC Server..."
x11vnc -display :1 -nopw -forever -bg

# 7. Start noVNC bridge on port 6080
echo "Starting noVNC Bridge..."
$HOME/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &

# 8. Launch Blender
echo "---"
echo "Blender is starting. Open the 'Ports' tab and click the globe icon for 6080."
echo "---"
blender
