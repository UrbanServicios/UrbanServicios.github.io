//serverv2.js
const express = require('express');
const bodyParser = require('body-parser');
const { Pool } = require('pg'); // Importar el cliente PostgreSQL

// Crear la aplicación de Express
const app = express();
const port = 3000;

// Configurar middlewares
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Configuración de la base de datos PostgreSQL
const pool = new Pool({
    user: 'cruzt',           // Cambia por tu usuario
    host: 'localhost',       // Host del servidor PostgreSQL
    database: 'urban'   ,     // Nombre de la base de datos
    password: 'm900dcb4a75d2', // Contraseña del usuario
    port: 5432,              // Puerto por defecto de PostgreSQL
});

// Probar conexión a la base de datos
pool.connect()
    .then(() => console.log('Conexión exitosa a PostgreSQL'))
    .catch(err => console.error('Error al conectar a PostgreSQL:', err));

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
        // Iniciar una transacción
        const client = await pool.connect();

        try {
            // Insertar datos en la tabla Usuarios y retornar el ID
            const result = await client.query(
                'INSERT INTO usuarios (nombre, apellido) VALUES ($1, $2) RETURNING id_usuario',
                [nombre, apellidos]
            );

            const id_usuario = result.rows[0].id_usuario;

            // Insertar datos en la tabla loginusuario
            await client.query(
                'INSERT INTO loginusuario (id_usuario, telefonocoreo, password) VALUES ($1, $2, $3)',
                [id_usuario, telefonocoreo, password]
            );

            res.status(201).send('Usuario registrado correctamente');
        } finally {
            client.release(); // Liberar conexión
        }

    } catch (error) {
        console.error('Error al registrar usuario:', error);
        res.status(500).send('Error al registrar usuario');
    }
});

// Iniciar el servidor
app.listen(port, () => {
    console.log(`Servidor corriendo en http://localhost:${port}`);
});
