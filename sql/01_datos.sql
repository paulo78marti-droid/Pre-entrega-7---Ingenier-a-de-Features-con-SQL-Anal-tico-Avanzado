-- Creación de tablas de prueba para Ingeniería de Features
DROP TABLE IF EXISTS compras;
DROP TABLE IF EXISTS usuarios;

CREATE TABLE usuarios (
    usuario_id INT PRIMARY KEY,
    nombre VARCHAR(100),
    fecha_registro DATE
);

CREATE TABLE compras (
    compra_id INT PRIMARY KEY,
    usuario_id INT,
    fecha_compra DATE,
    monto DECIMAL(10, 2),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

-- Inserción de usuarios
INSERT INTO usuarios (usuario_id, nombre, fecha_registro) VALUES
(1, 'Ana Gómez', '2023-12-01'),
(2, 'Bruno Díaz', '2024-01-05'),
(3, 'Carla Ruiz', '2023-11-15'),
(4, 'Diego Sosa', '2023-12-10'),
(5, 'Elena Paz', '2024-01-20'),
(6, 'Hernán Vega', '2023-10-01');

-- Inserción de compras
INSERT INTO compras (compra_id, usuario_id, fecha_compra, monto) VALUES
-- Ana Gómez (id=1): recency 12 -> last 2024-05-20, freq=12, monetary=750, ultimo_mes=145, hist=121
(101, 1, '2024-01-10', 105.00),
(102, 1, '2024-01-25', 100.00),
(103, 1, '2024-02-05', 80.00),
(104, 1, '2024-02-18', 70.00),
(105, 1, '2024-03-02', 60.00),
(106, 1, '2024-03-15', 50.00),
(107, 1, '2024-04-01', 40.00),
(108, 1, '2024-04-12', 40.00),
(109, 1, '2024-04-22', 60.00),
(110, 1, '2024-05-06', 70.00),
(111, 1, '2024-05-14', 60.00),
(112, 1, '2024-05-20', 15.00),

-- Bruno Díaz (id=2): recency 20 -> last 2024-05-12, freq=3, monetary=2350, ultimo_mes=900, hist=290, dias_entre=87
(201, 2, '2024-01-15', 850.00),
(202, 2, '2024-02-15', 600.00),
(203, 2, '2024-05-12', 900.00),

-- Carla Ruiz (id=3): recency 111 -> last 2024-02-11, freq=3, monetary=320, ultimo_mes=0, hist=64, dias_entre=28
(301, 3, '2023-12-20', 120.00),
(302, 3, '2024-01-14', 100.00),
(303, 3, '2024-02-11', 100.00),

-- Diego Sosa (id=4): recency 15 -> last 2024-05-17, freq=6, monetary=1040, ultimo_mes=40, hist=200, dias_entre=31
(401, 4, '2024-01-05', 250.00),
(402, 4, '2024-02-10', 250.00),
(403, 4, '2024-03-01', 250.00),
(404, 4, '2024-03-25', 150.00),
(405, 4, '2024-04-16', 100.00),
(406, 4, '2024-05-17', 40.00),

-- Elena Paz (id=5): recency 10 -> last 2024-05-22, freq=4, monetary=400, ultimo_mes=300, hist=20, dias_entre=39
(501, 5, '2024-02-01', 50.00),
(502, 5, '2024-03-10', 50.00),
(503, 5, '2024-04-13', 100.00),
(504, 5, '2024-05-22', 200.00);
