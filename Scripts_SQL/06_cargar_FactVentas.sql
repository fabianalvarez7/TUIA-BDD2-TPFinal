USE [bd_intermedia_2025_G06];
GO

-- Borrar fact_ventas antes de recargar (si ya existe)
DELETE FROM [datawarehouse_2025_G06].[dbo].[Fact_Ventas_G06];

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

-- Tabla temporal para calcular la edad del empleado al momento de la venta
CTE_VentasConEdadEmpleado AS (
    SELECT       
        v.id,
        TRY_CAST(e.BIRTH_DATE AS DATE) AS BIRTH_DATE,
        CASE
            WHEN TRY_CAST(e.BIRTH_DATE AS DATE) IS NULL THEN -1
            ELSE DATEDIFF(YEAR, TRY_CAST(e.BIRTH_DATE AS DATE), v.date)
                 - CASE
                     WHEN MONTH(v.date) < MONTH(TRY_CAST(e.BIRTH_DATE AS DATE))
                          OR (MONTH(v.date) = MONTH(TRY_CAST(e.BIRTH_DATE AS DATE)) AND DAY(v.date) < DAY(TRY_CAST(e.BIRTH_DATE AS DATE)))
                     THEN 1 ELSE 0
                   END
        END AS edad_empleado
    FROM dbo.int_ventas_G06 v
    LEFT JOIN bd_staging_2025_G06.dbo.stg_empleados_G06 e
        ON v.employee_id = e.EMPLOYEE_ID
),

-- Tabla temporal para evitar duplicados en precios por producto
CTE_PrecioPorFecha AS (
    SELECT
        p.*,
        v.date AS fecha_venta,
        ROW_NUMBER() OVER (
            PARTITION BY v.product_id, v.date
            ORDER BY p.[FROM] DESC
        ) AS rn
    FROM dbo.int_ventas_G06 v
    JOIN dbo.int_precios_G06 p
        ON v.product_id = p.PRODUCT_ID
       AND v.date >= p.[FROM]
       AND (v.date < p.UNTIL OR p.UNTIL IS NULL)
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
    edad_empleado,
    region
)
SELECT
    CONVERT(INT, CONVERT(VARCHAR(8), v.date, 112)) AS tiempo_key,
    ISNULL(dp.producto_key, 0)     AS producto_key,
    ISNULL(dc.cliente_key, 0)      AS cliente_key,
    ISNULL(de.empleado_key, 0)     AS empleado_key,
    ISNULL(dre.rango_etario_id, 1) AS rango_etario_id,
    v.quantity,
    CASE
        WHEN unidad_medida = 'Liter' THEN Capacidad * v.quantity
        ELSE (Capacidad / 1000.0) * v.quantity
    END AS cantidad_litros,
    CASE
        WHEN es_lata = 1 THEN v.quantity ELSE 0
    END AS cantidad_latas,
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
    ve.edad_empleado,
    v.region
FROM CTE_VentasConEdad v
LEFT JOIN CTE_VentasConEdadEmpleado ve
    ON v.id = ve.id
LEFT JOIN CTE_PrecioPorFecha p
    ON v.product_id = p.PRODUCT_ID
   AND v.date = p.fecha_venta
   AND p.rn = 1
LEFT JOIN CTE_Descuentos d
    ON v.billing_id = d.billing_id
LEFT JOIN bd_intermedia_2025_G06.dbo.int_rango_etario_G06 dre
    ON v.edad_cliente BETWEEN ISNULL(dre.edad_desde, -1) AND ISNULL(dre.edad_hasta, 999)
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