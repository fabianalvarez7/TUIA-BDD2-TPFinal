INSERT INTO [bd_datawarehouse_2025_G06].[dbo].[Dim_Productos_G06](
	Product_ID
	,Detail
	,Tipo_Producto
	,Package
	,col_capacidad
	,col_medida
	,col_extra
	,Capacidad
	,Unidad_Medida
	,Es_Lata
	,Capacidad_cm3
)


SELECT
	t.Product_ID,
	t.Detail,

-- Última palabra en Detail
	Tipo_Producto =	RIGHT(
		TRIM(t.Detail),
			CHARINDEX(' ', REVERSE(TRIM(t.Detail))) - 1
	),
	
-- Dejamos el Package original
	t.Package,

-- Separamos en partes con OPENJSON
	parts.[1] AS col_capacidad,
	parts.[2] AS col_medida,
	parts.[3] AS col_extra,

-- Capacidad en números
	Capacidad = TRY_CAST(parts.[1] AS INT),

-- Unidad de medida (litro, cm3)
	Unidad_Medida = parts.[2],

-- ¿Es lata? Última parte de Package --> 'can' = lata
	Es_Lata = CASE
				WHEN parts.[3] IN ('can', 'lata') THEN 'Si'
				ELSE 'No'
			  END,
			  
-- Capacidad en cm3
	Capacidad_cm3 = CASE
						WHEN parts.[2] IN ('Liter', 'L', 'litro', 'litros')
							THEN TRY_CAST(parts.[1] AS FLOAT) * 1000
						WHEN parts.[2] IN ('cm3', 'ml')
							THEN TRY_CAST(parts.[1] AS FLOAT)
						ELSE NULL
					END

FROM [bd_staging_2025_G06].[dbo].[stg_productos_G06] AS t
CROSS APPLY (
-- Convertimos "x y [z]" a JSON array ["x", "y", "z"]
	SELECT
		MAX(CASE WHEN [key] = 0 THEN value END) AS [1],
		MAX(CASE WHEN [key] = 1 THEN value END) AS [2],
		MAX(CASE WHEN [key] = 2 THEN value END) AS [3],
	FROM OPENJSON(
		'["' + REPLACE(t.Package, ' ', '", "') + '"]'
	)
)
