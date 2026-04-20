#!/bin/bash

# 1. Update and install display dependencies
sudo apt-get update
sudo apt-get install -y x11vnc xvfb fluxbox blender python3-pip

# 2. Install noVNC and websockify (to bridge VNC to the browser)
pip install websockify

# Clone noVNC if not already present
if [ ! -d "$HOME/noVNC" ]; then
    git clone https://github.com/novnc/noVNC.git $HOME/noVNC
fi

# 3. Start the Virtual Display (Screen 0)
# This creates a "fake" monitor in the cloud
Xvfb :1 -screen 0 1280x720x24 &
export DISPLAY=:1

# 4. Start a lightweight Window Manager
# Without this, you can't move or resize the Blender window
fluxbox &

# 5. Start the VNC Server
# This shares the virtual screen via the VNC protocol
x11vnc -display :1 -nopw -forever -bg

# 6. Start noVNC bridge on port 6080
# This makes the VNC stream accessible via a web browser
$HOME/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &

# 7. Launch Blender
echo "Starting Blender... Access it via the Ports tab on port 6080"
blender
