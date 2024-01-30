/*==================================================================================================*/
-- Producto:		INTERNATIONAL BUSINESS SOLUTION DE MEXICO | STED - Traslados
-- Autor:			Benito Mora Cruz (Mocbana)
-- Fecha:           11 de Enero del 2024
-- Descripción:		Stored Procedure | Calculo de Nomina
/*==================================================================================================*/

CREATE PROCEDURE [dbo].[CalculoNominaProductividad]

@IdPlanificacion				INT					= NULL,
@IdCoordinador					INT					= NULL,
@IdOperador						INT					= NULL,
@IdTienda						INT					= NULL,

@FechaIni						DATETIME			= NULL,
@FechaEnd						DATETIME			= NULL

AS

SET NOCOUNT ON
SET XACT_ABORT ON

declare @SQL					nvarchar(max)
declare @Mensaje				varchar(max)				

declare @Row					int
declare @Reg					int

declare @IdProcesoNomina		DECIMAL (18)
declare @Fecha					datetime
declare @Dias					int

begin try

	--##############################################################################################
	---### DEFAULT
	
	set @IdPlanificacion		= iif(isnull(@IdPlanificacion,0) <= 0, null, @IdPlanificacion)
	set @IdCoordinador			= iif(isnull(@IdCoordinador,0) <= 0, null, @IdCoordinador)
	set @IdOperador				= iif(isnull(@IdOperador,0) <= 0, null, @IdOperador)
	set @IdTienda				= iif(isnull(@IdTienda,0) <= 0, null, @IdTienda)
	set @Fecha					= getdate()

    --##############################################################################################
	--# TABLAS TEMPORALES
	
	if object_id('tempdb..#TMP_Dias')				is not null drop table #TMP_Dias
	if object_id('tempdb..#TMP_CalculoNomina')		is not null drop table #TMP_CalculoNomina
	if object_id('tempdb..#TMP_ComprobanteNomina')	is not null drop table #TMP_ComprobanteNomina

	if object_id('tempdb..#TMP_Dias')				is null begin

		create table #TMP_Dias
		(
			[Anio]						INT,
			[Mes]						INT,
			[Dia]						INT,
			[Sol]						INT,
			[Spot]						INT,
			[Tot]						INT
		)

	end

	if object_id('tempdb..#TMP_CalculoNomina')		is null begin

		create table #TMP_CalculoNomina
		(    
			
			IdEjecucionPlanificacion	BIGINT,				
			IdDetallePlanificacion		BIGINT,				
			IdPlanificacion				BIGINT,				
			IdOperador					INT,
			IdCoordinador				INT,
			IdTienda					INT,				
			
			--*** DATA
			Fecha						DATETIME,
			Dia							INT,
			
			HoraInicio					TIME(7),
			HoraFin						TIME(7),
			Horas						INT,
			MinutosRetardo				INT,
			
			IncentivoFactura			DECIMAL(19,6),
			DescuentoTardanza			DECIMAL(19,6),
			MontoHorasExtras			DECIMAL(19,6),
			MontoCombustible			DECIMAL(19,6),
			Descanso					BIT,

			Accion						VARCHAR(50),		
		)

	end

	if object_id('tempdb..#TMP_ComprobanteNomina')	is null begin

		select 
			* 
		into #TMP_ComprobanteNomina
		from tbl_ComprobanteNomina
		where 1 = 2

	end

	--##############################################################################################
	--#### DEPURANDO PROCESO

	update tbl_ProcesoNomina set
		IsDeleted					= 1
	where	isnull(Procesado,0)		= 0 
		and IdPlanificacion			= @IdPlanificacion 
		and isnull(IdCoordinador,0)	= isnull(@IdCoordinador, isnull(IdCoordinador,0))

	update tbl_ComprobanteNomina set
		IsDeleted					= 1
	where	IdProcesoNomina			in (select IdProcesoNomina from tbl_ProcesoNomina where isnull(IsDeleted,0) = 1)

	update tbl_EjecucionPlanificacion set
		IdProcesoNomina				= null,
		IdComprobanteNomina			= null
	where IdProcesoNomina			in (select IdProcesoNomina from tbl_ProcesoNomina where isnull(IsDeleted,0) = 1)

	--##############################################################################################
	--#### DATA | DETALLE DE NOMINA
	
	set @Fecha = @FechaIni
	while @Fecha <= @FechaEnd begin

		insert into #TMP_Dias
		(
			Anio,
			Mes,
			Dia,
			Sol,
			Spot,
			Tot
		)
		select	
			year(@Fecha),
			month(@Fecha),
			day(@Fecha),
			0,
			0,
			0

		set @Fecha = dateadd(day, 1, @Fecha)

	end

	set @SQL = '' 
	set @SQL += char(13) + 'insert into #TMP_CalculoNomina'
	set @SQL += char(13) + '('
	set @SQL += char(13) + '	[IdEjecucionPlanificacion],'
	set @SQL += char(13) + '	[IdDetallePlanificacion],'
	set @SQL += char(13) + '	[IdPlanificacion],'
	set @SQL += char(13) + '	[IdOperador],'
	set @SQL += char(13) + '	[IdCoordinador],'
	set @SQL += char(13) + '	[IdTienda],'
	set @SQL += char(13) + ''
	set @SQL += char(13) + '	[Fecha],'
	set @SQL += char(13) + '	[HoraInicio],'
	set @SQL += char(13) + '	[HoraFin],'
	set @SQL += char(13) + ''
	set @SQL += char(13) + '	[IncentivoFactura],'
	set @SQL += char(13) + '	[DescuentoTardanza],'
	set @SQL += char(13) + '	[MontoHorasExtras],'
	set @SQL += char(13) + '	[MontoCombustible],'
	set @SQL += char(13) + '	[Descanso]'
	set @SQL += char(13) + ')'
	
	set @SQL += char(13) + 'select '
	set @SQL += char(13) + '	EP.[IdEjecucionPlanificacion],'
	set @SQL += char(13) + '	EP.[IdDetallePlanificacion],'
	set @SQL += char(13) + '	EP.[IdPlanificacion],'
	set @SQL += char(13) + '	EP.[IdOperador],'
	set @SQL += char(13) + '	P.[IdCoordinador],'
	set @SQL += char(13) + '	EP.[IdTienda],'
	set @SQL += char(13) + '	EP.[Fecha],'
	set @SQL += char(13) + '	EP.[HoraInicio],'
	set @SQL += char(13) + '	EP.[HoraFin],'
	set @SQL += char(13) + ''
	set @SQL += char(13) + '	EP.[IncentivoFactura],'
	set @SQL += char(13) + '	EP.[DescuentoTardanza],'
	set @SQL += char(13) + '	EP.[MontoHorasExtras],'
	set @SQL += char(13) + '	EP.[MontoCombustible],'
	set @SQL += char(13) + '	EP.[Descanso]'
	set @SQL += char(13) + 'from tbl_EjecucionPlanificacion EP with(NoLock), tbl_DetallePlanificacion DP with(NoLock), tbl_Planificacion P with(NoLock)'
	set @SQL += char(13) + 'where	EP.IdDetallePlanificacion			= DP.IdDetallePlanificacion and EP.IdPlanificacion = DP.IdPlanificacion'
	set @SQL += char(13) + '	and DP.IdPlanificacion					= P.IdPlanificacion'
	set @SQL += char(13) + '	and isnull(EP.IdComprobanteNomina,0)	= 0'
	set @SQL += char(13) + '	and isnull(EP.IdProcesoNomina,0)		= 0'
	set @SQL += char(13) + '	and isnull(EP.IsDeleted,0)				= 0'

	--*** FILTROS

	if isnull(@IdPlanificacion,0) > 0	set @SQL += char(13) + ' and EP.IdPlanificacion		= ' + dbo.funStrInt(@IdPlanificacion)
	if isnull(@IdCoordinador,0) > 0		set @SQL += char(13) + ' and P.IdCoordinador		= ' + dbo.funStrInt(@IdCoordinador)
	if isnull(@IdOperador,0) > 0		set @SQL += char(13) + ' and EP.IdOperador			= ' + dbo.funStrInt(@IdOperador)
	if isnull(@IdTienda,0) > 0			set @SQL += char(13) + ' and EP.IdTienda			= ' + dbo.funStrInt(@IdTienda)

	if isDate(@FechaIni) = 1 and isDate(@FechaEnd) = 1 begin
		Select @SQL += char(13) + ' and EP.Fecha >= ''' + dbo.funFechaStr(@FechaIni, 20, '-') + ''' and EP.Fecha <= ''' + dbo.funFechaStr(@FechaEnd, 20, '-') + ' 23:59'''
	end else if isDate(@FechaIni) = 1 and not isDate(@FechaEnd) = 1 begin
		Select @SQL += char(13) + ' and EP.Fecha >= ''' + dbo.funFechaStr(@FechaIni, 20, '-') + ''''
	end else if not isDate(@FechaIni) = 1 and isDate(@FechaEnd) = 1 begin
		Select @SQL += char(13) + ' and EP.Fecha <= ''' + dbo.funFechaStr(@FechaEnd, 20, '-') + ' 23:59'''
	end

	print(@SQL)
	exec(@SQL)


	--##############################################################################################
	--#### DETALLE NOMINA | CALCULOS

	if isdate(@FechaIni) = 0 select @FechaIni = min(Fecha) from #TMP_CalculoNomina
	if isdate(@FechaEnd) = 0 select @FechaEnd = max(Fecha) from #TMP_CalculoNomina

	update #TMP_CalculoNomina set
		Dia					= day(Fecha),
		Horas				= datediff(hour, HoraInicio, HoraFin),

		MinutosRetardo		= isnull(datediff(minute, isnull(HoraInicio,'00:00:00'), HoraInicio), 0)
	
	update #TMP_CalculoNomina set
		DescuentoTardanza	= isnull(MinutosRetardo,0) * 1.5

	
	--##############################################################################################
	--#### RESUMEN

	if exists(select * from #TMP_CalculoNomina) begin

		set @IdProcesoNomina = null
		
		insert into tbl_ProcesoNomina
		(
			Fecha,
			FechaIni,
			FechaEnd,
		
			IdPlanificacion,
			IdCoordinador,
			IdOperador,
			IdTienda,
		
			Procesado,
			Accion			
		)
		select 
			@Fecha,
			@FechaIni,
			@FechaEnd,
		
			@IdPlanificacion,
			@IdCoordinador,
			@IdOperador,
			@IdTienda,
		
			0,
			''
		
		set @IdProcesoNomina	= @@IDENTITY

	end

	insert into #TMP_ComprobanteNomina
	(
		IdProcesoNomina,

		IdPlanificacion,
		IdCoordinador,			
		IdOperador,
		IdTienda,

		Fecha,

		IsDeleted
	)
	select
		@IdProcesoNomina,

		@IdPlanificacion,
		IdCoordinador,			
		IdOperador,
		IdTienda,
		
		@Fecha,

		0
	from #TMP_CalculoNomina
	group by 
		IdCoordinador,
		IdOperador,
		IdTienda
			
	--##############################################################################################
	--### RESUMEN | REFERENCIAS	

	update #TMP_ComprobanteNomina set
		FechaIni		= @FechaIni,
		FechaEnd		= @FechaEnd,
		Accion			= ''

	--*** DETALLE NOMINA | COORDINADOR

	update #TMP_ComprobanteNomina set
		Coordinador			= ltrim(rtrim(isnull(E.Nombres,''))) + ' ' + ltrim(rtrim(isnull(E.ApellidoPaterno,''))) + ' ' + ltrim(rtrim(isnull(E.ApellidoMaterno,'')))		
	from #TMP_ComprobanteNomina N, tbl_Empleados E with(NoLock)
	where N.IdCoordinador	= E.IdEmpleado

	--*** OPERADOR

	update #TMP_ComprobanteNomina set
		Operador			= ltrim(rtrim(isnull(E.Nombres,''))) + ' ' + ltrim(rtrim(isnull(E.ApellidoPaterno,''))) + ' ' + ltrim(rtrim(isnull(E.ApellidoMaterno,''))),
		IdSegmento			= E.IdSegmento,						-- Interno = 1, Externo = 2, Spot = 3
		Segmento			= case E.IdSegmento 
								when 1 then 'Interno' 
								when 2 then 'Externo' 
								when 3 then 'Spot' 
							  end,
		Spot				= iif(E.IdSegmento = 3, 1, 0),
		
		Salario				= E.Salario,
		SMG					= E.SMG
	from #TMP_ComprobanteNomina N, tbl_Empleados E with(NoLock)
	where N.IdOperador		= E.IdEmpleado

	update #TMP_ComprobanteNomina set
		Tarjeta								= ECB.CuentaBancaria,
		IdBanco								= ECB.IdBanco,
		Banco								= CB.NombreBanco
	from #TMP_ComprobanteNomina N, tbl_EmpleadoCuentaBancaria ECB with(NoLock), tbl_CatalogoBancos CB with(NoLock)
	where	N.IdOperador					= ECB.IdEmpleado
		and isnull(ECB.Activa,0)			= 1
		and isnull(ECB.CuentaPrincipal,0)	= 1
		and ECB.IdBanco						= CB.IdBanco

	--*** CLIENTE

	update #TMP_ComprobanteNomina set
		IdCliente					= CC.IdCliente
	from #TMP_ComprobanteNomina N, tbl_CoordinadorCliente CC with(NoLock)
	where	N.IdCoordinador			= CC.IdCoordinador
		and isnull(CC.IsDeleted,0)	= 0

	update #TMP_ComprobanteNomina set
		Cliente						= C.NombreCliente
	from #TMP_ComprobanteNomina N, tbl_Cliente C with(NoLock)
	where N.IdCliente				= C.IdCliente
	
	--*** TIENDA

	update #TMP_ComprobanteNomina set
		Tienda				= T.NombreTienda,
		IdZonaSted			= T.IdZonaSted
	from #TMP_ComprobanteNomina N, tbl_Tienda T with(NoLock)
	where N.IdTienda		= T.IdTienda

	update #TMP_ComprobanteNomina set
		ZonaSted			= ZS.NombreZona
	from #TMP_ComprobanteNomina N, tbl_ZonaSted ZS with(NoLock)
	where N.IdZonaSted		= ZS.IdZonaSted

	--##############################################################################################
	--### RESUMEN | CALCULOS
		
	select @Dias = count(-1) from #TMP_Dias

	update #TMP_ComprobanteNomina set 
		Dias		= isnull((select count(-1)																		from #TMP_CalculoNomina N where N.IdCoordinador = R.IdCoordinador and N.IdOperador = R.IdOperador and N.IdTienda = R.IdTienda and isnull(N.Descanso,0) = 0),0),
		Descansos	= isnull((select count(-1)																		from #TMP_CalculoNomina N where N.IdCoordinador = R.IdCoordinador and N.IdOperador = R.IdOperador and N.IdTienda = R.IdTienda and isnull(N.Descanso,0) = 1),0),
		Faltas		= @Dias - isnull((select count(-1)																from #TMP_CalculoNomina N where N.IdCoordinador = R.IdCoordinador and N.IdOperador = R.IdOperador and N.IdTienda = R.IdTienda and isnull(N.Descanso,0) = 0),0),
		Descuento	= isnull((select isnull(sum(isnull(DescuentoTardanza,0)),0)										from #TMP_CalculoNomina N where N.IdCoordinador = R.IdCoordinador and N.IdOperador = R.IdOperador and N.IdTienda = R.IdTienda),0),
		Bono		= isnull((select isnull(sum(isnull(MontoHorasExtras,0) + (isnull(IncentivoFactura,0) * 100)),0) from #TMP_CalculoNomina N where N.IdCoordinador = R.IdCoordinador and N.IdOperador = R.IdOperador and N.IdTienda = R.IdTienda),0),
		Gasolina	= isnull((select isnull(sum(isnull(MontoCombustible,0)),0)										from #TMP_CalculoNomina N where N.IdCoordinador = R.IdCoordinador and N.IdOperador = R.IdOperador and N.IdTienda = R.IdTienda),0)
	from #TMP_ComprobanteNomina R
	
	update #TMP_ComprobanteNomina set 
		SubTotal1 = isnull(Salario,0) * isnull(Dias,0)

	update #TMP_ComprobanteNomina set 
		SubTotal2 = isnull(SubTotal1,0) - isnull(Descuento,0) + isnull(Bono,0) + isnull(Gasolina,0)

	update #TMP_ComprobanteNomina set 
		Total = isnull(SubTotal2,0) - isnull(SMG,0)

	update #TMP_ComprobanteNomina set 
		STED = isnull( iif(Dias >= 7, 600, 0) , 0 )

	update #TMP_ComprobanteNomina set 
		Pago = isnull(Total,0) - isnull(STED,0)	

	--##############################################################################################
	--### GENERACION DE COMPROBANTES

	insert into tbl_ComprobanteNomina
	(
		IdProcesoNomina,
		IdPlanificacion,

		Fecha,
		FechaIni,
		FechaEnd,
	
		IdCoordinador,
		Coordinador,
	
		IdOperador,
		Operador,
	
		IdSegmento,
		Segmento,
		Spot,
	
		Tarjeta,
		IdBanco,
		Banco,
	
		Salario,
		SMG,
	
		IdCliente,
		Cliente,

		IdTienda,
		Tienda,
		IdZonaSted,
		ZonaSted,
	
		Dias,
		Descansos,
		Faltas,
	
		SubTotal1,
		Descuento,
		Bono,
		Gasolina,
		SubTotal2,
		Total,
		STED,
		Pago,
	
		Accion
	)
	select
		@IdProcesoNomina,
		@IdPlanificacion,

		Fecha,
		FechaIni,
		FechaEnd,
	
		IdCoordinador,
		Coordinador,
	
		IdOperador,
		Operador,
	
		IdSegmento,
		Segmento,
		Spot,
	
		Tarjeta,
		IdBanco,
		Banco,
	
		Salario,
		SMG,
	
		IdCliente,
		Cliente,

		IdTienda,
		Tienda,
		IdZonaSted,
		ZonaSted,
	
		Dias,
		Descansos,
		Faltas,
	
		SubTotal1,
		Descuento,
		Bono,
		Gasolina,
		SubTotal2,
		Total,
		STED,
		Pago,
	
		Accion
	from #TMP_ComprobanteNomina

	update tbl_EjecucionPlanificacion set
		IdProcesoNomina							= N.IdProcesoNomina,
		IdComprobanteNomina						= N.IdComprobanteNomina
	from tbl_EjecucionPlanificacion EP, tbl_ComprobanteNomina N
	where	EP.IdOperador						= N.IdOperador
		and EP.IdTienda							= N.IdTienda
		and isnull(EP.IdComprobanteNomina,0)	= 0
		and isnull(EP.IdProcesoNomina,0)		= 0
		and N.IdProcesoNomina					= @IdProcesoNomina

	update tbl_Planificacion set
		EstatusPlanificacionId					= 2
	where IdPlanificacion						= @IdPlanificacion

	--##############################################################################################
	--#### SALIDA

	select * from tbl_ComprobanteNomina where IdProcesoNomina = @IdProcesoNomina order by Operador

	--##############################################################################################
	--#### TABLAS TEMPORALES

	if object_id('tempdb..#TMP_Dias')				is not null drop table #TMP_Dias
	if object_id('tempdb..#TMP_CalculoNomina')		is not null drop table #TMP_CalculoNomina
	if object_id('tempdb..#TMP_ComprobanteNomina')	is not null drop table #TMP_ComprobanteNomina

end try
begin catch
--***   ERRORES 

    set @Mensaje = error_message()
	raiserror(@Mensaje, 16, 1)                  

end catch


