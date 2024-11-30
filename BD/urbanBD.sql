-- Crear la base de datos
CREATE DATABASE urbanv2;
GO

USE urbanv2;
GO

-- Tabla Usuarios
CREATE TABLE Usuarios (
    ID_Usuario INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    Apellido NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Telefono NVARCHAR(15) NOT NULL,
    Direccion NVARCHAR(255),
    Contrasena NVARCHAR(255) NOT NULL,
    Tipo NVARCHAR(20) CHECK (Tipo IN ('Cliente', 'Conductor', 'Admin')),
    Fecha_Registro DATETIME DEFAULT GETDATE()
);

-- Tabla Conductores
CREATE TABLE Conductores (
    ID_Conductor INT PRIMARY KEY,
    Licencia_Conducir NVARCHAR(50) NOT NULL,
    Foto_Perfil NVARCHAR(255),
    Estado NVARCHAR(20) CHECK (Estado IN ('Disponible', 'No Disponible', 'Suspendido')),
    FOREIGN KEY (ID_Conductor) REFERENCES Usuarios(ID_Usuario)
);

-- Tabla Clientes
CREATE TABLE Clientes (
    ID_Cliente INT PRIMARY KEY,
    Historial_Pedidos NVARCHAR(MAX),
    FOREIGN KEY (ID_Cliente) REFERENCES Usuarios(ID_Usuario)
);

-- Tabla Vehículos
CREATE TABLE Vehiculos (
    ID_Vehiculo INT IDENTITY(1,1) PRIMARY KEY,
    ID_Conductor INT NOT NULL,
    Marca NVARCHAR(50) NOT NULL,
    Modelo NVARCHAR(50) NOT NULL,
    Anio INT CHECK (Anio >= 2000 AND Anio <= YEAR(GETDATE())),
    Matricula NVARCHAR(15) UNIQUE NOT NULL,
    Tipo_Vehiculo NVARCHAR(20) CHECK (Tipo_Vehiculo IN ('Auto', 'Moto', 'Van')),
    Estado NVARCHAR(20) CHECK (Estado IN ('Activo', 'Inactivo')),
    FOREIGN KEY (ID_Conductor) REFERENCES Conductores(ID_Conductor)
);

-- Tabla Viajes
CREATE TABLE Viajes (
    ID_Viaje INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cliente INT NOT NULL,
    ID_Conductor INT NOT NULL,
    ID_Vehiculo INT NOT NULL,
    Origen NVARCHAR(255) NOT NULL,
    Destino NVARCHAR(255) NOT NULL,
    Fecha_Hora_Inicio DATETIME NOT NULL,
    Fecha_Hora_Fin DATETIME,
    Distancia DECIMAL(10, 2),
    Precio DECIMAL(10, 2),
    Estado NVARCHAR(20) CHECK (Estado IN ('Pendiente', 'En Curso', 'Completado', 'Cancelado')),
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Conductor) REFERENCES Conductores(ID_Conductor),
    FOREIGN KEY (ID_Vehiculo) REFERENCES Vehiculos(ID_Vehiculo)
);

-- Tabla Pagos
CREATE TABLE Pagos (
    ID_Pago INT IDENTITY(1,1) PRIMARY KEY,
    ID_Viaje INT NOT NULL,
    Monto DECIMAL(10, 2) NOT NULL,
    Metodo_Pago NVARCHAR(20) CHECK (Metodo_Pago IN ('Tarjeta', 'Paypal', 'Efectivo')),
    Fecha_Hora DATETIME DEFAULT GETDATE(),
    Estado NVARCHAR(20) CHECK (Estado IN ('Pagado', 'Pendiente')),
    FOREIGN KEY (ID_Viaje) REFERENCES Viajes(ID_Viaje)
);

-- Tabla Calificaciones
CREATE TABLE Calificaciones (
    ID_Calificacion INT IDENTITY(1,1) PRIMARY KEY,
    ID_Viaje INT NOT NULL,
    ID_Cliente INT NOT NULL,
    ID_Conductor INT NOT NULL,
    Puntuacion_Cliente INT CHECK (Puntuacion_Cliente BETWEEN 1 AND 5),
    Puntuacion_Conductor INT CHECK (Puntuacion_Conductor BETWEEN 1 AND 5),
    Comentario_Cliente NVARCHAR(255),
    Comentario_Conductor NVARCHAR(255),
    Fecha DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ID_Viaje) REFERENCES Viajes(ID_Viaje),
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Conductor) REFERENCES Conductores(ID_Conductor)
);

