CREATE TABLE [dbo].[tbl_DetallePlanificacion] (
    [IdPlanificacion]        DECIMAL (18) NOT NULL,
    [IdDetallePlanificacion] DECIMAL (18) IDENTITY (1, 1) NOT NULL,
    [IdOperador]             BIGINT       NOT NULL,
    [IdTienda]               INT          NOT NULL,
    [Fecha]                  DATE         NOT NULL,
    [HoraInicio]             TIME (7)     NOT NULL,
    [HoraFin]                TIME (7)     NOT NULL,
    [Descanso]               BIT          NOT NULL,
    [IsDeleted]              BIT          DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_DetallePlanificacion] PRIMARY KEY CLUSTERED ([IdPlanificacion] ASC, [IdDetallePlanificacion] ASC),
    CONSTRAINT [FK_Detalle_Planificacion] FOREIGN KEY ([IdPlanificacion]) REFERENCES [dbo].[tbl_Planificacion] ([IdPlanificacion]),
    CONSTRAINT [FK_DetallePlanificacion_Operador] FOREIGN KEY ([IdOperador]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado]),
    CONSTRAINT [FK_tbl_DetallePlanificacion_tbl_Tienda_IdTienda] FOREIGN KEY ([IdTienda]) REFERENCES [dbo].[tbl_Tienda] ([IdTienda]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DetallePlanificacion_IdOperador]
    ON [dbo].[tbl_DetallePlanificacion]([IdOperador] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DetallePlanificacion_IdTienda]
    ON [dbo].[tbl_DetallePlanificacion]([IdTienda] ASC);

