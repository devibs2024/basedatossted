CREATE TABLE [dbo].[tbl_CatalogoVehiculoMarca] (
    [IdMarca]   INT           IDENTITY (1, 1) NOT NULL,
    [IdTipo]    INT           NULL,
    [Marca]     NVARCHAR (50) NULL,
    [Activo]    BIT           NULL,
    [IsDeleted] BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_CatalogoVehiculoMarca] PRIMARY KEY CLUSTERED ([IdMarca] ASC),
    CONSTRAINT [FK_VehiculoMarca_TipoVehiculo] FOREIGN KEY ([IdTipo]) REFERENCES [dbo].[tbl_CatalogoTipoVehiculo] ([IdTipoVehiculo])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CatalogoVehiculoMarca_IdTipo]
    ON [dbo].[tbl_CatalogoVehiculoMarca]([IdTipo] ASC);

