const mysql = require('mysql2');

const db = mysql.createConnection({
  host: 'localhost',        // o IP si está en otro servidor
  user: 'server',           // tu usuario MySQL
  password: 'server',       // tu contraseña MySQL
  database: 'TFG'           // el nombre de tu base de datos
});


db.connect((err) => {
  if (err) {
    console.error('Error al conectar con la base de datos:', err.message);
  } else {
    console.log('Conectado a la base de datos MySQL');
  }
});

module.exports = db;