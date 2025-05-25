USE [bd_staging_2025_G06]
GO

/****** Object:  Table [dbo].[stg_feriados_G06]    Script Date: 25/05/2025 19:38:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_feriados_G06](
	[DATE] [datetime] NULL,
	[HOLIDAY] [nvarchar](255) NULL
) ON [PRIMARY]
GO

