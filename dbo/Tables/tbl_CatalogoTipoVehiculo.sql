CREATE TABLE [dbo].[tbl_CatalogoTipoVehiculo] (
    [IdTipoVehiculo] INT           IDENTITY (1, 1) NOT NULL,
    [TipoVehiculo]   NVARCHAR (50) NULL,
    [Activo]         BIT           NULL,
    [IsDeleted]      BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_CatalogoTipoVehiculo] PRIMARY KEY CLUSTERED ([IdTipoVehiculo] ASC)
);

