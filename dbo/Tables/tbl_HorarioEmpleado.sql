CREATE TABLE [dbo].[tbl_HorarioEmpleado] (
    [IdHorario]  BIGINT NOT NULL,
    [IdEmpleado] BIGINT NOT NULL,
    [IsDeleted]  BIT    DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_HorarioEmpleado] PRIMARY KEY CLUSTERED ([IdHorario] ASC, [IdEmpleado] ASC),
    CONSTRAINT [FK_HorarioEmpleado_Empleado] FOREIGN KEY ([IdEmpleado]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado]),
    CONSTRAINT [FK_HorarioEmpleado_Horario] FOREIGN KEY ([IdHorario]) REFERENCES [dbo].[tbl_Horario] ([IdHorario])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_HorarioEmpleado_IdEmpleado]
    ON [dbo].[tbl_HorarioEmpleado]([IdEmpleado] ASC);

