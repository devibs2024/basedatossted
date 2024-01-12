CREATE TABLE [dbo].[tbl_SubDirectorCoordinador] (
    [IdCoordinador] BIGINT NOT NULL,
    [IdSubDirector] BIGINT NOT NULL,
    [IsDeleted]     BIT    DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_SubDirectorCoordinador] PRIMARY KEY CLUSTERED ([IdSubDirector] ASC, [IdCoordinador] ASC),
    CONSTRAINT [FK_SubDirectorCoordinador_Coordinador] FOREIGN KEY ([IdCoordinador]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_SubDirectorCoordinador_IdCoordinador]
    ON [dbo].[tbl_SubDirectorCoordinador]([IdCoordinador] ASC);

