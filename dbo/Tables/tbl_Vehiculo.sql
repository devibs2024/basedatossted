CREATE TABLE [dbo].[tbl_Vehiculo] (
    [IdVehiculo]       BIGINT          IDENTITY (1, 1) NOT NULL,
    [NombreVehiculo]   NVARCHAR (50)   NOT NULL,
    [IdTipoVehiculo]   INT             NULL,
    [IdMarcaVehiculo]  INT             NULL,
    [IdModeloVehiculo] INT             NULL,
    [EmisionVehiculo]  INT             NULL,
    [VehiculoEmpresa]  BIT             NULL,
    [Tarifa]           DECIMAL (18, 2) NOT NULL,
    [IsDeleted]        BIT             DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_Vehiculo] PRIMARY KEY CLUSTERED ([IdVehiculo] ASC),
    CONSTRAINT [FK_Vehiculo_Marca] FOREIGN KEY ([IdMarcaVehiculo]) REFERENCES [dbo].[tbl_CatalogoVehiculoMarca] ([IdMarca]),
    CONSTRAINT [FK_Vehiculo_Modelo] FOREIGN KEY ([IdModeloVehiculo]) REFERENCES [dbo].[tbl_CatalogoVehiculoModelo] ([IdModelo]),
    CONSTRAINT [FK_Vehiculo_TipoVehiculo] FOREIGN KEY ([IdTipoVehiculo]) REFERENCES [dbo].[tbl_CatalogoTipoVehiculo] ([IdTipoVehiculo])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Vehiculo_IdMarcaVehiculo]
    ON [dbo].[tbl_Vehiculo]([IdMarcaVehiculo] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Vehiculo_IdModeloVehiculo]
    ON [dbo].[tbl_Vehiculo]([IdModeloVehiculo] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Vehiculo_IdTipoVehiculo]
    ON [dbo].[tbl_Vehiculo]([IdTipoVehiculo] ASC);

