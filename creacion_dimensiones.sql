-- Creación de las dimensiones del data warehouse con sus claves subrogadas

USE [datawarehouse_2025_G06]


CREATE TABLE dbo.Dim_Productos_G06 (
    producto_key INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,  -- clave natural (de sistema fuente)
    detail NVARCHAR(255),
	package NVARCHAR(255),
    tipo_bebida NVARCHAR(50),
    unidad_medida NVARCHAR(10),  -- 'Liter', 'cm3'
    capacidad FLOAT,
    es_lata BIT,
    es_diet BIT
);

CREATE TABLE dbo.Dim_Clientes_G06 (
    cliente_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,      -- clave natural
    full_name NVARCHAR(255),
    birth_date DATE,
    city NVARCHAR(255),
    state NVARCHAR(255),
    zipcode BIGINT,
	tipo_cliente NVARCHAR(50)
);

CREATE TABLE dbo.Dim_Empleados_G06 (
    empleado_key INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,  -- clave natural
    full_name NVARCHAR(255),
    category NVARCHAR(255),
	employment_date DATE,
    birth_date DATE,
	education_level NVARCHAR(255),
    gender NVARCHAR(255)
);

CREATE TABLE dbo.Dim_Rango_Etario_G06 (
    rango_etario_id INT IDENTITY(1,1) PRIMARY KEY,
    edad_desde INT,
    edad_hasta INT,
    nombre_rango NVARCHAR(50)
);

CREATE TABLE [dbo].[Dim_tiempo_G06](
	[Fecha_key] [int] PRIMARY KEY,	-- Clave primaria en formato yyyymmdd
	[Fecha] [date] NOT NULL,  -- Clave natural
	[Dia] [tinyint] NULL,
	[Mes] [tinyint] NULL,
	[NombreMes] [varchar](16) NULL,
	[Año] [int] NULL,
	[Trimestre] [tinyint] NULL,
	[Semestre] [tinyint] NULL,
	[DiaSemana] [tinyint] NULL,
	[NombreDiaSemana] [varchar](16) NULL,
	[Semana] [tinyint] NULL,
	[DiaAño] [smallint] NULL,
);