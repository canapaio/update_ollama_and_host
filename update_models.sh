#!/bin/bash

echo "Starting update of all models..."
echo "Searching for installed models..."
MODEL_COUNT=0
UPDATED_COUNT=0

for model in $(ollama list | awk '{print $1}' | grep -v "NAME"); do
    echo "----------------------------------------"
    echo "Checking model: $model"
    ((MODEL_COUNT++))
    
    # First check: model exists locally
    if ollama list | grep -q "^$model "; then
        # Second check: is it a local model?
        if ollama show "$model" 2>&1 | grep -q "local model"; then
            echo "[INFO] Local model - skipped: $model"
            ((UPDATED_COUNT++))
            continue
        fi
        
        # Attempt update
        echo "Downloading latest version of: $model"
        if ollama pull "$model"; then
            echo "[SUCCESS] Model updated: $model"
            ((UPDATED_COUNT++))
        else
            echo "[WARNING] Update failed for: $model"
            ((UPDATED_COUNT++))
        fi
    else
        echo "[WARNING] Model not found - skipped: $model"
        ((UPDATED_COUNT++))
    fi
done

echo "----------------------------------------"
echo "Update summary:"
echo "Models found: $MODEL_COUNT"
echo "Models updated: $UPDATED_COUNT"

if [ $MODEL_COUNT -eq 0 ]; then
    echo "No models found."
elif [ $UPDATED_COUNT -lt $MODEL_COUNT ]; then
    echo "Warning: some models were not updated."
else
    echo "All models were successfully updated!"
fi