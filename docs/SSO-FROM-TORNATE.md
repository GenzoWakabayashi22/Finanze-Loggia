# 🔐 SSO da Tornate - Documentazione Completa

## 📋 Indice

1. [Panoramica](#panoramica)
2. [Architettura](#architettura)
3. [Flusso di Autenticazione](#flusso-di-autenticazione)
4. [Configurazione](#configurazione)
5. [Endpoint SSO](#endpoint-sso)
6. [Formato Token JWT](#formato-token-jwt)
7. [Gestione Errori](#gestione-errori)
8. [Testing](#testing)
9. [Sicurezza](#sicurezza)
10. [Troubleshooting](#troubleshooting)

---

## 🎯 Panoramica

Il sistema SSO (Single Sign-On) permette agli utenti autenticati su **Tornate** di accedere automaticamente a **Finanze-Loggia** senza dover inserire nuovamente le credenziali.

### Caratteristiche

- ✅ Autenticazione tramite JWT (JSON Web Token)
- ✅ Verifica server-side del token
- ✅ Gestione sessioni con express-session
- ✅ Trasferimento sicuro dei ruoli (admin/user)
- ✅ Logging dettagliato di ogni tentativo SSO
- ✅ Gestione errori con messaggi user-friendly

---

## 🏗️ Architettura

```
┌─────────────┐                      ┌──────────────────┐                    ┌─────────────────┐
│   TORNATE   │                      │  FINANZE-LOGGIA  │                    │   USER BROWSER  │
│   (Source)  │                      │  (Destination)   │                    │                 │
└──────┬──────┘                      └────────┬─────────┘                    └────────┬────────┘
       │                                      │                                        │
       │ 1. User clicks "Finanze" 💰          │                                        │
       │────────────────────────────────────> │                                        │
       │                                      │                                        │
       │ 2. Genera JWT con dati utente       │                                        │
       │    - id, username, nome              │                                        │
       │    - role, admin_access              │                                        │
       │    - source: "tornate"               │                                        │
       │                                      │                                        │
       │ 3. Redirect con token                │                                        │
       │ https://finanze.../sso-login?token=xxx                                       │
       │──────────────────────────────────────┼────────────────────────────────────>  │
       │                                      │                                        │
       │                                      │ 4. GET /sso-login?token=xxx            │
       │                                      │ <──────────────────────────────────────│
       │                                      │                                        │
       │                                      │ 5. Verifica JWT signature              │
       │                                      │    - Secret match                      │
       │                                      │    - Token not expired                 │
       │                                      │    - Source = "tornate"                │
       │                                      │    - Payload valido                    │
       │                                      │                                        │
       │                                      │ 6. Crea sessione utente                │
       │                                      │    req.session.user = { ... }          │
       │                                      │                                        │
       │                                      │ 7. Redirect /dashboard                 │
       │                                      │ ────────────────────────────────────>  │
       │                                      │                                        │
       │                                      │ 8. Dashboard aperta con sessione attiva│
       │                                      │                                        │
```

---

## 🔄 Flusso di Autenticazione

### Step 1: Generazione Token (Tornate)

L'app Tornate genera un JWT contenente i dati dell'utente:

```javascript
const token = jwt.sign({
    id: user.id,
    username: user.username,
    nome: user.nome,
    role: user.role,
    admin_access: user.admin_access,
    grado: user.grado,
    source: 'tornate'
}, process.env.FINANZE_JWT_SECRET, {
    expiresIn: '5m' // Token valido 5 minuti
});
```

### Step 2: Redirect a Finanze

```javascript
const finanze_url = `https://finanze.loggiakilwinning.com/sso-login?token=${token}`;
window.location.href = finanze_url;
```

### Step 3: Verifica Token (Finanze)

Il server Finanze riceve la richiesta GET `/sso-login?token=xxx` e:

1. **Estrae il token** dal query parameter
2. **Verifica la firma JWT** usando `FINANZE_JWT_SECRET`
3. **Valida il payload**:
   - `source` deve essere "tornate"
   - `id`, `username`, `nome` devono esistere
4. **Crea la sessione** se tutto è OK
5. **Redirect a `/dashboard`**

### Step 4: Sessione Attiva

L'utente viene automaticamente loggato con una sessione valida per 24 ore.

---

## ⚙️ Configurazione

### 1. Variabili d'Ambiente (.env)

**IMPORTANTE:** Il secret JWT deve essere **IDENTICO** in entrambe le applicazioni!

#### Tornate (.env)
```env
FINANZE_JWT_SECRET=kilwinning_finanze_secret_key_2025_super_secure
```

#### Finanze (.env)
```env
FINANZE_JWT_SECRET=kilwinning_finanze_secret_key_2025_super_secure
SESSION_SECRET=kilwinning_session_secret_2025
```

### 2. Pannello Netsons

Assicurati di configurare le variabili d'ambiente anche nel pannello di hosting:

**Tornate:**
- `FINANZE_JWT_SECRET` = `kilwinning_finanze_secret_key_2025_super_secure`

**Finanze:**
- `FINANZE_JWT_SECRET` = `kilwinning_finanze_secret_key_2025_super_secure`
- `SESSION_SECRET` = `kilwinning_session_secret_2025`

### 3. Dipendenze

Assicurati che siano installate:

```bash
npm install jsonwebtoken express-session
```

---

## 🔗 Endpoint SSO

### `GET /sso-login`

Endpoint che gestisce l'autenticazione SSO.

#### Query Parameters

| Parametro | Tipo   | Obbligatorio | Descrizione                    |
|-----------|--------|--------------|--------------------------------|
| `token`   | string | ✅ Sì        | JWT token generato da Tornate  |

#### Esempio Request

```
GET /sso-login?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Risposte

##### ✅ Success (302 Redirect)

Se il token è valido:
```
HTTP/1.1 302 Found
Location: /dashboard
Set-Cookie: connect.sid=...
```

##### ❌ Error (302 Redirect)

In caso di errore, redirect alla login page con parametro error:

```
HTTP/1.1 302 Found
Location: /login?error=invalid_token
```

#### Codici Errore

| Codice            | Descrizione                                      |
|-------------------|--------------------------------------------------|
| `token_missing`   | Token non presente nell'URL                      |
| `invalid_token`   | Token scaduto, malformato o signature invalida   |
| `invalid_source`  | Il campo `source` non è "tornate"                |
| `invalid_payload` | Campi obbligatori mancanti nel payload           |
| `session_error`   | Errore nella creazione della sessione            |
| `server_error`    | Errore generico del server                       |

---

## 📦 Formato Token JWT

### Payload Obbligatorio

```json
{
  "id": 1,
  "username": "paolo.giulio.gazzano",
  "nome": "Paolo Giulio Gazzano",
  "role": "admin",
  "admin_access": true,
  "grado": "Maestro Venerabile",
  "source": "tornate",
  "iat": 1699999999,
  "exp": 1700000299
}
```

### Campi

| Campo          | Tipo    | Obbligatorio | Descrizione                              |
|----------------|---------|--------------|------------------------------------------|
| `id`           | number  | ✅ Sì        | ID univoco utente                        |
| `username`     | string  | ✅ Sì        | Username utente                          |
| `nome`         | string  | ✅ Sì        | Nome completo utente                     |
| `role`         | string  | ❌ No        | Ruolo ("admin" o "user"), default: "user"|
| `admin_access` | boolean | ❌ No        | Ha accesso admin, default: false         |
| `grado`        | string  | ❌ No        | Grado massonico                          |
| `source`       | string  | ✅ Sì        | Deve essere "tornate"                    |
| `iat`          | number  | ✅ Sì        | Timestamp emissione (auto)               |
| `exp`          | number  | ✅ Sì        | Timestamp scadenza (auto)                |

### Sessione Creata

Dopo la verifica, viene creata questa sessione:

```javascript
req.session.user = {
    id: decoded.id,
    username: decoded.username,
    nome: decoded.nome,
    role: decoded.role || 'user',
    admin_access: decoded.admin_access || false,
    grado: decoded.grado,
    sso_login: true,
    sso_source: 'tornate',
    loginTime: new Date().toISOString(),
    lastActivity: new Date().toISOString()
}
```

---

## ⚠️ Gestione Errori

### Frontend (index.html)

Quando l'URL contiene un parametro `error`, viene mostrato un messaggio all'utente:

```javascript
const errorMessages = {
    'token_missing': 'Token SSO mancante. Effettua login manuale.',
    'invalid_token': 'Token SSO scaduto o invalido. Effettua login manuale.',
    'invalid_source': 'Token SSO non valido. Effettua login manuale.',
    'invalid_payload': 'Dati SSO incompleti. Effettua login manuale.',
    'session_error': 'Errore creazione sessione. Riprova.',
    'server_error': 'Errore del server. Riprova più tardi.'
};
```

Il messaggio viene mostrato per 5 secondi, poi l'URL viene pulito.

### Backend Logging

Ogni tentativo SSO viene loggato:

```
✅ Log Success:
🔗 [SSO] Richiesta SSO login da Tornate
✅ [SSO] Login successful: Paolo Giulio Gazzano (paolo.giulio.gazzano) [ADMIN]

❌ Log Error:
🔗 [SSO] Richiesta SSO login da Tornate
❌ [SSO] Token invalido: jwt expired
```

---

## 🧪 Testing

### Test 1: Login Admin (Paolo)

1. Vai su `https://tornate.loggiakilwinning.com`
2. Login con:
   - Username: `paolo.giulio.gazzano`
   - Password: `paologiuliogazzano`
3. Apri Console (F12)
4. Verifica log Tornate:
   ```
   👑 Login ADMIN: Paolo Giulio Gazzano
   🔗 [SSO FINANZE] Richiesta token per: Paolo Giulio Gazzano
   ✅ [SSO FINANZE] Token generato
   ```
5. Click su **Finanze** 💰
6. Redirect automatico a Finanze
7. Verifica log Finanze (console server):
   ```
   🔗 [SSO] Richiesta SSO login da Tornate
   ✅ [SSO] Login successful: Paolo Giulio Gazzano (paolo.giulio.gazzano) [ADMIN]
   ```
8. Dashboard Finanze con funzionalità admin visibili

### Test 2: Login User (Davide)

1. Login su Tornate con:
   - Username: `davide.santori`
   - Password: `davidesantori`
2. Console Tornate:
   ```
   👤 Login USER: Davide Santori
   ```
3. Click su **Finanze**
4. Verifica log Finanze:
   ```
   ✅ [SSO] Login successful: Davide Santori (davide.santori) [USER]
   ```
5. Dashboard Finanze **senza** funzionalità admin

### Test 3: Token Invalido

1. Prova ad accedere manualmente:
   ```
   https://finanze.loggiakilwinning.com/sso-login?token=invalid_token_123
   ```
2. Verifica redirect a login con errore:
   ```
   /login?error=invalid_token
   ```
3. Messaggio mostrato:
   ```
   ⚠️ Errore SSO: Token SSO scaduto o invalido. Effettua login manuale.
   ```

### Test 4: Token Scaduto

1. Genera un token da Tornate
2. Aspetta 6 minuti (token valido 5 minuti)
3. Prova ad usare il token
4. Verifica errore `invalid_token`

---

## 🔒 Sicurezza

### Misure Implementate

1. **Token JWT Firmato**
   - Signature con HMAC SHA-256
   - Secret condiviso solo tra Tornate e Finanze
   - Impossibile falsificare senza il secret

2. **Durata Limitata**
   - Token valido solo 5 minuti
   - Riduce finestra di vulnerabilità se intercettato

3. **Verifica Source**
   - Campo `source` deve essere "tornate"
   - Previene token da altre fonti

4. **Validazione Payload**
   - Campi obbligatori verificati
   - Prevenzione injection

5. **Sessione Sicura**
   - Cookie httpOnly (in produzione con `secure: true`)
   - Sessione valida 24 ore
   - Secret separato per le sessioni

6. **Logging Completo**
   - Tutti i tentativi loggati
   - Monitoraggio tentativi falliti
   - Audit trail completo

### Best Practices

✅ **DO:**
- Usa HTTPS in produzione (obbligatorio)
- Ruota i secret periodicamente
- Monitora i log per tentativi sospetti
- Mantieni i secret fuori dal repository (usa .env)

❌ **DON'T:**
- Non committare i secret nel repository
- Non aumentare la durata del token oltre 5 minuti
- Non rimuovere le validazioni

---

## 🔧 Troubleshooting

### Problema: "Token SSO invalido"

**Causa:** Secret diversi tra Tornate e Finanze

**Soluzione:**
1. Verifica `.env` in Tornate:
   ```bash
   cat .env | grep FINANZE_JWT_SECRET
   ```
2. Verifica `.env` in Finanze:
   ```bash
   cat .env | grep FINANZE_JWT_SECRET
   ```
3. Assicurati che siano **identici**
4. Riavvia entrambe le applicazioni

### Problema: "Token scaduto"

**Causa:** Token generato più di 5 minuti fa

**Soluzione:**
- Effettua nuovo login su Tornate
- Click subito su Finanze
- Non aspettare più di 5 minuti

### Problema: "Errore creazione sessione"

**Causa:** express-session non configurato correttamente

**Soluzione:**
1. Verifica che express-session sia installato:
   ```bash
   npm list express-session
   ```
2. Verifica configurazione in `server.js`:
   ```javascript
   app.use(session({ ... }))
   ```
3. Riavvia il server

### Problema: Redirect loop

**Causa:** Route `/dashboard` non gestito correttamente

**Soluzione:**
- Verifica che il route catch-all sia alla fine:
  ```javascript
  app.get('*', (req, res) => {
      res.sendFile(path.join(__dirname, 'index.html'));
  });
  ```

### Verifica Logs

**Tornate:**
```bash
pm2 logs tornate --lines 50
```

**Finanze:**
```bash
pm2 logs finanze --lines 50
```

---

## 📝 Changelog

### Version 1.0.0 (2025-11-18)

- ✅ Implementazione endpoint `/sso-login`
- ✅ Verifica JWT server-side
- ✅ Gestione sessioni con express-session
- ✅ Gestione errori con redirect e messaggi user-friendly
- ✅ Logging completo di tutti i tentativi SSO
- ✅ Documentazione completa

---

## 🤝 Support

Per problemi o domande:

1. Verifica questa documentazione
2. Controlla i log di entrambe le applicazioni
3. Verifica che i secret siano identici
4. Verifica che le dipendenze siano installate

---

## 📚 Riferimenti

- [JWT.io](https://jwt.io/) - JWT Debugger
- [Express Session](https://github.com/expressjs/session) - Session middleware
- [jsonwebtoken](https://github.com/auth0/node-jsonwebtoken) - JWT library

---

**Ultima modifica:** 18 Novembre 2025
**Versione:** 1.0.0
**Autore:** Sistema Finanze Loggia Kilwinning
