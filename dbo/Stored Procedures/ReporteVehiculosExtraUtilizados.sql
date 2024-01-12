
CREATE PROCEDURE [dbo].[ReporteVehiculosExtraUtilizados]

@fechaIni DATETIME,
@fechaEnd DATETIME,
@ColumnHeaders VARCHAR(MAX),
@IdPlanificacion VARCHAR(MAX),
@ColumnHeaderSpot VARCHAR(MAX)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT @ColumnHeaderSpot = 
			COALESCE(
				@ColumnHeaderSpot + ',[' + CAST([Fecha] As varchar) + ']', '[' + CAST([Fecha] AS varchar) + ']'
			)
			FROM tbl_EjecucionPlanificacion a
			INNER JOIN tbl_Empleados b ON a.IdOperador = b.IdEmpleado
			WHERE Fecha BETWEEN @fechaIni AND @fechaEnd AND b.IdSegmento = 3


			SELECT @ColumnHeaders = 
			COALESCE(
				@ColumnHeaders + ',[' + CAST([Fecha] AS varchar) + ']', '[' + CAST([Fecha] AS varchar) + ']', CONVERT(char, IdOperador) 
			)
			FROM tbl_EjecucionPlanificacion
			WHERE Fecha BETWEEN @fechaIni AND @fechaEnd AND IdPlanificacion = @IdPlanificacion
			GROUP BY [Fecha], IdOperador


			DECLARE @TableSQL NVARCHAR(MAX)

			SET @TableSQL = N'
				SELECT
					DISTINCT 
					 IdPlanificacion, 
					 Tienda,
					 Operador,
					 TipoVehiculo,
					 UnidadesSpot,
					 ' + @ColumnHeaders + ',
					 TotalUtilizadas
         
				FROM (
					SELECT
					  DISTINCT  
					  a.IdPlanificacion
					, c.NombreTienda Tienda
					, b.Nombres Operador        
					, f.TipoVehiculo
					, c.CntEmpleadosSpot UnidadesSpot        
					, a.Fecha
					, COUNT(a.IdEjecucionPlanificacion) Cantidad
					, SUM(a.IdEjecucionPlanificacion) TotalUtilizadas
					FROM tbl_EjecucionPlanificacion a
					INNER JOIN tbl_Empleados b ON a.IdOperador = b.IdEmpleado
					INNER JOIN tbl_Tienda c ON a.IdTienda = c.IdTienda
					INNER JOIN tbl_VehiculoOperador d ON a.IdOperador = d.IdEmpleado
					INNER JOIN tbl_Vehiculo e ON d.IdVehiculo = e.IdVehiculo
					INNER JOIN tbl_CatalogoTipoVehiculo f ON e.IdTipoVehiculo = f.IdTipoVehiculo               
					GROUP BY Fecha, IdPlanificacion, IdPlanificacion, c.NombreTienda, b.Nombres, f.TipoVehiculo, c.CntEmpleadosSpot                
				) AS PivotData
				PIVOT(
					SUM(Cantidad) FOR [Fecha] IN(' + @ColumnHeaders + ')
				) AS PivotTable
				ORDER BY IdPlanificacion
			'
			EXECUTE(@TableSQL)

END