USE [bd_staging_2025_G06]
GO

/****** Object:  Table [dbo].[stg_discounts_G06]    Script Date: 25/05/2025 19:38:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_discounts_G06](
	[DISCOUNT_ID] [int] NULL,
	[FROM] [datetime] NULL,
	[UNTIL] [datetime] NULL,
	[TOTAL_BILLING] [float] NULL,
	[PERCENTAGE] [smallint] NULL
) ON [PRIMARY]
GO

