/*==================================================================================================*/
-- Producto:		INTERNATIONAL BUSINESS SOLUTION DE MEXICO | STED - Traslados
-- Autor:			Benito Mora Cruz (Mocbana)
-- Fecha:           11 de Enero del 2024
-- Descripción:		Stored Procedure | Consulta de Nomina
/*==================================================================================================*/

CREATE PROCEDURE [dbo].[ConsultaNominaProductividad]

@IdProcesoNomina				INT					= NULL,
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

	--##############################################################################################
	---### DEFAULT
	
	set @IdPlanificacion		= iif(isnull(@IdPlanificacion,0) <= 0, null, @IdPlanificacion)
	set @IdCoordinador			= iif(isnull(@IdCoordinador,0) <= 0, null, @IdCoordinador)
	set @IdOperador				= iif(isnull(@IdOperador,0) <= 0, null, @IdOperador)
	set @IdTienda				= iif(isnull(@IdTienda,0) <= 0, null, @IdTienda)

	--##############################################################################################
	--#### DATA | DETALLE DE NOMINA
	
	set @SQL = '' 
	set @SQL += char(13) + 'select '
	set @SQL += char(13) + '	CN.*  '
	set @SQL += char(13) + 'from tbl_ComprobanteNomina CN with(NoLock), tbl_ProcesoNomina PN with(NoLock)'
	set @SQL += char(13) + 'where	CN.IdProcesoNomina				= PN.IdProcesoNomina'
	set @SQL += char(13) + '	and isnull(PN.Procesado,0)			= 1'
	set @SQL += char(13) + '	and isnull(PN.IsDeleted,0)			= 0'

	--*** FILTROS

	if isnull(@IdProcesoNomina,0) > 0	set @SQL += char(13) + ' and PN.IdProcesoNomina		= ' + dbo.funStrInt(@IdProcesoNomina)
	if isnull(@IdPlanificacion,0) > 0	set @SQL += char(13) + ' and PN.IdPlanificacion		= ' + dbo.funStrInt(@IdPlanificacion)
	if isnull(@IdCoordinador,0) > 0		set @SQL += char(13) + ' and PN.IdCoordinador		= ' + dbo.funStrInt(@IdCoordinador)
	if isnull(@IdOperador,0) > 0		set @SQL += char(13) + ' and PN.IdOperador			= ' + dbo.funStrInt(@IdOperador)
	if isnull(@IdTienda,0) > 0			set @SQL += char(13) + ' and PN.IdTienda			= ' + dbo.funStrInt(@IdTienda)

	--if isDate(@FechaIni) = 1 and isDate(@FechaEnd) = 1 begin
	--	Select @SQL += char(13) + ' and PN.Fecha >= ''' + dbo.funFechaStr(@FechaIni, 20, '-') + ''' and PN.Fecha <= ''' + dbo.funFechaStr(@FechaEnd, 20, '-') + ' 23:59'''
	--end else if isDate(@FechaIni) = 1 and not isDate(@FechaEnd) = 1 begin
	--	Select @SQL += char(13) + ' and PN.Fecha >= ''' + dbo.funFechaStr(@FechaIni, 20, '-') + ''''
	--end else if not isDate(@FechaIni) = 1 and isDate(@FechaEnd) = 1 begin
	--	Select @SQL += char(13) + ' and PN.Fecha <= ''' + dbo.funFechaStr(@FechaEnd, 20, '-') + ' 23:59'''
	--end

	print(@SQL)
	exec(@SQL)


end try
begin catch
--***   ERRORES 

    set @Mensaje = error_message()
	raiserror(@Mensaje, 16, 1)                  

end catch


