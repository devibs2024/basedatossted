-- =============================================
-- Author: José Carbajal Huerta
-- Create date: 28.10.2023
-- Description:	Realiza el calculo de nomina de los operadores, con filtro por fechas, coordinador y operador
-- =============================================
CREATE PROCEDURE [dbo].[CalculoNominaProductividadResp]
	-- Add the parameters for the stored procedure here
@FechaIni DATETIME = NULL,
@FechaEnd DATETIME = NULL,
@IdCoordinador INT = NULL,
@IdOperador INT = NULL,
@IdPlanificacion INT = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
            Ejecucion.IdOperador
            , CONCAT(Oper.Nombres, ' ', Oper.ApellidoPaterno, ' ', Oper.ApellidoMaterno) Nombre
            , Oper.Salario    
            , CONCAT(cta.CuentaBancaria, ' ', bco.NombreBanco) Banco
            , pl.IdCoordinador
            , (SELECT CONCAT(Nombres, ' ', ApellidoPaterno, ' ', ApellidoMaterno)  FROM tbl_Empleados WHERE IdTipoEmpleado = 2 AND IdEmpleado = pl.IdCoordinador) Coordinador
            , Tda.NombreTienda Tienda
            , ZnaSted.NombreZona ZonaSted
            , Ejecucion.Fecha
            , DAY(Ejecucion.Fecha) Dia
            , Ejecucion.HoraInicio
            , Ejecucion.HoraFin
            , DATEDIFF(HOUR, Ejecucion.HoraInicio, Ejecucion.HoraFin) Horas
            , COUNT(Ejecucion.IdDetallePlanificacion) * Oper.Salario SubTotal
            , Ejecucion.MontoCombustible Gasolina
            , Ejecucion.MontoHorasExtras HorasExtra
            , DATEDIFF(MINUTE, Isnull(Detalle.HoraInicio,'00:00:00'), Ejecucion.HoraInicio) MinutosRetardo
            , DATEDIFF(MINUTE, Isnull(Detalle.HoraInicio,'00:00:00'), Ejecucion.HoraInicio) * 1.5 DescuentoRetardo
            , Oper.SMG PagoSMG
            , COUNT(Ejecucion.IdDetallePlanificacion) / 600 DescuentoSted
            -- , SUM
            --     (
            --         (COUNT(Ejecucion.IdDetallePlanificacion) * Oper.Salario) +
            --         Ejecucion.MontoCombustible +
            --         Ejecucion.MontoHorasExtras +
            --         Oper.SMG -
            --         DATEDIFF(MINUTE, Isnull(Detalle.HoraInicio,'00:00:00'), Ejecucion.HoraInicio) * 1.5 -
            --         600
                    
            --     ) Total
FROM tbl_EjecucionPlanificacion Ejecucion    
	LEFT JOIN tbl_DetallePlanificacion Detalle
		ON Detalle.IdPlanificacion  =  Ejecucion.IdPlanificacion
	   AND Detalle.IdDetallePlanificacion =  Ejecucion.IdDetallePlanificacion
	   AND Detalle.IdOperador = Ejecucion.IdOperador
	INNER JOIN tbl_Tienda Tda
		ON Ejecucion.IdTienda = tda.IdTienda
	INNER JOIN tbl_ZonaSted ZnaSted
		ON Tda.IdZonaSted = ZnaSted.IdZonaSted
	INNER JOIN tbl_Cliente cte
		ON ZnaSted.IdCliente = cte.IdCliente
	INNER JOIN tbl_CatalogoEstado est
		ON tda.IdEstado = est.IdEstado
	INNER JOIN tbl_Empleados Oper
		ON Ejecucion.IdOperador = Oper.IdEmpleado
	INNER JOIN tbl_AsignacionTarjeta tc
		ON oper.IdEmpleado = tc.IdEmpleado
		AND tc.Activa = 1 AND tc.TarjetaPrincipal = 1
	INNER JOIN tbl_EmpleadoCuentaBancaria cta
		ON cta.IdEmpleado = oper.IdEmpleado
		AND cta.Activa = 1 AND cta.CuentaPrincipal = 1
	INNER JOIN tbl_CatalogoBancos bco
		ON cta.IdBanco = bco.IdBanco
    INNER JOIN tbl_Planificacion pl ON Detalle.IdPlanificacion = pl.IdPlanificacion
WHERE Ejecucion.Fecha BETWEEN @FechaIni AND @FechaEnd
AND DATEDIFF(HOUR, Ejecucion.HoraInicio, Ejecucion.HoraFin) >= 8
AND ((@IdCoordinador IS NULL) OR (pl.IdCoordinador = @IdCoordinador))
AND ((@IdOperador IS NULL) OR (Ejecucion.IdOperador = @IdOperador))
AND ((@IdPlanificacion IS NULL) OR (Ejecucion.IdPlanificacion = @IdPlanificacion)) 
GROUP BY Ejecucion.IdOperador, Oper.Nombres, Oper.ApellidoPaterno, Oper.ApellidoMaterno, Oper.Salario, cta.CuentaBancaria, bco.NombreBanco, 
            pl.IdCoordinador, Tda.NombreTienda, ZnaSted.NombreZona, Ejecucion.Fecha, Ejecucion.HoraInicio, Ejecucion.HoraFin, Ejecucion.MontoCombustible, 
            Ejecucion.MontoHorasExtras, Detalle.HoraInicio, Detalle.HoraFin, Oper.SMG

END
