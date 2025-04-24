require('dotenv').config();

const db = require('./conexionBD.js');
const express = require('express');
const app = express();
const jwt = require('jsonwebtoken');

const PORT = process.env.PORT || 3000;
const SECRET_KEY = process.env.SECRET_KEY;

app.use(express.json());

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

function verificarToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
  
    if (!token) return res.status(401).json({ error: 'Token requerido' });
  
    jwt.verify(token, SECRET_KEY, (err, usuario) => {
      if (err) return res.status(403).json({ error: 'Token inválido o expirado' });
      req.usuario = usuario;
      next();
    });
  }

app.post('/login', (req, res) => {
    const { username, passwd } = req.body;

    db.query('SELECT * FROM usuarios WHERE username = ? AND passwd = ?', [username, passwd], (err, results) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (results.length > 0) {
            const token = jwt.sign(
                { username: username },
                SECRET_KEY,
                { expiresIn: '24h' } // Duración del token
              );
          
              res.status(200).json({ mensaje: 'Login exitoso', token });
            
        } else {
            res.status(401).send('Invalid username or password');
        }
    });
});

app.post('/singin', (req, res) => {
    const { username, passwd } = req.body;

    const query = 'INSERT INTO usuarios (username, passwd) VALUES (?, ?)';
    const valores = [username, passwd];

    db.query(query, valores, (err, result) => {
        if (err) {
          console.error('Error en el INSERT:', err);
          return res.status(500).json({ error: 'Error al insertar usuario' });
        }
    
        res.status(201).json({
          mensaje: 'Usuario insertado correctamente',
        });
    });
});

app.get('/verificar', verificarToken, (req, res) => {
    res.json({
      mensaje: 'Acceso autorizado',
    });
  });

app.post('/existeUser', (req, res) => {
    const { username } = req.body;

    db.query('SELECT * FROM usuarios WHERE username = ?', [username], (err, results) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (results.length > 0) {
            res.status(200).json({ existe: true });
        } else {
            res.status(200).json({ existe: false });
        }
    });
});

app.get('/delete', (req, res) => {
    const { username } = req.query;

    db.query('DELETE FROM usuarios WHERE username = ?', [username], (err, result) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (result.affectedRows > 0) {
            res.status(200).json({ mensaje: 'Usuario eliminado correctamente' });
        } else {
            res.status(404).json({ mensaje: 'Usuario no encontrado' });
        }
    });
});