-- Tabla Promociones
CREATE TABLE Promociones (
    ID_Promocion INT IDENTITY(1,1) PRIMARY KEY,
    Codigo NVARCHAR(20) UNIQUE NOT NULL,
    Descuento DECIMAL(5, 2) CHECK (Descuento > 0 AND Descuento <= 100),
    Fecha_Inicio DATETIME NOT NULL,
    Fecha_Fin DATETIME NOT NULL,
    Condiciones NVARCHAR(255)
);

-- Tabla Historial Clientes
CREATE TABLE Historial_Clientes (
    ID_Historial INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cliente INT NOT NULL,
    ID_Viaje INT NOT NULL,
    Fecha DATETIME DEFAULT GETDATE(),
    Estado_Viaje NVARCHAR(20),
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Viaje) REFERENCES Viajes(ID_Viaje)
);

-- Tabla Historial Conductores
CREATE TABLE Historial_Conductores (
    ID_Historial INT IDENTITY(1,1) PRIMARY KEY,
    ID_Conductor INT NOT NULL,
    ID_Viaje INT NOT NULL,
    Fecha DATETIME DEFAULT GETDATE(),
    Estado_Viaje NVARCHAR(20),
    FOREIGN KEY (ID_Conductor) REFERENCES Conductores(ID_Conductor),
    FOREIGN KEY (ID_Viaje) REFERENCES Viajes(ID_Viaje)
);

-- Tabla Zonas
CREATE TABLE Zonas (
    ID_Zona INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Zona NVARCHAR(50) NOT NULL,
    Latitud DECIMAL(9, 6) NOT NULL,
    Longitud DECIMAL(9, 6) NOT NULL,
    Radio DECIMAL(5, 2) NOT NULL,
    Tipo_Zona NVARCHAR(20) CHECK (Tipo_Zona IN ('Alta Demanda', 'Normal'))
);

-- Tabla Tarifas
CREATE TABLE Tarifas (
    ID_Tarifa INT IDENTITY(1,1) PRIMARY KEY,
    Tipo_Vehiculo NVARCHAR(20) CHECK (Tipo_Vehiculo IN ('Auto', 'Moto', 'Van')) NOT NULL,
    Precio_Base DECIMAL(10, 2) NOT NULL,
    Precio_Por_Km DECIMAL(10, 2) NOT NULL,
    Precio_Por_Minuto DECIMAL(10, 2) NOT NULL,
    Factor_Demanda DECIMAL(5, 2)
);

-- Tabla Soporte
CREATE TABLE Soporte (
    ID_Ticket INT IDENTITY(1,1) PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    Asunto NVARCHAR(255) NOT NULL,
    Descripcion NVARCHAR(MAX),
    Fecha_Hora DATETIME DEFAULT GETDATE(),
    Estado NVARCHAR(20) CHECK (Estado IN ('Abierto', 'Cerrado')),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario)
);

-- Tabla Métodos de Pago
CREATE TABLE Metodos_Pago (
    ID_Metodo INT IDENTITY(1,1) PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    Tipo NVARCHAR(20) CHECK (Tipo IN ('Tarjeta', 'Paypal')),
    Detalle NVARCHAR(255),
    Fecha_Agregado DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario)
);

-- Tabla Notificaciones
CREATE TABLE Notificaciones (
    ID_Notificacion INT IDENTITY(1,1) PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    Tipo NVARCHAR(20) CHECK (Tipo IN ('Viaje', 'Pago', 'Promocion', 'Soporte')),
    Mensaje NVARCHAR(255) NOT NULL,
    Fecha_Hora DATETIME DEFAULT GETDATE(),
    Estado NVARCHAR(20) CHECK (Estado IN ('Leida', 'No Leida')),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario)
);

CREATE PROCEDURE RegistrarUsuario
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @Email NVARCHAR(100),
    @Telefono NVARCHAR(15),
    @Direccion NVARCHAR(255),
    @Contrasena NVARCHAR(255),
    @Tipo NVARCHAR(20)
AS
BEGIN
    -- Validación del tipo de usuario
    IF @Tipo NOT IN ('Cliente', 'Conductor', 'Admin')
    BEGIN
        RAISERROR ('Tipo de usuario no válido.', 16, 1);
        RETURN;
    END

    -- Insertar el usuario
    INSERT INTO Usuarios (Nombre, Apellido, Email, Telefono, Direccion, Contrasena, Tipo)
    VALUES (@Nombre, @Apellido, @Email, @Telefono, @Direccion, @Contrasena, @Tipo);

    -- Declarar la variable ID_Usuario después de insertar el usuario
    DECLARE @ID_Usuario INT = SCOPE_IDENTITY();

    -- Insertar en la tabla Conductores si el tipo es 'Conductor'
    IF @Tipo = 'Conductor'
    BEGIN
        INSERT INTO Conductores (ID_Conductor, Licencia_Conducir, Estado)
        VALUES (@ID_Usuario, NULL, 'No Disponible');
    END

    -- Insertar en la tabla Clientes si el tipo es 'Cliente'
    IF @Tipo = 'Cliente'
    BEGIN
        INSERT INTO Clientes (ID_Cliente, Historial_Pedidos)
        VALUES (@ID_Usuario, NULL);
    END
