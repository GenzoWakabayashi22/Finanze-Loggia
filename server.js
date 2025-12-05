const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const session = require('express-session');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('.'));

// Configurazione sessioni per SSO
app.use(session({
  secret: process.env.SESSION_SECRET || 'kilwinning_session_secret_2025',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production',
    maxAge: 24 * 60 * 60 * 1000 // 24 ore
  }
}));

// Configurazione database - usa le tue credenziali
const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'jmvvznbb_finanze_user',
  password: process.env.DB_PASSWORD || 'Puntorosso22',
  database: process.env.DB_NAME || 'jmvvznbb_finanze_db',
  multipleStatements: true
};

// Pool di connessioni
const pool = mysql.createPool(dbConfig);

// JWT Secret
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-this-in-production';

// Middleware autenticazione - VERSIONE CORRETTA
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token richiesto' });
  }

  // Prova prima con JWT_SECRET (login classico)
  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (!err) {
      req.user = user;
      return next();
    }
    
    // Se fallisce, prova con FINANZE_JWT_SECRET (SSO da Tornate)
    jwt.verify(token, process.env.FINANZE_JWT_SECRET || 'kilwinning_finanze_secret_key_2025_super_secure', (err2, user2) => {
      if (err2) {
        return res.status(403).json({ error: 'Token non valido' });
      }
      req.user = user2;
      next();
    });
  });
};

// Ruoli con permessi di amministrazione
const ADMIN_ROLES = ['admin', 'tesoriere'];

// Middleware: solo admin o tesoriere possono modificare/cancellare dati
const requireAdmin = (req, res, next) => {
  if (!ADMIN_ROLES.includes(req.user.role)) {
    return res.status(403).json({ error: 'Permesso negato: solo l\'admin o il tesoriere possono modificare o cancellare.' });
  }
  next();
};

// === AUTHENTICATION ROUTES ===

// Login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { username, password } = req.body;
    
    console.log('Tentativo login per:', username);
    
    const [users] = await pool.execute(
      'SELECT id, username, password_hash, role FROM users WHERE username = ?',
      [username]
    );

    if (users.length === 0) {
      console.log('Utente non trovato');
      return res.status(401).json({ error: 'Credenziali non valide' });
    }

    const user = users[0];
    console.log('Utente trovato:', user.username, 'Ruolo:', user.role);
    
    // Gestione password con confronto diretto
    let validPassword = false;
    
    // Confronto diretto con il valore nel database 
    if (password === user.password_hash) {
      validPassword = true;
    } 
    // Mantieni anche i vecchi fallback
    else if (username === 'admin' && password === 'admin123') {
      validPassword = true;
    }
    else if (username === 'Tesoriere' && password === 'tesoriere2025') {
      validPassword = true;
    }
    // Tenta anche bcrypt come fallback in caso qualcuno abbia password hashate
    else {
      try {
        // Rimuovi caratteri di ritorno a capo
        const cleanHash = user.password_hash.replace(/[\r\n]/g, '');
        validPassword = await bcrypt.compare(password, cleanHash);
      } catch (bcryptError) {
        console.log('Errore bcrypt, password non valida');
        validPassword = false;
      }
    }

    if (!validPassword) {
      console.log('Password non valida per:', username);
      return res.status(401).json({ error: 'Credenziali non valide' });
    }

    const token = jwt.sign(
      { id: user.id, username: user.username, role: user.role },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    console.log('Login riuscito per:', username, 'con ruolo:', user.role);
    res.json({
      message: 'Login effettuato',
      token,
      user: { id: user.id, username: user.username, role: user.role }
    });
  } catch (error) {
    console.error('Errore login:', error);
    res.status(500).json({ error: 'Errore server durante il login' });
  }
});
// Verifica token
app.get('/api/auth/verify', authenticateToken, (req, res) => {
  res.json({ valid: true, user: req.user });
});

