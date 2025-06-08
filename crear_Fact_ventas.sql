-- Creación de Fact Ventas

with CTE_Total_Facturado AS(
	select v.billing_id, v.date, SUM(v.quantity) * SUM(p.PRICE) AS total_facturado
	from dbo.Tmp_Fact_Ventas v  --1.676.294 filas
		left join dbo.Precios_DW p  --con inner join 1.642.971 quedan sin precios
			on v.product_id = p.PRODUCT_ID
			and v.date >= p.[FROM]
			and (v.date < p.UNTIL or p.UNTIL is null)
		group by v.billing_id, v.date
),

	CTE_Descuentos AS(
		select v.billing_id, v.date, v.total_facturado, isnull (MAX(d.PERCENTAGE,/100.00), 0.00) AS descuento
		from CTE_Total_Facturado v  --1.656.457 filas
			left join dbo.Descuentos_DW d
				on v.date >= d.[FROM]
				and (v.date < d.UNTIL or d.UNTIL is null)
				and v.total_facturado > d.TOTAL_BILLING
			group by v.billing_id, v.date, v.total_facturado
)

select v. *
	,v.quantity * p.PRICE AS total_facturado
	,v.quantity * p.PRICE * (1 - d.Descuentos_DW) AS total_facturado_con_descuento
	,p.PRICE
	,d.descuento
	--, case when pr.EsLata = 1 then v.quantity else 0 end Cantidad_Latas
	--, case when pr.Medida = 'Liter' then pr.Capacidad * v.quantity else (pr.Capacidad / 1000.00) * v.quantity end Cantidad_Litros_Vendidos


-- Agrego las FK de las dimensiones
,pr.Productos_FK
,convert(int, convert(varchar(8), v.date,112)) AS Tiempo_FK


from dbo.Tmp_Fact_Ventas v  --1.676.294 filas
	left join dbo.Precios_DW p  --con inner join 1.642.971 quedan sin precios
		on v.product_id = p.PRODUCT_ID
		and v.date >= p.[FROM]
		and (v.date < p.UNTIL or p.UNTIL is null)

	left join CTE_Descuentos d
		on v.billing_id = d.billing_id

	left join [bd_datawarehouse_2025_G06].dbo.Dim_Productos pr
		on v.Product_id = pr.Product_ID
