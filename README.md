# update_ollama_and_host
Ollama script to update ollama and set Environment="OLLAMA_HOST=0.0.0.0" in service an fix EOF in Gemma3 models

[Service]
Environment="OLLAMA_HOST=0.0.0.0"
Environment="GGML_CUDA_ENABLE_UNIFIED_MEMORY=1"
LimitMEMLOCK=infinity
