CREATE TABLE [dbo].[tbl_ProcesoNomina]
(
	[IdProcesoNomina]			DECIMAL (18)    IDENTITY (1, 1) NOT NULL,

	Fecha						DATETIME,
	FechaIni					DATETIME,			
	FechaEnd					DATETIME,			

	IdPlanificacion				DECIMAL (18),
	IdCoordinador				INT,
	IdOperador					INT,
	IdTienda					INT,
	
	Procesado					BIT,

	Accion						VARCHAR(50),

	CONSTRAINT [PK_tbl_ProcesoNomina] PRIMARY KEY CLUSTERED ([IdProcesoNomina] ASC),
)
