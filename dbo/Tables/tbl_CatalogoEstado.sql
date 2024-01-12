CREATE TABLE [dbo].[tbl_CatalogoEstado] (
    [IdEstado]     INT           IDENTITY (1, 1) NOT NULL,
    [NombreEstado] NVARCHAR (30) NOT NULL,
    [Activo]       BIT           NOT NULL,
    [IdZona]       INT           NOT NULL,
    [IsDeleted]    BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_CatalogoEstado] PRIMARY KEY CLUSTERED ([IdEstado] ASC),
    CONSTRAINT [FK_Estados_Zona] FOREIGN KEY ([IdZona]) REFERENCES [dbo].[tbl_Zona] ([IdZona])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CatalogoEstado_IdZona]
    ON [dbo].[tbl_CatalogoEstado]([IdZona] ASC);

