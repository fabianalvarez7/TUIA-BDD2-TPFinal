--Registros que no llegan a la fact_ventas y sus motivos

USE bd_intermedia_2025_G06;
GO

SELECT 
    v.id AS venta_id,
    v.product_id,
    v.customer_id,
    v.employee_id,
    v.date,
    CASE
        WHEN dp.producto_key IS NULL THEN 'Producto sin clave en dimensión'
        WHEN dc.cliente_key IS NULL THEN 'Cliente sin clave en dimensión'
        WHEN de.empleado_key IS NULL THEN 'Empleado sin clave en dimensión'
        WHEN p.PRICE IS NULL THEN 'Producto sin precio válido'
        ELSE 'Otro motivo'
    END AS motivo_descarte
FROM dbo.int_ventas_G06 v

-- LEFT JOIN dimensiones del DW
LEFT JOIN datawarehouse_2025_G06.dbo.Dim_Productos_G06 dp
    ON v.product_id = dp.product_id

LEFT JOIN datawarehouse_2025_G06.dbo.Dim_Clientes_G06 dc
    ON v.customer_id = dc.customer_id

LEFT JOIN datawarehouse_2025_G06.dbo.Dim_Empleados_G06 de
    ON v.employee_id = de.employee_id

-- LEFT JOIN precios con lógica de rango válida
LEFT JOIN bd_intermedia_2025_G06.dbo.int_precios_G06 p
    ON v.product_id = p.PRODUCT_ID
   AND v.date >= p.[FROM]
   AND (v.date <= p.UNTIL OR p.UNTIL IS NULL)

-- Solo mostrar los que NO fueron cargados
WHERE 
    dp.producto_key IS NULL
    OR dc.cliente_key IS NULL
    OR de.empleado_key IS NULL
    OR p.PRICE IS NULL;


--Agrupar para saber cuántos registros se descartan por cada causa

SELECT motivo_descarte, COUNT(*) AS cantidad
FROM (
		SELECT 
    v.id AS venta_id,
    v.product_id,
    v.customer_id,
    v.employee_id,
    v.date,
    CASE
        WHEN dp.producto_key IS NULL THEN 'Producto sin clave en dimensión'
        WHEN dc.cliente_key IS NULL THEN 'Cliente sin clave en dimensión'
        WHEN de.empleado_key IS NULL THEN 'Empleado sin clave en dimensión'
        WHEN p.PRICE IS NULL THEN 'Producto sin precio válido'
        ELSE 'Otro motivo'
    END AS motivo_descarte
FROM dbo.int_ventas_G06 v

-- LEFT JOIN dimensiones del DW
LEFT JOIN datawarehouse_2025_G06.dbo.Dim_Productos_G06 dp
    ON v.product_id = dp.product_id

LEFT JOIN datawarehouse_2025_G06.dbo.Dim_Clientes_G06 dc
    ON v.customer_id = dc.customer_id

LEFT JOIN datawarehouse_2025_G06.dbo.Dim_Empleados_G06 de
    ON v.employee_id = de.employee_id

-- LEFT JOIN precios con lógica de rango válida
LEFT JOIN bd_intermedia_2025_G06.dbo.int_precios_G06 p
    ON v.product_id = p.PRODUCT_ID
   AND v.date >= p.[FROM]
   AND (v.date <= p.UNTIL OR p.UNTIL IS NULL)

-- Solo mostrar los que NO fueron cargados
WHERE 
    dp.producto_key IS NULL
    OR dc.cliente_key IS NULL
    OR de.empleado_key IS NULL
    OR p.PRICE IS NULL
) AS descartes
GROUP BY motivo_descarte
ORDER BY cantidad DESC;
