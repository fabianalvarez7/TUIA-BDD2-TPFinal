USE [bd_intermedia_2025_G06]

CREATE TABLE dbo.int_rango_etario_G06 (
    rango_etario_id    INT PRIMARY KEY,
    edad_desde         INT,
    edad_hasta         INT,
    nombre_rango       NVARCHAR(50)
);

INSERT INTO dbo.int_rango_etario_G06 (rango_etario_id, edad_desde, edad_hasta, nombre_rango)
VALUES
(1, -1, -1, 'Edad desconocida'),  -- valor por defecto para datos faltantes
(2, 13, 19, 'Teenagers'),
(3, 20, 39, 'Adultos'),
(4, 40, 50, 'Adultos medios'),
(5, 51, 65, 'Adultos mayores'),
(6, 66, 66, 'Consumidores 66'),
(7, 67, 120, 'Adultos mayores')  -- continúa el grupo desde 67+
