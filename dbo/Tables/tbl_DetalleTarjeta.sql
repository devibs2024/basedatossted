CREATE TABLE [dbo].[tbl_DetalleTarjeta] (
    [IdDetalleTarjeta] INT             IDENTITY (1, 1) NOT NULL,
    [IdTarjeta]        BIGINT          NULL,
    [IdEmpleado]       BIGINT          NULL,
    [Importe]          DECIMAL (18, 2) NULL,
    [FechaDispension]  DATETIME        NULL,
    [IdSucursal]       INT             NULL,
    [IdCordinador]     BIGINT          NULL,
    [IsDeleted]        BIT             DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_DetalleTarjeta] PRIMARY KEY CLUSTERED ([IdDetalleTarjeta] ASC),
    CONSTRAINT [FK_DetalleTarjeta_AsignacionTarjeta] FOREIGN KEY ([IdTarjeta]) REFERENCES [dbo].[tbl_AsignacionTarjeta] ([IdTarjeta]),
    CONSTRAINT [FK_DetalleTarjeta_Coordinador] FOREIGN KEY ([IdCordinador]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado]),
    CONSTRAINT [FK_DetalleTarjeta_Empleado] FOREIGN KEY ([IdEmpleado]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DetalleTarjeta_IdCordinador]
    ON [dbo].[tbl_DetalleTarjeta]([IdCordinador] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DetalleTarjeta_IdEmpleado]
    ON [dbo].[tbl_DetalleTarjeta]([IdEmpleado] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DetalleTarjeta_IdTarjeta]
    ON [dbo].[tbl_DetalleTarjeta]([IdTarjeta] ASC);

