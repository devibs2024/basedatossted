CREATE TABLE [dbo].[tbl_Tienda] (
    [IdTienda]            INT             IDENTITY (1, 1) NOT NULL,
    [NombreTienda]        NVARCHAR (30)   NOT NULL,
    [IdSubGerente]        BIGINT          NOT NULL,
    [IdEstado]            INT             NOT NULL,
    [IdZonaSted]          INT             NOT NULL,
    [NumUnidades]         DECIMAL (18, 2) NOT NULL,
    [UnidadesMaximas]     DECIMAL (18, 2) NOT NULL,
    [Tarifa]              DECIMAL (18, 2) NOT NULL,
    [TarifaDescanso]      DECIMAL (18, 2) NOT NULL,
    [Activa]              BIT             NULL,
    [CntEmpleadosInterno] INT             NULL,
    [CntEmpleadosExterno] INT             NULL,
    [CntEmpleadosSpot]    INT             NULL,
    [IsDeleted]           BIT             DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_Tienda] PRIMARY KEY CLUSTERED ([IdTienda] ASC),
    CONSTRAINT [FK_Tienda_Estado] FOREIGN KEY ([IdEstado]) REFERENCES [dbo].[tbl_CatalogoEstado] ([IdEstado]),
    CONSTRAINT [FK_ZonaSted_Tienda] FOREIGN KEY ([IdZonaSted]) REFERENCES [dbo].[tbl_ZonaSted] ([IdZonaSted])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Tienda_IdEstado]
    ON [dbo].[tbl_Tienda]([IdEstado] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Tienda_IdZonaSted]
    ON [dbo].[tbl_Tienda]([IdZonaSted] ASC);

