CREATE TABLE [dbo].[tbl_CoordinadorCliente] (
    [IdCoordinador] BIGINT NOT NULL,
    [IdCliente]     BIGINT NOT NULL,
    [IsDeleted]     BIT    DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_CoordinadorCliente] PRIMARY KEY CLUSTERED ([IdCoordinador] ASC, [IdCliente] ASC),
    CONSTRAINT [FK_CoordinadorCliente_Cliente] FOREIGN KEY ([IdCliente]) REFERENCES [dbo].[tbl_Cliente] ([IdCliente]),
    CONSTRAINT [FK_CoordinadorCliente_Coordinador] FOREIGN KEY ([IdCoordinador]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CoordinadorCliente_IdCliente]
    ON [dbo].[tbl_CoordinadorCliente]([IdCliente] ASC);

