USE [bd_staging_2025_G06]
GO

/****** Object:  Table [dbo].[stg_regiones_G06]    Script Date: 25/05/2025 19:39:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_regiones_G06](
	[Region] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[ZipCode] [varchar](50) NULL
) ON [PRIMARY]
GO

