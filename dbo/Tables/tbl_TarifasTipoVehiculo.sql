CREATE TABLE [dbo].[tbl_TarifasTipoVehiculo] (
    [IdTarifa]       INT             IDENTITY (1, 1) NOT NULL,
    [Tarifa]         DECIMAL (18, 2) NOT NULL,
    [Activa]         BIT             NOT NULL,
    [Principal]      BIT             NOT NULL,
    [IdTipoVehiculo] INT             NOT NULL,
    [IsDeleted]      BIT             DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_TarifasTipoVehiculo] PRIMARY KEY CLUSTERED ([IdTarifa] ASC),
    CONSTRAINT [FK_Tarifa_TipoVehiculo] FOREIGN KEY ([IdTipoVehiculo]) REFERENCES [dbo].[tbl_CatalogoTipoVehiculo] ([IdTipoVehiculo])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_TarifasTipoVehiculo_IdTipoVehiculo]
    ON [dbo].[tbl_TarifasTipoVehiculo]([IdTipoVehiculo] ASC);

