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

    const query = 'SELECT * FROM usuarios WHERE username = ? AND passwd = ?';
    const valores = [username, passwd];

    db.query(query, valores, (err, results) => {
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

app.get('/getUsuarios', (req, res) => {
    const query = 'SELECT username FROM usuarios ORDER BY descargas DESC';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (results.length > 0) {
            res.status(200).json({ usuarios: results });
        } else {
            res.status(404).json({ mensaje: 'Usuarios no encontrados' });
        }
    });
}
);

app.post('/existeUser', (req, res) => {
    const { username } = req.body;

    const query = 'SELECT * FROM usuarios WHERE username = ?';
    const valores = [username];

    db.query(query, valores, (err, results) => {
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

app.get('/deleteUser', (req, res) => {
    const { username } = req.query;

    const query = 'DELETE FROM usuarios WHERE username = ?';
    const valores = [username];

    db.query(query, valores, (err, result) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);deleteRutina
            return res.status(500).send('Error en el servidor');
        }

        if (result.affectedRows > 0) {
            res.status(200).json({ mensaje: 'Usuario eliminado correctamente' });
        } else {
            res.status(404).json({ mensaje: 'Usuario no encontrado' });
        }
    });
});

app.post('/subirEjercicio', (req, res) => {
    const { nombre,tipo,descripcion } = req.body;

    const query = 'INSERT INTO ejercicios (nombre, tipo, descripcion) VALUES (?, ?, ?)';
    const valores = [nombre,tipo,descripcion];

    db.query(query, valores, (err, result) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (result.affectedRows > 0) {
            res.status(200).json({ mensaje: 'Ejercicio subido correctamente' , id: result.insertId});
        } else {
            res.status(404).json({ mensaje: 'Ejercicio no encontrado' });
        }
    });
});

app.post('/subirRutina', (req, res) => {
    const { nombre, descripcion, idEjercicios, usuario, descansos } = req.body;

    const query = 'INSERT INTO rutinas (nombre, descripcion, idEjercicios, usuario, descansos) VALUES (?, ?, ?, ?, ?)';
    const valores = [nombre, descripcion, idEjercicios, usuario, descansos]

    db.query(query, valores, (err, result) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (result.affectedRows > 0) {
            res.status(200).json({ mensaje: 'Rutina subida correctamente' , id: result.insertId});
        } else {
            res.status(404).json({ mensaje: 'Rutina no encontrada' });
        }
    });
});

app.post('/aniadirIdsAEjercicios', (req, res) => {
    const { idsEjercicios, idRutina } = req.body;

    query = 'UPDATE ejercicios SET idRutina = CASE ';

    idsEjercicios.forEach(element => {
        query += `WHEN id = ${element} THEN ${idRutina} `;
    });

    query += 'ELSE idRutina';
    query += ` END WHERE id IN (${idsEjercicios.join(', ')})`;

    db.query(query, (err, result) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (result.affectedRows > 0) {
            res.status(200).json({ mensaje: 'Ejercicio actualizado correctamente' });
        } else {
            res.status(404).json({ mensaje: 'Ejercicio no encontrado' });
        }
    });
});

app.post('/aniadirEjerciciosARutina', (req, res) => {
    const { idsEjercicios, idRutina } = req.body;

    const query = 'UPDATE rutinas SET idEjercicios = ? WHERE id = ?';
    const valores = [idsEjercicios , idRutina];

    db.query(query, valores, (err, result) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (result.affectedRows > 0) {
            res.status(200).json({ mensaje: 'Ejercicio actualizado correctamente' });
        } else {
            res.status(404).json({ mensaje: 'Ejercicio no encontrado' });
        }
    });
});

app.post('/rutinasCompartidasUsuario', (req, res) => {
    const { usuario } = req.body;

    const query = 'SELECT id, nombre FROM rutinas WHERE usuario = ? ORDER BY descargas DESC';
    const valores = [usuario];
    db.query(query, valores, (err, results) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (results.length > 0) {
            res.status(200).json({ rutinas: results });
        } else {
            res.status(404).json({ mensaje: 'Rutinas no encontradas' });
        }
    });
});

app.post('/getRutina', (req, res) => {
    const { id , usuario} = req.body;

    if(usuario==undefined){
        const query = 'SELECT descripcion, descargas, descansos FROM rutinas WHERE id = ?';
        const valores = [id];

        db.query(query, valores, (err, results) => {
            if (err) {
                console.error('Error al ejecutar la consulta:', err);
                return res.status(500).send('Error en el servidor');
            }

            if (results.length > 0) {
                res.status(200).json({ rutina: results[0] });
            } else {
                res.status(404).json({ mensaje: 'Rutina no encontrada' });
            }
        });
    }else{
        const query = 'SELECT descripcion, idEjercicios, descargas, descansos, usuario FROM rutinas WHERE id = ?';
        const valores = [id];

        db.query(query, valores, (err, results) => {
            if (err) {
                console.error('Error al ejecutar la consulta:', err);
                return res.status(500).send('Error en el servidor');
            }

            if (results.length > 0) {
                res.status(200).json({ rutina: results[0] });
            } else {
                res.status(404).json({ mensaje: 'Rutina no encontrada' });
            }
        });
    }
});

app.get('/getRutinas', (req, res) => {
    const query = 'SELECT id, nombre FROM rutinas ORDER BY descargas DESC';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (results.length > 0) {
            res.status(200).json({ rutinas: results });
        } else {
            res.status(404).json({ mensaje: 'Rutinas no encontradas' });
        }
    });
}
);

app.post('/borrarRutina', (req, res) => {
    const { id } = req.body;

    const query = 'DELETE FROM rutinas WHERE id = ?';
    const valores = [id];

    db.query(query, valores, (err, result) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (result.affectedRows > 0) {
            res.status(200).json({ mensaje: 'Rutina eliminada correctamente' });
        } else {
            res.status(404).json({ mensaje: 'Rutina no encontrada' });
        }
    });
}
);

app.post('/getEjerciciosRutina', (req, res) => {
    const { id } = req.body;

    const query = 'SELECT nombre FROM ejercicios WHERE idRutina IN (SELECT id FROM rutinas WHERE id = ?)';
    const valores = [id];

    db.query(query, valores, (err, results) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (results.length > 0) {
            res.status(200).json({ ejercicios: results });
        } else {
            res.status(404).json({ mensaje: 'Ejercicios no encontrados' });
        }
    });
}
);

app.post('/registrarDescarga',(req,res) => {
    
    const { id } = req.body;
    const query = 'UPDATE rutinas SET descargas = descargas + 1 WHERE id = ?';
    const valores = [id];

    db.query(query, valores, (err, result) => {
    if (err) {
        console.error('Error al ejecutar la consulta:', err);
        return res.status(500).send('Error en el servidor');
    }

    if (result.affectedRows > 0) {
        res.status(200).json({ mensaje: 'Descarga registrada correctamente' });
    } else {
        res.status(404).json({ mensaje: 'Rutina no encontrada' });
    }

    });
});

app.post('/getEjerciciosRutinaDescargar', (req, res) => {
    const { id } = req.body;

    const query = 'SELECT nombre, tipo, descripcion FROM ejercicios WHERE idRutina IN (SELECT id FROM rutinas WHERE id = ?)';
    const valores = [id];

    db.query(query, valores, (err, results) => {
        if (err) {
            console.error('Error al ejecutar la consulta:', err);
            return res.status(500).send('Error en el servidor');
        }

        if (results.length > 0) {
            res.status(200).json({ ejercicios: results });
        } else {
            res.status(404).json({ mensaje: 'Ejercicios no encontrados' });
        }
    });
}
);