// ============================================
// SSO Login da Tornate
// ============================================
app.get('/sso-login', async (req, res) => {
    try {
        const token = req.query.token;

        console.log('🔗 [SSO] Richiesta SSO login da Tornate');

        if (!token) {
            console.log('❌ [SSO] Token mancante');
            return res.redirect('/login?error=token_missing');
        }

        // Verifica JWT
        let decoded;
        try {
            decoded = jwt.verify(
                token,
                process.env.FINANZE_JWT_SECRET || 'kilwinning_finanze_secret_key_2025_super_secure'
            );
        } catch (jwtError) {
            console.log('❌ [SSO] Token invalido:', jwtError.message);
            return res.redirect('/login?error=invalid_token');
        }

        // Valida source
        if (decoded.source !== 'tornate') {
            console.log('❌ [SSO] Source invalida:', decoded.source);
            return res.redirect('/login?error=invalid_source');
        }

        // Valida campi obbligatori
        if (!decoded.id || !decoded.username || !decoded.nome) {
            console.log('❌ [SSO] Payload incompleto');
            return res.redirect('/login?error=invalid_payload');
        }

        // Crea sessione utente
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
        };

        console.log('✅ [SSO] Login successful:', decoded.nome,
                    `(${decoded.username})`,
                    decoded.admin_access ? '[ADMIN]' : '[USER]');

        // Salva sessione e redirect
        req.session.save((err) => {
            if (err) {
                console.error('❌ [SSO] Errore salvataggio sessione:', err);
                return res.redirect('/login?error=session_error');
            }

            // Redirect alla dashboard
            res.redirect('/dashboard');
        });

    } catch (error) {
        console.error('❌ [SSO] Errore generale:', error);
        res.redirect('/login?error=server_error');
    }
});

// === CATEGORIE ROUTES ===

// Get categorie entrate (tutti possono vedere)
app.get('/api/categorie/entrate', async (req, res) => {
  try {
    const [rows] = await pool.execute(
      'SELECT id, nome, descrizione FROM categorie_entrate WHERE attiva = 1 ORDER BY nome'
    );
    res.json(rows);
  } catch (error) {
    console.error('Errore categorie entrate:', error);
    res.status(500).json({ error: 'Errore server nel caricamento categorie entrate' });
  }
});

// Get categorie uscite (tutti possono vedere)
app.get('/api/categorie/uscite', async (req, res) => {
  try {
    const [rows] = await pool.execute(
      'SELECT id, nome, descrizione FROM categorie_uscite WHERE attiva = 1 ORDER BY nome'
    );
    res.json(rows);
  } catch (error) {
    console.error('Errore categorie uscite:', error);
    res.status(500).json({ error: 'Errore server nel caricamento categorie uscite' });
  }
});

// Aggiungi categoria entrata (solo admin)
app.post('/api/categorie/entrate', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { nome, descrizione } = req.body;
    
    if (!nome || nome.trim() === '') {
      return res.status(400).json({ error: 'Il nome della categoria è obbligatorio' });
    }
    
    const [result] = await pool.execute(
      'INSERT INTO categorie_entrate (nome, descrizione) VALUES (?, ?)',
      [nome.trim(), descrizione || '']
    );
    
    res.status(201).json({ message: 'Categoria entrata creata', id: result.insertId });
  } catch (error) {
    console.error('Errore creazione categoria entrata:', error);
    if (error.code === 'ER_DUP_ENTRY') {
      res.status(400).json({ error: 'Categoria già esistente' });
    } else {
      res.status(500).json({ error: 'Errore server nella creazione categoria' });
    }
  }
});

// Aggiungi categoria uscita (solo admin)
app.post('/api/categorie/uscite', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { nome, descrizione } = req.body;
    
    if (!nome || nome.trim() === '') {
      return res.status(400).json({ error: 'Il nome della categoria è obbligatorio' });
    }
    
    const [result] = await pool.execute(
      'INSERT INTO categorie_uscite (nome, descrizione) VALUES (?, ?)',
      [nome.trim(), descrizione || '']
    );
    
    res.status(201).json({ message: 'Categoria uscita creata', id: result.insertId });
  } catch (error) {
    console.error('Errore creazione categoria uscita:', error);
    if (error.code === 'ER_DUP_ENTRY') {
      res.status(400).json({ error: 'Categoria già esistente' });
    } else {
      res.status(500).json({ error: 'Errore server nella creazione categoria' });
    }
  }
});

