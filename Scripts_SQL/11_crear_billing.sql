USE [bd_staging_2025_G06]
GO

/****** Object:  Table [dbo].[stg_billing_G06]    Script Date: 25/05/2025 19:38:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_billing_G06](
	[BILLING_ID] [int] NULL,
	[REGION] [nvarchar](90) NULL,
	[BRANCH_ID] [int] NULL,
	[DATE] [datetime] NULL,
	[CUSTOMER_ID] [smallint] NULL,
	[EMPLOYEE_ID] [smallint] NULL
) ON [PRIMARY]
GO

