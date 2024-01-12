CREATE TABLE [dbo].[tbl_CatalogoMunicipio] (
    [IdMunicipio]     INT           IDENTITY (1, 1) NOT NULL,
    [IdEstado]        INT           NOT NULL,
    [NombreMunicipio] NVARCHAR (30) NOT NULL,
    [Activo]          BIT           NOT NULL,
    [IsDeleted]       BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_CatalogoMunicipio] PRIMARY KEY CLUSTERED ([IdMunicipio] ASC),
    CONSTRAINT [FK_Municipio_Estado] FOREIGN KEY ([IdEstado]) REFERENCES [dbo].[tbl_CatalogoEstado] ([IdEstado])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CatalogoMunicipio_IdEstado]
    ON [dbo].[tbl_CatalogoMunicipio]([IdEstado] ASC);

