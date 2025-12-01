# Deploy Instructions

Istruzioni per il deploy del sistema Finanze Associazione.

## Prerequisiti

- Node.js v14+ (attualmente v22.18.0 ✅)
- npm installato
- Accesso al server di produzione

## Steps per il deploy

### 1. Pull del codice aggiornato

```bash
cd /home/jmvvznbb/finanze
git pull origin main
```

### 2. Installa dipendenze

```bash
npm install
```

### 3. Configura variabili ambiente (se necessario)

Crea un file `.env` con le seguenti variabili:

```
DB_HOST=localhost
DB_USER=jmvvznbb_finanze_user
DB_PASSWORD=Puntorosso22
DB_NAME=jmvvznbb_finanze_db
JWT_SECRET=your-secret-key
FINANZE_JWT_SECRET=kilwinning_finanze_secret_key_2025_super_secure
SESSION_SECRET=kilwinning_session_secret_2025
NODE_ENV=production
```

### 4. Riavvia il server

Se usi **PM2**:
```bash
pm2 restart finanze
```

Se usi **systemd**:
```bash
sudo systemctl restart finanze
```

Oppure riavvia **manualmente**:
```bash
pkill -f "node.*server.js"
node server.js &
```

### 5. Verifica che funzioni

- Testa l'accesso al sito
- Controlla i log per errori:
  ```bash
  tail -f /path/to/stderr.log
  ```

## Troubleshooting

### Errore 503

Se ricevi un errore 503, verifica:

1. **Il server Node.js è in esecuzione?**
   ```bash
   pgrep -f "node.*server.js"
   ```

2. **Controlla i log degli errori**
   ```bash
   cat stderr.log
   ```

3. **Verifica la sintassi del codice**
   ```bash
   node --check server.js
   ```

4. **Assicurati che la versione di server.js sia aggiornata**
   ```bash
   git status
   git pull origin main
   ```

### Database non raggiungibile

1. Verifica che MySQL sia in esecuzione
2. Controlla le credenziali nel file `.env` o in `server.js`
3. Testa la connessione:
   ```bash
   mysql -u jmvvznbb_finanze_user -p jmvvznbb_finanze_db
   ```

## Scripts disponibili

```bash
# Avvia il server in produzione
npm start

# Avvia il server in sviluppo (con auto-reload)
npm run dev

# Testa la connessione al database
npm run test-db
```

## Note importanti

- Il middleware `requireAdmin` è definito nel file `server.js` (righe 71-76)
- Il middleware `authenticateToken` supporta sia JWT classico che SSO da Tornate
- I file `.log` sono esclusi dal repository (vedi `.gitignore`)
- Il file `.env` contiene credenziali sensibili e NON deve essere committato
