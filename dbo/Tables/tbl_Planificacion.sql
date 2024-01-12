CREATE TABLE [dbo].[tbl_Planificacion] (
    [IdPlanificacion]        DECIMAL (18)  IDENTITY (1, 1) NOT NULL,
    [FechaDesde]             DATE          NOT NULL,
    [FechaHasta]             DATE          NOT NULL,
    [Comentario]             NVARCHAR (50) NOT NULL,
    [IdCoordinador]          BIGINT        NOT NULL,
    [FrecuenciaId]           INT           DEFAULT ((0)) NOT NULL,
    [EstatusPlanificacionId] INT           DEFAULT ((0)) NOT NULL,
    [IsDeleted]              BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_Planificacion] PRIMARY KEY CLUSTERED ([IdPlanificacion] ASC),
    CONSTRAINT [FK_Planificacion_Coordinador] FOREIGN KEY ([IdCoordinador]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Planificacion_IdCoordinador]
    ON [dbo].[tbl_Planificacion]([IdCoordinador] ASC);

