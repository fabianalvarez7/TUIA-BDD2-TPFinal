USE [datawarehouse_2025_G06]
GO
-- Vaciar la tabla
TRUNCATE TABLE dbo.Dim_tiempo_G06;

-- Generar las fechas
DECLARE @vFechaDesde DATE = '1900-01-01';
DECLARE @vFechaHasta DATE = '2099-12-31';

WITH Fechas (Fecha) AS (
    SELECT @vFechaDesde
    UNION ALL
    SELECT DATEADD(DAY, 1, Fecha)
    FROM Fechas
    WHERE Fecha < @vFechaHasta
)

INSERT INTO [dbo].[Dim_tiempo_G06] (
    Fecha_key, Fecha, Dia, Mes, NombreMes, Año, Trimestre, Semestre,
    DiaSemana, NombreDiaSemana, Semana, DiaAño
)
SELECT
	CONVERT(INT, CONVERT(VARCHAR(8), Fecha, 112)) AS Fecha_key,
    Fecha,
    DAY(Fecha) AS Dia,
    MONTH(Fecha) AS Mes,
    DATENAME(MONTH, Fecha) AS NombreMes,
    YEAR(Fecha) AS Año,
    DATEPART(QUARTER, Fecha) AS Trimestre,
    (DATEPART(QUARTER, Fecha) + 1) / 2 AS Semestre,
    DATEPART(WEEKDAY, Fecha) AS DiaSemana,
    DATENAME(WEEKDAY, Fecha) AS NombreDiaSemana,
    DATEPART(WEEK, Fecha) AS Semana,
    DATEPART(DAYOFYEAR, Fecha) AS DiaAño
FROM Fechas
OPTION (MAXRECURSION 0);
