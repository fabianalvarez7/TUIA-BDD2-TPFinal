USE [bd_staging_2025_G06]
GO

/****** Object:  Table [dbo].[stg_empleados_G06]    Script Date: 25/05/2025 19:38:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_empleados_G06](
	[EMPLOYEE_ID] [float] NULL,
	[FULL_NAME] [nvarchar](255) NULL,
	[CATEGORY] [nvarchar](255) NULL,
	[EMPLOYMENT_DATE] [nvarchar](255) NULL,
	[BIRTH_DATE] [nvarchar](255) NULL,
	[EDUCATION_LEVEL] [nvarchar](255) NULL,
	[GENDER] [nvarchar](255) NULL
) ON [PRIMARY]
GO

