USE [bd_staging_2025_G06]
GO

/****** Object:  Table [dbo].[stg_prices_G06]    Script Date: 25/05/2025 19:39:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_prices_G06](
	[PRODUCT_ID] [int] NULL,
	[DATE] [datetime] NULL,
	[PRICE] [float] NULL
) ON [PRIMARY]
GO

