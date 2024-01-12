CREATE TABLE [dbo].[tbl_FormatoCliente] (
    [IdFormato] INT    NOT NULL,
    [IdCliente] BIGINT NOT NULL,
    [IsDeleted] BIT    DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_FormatoCliente] PRIMARY KEY CLUSTERED ([IdFormato] ASC, [IdCliente] ASC),
    CONSTRAINT [FK_FormatoCliente_Cliente] FOREIGN KEY ([IdCliente]) REFERENCES [dbo].[tbl_Cliente] ([IdCliente]),
    CONSTRAINT [FK_FormatoCliente_Formato] FOREIGN KEY ([IdFormato]) REFERENCES [dbo].[tbl_Formato] ([IdFormato])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_FormatoCliente_IdCliente]
    ON [dbo].[tbl_FormatoCliente]([IdCliente] ASC);

