create Procedure [dbo].[PlanificacionDetalleGetByParameter] 
								@IdPlanificacion as decimal(8,0),
								@IdDetallePlanificacion as decimal(8,0) = null


				As

				Select
				cte.IdCliente,
				cte.NombreCliente, 
				cte.Clave, 
				cte.IdZona, 
				zn_Sted.NombreZona As NombreZonaSted,
				zn_Sted.ClaveDET,
				zn_Sted.IdZonaSted,
				tda.IdSubGerente,
				tda.IdEstado,
				dtPln.IdTienda,
				tda.NombreTienda, 
				tda.NumUnidades, 
				tda.Tarifa, 
				tda.TarifaDescanso, 
				tda.UnidadesMaximas, 
				subg.Nombre As SubGerente,
				IsNull(subg.email,'') As EmailSubGerente, 
				IsNull(subg.telefono,'') As Tel1SubGerente, 
				IsNull(subg.telefono2,'') As Tel2SubGerente,
				gte.Nombre As Gerente,
				IsNull(gte.email,'') As EmailGerente, 
				IsNull(gte.telefono,'') As Tel1Gerente, 
				IsNull(gte.telefono2,'') As Tel2Gerente,
				est.NombreEstado,
				zna.NombreZona, 
				tdacdor.IdCoordinador,
				concat_WS(' ',cdor.Nombres,cdor.ApellidoPaterno,cdor.ApellidoMaterno) NombreCoordinador,
				pln.IdPlanificacion,
				pln.FechaDesde, 
				pln.FechaHasta,
				pln.Comentario, 
				dtPln.IdDetallePlanificacion, 
				dtPln.IdOperador, 
				concat_WS(' ', OpEmp.Nombres,OpEmp.ApellidoPaterno,OpEmp.ApellidoMaterno) NombreOperador,
				dtPln.HoraInicio, 
				dtPln.HoraFin, 
				dtPln.Fecha, 
				dtPln.Descanso

				From tbl_Planificacion pln					
						Inner Join tbl_DetallePlanificacion dtPln
							On pln.IdPlanificacion = dtPln.IdPlanificacion
						Inner Join tbl_Empleados OpEmp
							On dtPln.IdOperador = OpEmp.IdEmpleado
						Inner Join tbl_Tienda tda
							On dtPln.IdTienda =  tda.IdTienda
						Inner Join tbl_TiendaCoordinador tdacdor
							On tda.IdTienda = tdacdor.IdTienda
						And tdacdor.IdCoordinador = pln.IdCoordinador	
						Inner Join tbl_Empleados cdor
							On tdacdor.IdCoordinador = cdor.IdEmpleado
						Inner Join tbl_ZonaSted zn_Sted
						   On zn_Sted.IdZonaSted = tda.IdZonaSted
						Inner Join tbl_Cliente cte
						   On cte.IdCliente = zn_Sted.IdCliente
						And zn_Sted.IdZonaSted = tda.IdZonaSted
						Inner Join tbl_GerenteSubGerente gteSubg
    						On tda.IdSubGerente = gteSubg.IdSubGerente
						Inner Join tbl_ContactoCliente subg
							On gteSubg.IdSubGerente = subg.IdContacto
						Inner Join tbl_ContactoCliente gte
							On gteSubg.IdGerente = gte.IdContacto
						Inner Join tbl_CatalogoEstado est
							On tda.IdEstado  = est.IdEstado
						Inner Join tbl_Zona zna
							On cte.IdZona = zna.IdZona				
				Where pln.IdPlanificacion = @IdPlanificacion
				And ((@IdDetallePlanificacion Is Null) Or (dtPln.IdDetallePlanificacion = @IdDetallePlanificacion))
				and isnull(dtPln.IsDeleted,0) = 0
            


            
