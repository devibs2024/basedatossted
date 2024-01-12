CREATE TABLE [dbo].[tbl_ContactoCliente] (
    [IdContacto]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [IdCliente]    BIGINT         NOT NULL,
    [Nombre]       NVARCHAR (MAX) NOT NULL,
    [email]        NVARCHAR (MAX) NOT NULL,
    [telefono]     NVARCHAR (MAX) NOT NULL,
    [telefono2]    NVARCHAR (MAX) NOT NULL,
    [Activo]       BIT            NOT NULL,
    [TipoContacto] INT            NOT NULL,
    [IsDeleted]    BIT            DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_ContactoCliente] PRIMARY KEY CLUSTERED ([IdContacto] ASC),
    CONSTRAINT [FK_Contacto_Cliente] FOREIGN KEY ([IdCliente]) REFERENCES [dbo].[tbl_Cliente] ([IdCliente])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_ContactoCliente_IdCliente]
    ON [dbo].[tbl_ContactoCliente]([IdCliente] ASC);

