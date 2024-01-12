CREATE PROCEDURE [dbo].[ReporteImporteCombustibleAsignado]

@FechaIni DATETIME = NULL,
@FechaEnd DATETIME = NULL,
@IdTienda INT = NULL,
@IdCoordinador INT = NULL	

AS

	SELECT
		DISTINCT
		tienda.IdTienda
		, tienda.NombreTienda Tienda
		, ejecucion.IdOperador
		, CONCAT(oper.Nombres, ' ', oper.ApellidoPaterno, ' ', oper.ApellidoMaterno) Operador
		, tarjeta.NumTarjeta NumTarjetaGasolina
		, ejecucion.MontoCombustible ImporteGasolina
		, ejecucion.Fecha FechaDisperción
	FROM tbl_EjecucionPlanificacion ejecucion
	INNER JOIN tbl_Planificacion pl
		ON ejecucion.IdPlanificacion = pl.IdPlanificacion
	INNER JOIN tbl_Empleados oper
		ON ejecucion.IdOperador = oper.IdEmpleado
	INNER JOIN tbl_Tienda tienda
		ON ejecucion.IdTienda = tienda.IdTienda
	INNER JOIN tbl_AsignacionTarjeta tarjeta
		ON ejecucion.IdOperador = tarjeta.IdEmpleado
	WHERE ISNULL(ejecucion.IdTienda, '') = CASE WHEN @IdTienda IS NULL THEN ISNULL(ejecucion.IdTienda, '') ELSE @IdTienda END
    AND ejecucion.Fecha BETWEEN @FechaIni AND @FechaEnd
    AND ISNULL(pl.IdCoordinador, '') = CASE WHEN @IdCoordinador IS NULL THEN ISNULL(pl.IdCoordinador, '') ELSE @IdCoordinador END
    AND ejecucion.MontoCombustible > 0    
