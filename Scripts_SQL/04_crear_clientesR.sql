USE [bd_staging_2025_G06]
GO

/****** Object:  Table [dbo].[stg_clientes_R_G06]    Script Date: 25/05/2025 21:27:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_clientes_R_G06](
	[CUSTOMER_ID] [int] NULL,
	[FULL_NAME] [nvarchar](255) NULL,
	[BIRTH_DATE] [nvarchar](255) NULL,
	[CITY] [nvarchar](255) NULL,
	[STATE] [nvarchar](255) NULL,
	[ZIPCODE] [bigint] NULL
) ON [PRIMARY]
GO

