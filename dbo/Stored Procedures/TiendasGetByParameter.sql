CREATE Procedure [dbo].[TiendasGetByParameter] 
                @IdTienda as int = null,
                @IdZonaSted as int = null, 
                @IdCliente as bigint = null,
                @IdCoordinador as bigint = null

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
                tda.IdTienda,
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
                concat_WS(' ',cdor.Nombres,cdor.ApellidoPaterno,cdor.ApellidoMaterno) NombreCoordinador
                From tbl_Cliente cte
	                Inner Join tbl_ZonaSted zn_Sted
		                On cte.IdCliente = zn_Sted.IdCliente
	                Inner Join tbl_Tienda tda
		                On zn_Sted.IdZonaSted = tda.IdZonaSted
	                Inner Join tbl_GerenteSubGerente gteSubg
		                On tda.IdSubGerente = gteSubg.IdSubGerente
	                Inner Join tbl_ContactoCliente subg
		                On gteSubg.IdSubGerente = subg.IdContacto
                    Inner Join tbl_ContactoCliente gte
		                On gteSubg.IdGerente = gte.IdContacto
	                Inner Join tbl_CatalogoEstado est
		                On tda.IdEstado  = est.IdEstado
	                Inner Join tbl_Zona zna
		                On est.IdZona = zna.IdZona
                    Inner Join tbl_TiendaCoordinador tdacdor
		                On tda.IdTienda = tdacdor.IdTienda
	                Inner Join tbl_Empleados cdor
		                On tdacdor.IdCoordinador = cdor.IdEmpleado                
				Where ((@IdTienda Is Null) or tda.IdTienda = @IdTienda)
                  And ((@IdCliente Is Null) Or (cte.IdCliente = @IdCliente))
                  And ((@IdZonaSted Is Null) Or (tda.IdZonaSted = @IdZonaSted))  
                  And ((@IdCoordinador Is Null) Or (tdacdor.IdCoordinador = @IdCoordinador))
				  And (tda.IsDeleted = 0)
            
