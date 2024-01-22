/*==================================================================================================*/
-- Producto:		INTERNATIONAL BUSINESS SOLUTION DE MEXICO | STED - Traslados
-- Autor:			Benito Mora Cruz (Mocbana)
-- Fecha:           21 de Enero del 2024
-- Descripción:		Stored Procedure | Reporte de Consumo de Gasolina
/*==================================================================================================*/

CREATE PROCEDURE [dbo].[ReporteGasolina]

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

begin try

	--##############################################################################################
	---### DEFAULT
	
	set @IdCoordinador			= iif(isnull(@IdCoordinador,0) <= 0, null, @IdCoordinador)
	set @IdOperador				= iif(isnull(@IdOperador,0) <= 0, null, @IdOperador)
	set @IdTienda				= iif(isnull(@IdTienda,0) <= 0, null, @IdTienda)

    --##############################################################################################
	--# TABLAS TEMPORALES
	
	if object_id('tempdb..#TMP_Ejecucion')			is not null drop table #TMP_Ejecucion
	if object_id('tempdb..#TMP_CalculoNomina')		is not null drop table #TMP_Base
	if object_id('tempdb..#TMP_ReporteGasolina')	is not null drop table #TMP_ReporteGasolina

	if object_id('tempdb..#TMP_Ejecucion')			is null begin

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

			[MontoCombustible]         DECIMAL (18, 2) NULL
		)
		

	end

	if object_id('tempdb..#TMP_Base')				is null begin

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

	if object_id('tempdb..#TMP_ReporteGasolina')	is null begin

		
		create table #TMP_ReporteGasolina
		(    
			
			IdCoordinador				BIGINT,				
			Coordinador					VARCHAR(250),

			IdOperador					BIGINT,				
			Operador					VARCHAR(250),

			IdTienda					BIGINT,				
			Tienda						VARCHAR(250),

			IdTarjeta					BIGINT,
			Tarjeta						VARCHAR(250),

			Importe						DECIMAL(19,6),
			FechaDispersion				DATETIME,
			
			Accion						VARCHAR(50)	
		)

	end
	
	--##############################################################################################
	--#### DATA 
	
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
	set @SQL += char(13) + '	[MontoCombustible]				'
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

	if isDate(@FechaIni) = 1 and isDate(@FechaEnd) = 1 begin
		Select @SQL += char(13) + ' and EP.Fecha >= ''' + dbo.funFechaStr(@FechaIni, 20, '-') + ''' and EP.Fecha <= ''' + dbo.funFechaStr(@FechaEnd, 20, '-') + ' 23:59'''
	end else if isDate(@FechaIni) = 1 and not isDate(@FechaEnd) = 1 begin
		Select @SQL += char(13) + ' and EP.Fecha >= ''' + dbo.funFechaStr(@FechaIni, 20, '-') + ''''
	end else if not isDate(@FechaIni) = 1 and isDate(@FechaEnd) = 1 begin
		Select @SQL += char(13) + ' and EP.Fecha <= ''' + dbo.funFechaStr(@FechaEnd, 20, '-') + ' 23:59'''
	end

	print(@SQL)
	exec(@SQL)


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
	from tbl_ComprobanteNomina CN with(NoLock)
	where	CN.IdComprobanteNomina	in (select IdProcesoNomina from #TMP_Ejecucion)

	--##############################################################################################
	--### CALCULOS
		
	insert into #TMP_ReporteGasolina
	(
		IdCoordinador,				
		Coordinador,					

		IdOperador,
		Operador,

		IdTienda,					
		Tienda,						

		IdTarjeta,						

		Importe,						
		FechaDispersion,				
			
		Accion			
	)
	select 
		B.IdCoordinador,				
		B.Coordinador,												

		B.IdOperador,					
		B.Operador,

		B.IdTienda,					
		B.Tienda,	

		E.IdTarjeta,						

		sum(E.MontoCombustible),						
		B.Fecha,				
			
		''	
	from #TMP_Ejecucion E, #TMP_Base B
	where	E.IdProcesoNomina		= B.IdProcesoNomina
		and E.IdComprobanteNomina	= B.IdComprobanteNomina
	group by B.IdCoordinador, B.Coordinador, B.IdOperador, B.Operador, B.IdTienda, B.Tienda, E.IdTarjeta, B.Fecha


	update #TMP_ReporteGasolina set
		Tarjeta = T.NumTarjeta
	from #TMP_ReporteGasolina TG, tbl_AsignacionTarjeta T
	where TG.IdTarjeta	= T.IdTarjeta

	--##############################################################################################
	--#### SALIDA

	select 
		row_number() over(order by FechaDispersion) Row,
		* 
	from #TMP_ReporteGasolina

	--##############################################################################################
	--#### TABLAS TEMPORALES

	if object_id('tempdb..#TMP_Ejecucion')			is not null drop table #TMP_Ejecucion
	if object_id('tempdb..#TMP_Base')				is not null drop table #TMP_Base
	if object_id('tempdb..#TMP_ReporteGasolina')	is not null drop table #TMP_ReporteGasolina

end try
begin catch
--***   ERRORES 

    set @Mensaje = error_message()
	raiserror(@Mensaje, 16, 1)                  

end catch


