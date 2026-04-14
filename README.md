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

### 2. updatefile.sh
- **Purpose**: Like `updateollama.sh` but with customizable `[Server]` section
- **Features**:
  - Creates backup of current configuration
  - Downloads and installs latest Ollama version
  - Adds a `[Server]` section populated with `amd.txt` content:
    ```ini
    [Service]
    [Server]
    Environment="HSA_OVERRIDE_GFX_VERSION=11.5.1"
    Environment="OLLAMA_FLASH_ATTENTION=1"
    Environment="OLLAMA_HOST=0.0.0.0"
    Environment="OLLAMA_NUM_PARALLEL=1"
    Environment="ROCM_PATH=/opt/rocm"
    Environment="LD_LIBRARY_PATH=/opt/rocm/lib:/opt/rocm/llvm/lib:$LD_LIBRARY_PATH"
    Environment="HIP_VISIBLE_DEVICES=0"
    ```
  - Accepts a custom `.txt` file as argument to append additional settings
  - Restarts the Ollama service
- **Usage**:
  ```bash
  ./updatefile.sh              # uses default amd.txt
  ./updatefile.sh custom.txt   # appends custom.txt content
  ```

### 3. update_models.sh
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

### 4. hf_update_models.sh
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
1. First run `updateollama.sh` or `updatefile.sh` to update the core service
2. Then run either:
   - `update_models.sh` to update all models
   - `hf_update_models.sh` to update only Hugging Face models

## Setup Instructions
Before first use, make the scripts executable:
```bash
chmod +x updateollama.sh update_models.sh hf_update_models.sh
```
