CREATE TABLE [dbo].[tbl_AsignacionTarjeta] (
    [IdTarjeta]        BIGINT          IDENTITY (1, 1) NOT NULL,
    [IdEmpleado]       BIGINT          NOT NULL,
    [NumTarjeta]       NVARCHAR (50)   NULL,
    [NumeroInterno]    NVARCHAR (50)   NULL,
    [Activa]           BIT             NULL,
    [TarjetaPrincipal] BIT             NOT NULL,
    [MontoDiario]      DECIMAL (18, 2) NOT NULL,
    [IsDeleted]        BIT             DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_AsignacionTarjeta] PRIMARY KEY CLUSTERED ([IdTarjeta] ASC),
    CONSTRAINT [FK_AsignacionTarjeta_Empleados] FOREIGN KEY ([IdEmpleado]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_AsignacionTarjeta_IdEmpleado]
    ON [dbo].[tbl_AsignacionTarjeta]([IdEmpleado] ASC);

