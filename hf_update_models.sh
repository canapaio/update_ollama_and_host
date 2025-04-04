#!/bin/bash

# Script per aggiornare solo i modelli Ollama da Hugging Face

echo "Avvio aggiornamento modelli da Hugging Face..."

# 1. Aggiornamento automatico dei modelli da Hugging Face
echo "Ricerca modelli hf.co/ installati..."
MODEL_COUNT=0
UPDATED_COUNT=0

for model in $(ollama list | awk '{print $1}' | grep "hf.co/"); do
    echo "----------------------------------------"
    echo "Download ultima versione di: $model"
    ((MODEL_COUNT++))
    
    ollama pull $model
    if [ $? -ne 0 ]; then
        echo "[ERRORE] Aggiornamento fallito per: $model"
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
    echo "Nessun modello hf.co/ trovato."
elif [ $UPDATED_COUNT -lt $MODEL_COUNT ]; then
    echo "Attenzione: alcuni modelli non sono stati aggiornati."
else
    echo "Tutti i modelli sono stati aggiornati con successo!"
fi