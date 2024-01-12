CREATE Procedure [dbo].[PlanificacionGetByCoordinador]
@IdCoordinador bigint = Null


As

Select 
	pln.IdPlanificacion
 ,  pln.IdCoordinador
 ,  concat_WS(' ',cdr.Nombres,cdr.ApellidoPaterno,cdr.ApellidoMaterno) Coordinador
 ,  pln.FechaDesde
 ,  pln.FechaHasta
 ,  pln.FrecuenciaId
 ,  Case pln.FrecuenciaId When 1 Then 'Semanal'
						  When 2 Then 'Quincenal'
						  When 3 Then 'Mensual' End Frecuencia
 ,  pln.EstatusPlanificacionId 
 ,  Case pln.EstatusPlanificacionId When 1 Then 'Pendiente'
									When 2 Then 'En Proceso'
									When 3 Then 'Cerrada'
									When 4 Then 'Pagada' End Estatus
From tbl_Planificacion pln
	Inner Join tbl_Empleados cdr
		On pln.IdCoordinador = cdr.IdEmpleado
Where ((@IdCoordinador Is Null) Or (pln.IdCoordinador = @IdCoordinador))

