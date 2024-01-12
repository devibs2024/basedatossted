CREATE TABLE [dbo].[tbl_CatalogoVehiculoModelo] (
    [IdModelo]  INT           IDENTITY (1, 1) NOT NULL,
    [IdMarca]   INT           NULL,
    [Modelo]    NVARCHAR (50) NULL,
    [Activo]    BIT           NULL,
    [IsDeleted] BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_CatalogoVehiculoModelo] PRIMARY KEY CLUSTERED ([IdModelo] ASC),
    CONSTRAINT [FK_VehiculoModelo_VehiculoMarca] FOREIGN KEY ([IdMarca]) REFERENCES [dbo].[tbl_CatalogoVehiculoMarca] ([IdMarca])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CatalogoVehiculoModelo_IdMarca]
    ON [dbo].[tbl_CatalogoVehiculoModelo]([IdMarca] ASC);