// Modifica categoria entrata (solo admin)
app.put('/api/categorie/entrate/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, descrizione } = req.body;
    
    if (!nome || nome.trim() === '') {
      return res.status(400).json({ error: 'Il nome della categoria è obbligatorio' });
    }
    
    const [result] = await pool.execute(
      'UPDATE categorie_entrate SET nome = ?, descrizione = ? WHERE id = ?',
      [nome.trim(), descrizione || '', id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Categoria non trovata' });
    }
    
    res.json({ message: 'Categoria entrata aggiornata' });
  } catch (error) {
    console.error('Errore modifica categoria entrata:', error);
    if (error.code === 'ER_DUP_ENTRY') {
      res.status(400).json({ error: 'Nome categoria già esistente' });
    } else {
      res.status(500).json({ error: 'Errore server nella modifica categoria' });
    }
  }
});

// Modifica categoria uscita (solo admin)
app.put('/api/categorie/uscite/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, descrizione } = req.body;
    
    if (!nome || nome.trim() === '') {
      return res.status(400).json({ error: 'Il nome della categoria è obbligatorio' });
    }
    
    const [result] = await pool.execute(
      'UPDATE categorie_uscite SET nome = ?, descrizione = ? WHERE id = ?',
      [nome.trim(), descrizione || '', id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Categoria non trovata' });
    }
    
    res.json({ message: 'Categoria uscita aggiornata' });
  } catch (error) {
    console.error('Errore modifica categoria uscita:', error);
    if (error.code === 'ER_DUP_ENTRY') {
      res.status(400).json({ error: 'Nome categoria già esistente' });
    } else {
      res.status(500).json({ error: 'Errore server nella modifica categoria' });
    }
  }
});

// Elimina categoria entrata (solo admin)
app.delete('/api/categorie/entrate/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    // Controlla se ci sono transazioni associate
    const [transactions] = await pool.execute(
      'SELECT COUNT(*) as count FROM transazioni WHERE categoria_entrata_id = ?',
      [id]
    );
    
    if (transactions[0].count > 0) {
      return res.status(400).json({ 
        error: 'Impossibile eliminare: ci sono transazioni associate a questa categoria' 
      });
    }
    
    const [result] = await pool.execute(
      'UPDATE categorie_entrate SET attiva = 0 WHERE id = ?',
      [id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Categoria non trovata' });
    }
    
    res.json({ message: 'Categoria entrata eliminata' });
  } catch (error) {
    console.error('Errore eliminazione categoria entrata:', error);
    res.status(500).json({ error: 'Errore server nell\'eliminazione categoria' });
  }
});

// Elimina categoria uscita (solo admin)
app.delete('/api/categorie/uscite/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    // Controlla se ci sono transazioni associate
    const [transactions] = await pool.execute(
      'SELECT COUNT(*) as count FROM transazioni WHERE categoria_uscita_id = ?',
      [id]
    );
    
    if (transactions[0].count > 0) {
      return res.status(400).json({ 
        error: 'Impossibile eliminare: ci sono transazioni associate a questa categoria' 
      });
    }
    
    const [result] = await pool.execute(
      'UPDATE categorie_uscite SET attiva = 0 WHERE id = ?',
      [id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Categoria non trovata' });
    }
    
    res.json({ message: 'Categoria uscita eliminata' });
  } catch (error) {
    console.error('Errore eliminazione categoria uscita:', error);
    res.status(500).json({ error: 'Errore server nell\'eliminazione categoria' });
  }
});

// === TRANSAZIONI ROUTES ===

// Get transazioni (tutti possono vedere)
app.get('/api/transazioni', async (req, res) => {
  try {
    const { anno, limit = 50, offset = 0 } = req.query;
    
    let query = `
      SELECT 
        t.id, 
        DATE(t.data_transazione) as data_transazione, 
        t.tipo, 
        t.importo, 
        t.descrizione,
        ce.nome as categoria_entrata, 
        cu.nome as categoria_uscita,
        t.categoria_entrata_id,
        t.categoria_uscita_id
      FROM transazioni t
      LEFT JOIN categorie_entrate ce ON t.categoria_entrata_id = ce.id
      LEFT JOIN categorie_uscite cu ON t.categoria_uscita_id = cu.id
    `;
    
    const params = [];
    if (anno) {
      query += ' WHERE YEAR(t.data_transazione) = ?';
      params.push(anno);
    }
    
    query += ' ORDER BY t.data_transazione DESC, t.id DESC LIMIT ? OFFSET ?';
    params.push(parseInt(limit), parseInt(offset));
    
    const [rows] = await pool.execute(query, params);
    
    // Ottieni anche il conteggio totale per la paginazione
    let countQuery = 'SELECT COUNT(*) as total FROM transazioni t';
    const countParams = [];
    if (anno) {
      countQuery += ' WHERE YEAR(t.data_transazione) = ?';
      countParams.push(anno);
    }
    
    const [countResult] = await pool.execute(countQuery, countParams);
    const total = countResult[0].total;
    
    res.json({
      transactions: rows,
      total: total,
      limit: parseInt(limit),
      offset: parseInt(offset),
      hasMore: (parseInt(offset) + rows.length) < total
    });
  } catch (error) {
    console.error('Errore get transazioni:', error);
    res.status(500).json({ error: 'Errore server nel caricamento transazioni' });
  }
});

