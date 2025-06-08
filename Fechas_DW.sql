USE [bd_datawarehouse_2025_G06]
GO


DECLARE @vFechaDesde DATE = '1900-01-01';
DECLARE @vFechaHasta DATE = '2099-12-31';

WITH Fechas (Fecha) AS (
    SELECT @vFechaDesde
    UNION ALL
    SELECT DATEADD(DAY, 1, Fecha)
    FROM Fechas
    WHERE Fecha < @vFechaHasta
)
INSERT INTO [dbo].[Dim_Fechas] (
    Fecha, Dia, Mes, NombreMes, Año, Trimestre, Semestre,
    DiaSemana, NombreDiaSemana, Semana, DiaAño
)
SELECT
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
