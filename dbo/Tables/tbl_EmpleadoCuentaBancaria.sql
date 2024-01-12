CREATE TABLE [dbo].[tbl_EmpleadoCuentaBancaria] (
    [IdCuenta]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [IdEmpleado]      BIGINT        NULL,
    [IdBanco]         INT           NOT NULL,
    [CuentaBancaria]  NVARCHAR (20) NOT NULL,
    [Activa]          BIT           NULL,
    [CuentaPrincipal] BIT           NULL,
    [IsDeleted]       BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_EmpleadoCuentaBancaria] PRIMARY KEY CLUSTERED ([IdCuenta] ASC),
    CONSTRAINT [FK_EmpleadoCuentaBancaria_Bancos] FOREIGN KEY ([IdBanco]) REFERENCES [dbo].[tbl_CatalogoBancos] ([IdBanco]),
    CONSTRAINT [FK_EmpleadoCuentaBancaria_Empleados] FOREIGN KEY ([IdEmpleado]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_EmpleadoCuentaBancaria_IdBanco]
    ON [dbo].[tbl_EmpleadoCuentaBancaria]([IdBanco] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_EmpleadoCuentaBancaria_IdEmpleado]
    ON [dbo].[tbl_EmpleadoCuentaBancaria]([IdEmpleado] ASC);

