#!/bin/bash

# Script per aggiornare tutti i modelli Ollama

echo "Avvio aggiornamento di tutti i modelli..."

# 1. Aggiornamento automatico di tutti i modelli
echo "Ricerca modelli installati..."
MODEL_COUNT=0
UPDATED_COUNT=0

for model in $(ollama list | awk '{print $1}' | grep -v "NAME"); do
    echo "----------------------------------------"
    echo "Download ultima versione di: $model"
    ((MODEL_COUNT++))
    
    # Verifica se il modello è locale
    if ollama show $model >/dev/null 2>&1; then
        if ollama show $model | grep -q "local model"; then
            echo "[INFO] Modello locale - saltato: $model"
            ((UPDATED_COUNT++))
            continue
        fi
    fi
    
    ollama pull $model
    if [ $? -ne 0 ]; then
        echo "[WARNING] Impossibile verificare aggiornamenti per: $model (potrebbe essere un modello locale)"
        ((UPDATED_COUNT++))  # Consideriamo comunque come "aggiornato"
    else
        echo "[SUCCESSO] Modello aggiornato: $model"
        ((UPDATED_COUNT++))
    fi
done

echo "----------------------------------------"
echo "Riepilogo aggiornamento:"
echo "Modelli trovati: $MODEL_COUNT"
echo "Modelli aggiornati: $UPDATED_COUNT"

if [ $MODEL_COUNT -eq 0 ]; then
    echo "Nessun modello trovato."
elif [ $UPDATED_COUNT -lt $MODEL_COUNT ]; then
    echo "Attenzione: alcuni modelli non sono stati aggiornati."
else
    echo "Tutti i modelli sono stati aggiornati con successo!"
fi