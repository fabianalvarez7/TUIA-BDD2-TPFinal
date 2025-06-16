USE [datawarehouse_2025_G06]
GO

CREATE TABLE datawarehouse_2025_G06.dbo.LogErroresVentas_G06(
	billing_id int,
	product_id int,
	quantity int,
	motivo_error varchar(255),
	fecha_registro datetime default getdate()
);


INSERT INTO datawarehouse_2025_G06.dbo.LogErroresVentas_G06
	(billing_id, product_id, quantity, motivo_error)

SELECT
	billing_id,
	product_id,
	quantity,
	'Falta fecha, cliente, empleado y región'
FROM bd_intermedia_2025_G06.dbo.int_ventas_G06
WHERE
	date IS NULL
	OR customer_id IS NULL
	OR employee_id IS NULL
	OR region IS NULL;