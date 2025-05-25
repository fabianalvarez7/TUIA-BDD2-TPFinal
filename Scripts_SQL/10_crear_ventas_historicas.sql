USE [bd_staging_2025_G06]
GO

/****** Object:  Table [dbo].[stg_ventas_historicas_G06]    Script Date: 25/05/2025 19:39:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_ventas_historicas_G06](
	[id] [int] NULL,
	[billing_id] [int] NULL,
	[date] [datetime] NULL,
	[customer_id] [int] NULL,
	[employee_id] [int] NULL,
	[product_id] [int] NULL,
	[quantity] [int] NULL,
	[region] [varchar](45) NULL
) ON [PRIMARY]
GO

