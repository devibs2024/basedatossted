CREATE TABLE [dbo].[tbl_VehiculoOperador] (
    [IdVehiculo] BIGINT NOT NULL,
    [IdEmpleado] BIGINT NOT NULL,
    [IsDeleted]  BIT    DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_VehiculoOperador] PRIMARY KEY CLUSTERED ([IdVehiculo] ASC, [IdEmpleado] ASC),
    CONSTRAINT [FK_VehiculoOperador_Empleados] FOREIGN KEY ([IdEmpleado]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado]),
    CONSTRAINT [FK_VehiculoOperador_Operador] FOREIGN KEY ([IdVehiculo]) REFERENCES [dbo].[tbl_Vehiculo] ([IdVehiculo])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_VehiculoOperador_IdEmpleado]
    ON [dbo].[tbl_VehiculoOperador]([IdEmpleado] ASC);

