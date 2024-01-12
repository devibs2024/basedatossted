
CREATE View [dbo].[vw_Productividad]

As

Select
 Ejecucion.IdDetallePlanificacion
, Ejecucion.IdEjecucionPlanificacion
, Ejecucion.IdPlanificacion
, Ejecucion.IdTienda
, Tda.NombreTienda
, cte.IdCliente
, cte.NombreCliente
, est.IdEstado
, est.NombreEstado
, Ejecucion.IdOperador
, concat_WS(' ',Oper.Nombres,Oper.ApellidoPaterno,Oper.ApellidoMaterno) NombreOperador
, Case Oper.IdSegmento when 3 then 1 else 0 end Spot
, Ejecucion.Fecha
, Isnull(Detalle.HoraInicio, '00:00:00') as HoraInicioPlanificacion
, Ejecucion.HoraInicio as HoraInicioEjecucion
, DATEDIFF(MINUTE, Isnull(Detalle.HoraInicio,'00:00:00'), Ejecucion.HoraInicio) AS TardanzaEnMinutos
, IsNull(Detalle.HoraFin,'00:00:00') as HoraFinPlanificacion
, Ejecucion.HoraFin as HoraFinEjecucion
, DATEDIFF(MINUTE, Isnull(Detalle.HoraFin,'00:00:00'), Ejecucion.HoraFin) AS HorasExtrasEnMinutos
, DATEPART(day, Ejecucion.Fecha) Dia
, Ejecucion.TipoRegistro
, Ejecucion.Descanso
, Ejecucion.DescuentoTardanza
, Ejecucion.IncentivoFactura
, Ejecucion.MontoHorasExtras
, Ejecucion.Justificacion
, Oper.Salario
, Ejecucion.MontoCombustible MontoDiario
, tc.NumTarjeta
, Oper.SMG
, ((Oper.Salario + Ejecucion.IncentivoFactura + Ejecucion.MontoHorasExtras + tc.MontoDiario) - Ejecucion.DescuentoTardanza) SubTotal
, cta.CuentaBancaria
, bco.IdBanco
, bco.NombreBanco
From tbl_EjecucionPlanificacion Ejecucion
	Left Join tbl_DetallePlanificacion Detalle
		On Detalle.IdPlanificacion  =  Ejecucion.IdPlanificacion
	   And Detalle.IdDetallePlanificacion =  Ejecucion.IdDetallePlanificacion
	   And Detalle.IdOperador = Ejecucion.IdOperador
	Inner Join tbl_Tienda Tda
		On Ejecucion.IdTienda = tda.IdTienda
	Inner Join tbl_ZonaSted ZnaSted
		On Tda.IdZonaSted = ZnaSted.IdZonaSted
	Inner Join tbl_Cliente cte
		On ZnaSted.IdCliente = cte.IdCliente
	Inner Join tbl_CatalogoEstado est
		On tda.IdEstado = est.IdEstado
	Inner Join tbl_Empleados Oper
		On Ejecucion.IdOperador = Oper.IdEmpleado
	Inner Join tbl_AsignacionTarjeta tc
		On oper.IdEmpleado = tc.IdEmpleado
		And tc.Activa = 1 And tc.TarjetaPrincipal = 1
	Inner Join tbl_EmpleadoCuentaBancaria cta
		On cta.IdEmpleado = oper.IdEmpleado
		And cta.Activa = 1 And cta.CuentaPrincipal = 1
	Inner Join tbl_CatalogoBancos bco
		On cta.IdBanco = bco.IdBanco

