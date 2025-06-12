USE [bd_intermedia_2025_G06];
GO

-- Borrar fact_ventas antes de recargar (si ya existe)
TRUNCATE TABLE [datawarehouse_2025_G06].[dbo].[Fact_Ventas_G06];

-- Tabla temporal para calcular el total de factura
WITH CTE_Total_Facturado AS (
    SELECT 
        v.billing_id,
        v.date,
        SUM(v.quantity * p.PRICE) AS total_facturado
    FROM [dbo].[int_ventas_G06] v
    LEFT JOIN [dbo].[int_precios_G06] p 
        ON v.product_id = p.PRODUCT_ID
       AND v.date >= p.[FROM]
       AND (v.date < p.UNTIL OR p.UNTIL IS NULL)
    GROUP BY v.billing_id, v.date
),

-- Tabla temporal para calcular si corresponde descuento
CTE_Descuentos AS (
    SELECT 
        tf.billing_id,
        tf.date,
        tf.total_facturado,
        ISNULL(MAX(d.PERCENTAGE / 100.0), 0.0) AS descuento
    FROM CTE_Total_Facturado tf
    LEFT JOIN [dbo].[int_descuentos_G06] d
        ON tf.date >= d.[FROM]
       AND (tf.date < d.UNTIL OR d.UNTIL IS NULL)
       AND tf.total_facturado > d.TOTAL_BILLING
    GROUP BY tf.billing_id, tf.date, tf.total_facturado
),

-- Tabla temporal para calcular la edad del cliente al momento de la venta
CTE_VentasConEdad AS (
    SELECT 
        v.*,
        c.BIRTH_DATE,
        CASE 
            WHEN c.BIRTH_DATE IS NULL THEN -1
            ELSE DATEDIFF(YEAR, c.BIRTH_DATE, v.date)
                 - CASE 
                     WHEN MONTH(v.date) < MONTH(c.BIRTH_DATE)
                          OR (MONTH(v.date) = MONTH(c.BIRTH_DATE) AND DAY(v.date) < DAY(c.BIRTH_DATE))
                     THEN 1 ELSE 0 
                   END
        END AS edad_cliente
    FROM dbo.int_ventas_G06 v
    LEFT JOIN bd_intermedia_2025_G06.dbo.int_clientes_G06 c
        ON v.customer_id = c.customer_id
),


-- Tabla temporal para evitar duplicados en precios por producto
CTE_PreciosUnicos AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY PRODUCT_ID
               ORDER BY [FROM] DESC
           ) AS rn
    FROM [dbo].[int_precios_G06]
)

-- Insertar en la tabla de hechos
INSERT INTO [datawarehouse_2025_G06].[dbo].[Fact_Ventas_G06] (
	tiempo_key,
    producto_key,
    cliente_key,
    empleado_key,  
    rango_etario_id,
    cantidad,
    cantidad_litros,
    cantidad_latas,
	cantidad_litros_diet,
    precio_unitario,
    monto_sin_descuento,
    monto_con_descuento,
    edad_cliente,
	region
)

SELECT
	-- FK: Tiempo
    CONVERT(INT, CONVERT(VARCHAR(8), v.date, 112)) AS tiempo_key,

    -- Claves subrogadas desde dimensiones del DW
    ISNULL(dp.producto_key, 0)     AS producto_key,
    ISNULL(dc.cliente_key, 0)      AS cliente_key,
    ISNULL(de.empleado_key, 0)     AS empleado_key,
    ISNULL(dre.rango_etario_id, 1) AS rango_etario_id,

    -- Métricas
    v.quantity,
    
	-- Cantidad de litros vendidos
    CASE 
        WHEN unidad_medida = 'Liter' THEN Capacidad * v.quantity 
        ELSE (Capacidad / 1000.0) * v.quantity 
    END AS cantidad_litros,

	-- Cantidad de latas vendidas
    CASE 
        WHEN es_lata = 1 THEN v.quantity ELSE 0 
    END AS cantidad_latas,

	-- Cantidad de litros vendidos de bebidas diet
	CASE 
		WHEN es_diet = 1 THEN 
			CASE 
				WHEN unidad_medida = 'Liter' THEN Capacidad * v.quantity
				WHEN unidad_medida = 'cm3' THEN (Capacidad / 1000.0) * v.quantity
				ELSE 0
			END
		ELSE 0
	END AS cantidad_litros_diet,


    p.PRICE AS precio_unitario,

    v.quantity * p.PRICE AS monto_sin_descuento,

    v.quantity * p.PRICE * (1 - ISNULL(d.descuento, 0.0)) AS monto_con_descuento,

	v.edad_cliente,

	v.region
	

FROM CTE_VentasConEdad v

-- Precios
LEFT JOIN CTE_PreciosUnicos p 
    ON v.product_id = p.PRODUCT_ID
   AND v.date >= p.[FROM]
   AND (v.date <= p.UNTIL OR p.UNTIL IS NULL)
   AND p.rn = 1

-- Descuentos
LEFT JOIN CTE_Descuentos d 
    ON v.billing_id = d.billing_id


-- Rango etario
LEFT JOIN bd_intermedia_2025_G06.dbo.int_rango_etario_G06 dre
    ON v.edad_cliente BETWEEN ISNULL(dre.edad_desde, -1) AND ISNULL(dre.edad_hasta, 999)


-- Dimensiones del DW con claves subrogadas
LEFT JOIN [datawarehouse_2025_G06].[dbo].[Dim_Productos_G06] dp
	ON v.product_id = dp.product_id

LEFT JOIN [datawarehouse_2025_G06].[dbo].[Dim_Clientes_G06] dc
	ON v.customer_id = dc.customer_id

LEFT JOIN [datawarehouse_2025_G06].[dbo].[Dim_Empleados_G06] de
	ON v.employee_id = de.employee_id


WHERE
    v.id IS NOT NULL
    AND dp.producto_key IS NOT NULL
    AND dc.cliente_key IS NOT NULL
    AND de.empleado_key IS NOT NULL
	AND p.PRICE IS NOT NULL;
