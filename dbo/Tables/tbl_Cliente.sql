CREATE TABLE [dbo].[tbl_Cliente] (
    [IdCliente]           BIGINT          IDENTITY (1, 1) NOT NULL,
    [Clave]               BIGINT          NOT NULL,
    [NombreCliente]       NVARCHAR (100)  NOT NULL,
    [IdEstado]            INT             NULL,
    [IdMunicipio]         INT             NULL,
    [IdZona]              INT             NULL,
    [Tarifa]              DECIMAL (18, 2) NULL,
    [TarifaHoraAdicional] DECIMAL (18, 2) NULL,
    [TarifaConAyudante]   DECIMAL (18, 2) NULL,
    [TarifaSpot]          DECIMAL (18, 2) NULL,
    [IsDeleted]           BIT             DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_Cliente] PRIMARY KEY CLUSTERED ([IdCliente] ASC),
    CONSTRAINT [FK_Clientes_Estado] FOREIGN KEY ([IdEstado]) REFERENCES [dbo].[tbl_CatalogoEstado] ([IdEstado]),
    CONSTRAINT [FK_Clientes_Municipio] FOREIGN KEY ([IdMunicipio]) REFERENCES [dbo].[tbl_CatalogoMunicipio] ([IdMunicipio]),
    CONSTRAINT [FK_tbl_Cliente_tbl_Zona_IdZona] FOREIGN KEY ([IdZona]) REFERENCES [dbo].[tbl_Zona] ([IdZona])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Cliente_IdEstado]
    ON [dbo].[tbl_Cliente]([IdEstado] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Cliente_IdMunicipio]
    ON [dbo].[tbl_Cliente]([IdMunicipio] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Cliente_IdZona]
    ON [dbo].[tbl_Cliente]([IdZona] ASC);

