USE [bd_datawarehouse_2025_G06]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Dim_Fechas](
	[Fecha] [date] PRIMARY KEY,
	[Dia][tinyint] NULL,
	[Mes] [tinyint] NULL,
	[NombreMes] [varchar] (16) NULL,
	[A�o] [int] NULL,
	[Trimestre] [tinyint] NULL,
	[Semestre] [tinyint] NULL,
	[DiaSemana] [tinyint] NULL,
	[NombreDiaSemana] [varchar] (16) NULL,
	[Semana] [tinyint] NULL,
	[DiaA�o] [smallint] NULL
) ON [PRIMARY]
GO