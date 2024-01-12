CREATE TABLE [dbo].[tbl_EjecucionPlanificacion] (
    [IdPlanificacion]          DECIMAL (18)    NOT NULL,
    [IdEjecucionPlanificacion] DECIMAL (18)    IDENTITY (1, 1) NOT NULL,
    [IdDetallePlanificacion]   DECIMAL (18)    NOT NULL,
    [IdOperador]               BIGINT          NOT NULL,
    [IdTienda]                 INT             DEFAULT ((0)) NOT NULL,
    [Fecha]                    DATE            NOT NULL,
    [HoraInicio]               TIME (7)        NOT NULL,
    [HoraFin]                  TIME (7)        NOT NULL,
    [Descanso]                 BIT             NOT NULL,
    [IncentivoFactura]         DECIMAL (18, 2) DEFAULT ((0.0)) NOT NULL,
    [DescuentoTardanza]        DECIMAL (18, 2) DEFAULT ((0.0)) NOT NULL,
    [MontoHorasExtras]         DECIMAL (18, 2) DEFAULT ((0.0)) NOT NULL,
    [TipoRegistro]             INT             NOT NULL,
    [Justificacion]            NVARCHAR (250)  DEFAULT (N'') NOT NULL,
    [IsDeleted]                BIT             DEFAULT (CONVERT([bit],(0))) NOT NULL,
    [MontoCombustible]         DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_tbl_EjecucionPlanificacion] PRIMARY KEY CLUSTERED ([IdPlanificacion] ASC, [IdEjecucionPlanificacion] ASC),
    CONSTRAINT [FK_Ejecucion_Planificacion] FOREIGN KEY ([IdPlanificacion]) REFERENCES [dbo].[tbl_Planificacion] ([IdPlanificacion]),
    CONSTRAINT [FK_EjecucionPlanificacion_Operador] FOREIGN KEY ([IdOperador]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado]),
    CONSTRAINT [FK_tbl_EjecucionPlanificacion_tbl_Tienda_IdTienda] FOREIGN KEY ([IdTienda]) REFERENCES [dbo].[tbl_Tienda] ([IdTienda]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_EjecucionPlanificacion_IdOperador]
    ON [dbo].[tbl_EjecucionPlanificacion]([IdOperador] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_EjecucionPlanificacion_IdTienda]
    ON [dbo].[tbl_EjecucionPlanificacion]([IdTienda] ASC);

