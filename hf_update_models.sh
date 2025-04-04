#!/bin/bash

# Script to update only Hugging Face Ollama models

echo "Starting Hugging Face models update..."

# 1. Automatic update of Hugging Face models
echo "Searching for installed hf.co/ models..."
MODEL_COUNT=0
UPDATED_COUNT=0

for model in $(ollama list | awk '{print $1}' | grep "hf.co/"); do
    echo "----------------------------------------"
    echo "Downloading latest version of: $model"
    ((MODEL_COUNT++))
    
    ollama pull $model
    if [ $? -ne 0 ]; then
        echo "[ERROR] Update failed for: $model"
    else
        echo "[SUCCESS] Model updated: $model"
        ((UPDATED_COUNT++))
    fi
done

echo "----------------------------------------"
echo "Update summary:"
echo "Models found: $MODEL_COUNT"
echo "Models updated: $UPDATED_COUNT"

if [ $MODEL_COUNT -eq 0 ]; then
    echo "No hf.co/ models found."
elif [ $UPDATED_COUNT -lt $MODEL_COUNT ]; then
    echo "Warning: some models were not updated."
else
    echo "All models were successfully updated!"
fi