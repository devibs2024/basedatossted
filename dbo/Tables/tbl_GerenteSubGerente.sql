CREATE TABLE [dbo].[tbl_GerenteSubGerente] (
    [IdGerente]    BIGINT NOT NULL,
    [IdSubGerente] BIGINT NOT NULL,
    [IsDeleted]    BIT    DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_GerenteSubGerente] PRIMARY KEY CLUSTERED ([IdGerente] ASC, [IdSubGerente] ASC),
    CONSTRAINT [FK_Contacto_SubGerentes] FOREIGN KEY ([IdSubGerente]) REFERENCES [dbo].[tbl_ContactoCliente] ([IdContacto])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_GerenteSubGerente_IdSubGerente]
    ON [dbo].[tbl_GerenteSubGerente]([IdSubGerente] ASC);