END;

CREATE PROCEDURE AgregarVehiculo
    @ID_Conductor INT,
    @Marca NVARCHAR(50),
    @Modelo NVARCHAR(50),
    @Anio INT,
    @Matricula NVARCHAR(15),
    @Tipo_Vehiculo NVARCHAR(20)
AS
BEGIN
    IF @Tipo_Vehiculo NOT IN ('Auto', 'Moto', 'Van')
    BEGIN
        RAISERROR ('Tipo de vehículo no válido.', 16, 1);
        RETURN;
    END

    INSERT INTO Vehiculos (ID_Conductor, Marca, Modelo, Anio, Matricula, Tipo_Vehiculo, Estado)
    VALUES (@ID_Conductor, @Marca, @Modelo, @Anio, @Matricula, @Tipo_Vehiculo, 'Activo');
END;


CREATE PROCEDURE SolicitarViaje
    @ID_Cliente INT,
    @Origen NVARCHAR(255),
    @Destino NVARCHAR(255),
    @Distancia DECIMAL(10, 2),
    @ID_Conductor INT,
    @ID_Vehiculo INT
AS
BEGIN
    DECLARE @Precio DECIMAL(10, 2);

    -- Cálculo del precio basado en la tarifa
    SELECT @Precio = t.Precio_Base + (@Distancia * t.Precio_Por_Km)
    FROM Tarifas t
    INNER JOIN Vehiculos v ON v.Tipo_Vehiculo = t.Tipo_Vehiculo
    WHERE v.ID_Vehiculo = @ID_Vehiculo;

    INSERT INTO Viajes (ID_Cliente, ID_Conductor, ID_Vehiculo, Origen, Destino, Fecha_Hora_Inicio, Distancia, Precio, Estado)
    VALUES (@ID_Cliente, @ID_Conductor, @ID_Vehiculo, @Origen, @Destino, GETDATE(), @Distancia, @Precio, 'Pendiente');
END;

CREATE PROCEDURE CompletarViaje
    @ID_Viaje INT
AS
BEGIN
    UPDATE Viajes
    SET Estado = 'Completado', Fecha_Hora_Fin = GETDATE()
    WHERE ID_Viaje = @ID_Viaje;

    -- Actualizar historial del cliente
    DECLARE @ID_Cliente INT, @ID_Conductor INT;
    SELECT @ID_Cliente = ID_Cliente, @ID_Conductor = ID_Conductor
    FROM Viajes
    WHERE ID_Viaje = @ID_Viaje;

    INSERT INTO Historial_Clientes (ID_Cliente, ID_Viaje, Fecha, Estado_Viaje)
    VALUES (@ID_Cliente, @ID_Viaje, GETDATE(), 'Completado');

    INSERT INTO Historial_Conductores (ID_Conductor, ID_Viaje, Fecha, Estado_Viaje)
    VALUES (@ID_Conductor, @ID_Viaje, GETDATE(), 'Completado');
END;


CREATE PROCEDURE CalificarViaje
    @ID_Viaje INT,
    @ID_Cliente INT,
    @ID_Conductor INT,
    @Puntuacion_Cliente INT,
    @Puntuacion_Conductor INT,
    @Comentario_Cliente NVARCHAR(255),
    @Comentario_Conductor NVARCHAR(255)
AS
BEGIN
    IF @Puntuacion_Cliente NOT BETWEEN 1 AND 5 OR @Puntuacion_Conductor NOT BETWEEN 1 AND 5
    BEGIN
        RAISERROR ('La puntuación debe estar entre 1 y 5.', 16, 1);
        RETURN;
    END

    INSERT INTO Calificaciones (ID_Viaje, ID_Cliente, ID_Conductor, Puntuacion_Cliente, Puntuacion_Conductor, Comentario_Cliente, Comentario_Conductor, Fecha)
    VALUES (@ID_Viaje, @ID_Cliente, @ID_Conductor, @Puntuacion_Cliente, @Puntuacion_Conductor, @Comentario_Cliente, @Comentario_Conductor, GETDATE());
END;


CREATE PROCEDURE ConsultarViajesPendientes
    @ID_Conductor INT
AS
BEGIN
    SELECT ID_Viaje, Origen, Destino, Distancia, Precio, Estado
    FROM Viajes
    WHERE ID_Conductor = @ID_Conductor AND Estado = 'Pendiente';
END;


