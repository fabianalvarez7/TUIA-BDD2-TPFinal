
-- La cantidad de registros en la tabla de ventas de la bd intermedia es 1.676.294
-- Pero en Fact_Ventas hay 273.857 registros
-- Se descartaron 1.306
-- Se redujeron 1.4 millones aprox. por la agrupación por facturas y fechas


-- ¿Cuántos productos se vendieron por factura en int_ventas_G06?
SELECT 
    billing_id,
    COUNT(*) AS cantidad_productos_en_factura
FROM dbo.int_ventas_G06
GROUP BY billing_id
ORDER BY cantidad_productos_en_factura DESC;


-- Ver cuántas facturas tienen más de una línea de producto
SELECT 
    cantidad_productos_en_factura,
    COUNT(*) AS cantidad_facturas
FROM (
    SELECT billing_id, COUNT(*) AS cantidad_productos_en_factura
    FROM dbo.int_ventas_G06
    GROUP BY billing_id
) AS facturas
GROUP BY cantidad_productos_en_factura
ORDER BY cantidad_productos_en_factura DESC;


-- Ver una factura con varias líneas
SELECT *
FROM dbo.int_ventas_G06
WHERE billing_id = 327713  -- Usar un billing_id de los que tengan varias líneas
