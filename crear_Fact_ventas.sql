-- Creación Fact_Ventas

USE datawarehouse_2025_G06


CREATE TABLE dbo.Fact_Ventas_G06 (
    venta_id              INT IDENTITY(1,1) PRIMARY KEY,  -- Clave subrogada para el dw
    
    -- Claves foráneas a dimensiones
    tiempo_key            INT NOT NULL, -- formato entero YYYYMMDD 
	producto_key          INT NOT NULL,
    cliente_key           INT NOT NULL,
    empleado_key          INT NOT NULL,
    rango_etario_id       INT NOT NULL,

    -- Métricas
    cantidad              INT NOT NULL,
    cantidad_litros       FLOAT NOT NULL,
    cantidad_latas        INT NOT NULL,
	cantidad_litros_diet  FLOAT NOT NULL,
    precio_unitario       MONEY NOT NULL,
    monto_sin_descuento   MONEY NOT NULL,
    monto_con_descuento   MONEY NOT NULL,
	edad_cliente          INT NULL,
	
	-- Adicionales
	region				  NVARCHAR(100) NULL
);


-- FK a Dim_Tiempo
ALTER TABLE dbo.Fact_Ventas_G06
ADD CONSTRAINT FK_FactVentas_Tiempo
    FOREIGN KEY (tiempo_key) REFERENCES dbo.Dim_tiempo_G06(Fecha_key);

-- FK a Dim_Productos
ALTER TABLE dbo.Fact_Ventas_G06
ADD CONSTRAINT FK_FactVentas_Producto
    FOREIGN KEY (producto_key) REFERENCES dbo.Dim_Productos_G06(producto_key);

-- FK a Dim_Clientes
ALTER TABLE dbo.Fact_Ventas_G06
ADD CONSTRAINT FK_FactVentas_Cliente
    FOREIGN KEY (cliente_key) REFERENCES dbo.Dim_Clientes_G06(cliente_key);

-- FK a Dim_Empleados
ALTER TABLE dbo.Fact_Ventas_G06
ADD CONSTRAINT FK_FactVentas_Empleado
    FOREIGN KEY (empleado_key) REFERENCES dbo.Dim_Empleados_G06(empleado_key);

-- FK a Dim_RangoEtario
ALTER TABLE dbo.Fact_Ventas_G06
ADD CONSTRAINT FK_FactVentas_RangoEtario
    FOREIGN KEY (rango_etario_id) REFERENCES dbo.Dim_rango_etario_G06(rango_etario_id);
