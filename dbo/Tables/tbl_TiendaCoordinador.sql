CREATE TABLE [dbo].[tbl_TiendaCoordinador] (
    [IdTienda]      INT    NOT NULL,
    [IdCoordinador] BIGINT NOT NULL,
    [IsDeleted]     BIT    DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_TiendaCoordinador] PRIMARY KEY CLUSTERED ([IdTienda] ASC, [IdCoordinador] ASC),
    CONSTRAINT [FK_TiendaCoordinador_Coordinador] FOREIGN KEY ([IdCoordinador]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado]),
    CONSTRAINT [FK_TiendaCoordinador_Tienda] FOREIGN KEY ([IdTienda]) REFERENCES [dbo].[tbl_Tienda] ([IdTienda])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_TiendaCoordinador_IdCoordinador]
    ON [dbo].[tbl_TiendaCoordinador]([IdCoordinador] ASC);

