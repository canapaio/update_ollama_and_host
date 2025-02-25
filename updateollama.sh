#!/bin/bash

# Script per aggiornare Ollama e configurarlo

# 1. Definizione del percorso del backup dinamico basato sullo script corrente
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
BACKUP_DIR="$SCRIPT_DIR/backup_ollama_service"

# 2. Crea la sottocartella di backup se non esiste
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "Errore: Impossibile creare la cartella di backup."
        exit 1
    fi
fi

# 3. Backup della configurazione del servizio ollama con data/ora inclusa nel nome del file
echo "Backup della configurazione del servizio ollama..."
FILE_NAME="ollama.service.$(date +'%Y%m%d_%H%M%S').bak"
sudo cp /etc/systemd/system/ollama.service "$BACKUP_DIR/$FILE_NAME"
if [ $? -ne 0 ]; then
    echo "Errore: Impossibile effettuare il backup del file di configurazione."
    exit 1
else
    echo "Backup completato: $BACKUP_DIR/$FILE_NAME"
fi

# 4. Scarica l'aggiornamento di Ollama tramite curl e eseguilo
echo "Aggiornamento di Ollama in corso..."
curl -fsSL https://ollama.com/install.sh | sh
if [ $? -ne 0 ]; then
    echo "Errore: Impossibile aggiornare Ollama."
    exit 1
fi

# 5. Modifica il file di configurazione del servizio ollama
echo "Modifica del file di configurazione per impostare l'indirizzo host su 0.0.0.0..."
CONFIG_FILE="/etc/systemd/system/ollama.service"

# Controlla se il file esiste
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Errore: Il file $CONFIG_FILE non esiste."
    exit 1
fi

# Controlla se Environment="OLLAMA_HOST=0.0.0.0" è già presente nel file
if grep -q "Environment=\"OLLAMA_HOST=0.0.0.0\"" "$CONFIG_FILE"; then
    echo "Environment='OLLAMA_HOST=0.0.0.0' è già presente nel file di configurazione."
else
    # Aggiungi o modifica la riga Environment
    sudo sed -i '/^\[Service\]/a Environment="OLLAMA_HOST=0.0.0.0"' "$CONFIG_FILE"
    if [ $? -ne 0 ]; then
        echo "Errore: Impossibile modificare il file di configurazione."
        exit 1
    else
        echo "Configurazione aggiornata con successo."
    fi
fi

# 6. Riavvia il servizio ollama
echo "Riavvio del servizio ollama..."
sudo systemctl daemon-reload
if [ $? -ne 0 ]; then
    echo "Errore: Impossibile ricaricare i demoni di systemd."
    exit 1
fi

sudo systemctl restart ollama
if [ $? -ne 0 ]; then
    echo "Errore: Impossibile riavviare il servizio ollama."
    exit 1
fi

# 7. Verifica dello stato del servizio
echo "Verifica dello stato del servizio ollama..."
sudo systemctl status ollama --no-pager
if [ $? -ne 0 ]; then
    echo "Attenzione: Lo stato del servizio ollama non è attivo."
else
    echo "Servizio ollama avviato correttamente."
fi

echo "Procedura di aggiornamento e configurazione completata con successo!"
