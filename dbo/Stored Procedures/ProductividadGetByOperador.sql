create procedure [dbo].[ProductividadGetByOperador]
  @IdPlanificacion decimal(18,0)
, @IdOperador bigint = NULL

As

	Select
		  IdEjecucionPlanificacion
		, IdDetallePlanificacion
		, IdPlanificacion
		, IdOperador
		, NombreOperador 
		, Fecha
		, HoraInicioPlanificacion
		, HoraFinPlanificacion
		, Descanso
		, IdTienda
		, NombreTienda
		, HoraInicioEjecucion
		, HoraFinEjecucion
		, IncentivoFactura
		, DescuentoTardanza
		, MontoHorasExtras
		, TardanzaEnMinutos
		, HorasExtrasEnMinutos
		, Justificacion
		, Dia
		, Spot
		, IdCliente
		, NombreCliente
		, IdEstado
		, NombreEstado
		, Salario
		, MontoDiario
		, NumTarjeta
		, SMG
		, SubTotal
		, CuentaBancaria
		, IdBanco
		, NombreBanco
		, Case When TardanzaEnMinutos > 0 or HorasExtrasEnMinutos < 0 Then 'R' When HorasExtrasEnMinutos > 0 Then 'A' else 'N' end Accion
		, IdVehiculo
		, IdTipoVehiculo
		, IdTarjeta
		, NombreVehiculo
	From vw_Productividad
	Where IdPlanificacion = @IdPlanificacion
		And ((@IdOperador Is Null) Or (IdOperador = @IdOperador))
	Order by IdOperador asc
