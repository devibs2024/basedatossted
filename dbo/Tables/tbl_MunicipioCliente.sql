CREATE TABLE [dbo].[tbl_MunicipioCliente] (
    [IdMunicipio] INT    NOT NULL,
    [IdCliente]   BIGINT NOT NULL,
    [IsDeleted]   BIT    DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_MunicipioCliente] PRIMARY KEY CLUSTERED ([IdMunicipio] ASC, [IdCliente] ASC),
    CONSTRAINT [FK_MunicipioCliente_Cliente] FOREIGN KEY ([IdCliente]) REFERENCES [dbo].[tbl_Cliente] ([IdCliente]),
    CONSTRAINT [FK_MunicipioCliente_Formato] FOREIGN KEY ([IdMunicipio]) REFERENCES [dbo].[tbl_CatalogoMunicipio] ([IdMunicipio])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_MunicipioCliente_IdCliente]
    ON [dbo].[tbl_MunicipioCliente]([IdCliente] ASC);

