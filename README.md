# ⚠️ IMPORTANT WARNING ⚠️
**THESE SCRIPTS MAKE SYSTEM-LEVEL CHANGES. USE AT YOUR OWN RISK!**
- These scripts modify Ollama service configuration and model files in *UBUNTU 22.04*
- Always back up important data before running
- Only use if you understand what these scripts do
- The authors are not responsible for any issues caused by these scripts

# Ollama Update and Configuration Scripts

This repository contains scripts to manage Ollama updates and model configurations.

## Scripts Overview

### 1. updateollama.sh
- **Purpose**: Updates Ollama and configures the service
- **Features**:
  - Creates backup of current configuration
  - Downloads and installs latest Ollama version
  - Configures service with:
    ```ini
    [Service]
    Environment="OLLAMA_HOST=0.0.0.0"
    Environment="GGML_CUDA_ENABLE_UNIFIED_MEMORY=1"
    LimitMEMLOCK=infinity
    ```
  - Restarts the Ollama service
- **Usage**:
  ```bash
  ./updateollama.sh
  ```

### 2. update_models.sh
- **Purpose**: Updates all installed Ollama models
- **Features**:
  - Automatically detects all installed models
  - Skips local models that can't be updated
  - Provides detailed progress for each model
  - Gives a summary of successful/failed updates
- **Usage**:
  ```bash
  ./update_models.sh
  ```

### 3. hf_update_models.sh
- **Purpose**: Updates only Hugging Face models (hf.co/)
- **Features**:
  - Specifically targets Hugging Face hosted models
  - Automatically filters for hf.co/ models
  - Provides clear status messages for each model
  - Outputs comprehensive update summary
- **Usage**:
  ```bash
  ./hf_update_models.sh
  ```

## Recommended Workflow
1. First run `updateollama.sh` to update the core service
2. Then run either:
   - `update_models.sh` to update all models
   - `hf_update_models.sh` to update only Hugging Face models

## Setup Instructions
Before first use, make the scripts executable:
```bash
chmod +x updateollama.sh update_models.sh hf_update_models.sh
```
