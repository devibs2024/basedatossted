CREATE TABLE [dbo].[tbl_EmpleadoCoordinador] (
    [IdOperador]    BIGINT NOT NULL,
    [IdCoordinador] BIGINT NOT NULL,
    [IsDeleted]     BIT    DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_EmpleadoCoordinador] PRIMARY KEY CLUSTERED ([IdOperador] ASC, [IdCoordinador] ASC),
    CONSTRAINT [FK_EmpleadoCoordinador_Coordinador] FOREIGN KEY ([IdCoordinador]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_EmpleadoCoordinador_IdCoordinador]
    ON [dbo].[tbl_EmpleadoCoordinador]([IdCoordinador] ASC);