// Get singola transazione (tutti possono vedere)
app.get('/api/transazioni/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    
    const [rows] = await pool.execute(`
      SELECT 
        t.id, 
        DATE(t.data_transazione) as data_transazione, 
        t.tipo, 
        t.importo, 
        t.descrizione,
        ce.nome as categoria_entrata, 
        cu.nome as categoria_uscita,
        t.categoria_entrata_id,
        t.categoria_uscita_id
      FROM transazioni t
      LEFT JOIN categorie_entrate ce ON t.categoria_entrata_id = ce.id
      LEFT JOIN categorie_uscite cu ON t.categoria_uscita_id = cu.id
      WHERE t.id = ?
    `, [id]);
    
    if (rows.length === 0) {
      return res.status(404).json({ error: 'Transazione non trovata' });
    }
    
    res.json(rows[0]);
  } catch (error) {
    console.error('Errore get transazione singola:', error);
    res.status(500).json({ error: 'Errore server nel caricamento transazione' });
  }
});

// Aggiungi transazione (solo admin)
app.post('/api/transazioni', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { data_transazione, tipo, importo, descrizione, categoria_id } = req.body;
    
    console.log('Dati ricevuti per nuova transazione:', req.body);
    
    // Validazione
    if (!data_transazione || !tipo || !importo || !descrizione || !categoria_id) {
      return res.status(400).json({ error: 'Tutti i campi sono obbligatori' });
    }
    
    if (!['entrata', 'uscita'].includes(tipo)) {
      return res.status(400).json({ error: 'Tipo transazione non valido' });
    }
    
    const importoNum = parseFloat(importo);
    if (isNaN(importoNum) || importoNum <= 0) {
      return res.status(400).json({ error: 'Importo deve essere un numero maggiore di 0' });
    }
    
    const categoria_entrata_id = tipo === 'entrata' ? categoria_id : null;
    const categoria_uscita_id = tipo === 'uscita' ? categoria_id : null;
    
    const [result] = await pool.execute(
      `INSERT INTO transazioni 
       (data_transazione, tipo, importo, descrizione, categoria_entrata_id, categoria_uscita_id, created_by) 
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [data_transazione, tipo, importoNum, descrizione, categoria_entrata_id, categoria_uscita_id, req.user.id]
    );
    
    console.log('Transazione creata con ID:', result.insertId);
    res.status(201).json({ message: 'Transazione creata con successo', id: result.insertId });
  } catch (error) {
    console.error('Errore creazione transazione:', error);
    res.status(500).json({ error: 'Errore server nella creazione transazione' });
  }
});

// Modifica transazione (solo admin)
app.put('/api/transazioni/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { data_transazione, tipo, importo, descrizione, categoria_id } = req.body;
    
    console.log('Dati ricevuti per modifica transazione:', id, req.body);
    
    // Validazione
    if (!data_transazione || !tipo || !importo || !descrizione || !categoria_id) {
      return res.status(400).json({ error: 'Tutti i campi sono obbligatori' });
    }
    
    if (!['entrata', 'uscita'].includes(tipo)) {
      return res.status(400).json({ error: 'Tipo transazione non valido' });
    }
    
    const importoNum = parseFloat(importo);
    if (isNaN(importoNum) || importoNum <= 0) {
      return res.status(400).json({ error: 'Importo deve essere un numero maggiore di 0' });
    }
    
    const categoria_entrata_id = tipo === 'entrata' ? categoria_id : null;
    const categoria_uscita_id = tipo === 'uscita' ? categoria_id : null;
    
    const [result] = await pool.execute(
      `UPDATE transazioni 
       SET data_transazione = ?, tipo = ?, importo = ?, descrizione = ?, 
           categoria_entrata_id = ?, categoria_uscita_id = ?, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?`,
      [data_transazione, tipo, importoNum, descrizione, categoria_entrata_id, categoria_uscita_id, id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Transazione non trovata' });
    }
    
    console.log('Transazione aggiornata:', id);
    res.json({ message: 'Transazione aggiornata con successo' });
  } catch (error) {
    console.error('Errore modifica transazione:', error);
    res.status(500).json({ error: 'Errore server nella modifica transazione' });
  }
});

// Elimina transazione (solo admin)
app.delete('/api/transazioni/:id', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    console.log('Eliminazione transazione:', id);
    
    const [result] = await pool.execute('DELETE FROM transazioni WHERE id = ?', [id]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Transazione non trovata' });
    }
    
    console.log('Transazione eliminata:', id);
    res.json({ message: 'Transazione eliminata con successo' });
  } catch (error) {
    console.error('Errore eliminazione transazione:', error);
    res.status(500).json({ error: 'Errore server nell\'eliminazione transazione' });
  }
});

// === RIEPILOGO ROUTES ===
// Riepilogo (tutti possono vedere)
app.get('/api/riepilogo', async (req, res) => {
  try {
    console.log('Calcolo riepilogo totali cumulativi');
    
    // TOTALI CUMULATIVI (DA SEMPRE)
    const [totaliCumulativi] = await pool.execute(`
      SELECT 
        SUM(CASE WHEN tipo = 'entrata' THEN importo ELSE 0 END) as totale_entrate,
        SUM(CASE WHEN tipo = 'uscita' THEN importo ELSE 0 END) as totale_uscite
      FROM transazioni
    `);
    
    const totaleEntrate = parseFloat(totaliCumulativi[0].totale_entrate || 0);
    const totaleUscite = parseFloat(totaliCumulativi[0].totale_uscite || 0);
    const saldoAttuale = totaleEntrate - totaleUscite;
    
    const riepilogo = {
      totale_entrate: totaleEntrate,
      totale_uscite: totaleUscite,
      saldo_finale: saldoAttuale
    };
    
    console.log('Riepilogo totali calcolato:', riepilogo);
    res.json(riepilogo);
  } catch (error) {
    console.error('Errore calcolo riepilogo:', error);
    res.status(500).json({ error: 'Errore server nel calcolo riepilogo' });
  }
});

// Set saldo iniziale (solo admin)
app.post('/api/saldo-iniziale', authenticateToken, requireAdmin, async (req, res) => {
  try {
    const { anno, saldo } = req.body;
    
    if (!anno || saldo === undefined) {
      return res.status(400).json({ error: 'Anno e saldo sono obbligatori' });
    }
    
    const saldoNum = parseFloat(saldo);
    if (isNaN(saldoNum)) {
      return res.status(400).json({ error: 'Saldo deve essere un numero valido' });
    }
    
    await pool.execute(
      'INSERT INTO saldo_iniziale (anno, saldo) VALUES (?, ?) ON DUPLICATE KEY UPDATE saldo = ?',
      [anno, saldoNum, saldoNum]
    );
    
    res.json({ message: 'Saldo iniziale aggiornato' });
  } catch (error) {
    console.error('Errore saldo iniziale:', error);
    res.status(500).json({ error: 'Errore server nell\'aggiornamento saldo' });
  }
});
// === UTILITY ROUTES ===

// Test database (tutti possono vedere)
app.get('/api/test-db', async (req, res) => {
  try {
    const [rows] = await pool.execute('SELECT COUNT(*) as count FROM users');
    const [transazioni] = await pool.execute('SELECT COUNT(*) as count FROM transazioni');
    
    res.json({ 
      message: 'Database connesso!', 
      users_count: rows[0].count,
      transazioni_count: transazioni[0].count,
      database: dbConfig.database
    });
  } catch (error) {
    console.error('Errore test database:', error);
    res.status(500).json({ 
      error: 'Errore database', 
      details: error.message 
    });
  }
});

// === ERROR HANDLING ===
app.use((err, req, res, next) => {
  console.error('Errore non gestito:', err);
  res.status(500).json({ error: 'Errore interno del server' });
});

// Serve index.html per tutte le altre routes (DEVE STARE ALLA FINE!)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Avvia server
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📊 Database: ${dbConfig.database}`);
  console.log(`🔑 Login admin: admin / admin123`);
  console.log(`👁️ Login viewer: viewer / viewer123`);
});
