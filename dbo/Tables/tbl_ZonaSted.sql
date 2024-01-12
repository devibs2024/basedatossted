CREATE TABLE [dbo].[tbl_ZonaSted] (
    [IdZonaSted] INT           IDENTITY (1, 1) NOT NULL,
    [NombreZona] NVARCHAR (30) NOT NULL,
    [ClaveDET]   NVARCHAR (50) NOT NULL,
    [Activa]     BIT           NOT NULL,
    [IdCliente]  BIGINT        NOT NULL,
    [IsDeleted]  BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_ZonaSted] PRIMARY KEY CLUSTERED ([IdZonaSted] ASC),
    CONSTRAINT [FK_tbl_ZonaSted_tbl_Cliente_IdCliente] FOREIGN KEY ([IdCliente]) REFERENCES [dbo].[tbl_Cliente] ([IdCliente]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_ZonaSted_IdCliente]
    ON [dbo].[tbl_ZonaSted]([IdCliente] ASC);

