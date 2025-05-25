USE [bd_staging_2025_G06]
GO

/****** Object:  Table [dbo].[stg_billing_detail_G06]    Script Date: 25/05/2025 19:37:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_billing_detail_G06](
	[BILLING_ID] [int] NULL,
	[PRODUCT_ID] [smallint] NULL,
	[QUANTITY] [smallint] NULL
) ON [PRIMARY]
GO

