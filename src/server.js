//server.js
const express = require('express');
const bodyParser = require('body-parser');
const sql = require('mssql');

// Crear la aplicación de Express
const app = express();
const port = 30000;

// Configurar middlewares
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Configuración de la base de datos SQL Server
const dbConfig = {
    server: 'FERNANDO\\SQLEXPRESS',
    database: 'URBAN',
    authentication: {
        type: 'ntlm',
        options: {
            domain: 'FERNANDO', // Reemplaza con el dominio válido
            userName: 'cruzt',
            password: 'm900dcb4a75d2'
        }
    },
    options: {
        encrypt: true,
        trustServerCertificate: true
    },
    port: 1433
};




// Conectar a la base de datos
sql.connect(dbConfig)
    .then(() => console.log('Conexión exitosa a la base de datos'))
    .catch(err => console.error('Error al conectar a la base de datos:', err));

// Ruta para registrar usuarios
app.post('/registrar', async (req, res) => {
    const { nombre, apellidos, telefonocoreo, password } = req.body;

    // Validaciones de los datos enviados
    if (!nombre || !apellidos || !telefonocoreo || !password) {
        return res.status(400).send('Todos los campos son obligatorios');
    }

    if (password.length < 6) {
        return res.status(400).send('La contraseña debe tener al menos 6 caracteres');
    }

    try {
        // Conexión al pool de la base de datos
        const pool = await sql.connect(dbConfig);

        // Insertar datos en la tabla Usuarios
        const result = await pool.request()
            .input('nombre', sql.VarChar(50), nombre)
            .input('apellidos', sql.VarChar(60), apellidos)
            .query('INSERT INTO Usuarios (nombre, apellidos) OUTPUT Inserted.id_usuario VALUES (@nombre, @apellidos)');

        const id_usuario = result.recordset[0].id_usuario; // Obtener ID del usuario insertado

        // Insertar datos en la tabla loginusuario
        await pool.request()
            .input('id_usuario', sql.Int, id_usuario)
            .input('telefonocoreo', sql.VarChar(80), telefonocoreo)
            .input('password', sql.VarChar(10), password)
            .query('INSERT INTO loginusuario (id_usuario, telefonocoreo, pasword) VALUES (@id_usuario, @telefonocoreo, @password)');

        res.status(201).send('Usuario registrado correctamente');
    } catch (error) {
        console.error('Error al registrar usuario:', error);
        res.status(500).send('Error al registrar usuario');
    }
});

// Iniciar el servidor
app.listen(port, () => {
    console.log(`Servidor corriendo en http://localhost:${port}`);
});
