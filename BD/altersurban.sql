-- Claves foráneas
ALTER TABLE Calificaciones ADD FOREIGN KEY(ID_Cliente) REFERENCES Clientes(ID_Cliente);
ALTER TABLE Calificaciones ADD FOREIGN KEY(ID_Conductor) REFERENCES Conductores(ID_Conductor);
ALTER TABLE Calificaciones ADD FOREIGN KEY(ID_Viaje) REFERENCES Viajes(ID_Viaje);
ALTER TABLE Clientes ADD FOREIGN KEY(ID_Cliente) REFERENCES Usuarios(ID_Usuario);
ALTER TABLE Conductores ADD FOREIGN KEY(ID_Conductor) REFERENCES Usuarios(ID_Usuario);
ALTER TABLE Historial_Clientes ADD FOREIGN KEY(ID_Cliente) REFERENCES Clientes(ID_Cliente);
ALTER TABLE Historial_Clientes ADD FOREIGN KEY(ID_Viaje) REFERENCES Viajes(ID_Viaje);
ALTER TABLE Historial_Conductores ADD FOREIGN KEY(ID_Conductor) REFERENCES Conductores(ID_Conductor);
ALTER TABLE Historial_Conductores ADD FOREIGN KEY(ID_Viaje) REFERENCES Viajes(ID_Viaje);
ALTER TABLE Metodos_Pago ADD FOREIGN KEY(ID_Usuario) REFERENCES Usuarios(ID_Usuario);
ALTER TABLE Notificaciones ADD FOREIGN KEY(ID_Usuario) REFERENCES Usuarios(ID_Usuario);
ALTER TABLE Pagos ADD FOREIGN KEY(ID_Viaje) REFERENCES Viajes(ID_Viaje);
ALTER TABLE Soporte ADD FOREIGN KEY(ID_Usuario) REFERENCES Usuarios(ID_Usuario);
ALTER TABLE Vehiculos ADD FOREIGN KEY(ID_Conductor) REFERENCES Conductores(ID_Conductor);
ALTER TABLE Viajes ADD FOREIGN KEY(ID_Cliente) REFERENCES Clientes(ID_Cliente);
ALTER TABLE Viajes ADD FOREIGN KEY(ID_Conductor) REFERENCES Conductores(ID_Conductor);
ALTER TABLE Viajes ADD FOREIGN KEY(ID_Vehiculo) REFERENCES Vehiculos(ID_Vehiculo);

-- Valores predeterminados
ALTER TABLE Calificaciones ALTER COLUMN Fecha SET DEFAULT NOW();
ALTER TABLE Historial_Clientes ALTER COLUMN Fecha SET DEFAULT NOW();
ALTER TABLE Historial_Conductores ALTER COLUMN Fecha SET DEFAULT NOW();
ALTER TABLE Metodos_Pago ALTER COLUMN Fecha_Agregado SET DEFAULT NOW();
ALTER TABLE Notificaciones ALTER COLUMN Fecha_Hora SET DEFAULT NOW();
ALTER TABLE Pagos ALTER COLUMN Fecha_Hora SET DEFAULT NOW();
ALTER TABLE Soporte ALTER COLUMN Fecha_Hora SET DEFAULT NOW();
ALTER TABLE Usuarios ALTER COLUMN Fecha_Registro SET DEFAULT NOW();

-- Restricciones CHECK
ALTER TABLE Calificaciones ADD CHECK (Puntuacion_Cliente >= 1 AND Puntuacion_Cliente <= 5);
ALTER TABLE Calificaciones ADD CHECK (Puntuacion_Conductor >= 1 AND Puntuacion_Conductor <= 5);
ALTER TABLE Conductores ADD CHECK (Estado IN ('Suspendido', 'No Disponible', 'Disponible'));
ALTER TABLE Metodos_Pago ADD CHECK (Tipo IN ('Paypal', 'Tarjeta'));
ALTER TABLE Notificaciones ADD CHECK (Estado IN ('No Leida', 'Leida'));
ALTER TABLE Notificaciones ADD CHECK (Tipo IN ('Soporte', 'Promocion', 'Pago', 'Viaje'));
ALTER TABLE Pagos ADD CHECK (Estado IN ('Pendiente', 'Pagado'));
ALTER TABLE Pagos ADD CHECK (Metodo_Pago IN ('Efectivo', 'Paypal', 'Tarjeta'));
ALTER TABLE Promociones ADD CHECK (Descuento > 0 AND Descuento <= 100);
ALTER TABLE Soporte ADD CHECK (Estado IN ('Cerrado', 'Abierto'));
ALTER TABLE Tarifas ADD CHECK (Tipo_Vehiculo IN ('Van', 'Moto', 'Auto'));
ALTER TABLE Usuarios ADD CHECK (Tipo IN ('Admin', 'Conductor', 'Cliente'));
ALTER TABLE Vehiculos ADD CHECK (Anio >= 2000 AND Anio <= EXTRACT(YEAR FROM CURRENT_DATE));
ALTER TABLE Vehiculos ADD CHECK (Estado IN ('Inactivo', 'Activo'));
ALTER TABLE Vehiculos ADD CHECK (Tipo_Vehiculo IN ('Van', 'Moto', 'Auto'));
ALTER TABLE Viajes ADD CHECK (Estado IN ('Cancelado', 'Completado', 'En Curso', 'Pendiente'));
ALTER TABLE Zonas ADD CHECK (Tipo_Zona IN ('Normal', 'Alta Demanda'));
