/*==================================================================================================*/
-- Producto:		INTERNATIONAL BUSINESS SOLUTION DE MEXICO | STED - Traslados
-- Autor:			Benito Mora Cruz (Mocbana)
-- Fecha:           21 de Enero del 2024
-- Descripción:		Stored Procedure | Reporte de Vehículos Extra
/*==================================================================================================*/

CREATE PROCEDURE [dbo].[ReporteComparativoPagos]

@IdCoordinador					INT					= NULL,
@IdOperador						INT					= NULL,
@IdTienda						INT					= NULL,
@IdTipoVehiculo					INT					= NULL,

@FechaIni						DATETIME			= NULL,
@FechaEnd						DATETIME			= NULL

AS

SET NOCOUNT ON
SET XACT_ABORT ON

declare @SQL					nvarchar(max)
declare @Mensaje				varchar(max)				

declare @Row					int
declare @Reg					int
declare @Fecha					datetime

declare @IdClienteRow			int
declare @IdTiendaRow			int
declare @IdTipoVehiculoRow		int
declare @IdCoordinadorRow		int

begin try

	--##############################################################################################
	---### DEFAULT
	
	set @IdCoordinador			= iif(isnull(@IdCoordinador,0) <= 0, null, @IdCoordinador)
	set @IdOperador				= iif(isnull(@IdOperador,0) <= 0, null, @IdOperador)
	set @IdTienda				= iif(isnull(@IdTienda,0) <= 0, null, @IdTienda)
	set @IdTipoVehiculo			= iif(isnull(@IdTipoVehiculo,0) <= 0, null, @IdTipoVehiculo)

    --##############################################################################################
	--# TABLAS TEMPORALES
	
	if object_id('tempdb..#TMP_Dias')						is not null drop table #TMP_Dias
	if object_id('tempdb..#TMP_Procesos')					is not null drop table #TMP_Procesos
	if object_id('tempdb..#TMP_Ejecucion')					is not null drop table #TMP_Ejecucion
	if object_id('tempdb..#TMP_CalculoNomina')				is not null drop table #TMP_Base
	if object_id('tempdb..#TMP_ReporteComparativoPagos')	is not null drop table #TMP_ReporteComparativoPagos

	if object_id('tempdb..#TMP_Dias')						is null begin

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

	if object_id('tempdb..#TMP_Procesos')					is null begin

		create table #TMP_Procesos
		(
			IdProcesoNomina				DECIMAL (18),
			IdPlanificacion				DECIMAL (18),
			IdCoordinador				INT,
			IdOperador					INT,
			IdTienda					INT,
	
			Fecha						DATETIME,
			Procesado					BIT
		)

	end

	if object_id('tempdb..#TMP_Ejecucion')					is null begin

		create table #TMP_Ejecucion
		(
			[IdProcesoNomina]          DECIMAL (18),
			[IdComprobanteNomina]      DECIMAL (18),

			[IdPlanificacion]          DECIMAL (18),
			[IdEjecucionPlanificacion] DECIMAL (18),
			[IdDetallePlanificacion]   DECIMAL (18),
			[IdOperador]               BIGINT,
			[IdTienda]                 INT,
			
			[Fecha]                    DATE,
		
			[IdVehiculo]               BIGINT,
			[IdTipoVehiculo]           INT,
			[IdTarjeta]                BIGINT,

			[MontoCombustible]         DECIMAL (18, 2)
		)
		

	end

	if object_id('tempdb..#TMP_Base')						is null begin

		create table #TMP_Base
		(
			[IdComprobanteNomina]		DECIMAL (18),
			[IdProcesoNomina]			DECIMAL (18),
			[IdPlanificacion]			DECIMAL (18),

			Fecha						DATETIME,			
			FechaIni					DATETIME,			
			FechaEnd					DATETIME,			

			IdCoordinador				INT,
			Coordinador					VARCHAR(250),

			IdOperador					INT,
			Operador					VARCHAR(250),
			
			IdSegmento					INT,
			Segmento					VARCHAR(50),
			Spot						BIT,

			Tarjeta						VARCHAR(50),		
			IdBanco						INT,				
			Banco						VARCHAR(250),
			
			Salario						DECIMAL(19,6),
			SMG							DECIMAL(19,6),

			IdCliente					INT,				
			Cliente						VARCHAR(250),

			IdTienda					INT,				
			Tienda						VARCHAR(250),
			IdZonaSted					INT,				
			ZonaSted					VARCHAR(50),
			
			Dias						INT,
			
			SubTotal1					DECIMAL(19,6),
			Descuento					DECIMAL(19,6),
			Bono						DECIMAL(19,6),
			Gasolina					DECIMAL(19,6),
			SubTotal2					DECIMAL(19,6),			
			Total						DECIMAL(19,6),
			STED						DECIMAL(19,6),
			Pago						DECIMAL(19,6),

			Procesado					BIT,
			Accion						VARCHAR(50)
		)

	end

	if object_id('tempdb..#TMP_ReporteComparativoPagos')	is null begin

		create table #TMP_ReporteComparativoPagos
		(    
			
			Row							BIGINT,

			IdCoordinador				BIGINT,				
			Coordinador					VARCHAR(250),

			IdCliente					BIGINT,				
			Cliente						VARCHAR(250),

			IdOperador					BIGINT,				
			Operador					VARCHAR(250),

			IdTienda					BIGINT,				
			Tienda						VARCHAR(250),

			IdZonaSted					BIGINT,				
			ZonaSted					VARCHAR(50),

			IdEstado					BIGINT,				
			Estado						VARCHAR(50),			

			IdTipoVehiculo				BIGINT,
			TipoVehiculo				VARCHAR(250),

			NoUnidades					INT,
			Dias						INT,

			TarifaCliente				DECIMAL(19,6),
			TarifaAyudante				DECIMAL(19,6),
			TarifaHoraExtra				DECIMAL(19,6),

			UnidadesSpot				INT,
			TarifaSpot					DECIMAL(19,6),

			TotalCliente				DECIMAL(19,6),

			TarifaVehiculo				DECIMAL(19,6),
			Salario						DECIMAL(19,6),
			Gasolina					DECIMAL(19,6),
			DescuentoSted				DECIMAL(19,6),
			Total						DECIMAL(19,6),
			TotalGeneral				DECIMAL(19,6),

			Accion						VARCHAR(50)	
		)

	end
	
	--##############################################################################################
	--#### DATA 
	
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
	set @SQL += char(13) + 'insert into #TMP_Procesos'
	set @SQL += char(13) + '('
	set @SQL += char(13) + '	IdProcesoNomina,'
	set @SQL += char(13) + '	IdPlanificacion,'
	set @SQL += char(13) + '	IdCoordinador,'
	set @SQL += char(13) + '	IdOperador,'
	set @SQL += char(13) + '	IdTienda,'
	set @SQL += char(13) + '	Fecha,'
	set @SQL += char(13) + '	Procesado'
	set @SQL += char(13) + ')'
	set @SQL += char(13) + 'select'
	set @SQL += char(13) + '	IdProcesoNomina,'
	set @SQL += char(13) + '	IdPlanificacion,'
	set @SQL += char(13) + '	IdCoordinador,'
	set @SQL += char(13) + '	IdOperador,'
	set @SQL += char(13) + '	IdTienda,'
	set @SQL += char(13) + '	Fecha,'
	set @SQL += char(13) + '	Procesado'
	set @SQL += char(13) + 'from tbl_ProcesoNomina PN with(NoLock)'
	set @SQL += char(13) + 'where	isnull(PN.Procesado,0)	= 1'
	set @SQL += char(13) + '	and isnull(PN.IsDeleted,0)	= 0'

	--*** FILTROS

	if isnull(@IdCoordinador,0) > 0		set @SQL += char(13) + ' and PN.IdCoordinador		= ' + dbo.funStrInt(@IdCoordinador)

	if isDate(@FechaIni) = 1 and isDate(@FechaEnd) = 1 begin
		Select @SQL += char(13) + ' and PN.Fecha >= ''' + dbo.funFechaStr(@FechaIni, 20, '-') + ''' and PN.Fecha <= ''' + dbo.funFechaStr(@FechaEnd, 20, '-') + ' 23:59'''
	end else if isDate(@FechaIni) = 1 and not isDate(@FechaEnd) = 1 begin
		Select @SQL += char(13) + ' and PN.Fecha >= ''' + dbo.funFechaStr(@FechaIni, 20, '-') + ''''
	end else if not isDate(@FechaIni) = 1 and isDate(@FechaEnd) = 1 begin
		Select @SQL += char(13) + ' and PN.Fecha <= ''' + dbo.funFechaStr(@FechaEnd, 20, '-') + ' 23:59'''
	end

	print(@SQL)
	exec(@SQL)

	set @SQL = '' 
	set @SQL += char(13) + 'insert into #TMP_Ejecucion'
	set @SQL += char(13) + '('
	set @SQL += char(13) + '	[IdProcesoNomina],				'
	set @SQL += char(13) + '	[IdComprobanteNomina],			'
	set @SQL += char(13) + ''							   
	set @SQL += char(13) + '	[IdPlanificacion],				'
	set @SQL += char(13) + '	[IdEjecucionPlanificacion],		'
	set @SQL += char(13) + '	[IdDetallePlanificacion],		'
	set @SQL += char(13) + '	[IdOperador],					'
	set @SQL += char(13) + '	[IdTienda],						'
	set @SQL += char(13) + ''							   
	set @SQL += char(13) + '	[Fecha],						'
	set @SQL += char(13) + ''							   
	set @SQL += char(13) + '	[IdVehiculo],					'
	set @SQL += char(13) + '	[IdTipoVehiculo],				'
	set @SQL += char(13) + '	[IdTarjeta],					'
	set @SQL += char(13) + ''							   
	set @SQL += char(13) + '	EP.[MontoCombustible]			'
	set @SQL += char(13) + ')'
	set @SQL += char(13) + 'select'
	set @SQL += char(13) + '	EP.[IdProcesoNomina],			'
	set @SQL += char(13) + '	EP.[IdComprobanteNomina],		'
	set @SQL += char(13) + ''							   
	set @SQL += char(13) + '	EP.[IdPlanificacion],			'
	set @SQL += char(13) + '	EP.[IdEjecucionPlanificacion],	'
	set @SQL += char(13) + '	EP.[IdDetallePlanificacion],	'
	set @SQL += char(13) + '	EP.[IdOperador],				'
	set @SQL += char(13) + '	EP.[IdTienda],					'
	set @SQL += char(13) + ''							   
	set @SQL += char(13) + '	EP.[Fecha],						'
	set @SQL += char(13) + ''							   
	set @SQL += char(13) + '	EP.[IdVehiculo],				'
	set @SQL += char(13) + '	EP.[IdTipoVehiculo],			'
	set @SQL += char(13) + '	EP.[IdTarjeta],					'
	set @SQL += char(13) + ''							   
	set @SQL += char(13) + '	EP.[MontoCombustible]			'
	set @SQL += char(13) + 'from tbl_EjecucionPlanificacion EP with(NoLock), tbl_DetallePlanificacion DP with(NoLock), tbl_Planificacion P with(NoLock)'
	set @SQL += char(13) + 'where	EP.IdDetallePlanificacion			= DP.IdDetallePlanificacion'
	set @SQL += char(13) + '	and EP.IdPlanificacion					= DP.IdPlanificacion'
	set @SQL += char(13) + '	and DP.IdPlanificacion					= P.IdPlanificacion'
	set @SQL += char(13) + '	and isnull(EP.IdComprobanteNomina,0)	> 0'
	set @SQL += char(13) + '	and isnull(EP.IdProcesoNomina,0)		> 0'
	set @SQL += char(13) + '	and isnull(EP.IsDeleted,0)				= 0'

	--*** FILTROS

	if isnull(@IdCoordinador,0) > 0		set @SQL += char(13) + ' and P.IdCoordinador		= ' + dbo.funStrInt(@IdCoordinador)
	if isnull(@IdOperador,0) > 0		set @SQL += char(13) + ' and EP.IdOperador			= ' + dbo.funStrInt(@IdOperador)
	if isnull(@IdTienda,0) > 0			set @SQL += char(13) + ' and EP.IdTienda			= ' + dbo.funStrInt(@IdTienda)
	if isnull(@IdTipoVehiculo,0) > 0	set @SQL += char(13) + ' and EP.IdTipoVehiculo		= ' + dbo.funStrInt(@IdTipoVehiculo)

	print(@SQL)
	exec(@SQL)	

	delete from #TMP_Ejecucion where IdProcesoNomina not in (select IdProcesoNomina from #TMP_Procesos)

	insert into #TMP_Base
	(
		IdComprobanteNomina,
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
		SubTotal1,
		Descuento,
		Bono,
		Gasolina,
		SubTotal2,
		Total,
		STED,
		Pago,
		Procesado,
		Accion
	)
	select
		CN.IdComprobanteNomina,
		CN.IdProcesoNomina,
		CN.IdPlanificacion,
		CN.Fecha,
		CN.FechaIni,
		CN.FechaEnd,
		CN.IdCoordinador,
		CN.Coordinador,
		CN.IdOperador,
		CN.Operador,
		CN.IdSegmento,
		CN.Segmento,
		CN.Spot,
		CN.Tarjeta,
		CN.IdBanco,
		CN.Banco,
		CN.Salario,
		CN.SMG,
		CN.IdCliente,
		CN.Cliente,
		CN.IdTienda,
		CN.Tienda,
		CN.IdZonaSted,
		CN.ZonaSted,
		CN.Dias,
		CN.SubTotal1,
		CN.Descuento,
		CN.Bono,
		CN.Gasolina,
		CN.SubTotal2,
		CN.Total,
		CN.STED,
		CN.Pago,
		CN.Procesado,
		CN.Accion
	from tbl_ComprobanteNomina CN with(NoLock), #TMP_Procesos PN
	where	CN.IdProcesoNomina		= PN.IdProcesoNomina
		and CN.IdComprobanteNomina	in (select IdComprobanteNomina from #TMP_Ejecucion)	

	--##############################################################################################
	--### CALCULOS
		
	insert into #TMP_ReporteComparativoPagos
	(
		Row,

		IdCoordinador,				
		Coordinador,					

		IdCliente,
		Cliente,

		IdOperador,					
		Operador,	

		IdTienda,					
		Tienda,						

		IdTipoVehiculo,				

		Accion			
	)
	select 
		row_number() over(order by E.IdTipoVehiculo) Row,

		B.IdCoordinador,				
		B.Coordinador,												

		B.IdCliente,					
		B.Cliente,	

		B.IdOperador,					
		B.Operador,	

		B.IdTienda,					
		B.Tienda,	

		E.IdTipoVehiculo,						

		''	
	from #TMP_Ejecucion E, #TMP_Base B
	where	E.IdProcesoNomina		= B.IdProcesoNomina
		and E.IdComprobanteNomina	= B.IdComprobanteNomina
	group by B.IdCoordinador, B.Coordinador, B.IdCliente, B.Cliente, B.IdOperador, B.Operador, B.IdTienda, B.Tienda, E.IdTipoVehiculo

	update #TMP_ReporteComparativoPagos set
		NoUnidades			= 0,
		Dias				= 0,
		TarifaCliente		= 0,
		TarifaAyudante		= 0,
		TarifaHoraExtra		= 0,
		UnidadesSpot		= 0,
		TotalCliente		= 0,
		TarifaVehiculo		= 0,
		Salario				= 0,
		Gasolina			= 0,
		DescuentoSted		= 0,
		Total				= 0,
		TotalGeneral		= 0

	update #TMP_ReporteComparativoPagos set
		TipoVehiculo		= TV.TipoVehiculo
	from #TMP_ReporteComparativoPagos TG, tbl_CatalogoTipoVehiculo TV
	where TG.IdTipoVehiculo	= TV.IdTipoVehiculo

	update #TMP_ReporteComparativoPagos set
		TarifaVehiculo		= TTV.Tarifa
	from #TMP_ReporteComparativoPagos TG, tbl_TarifasTipoVehiculo TTV
	where TG.IdTipoVehiculo	= TTV.IdTipoVehiculo
		and isnull(TTV.Principal,0) = 1
		and isnull(TTV.IsDeleted,0)	= 0

	update #TMP_ReporteComparativoPagos set 
		UnidadesSpot		= T.CntEmpleadosSpot,
		IdZonaSted			= T.IdZonaSted,
		IdEstado			= T.IdEstado
	from #TMP_ReporteComparativoPagos VE, tbl_Tienda T with(NoLock)
	where VE.IdTienda	= T.IdTienda

	update #TMP_ReporteComparativoPagos set
		ZonaSted			= ZS.NombreZona
	from #TMP_ReporteComparativoPagos N, tbl_ZonaSted ZS with(NoLock)
	where N.IdZonaSted		= ZS.IdZonaSted

	update #TMP_ReporteComparativoPagos set
		Estado				= E.NombreEstado
	from #TMP_ReporteComparativoPagos N, tbl_CatalogoEstado E with(NoLock)
	where N.IdEstado		= E.IdEstado

	update #TMP_ReporteComparativoPagos set
		Salario				= E.Salario
	from #TMP_ReporteComparativoPagos N, tbl_Empleados E with(NoLock)
	where N.IdOperador		= E.IdEmpleado

	update #TMP_ReporteComparativoPagos set
		TarifaCliente		= C.Tarifa,
		TarifaAyudante		= C.TarifaConAyudante,
		TarifaHoraExtra		= C.TarifaHoraAdicional,
		TarifaSpot			= C.TarifaSpot
	from #TMP_ReporteComparativoPagos N, tbl_Cliente c with(NoLock)
	where N.IdCliente		= C.IdCliente

	update #TMP_ReporteComparativoPagos set 
		NoUnidades			= isnull((select count(-1)																from #TMP_Ejecucion N, #TMP_Base B	where N.IdProcesoNomina = B.IdProcesoNomina and N.IdComprobanteNomina = B.IdComprobanteNomina and B.IdCoordinador = R.IdCoordinador and N.IdOperador = R.IdOperador and N.IdTienda = R.IdTienda and N.IdTipoVehiculo = R.IdTipoVehiculo),0),
		Dias				= isnull((select count(-1)																from #TMP_Ejecucion N, #TMP_Base B	where N.IdProcesoNomina = B.IdProcesoNomina and N.IdComprobanteNomina = B.IdComprobanteNomina and B.IdCoordinador = R.IdCoordinador and N.IdOperador = R.IdOperador and N.IdTienda = R.IdTienda and N.IdTipoVehiculo = R.IdTipoVehiculo),0),
		Gasolina			= isnull((select isnull(sum(isnull(MontoCombustible,0)),0)								from #TMP_Ejecucion N, #TMP_Base B	where N.IdProcesoNomina = B.IdProcesoNomina and N.IdComprobanteNomina = B.IdComprobanteNomina and B.IdCoordinador = R.IdCoordinador and N.IdOperador = R.IdOperador and N.IdTienda = R.IdTienda and N.IdTipoVehiculo = R.IdTipoVehiculo),0)
	from #TMP_ReporteComparativoPagos R

	update #TMP_ReporteComparativoPagos set 
		DescuentoSted			= isnull(iif( isnull(B.STED,0) > 0,  B.STED * (CP.Dias / B.Dias), 0 ), 0)
	from #TMP_ReporteComparativoPagos CP, #TMP_Base B
	where	CP.IdCliente		= B.IdCliente
		and CP.IdCoordinador	= B.IdCoordinador
		and CP.IdOperador		= B.IdOperador
		and CP.IdTienda			= B.IdTienda
		and isnull(CP.Dias,0)	> 0

	update #TMP_ReporteComparativoPagos set 
		Total			= isnull(TarifaVehiculo,0) + isnull(Salario,0) + isnull(Gasolina,0) - isnull(DescuentoSted,0)

	update #TMP_ReporteComparativoPagos set 
		TotalGeneral	= Dias * Total

	--##############################################################################################
	--#### SALIDA

	select 
		* 
	from #TMP_ReporteComparativoPagos

	select * from #TMP_Dias
	select * from #TMP_Procesos
	select * from #TMP_Ejecucion
	select * from #TMP_Base

	--##############################################################################################
	--#### TABLAS TEMPORALES

	if object_id('tempdb..#TMP_Dias')						is not null drop table #TMP_Dias
	if object_id('tempdb..#TMP_Procesos')					is not null drop table #TMP_Procesos
	if object_id('tempdb..#TMP_Ejecucion')					is not null drop table #TMP_Ejecucion
	if object_id('tempdb..#TMP_Base')						is not null drop table #TMP_Base
	if object_id('tempdb..#TMP_ReporteComparativoPagos')	is not null drop table #TMP_ReporteComparativoPagos

end try
begin catch
--***   ERRORES 

    set @Mensaje = error_message()
	raiserror(@Mensaje, 16, 1)                  

end catch


