#!/bin/bash

# Script to update and configure Ollama

# 1. Define dynamic backup path based on current script location
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
BACKUP_DIR="$SCRIPT_DIR/backup_ollama_service"

# 2. Create backup subfolder if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Unable to create backup folder."
        exit 1
    fi
fi

# 3. Backup ollama service configuration with timestamp in filename
echo "Backing up ollama service configuration..."
FILE_NAME="ollama.service.$(date +'%Y%m%d_%H%M%S').bak"
sudo cp /etc/systemd/system/ollama.service "$BACKUP_DIR/$FILE_NAME"
if [ $? -ne 0 ]; then
    echo "Error: Unable to backup configuration file."
    exit 1
else
    echo "Backup completed: $BACKUP_DIR/$FILE_NAME"
fi

# 4. Download and execute Ollama update via curl
echo "Updating Ollama..."
curl -fsSL https://ollama.com/install.sh | sh
if [ $? -ne 0 ]; then
    echo "Error: Unable to update Ollama."
    exit 1
fi

# 5. Modify ollama service configuration file
echo "Modifying configuration file to set host address to 0.0.0.0..."
CONFIG_FILE="/etc/systemd/system/ollama.service"
AMD_FILE="$SCRIPT_DIR/amd.txt"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: File $CONFIG_FILE does not exist."
    exit 1
fi

if [ ! -f "$AMD_FILE" ]; then
    echo "Error: File $AMD_FILE does not exist."
    exit 1
fi

while IFS= read -r line || [ -n "$line" ]; do
    if [ -n "$line" ] && ! grep -qF "$line" "$CONFIG_FILE"; then
        sudo sed -i '/\[Service\]/a '"$line"'' "$CONFIG_FILE"
        echo "Added: $line"
    fi
done < "$AMD_FILE"

# 6. Restart ollama service
echo "Restarting ollama service..."
sudo systemctl daemon-reload
if [ $? -ne 0 ]; then
    echo "Error: Unable to reload systemd daemons."
    exit 1
fi

sudo systemctl restart ollama
if [ $? -ne 0 ]; then
    echo "Error: Unable to restart ollama service."
    exit 1
fi

# 7. Verify service status
echo "Checking ollama service status..."
sudo systemctl status ollama --no-pager
if [ $? -ne 0 ]; then
    echo "Warning: Ollama service status is not active."
else
    echo "Ollama service started successfully."
fi

# 8. Append custom file if provided as argument
if [ -n "$1" ]; then
    if [ ! -f "$1" ]; then
        echo "Error: File $1 does not exist."
        exit 1
    fi
    
    EXTENSION="${1##*.}"
    if [ "$EXTENSION" != "txt" ]; then
        echo "Error: Only .txt files are allowed."
        exit 1
    fi
    
    echo "Appending custom file: $1"
    while IFS= read -r line || [ -n "$line" ]; do
        if [ -n "$line" ] && ! grep -qF "$line" "$CONFIG_FILE"; then
            sudo sed -i '/\[Service\]/a '"$line"'' "$CONFIG_FILE"
            echo "Added: $line"
        fi
    done < "$1"
fi

echo "Update and configuration procedure completed successfully!"

