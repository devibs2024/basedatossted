CREATE TABLE [dbo].[tbl_ComprobanteNomina]
(
	[IdComprobanteNomina]		DECIMAL (18)    IDENTITY (1, 1) NOT NULL,
	[IdProcesoNomina]			DECIMAL (18)	NOT NULL,
	[IdPlanificacion]			DECIMAL (18)	NOT NULL,

	Fecha						DATETIME,			
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

	--*** DATOS CLIENTE
	IdCliente					INT,
	Cliente						VARCHAR(250),

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

	Procesado					BIT,
	Accion						VARCHAR(50),

	IsDeleted					BIT            DEFAULT (CONVERT([bit],(0))) NOT NULL,

	CONSTRAINT [PK_tbl_ComprobanteNomina] PRIMARY KEY CLUSTERED ([IdComprobanteNomina] ASC),
)
