require('dotenv').config();

const db = require('./conexionBD.js');
const express = require('express');
const app = express();

const PORT = process.env.PORT || 3000;

// ✅ Importante: middleware para interpretar JSON
app.use(express.json());

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

app.post('/login', (req, res) => {
    const { username, passwd } = req.body;

    db.query('SELECT * FROM usuarios WHERE username = ? AND passwd = ?', [username, passwd], (err, results) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (results.length > 0) {
            res.status(200).send('Login successful');
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
          id_insertado: result.insertId
        });
    });
});
