/*==================================================================================================*/
-- Producto:		INTERNATIONAL BUSINESS SOLUTION DE MEXICO | STED - Traslados
-- Autor:			Benito Mora Cruz (Mocbana)
-- Fecha:           11 de Enero del 2024
-- Descripción:		Stored Procedure | Reporte de Nomina
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

begin try

	---### DEFAULT
	set @IdPlanificacion		= iif(isnull(@IdPlanificacion,0) <= 0, null, @IdPlanificacion)
	set @IdCoordinador			= iif(isnull(@IdCoordinador,0) <= 0, null, @IdCoordinador)
	set @IdOperador				= iif(isnull(@IdOperador,0) <= 0, null, @IdOperador)
	set @IdTienda				= iif(isnull(@IdTienda,0) <= 0, null, @IdTienda)

    --##############################################################################################
	--# TABLAS TEMPORALES
	
	if object_id('tempdb..#TMP_CalculoNomina')			is not null drop table #TMP_CalculoNomina
	if object_id('tempdb..#TMP_CalculoNominaResumen')	is not null drop table #TMP_CalculoNominaResumen

	if object_id('tempdb..#TMP_CalculoNomina')			is null begin

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

			Accion						VARCHAR(50),		
		)

	end

	if object_id('tempdb..#TMP_CalculoNominaResumen')			is null begin

		create table #TMP_CalculoNominaResumen
		(    
			
			FechaIni					DATETIME,			
			FechaEnd					DATETIME,			

			--*** DATOS COORDINADOR
			IdCoordinador				INT,
			Coordinador					VARCHAR(250),

			--*** DATOS OPERADOR
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

			--*** DATOS TIENDA/SUCURSAL
			IdTienda					INT,				
			Tienda						VARCHAR(250),
			IdZonaSted					INT,				
			ZonaSted					VARCHAR(50),
			
			--*** DATA
			Dias						INT,
			
			SubTotal1					DECIMAL(19,6),
			Descuento					DECIMAL(19,6),
			Bono						DECIMAL(19,6),
			Gasolina					DECIMAL(19,6),
			SubTotal2					DECIMAL(19,6),			
			Total						DECIMAL(19,6),
			STED						DECIMAL(19,6),
			Pago						DECIMAL(19,6),

			Accion						VARCHAR(50),		
		)

	end

	--##############################################################################################
	--#### DATA | DETALLE DE NOMINA
	
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
	set @SQL += char(13) + '	[MontoCombustible]'
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
	set @SQL += char(13) + '	EP.[MontoCombustible]'
	set @SQL += char(13) + 'from tbl_EjecucionPlanificacion EP with(NoLock), tbl_DetallePlanificacion DP with(NoLock), tbl_Planificacion P with(NoLock)'
	set @SQL += char(13) + 'where	EP.IdDetallePlanificacion	= DP.IdDetallePlanificacion and EP.IdPlanificacion = DP.IdPlanificacion'
	set @SQL += char(13) + '	and DP.IdPlanificacion			= P.IdPlanificacion'

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
	--### DETALLE NOMINA | REFERENCIAS		
		


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

	insert into #TMP_CalculoNominaResumen
	(
		IdCoordinador,			
		IdOperador,
		IdTienda
	)
	select
		IdCoordinador,			
		IdOperador,
		IdTienda				
	from #TMP_CalculoNomina
	group by 
		IdCoordinador,
		IdOperador,
		IdTienda
			
	--##############################################################################################
	--### RESUMEN | REFERENCIAS	

	update #TMP_CalculoNominaResumen set
		FechaIni		= @FechaIni,
		FechaEnd		= @FechaEnd,
		Accion			= ''

	--*** DETALLE NOMINA | COORDINADOR

	update #TMP_CalculoNominaResumen set
		Coordinador			= ltrim(rtrim(isnull(E.Nombres,''))) + ' ' + ltrim(rtrim(isnull(E.ApellidoPaterno,''))) + ' ' + ltrim(rtrim(isnull(E.ApellidoMaterno,'')))		
	from #TMP_CalculoNominaResumen N, tbl_Empleados E with(NoLock)
	where N.IdCoordinador	= E.IdEmpleado

	--*** OPERADOR

	update #TMP_CalculoNominaResumen set
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
	from #TMP_CalculoNominaResumen N, tbl_Empleados E with(NoLock)
	where N.IdOperador		= E.IdEmpleado

	update #TMP_CalculoNominaResumen set
		Tarjeta								= ECB.CuentaBancaria,
		IdBanco								= ECB.IdBanco,
		Banco								= CB.NombreBanco
	from #TMP_CalculoNominaResumen N, tbl_EmpleadoCuentaBancaria ECB with(NoLock), tbl_CatalogoBancos CB with(NoLock)
	where	N.IdOperador					= ECB.IdEmpleado
		and isnull(ECB.Activa,0)			= 1
		and isnull(ECB.CuentaPrincipal,0)	= 1
		and ECB.IdBanco						= CB.IdBanco

	--*** TIENDA

	update #TMP_CalculoNominaResumen set
		Tienda				= T.NombreTienda,
		IdZonaSted			= T.IdZonaSted
	from #TMP_CalculoNominaResumen N, tbl_Tienda T with(NoLock)
	where N.IdTienda		= T.IdTienda

	update #TMP_CalculoNominaResumen set
		ZonaSted			= ZS.NombreZona
	from #TMP_CalculoNominaResumen N, tbl_ZonaSted ZS with(NoLock)
	where N.IdZonaSted		= ZS.IdZonaSted


	--##############################################################################################
	--### RESUMEN | CALCULOS
		
	update #TMP_CalculoNominaResumen set 
		Dias		= isnull((select count(-1) from #TMP_CalculoNomina N where N.IdOperador = R.IdOperador),0),
		Descuento	= isnull((select isnull(sum(isnull(DescuentoTardanza,0)),0) from #TMP_CalculoNomina N where N.IdOperador = R.IdOperador),0),
		Bono		= isnull((select isnull(sum(isnull(MontoHorasExtras,0) + isnull(IncentivoFactura,0)),0) from #TMP_CalculoNomina N where N.IdOperador = R.IdOperador),0),
		Gasolina	= isnull((select isnull(sum(isnull(MontoCombustible,0)),0) from #TMP_CalculoNomina N where N.IdOperador = R.IdOperador),0)
	from #TMP_CalculoNominaResumen R
	
	update #TMP_CalculoNominaResumen set 
		SubTotal1 = isnull(Salario,0) * isnull(Dias,0)

	update #TMP_CalculoNominaResumen set 
		SubTotal2 = isnull(SubTotal1,0) - isnull(Descuento,0) + isnull(Bono,0) + isnull(Gasolina,0)

	update #TMP_CalculoNominaResumen set 
		Total = isnull(SubTotal2,0) - isnull(SMG,0)

	update #TMP_CalculoNominaResumen set 
		STED = isnull( iif(Dias >= 7, 600, 0) , 0 )

	update #TMP_CalculoNominaResumen set 
		Pago = isnull(Total,0) - isnull(STED,0)

	--select * from #TMP_CalculoNomina order by Fecha
	select * from #TMP_CalculoNominaResumen order by Operador

	--##############################################################################################
	--#### TABLAS TEMPORALES

	if object_id('tempdb..#TMP_CalculoNomina')			is not null drop table #TMP_CalculoNomina
	if object_id('tempdb..#TMP_CalculoNominaResumen')	is not null drop table #TMP_CalculoNominaResumen

end try
begin catch
--***   ERRORES 

    set @Mensaje = error_message()
	raiserror(@Mensaje, 16, 1)                  

end catch


