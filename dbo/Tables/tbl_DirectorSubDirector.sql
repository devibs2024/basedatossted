CREATE TABLE [dbo].[tbl_DirectorSubDirector] (
    [IdDirector]    BIGINT NOT NULL,
    [IdSubDirector] BIGINT NOT NULL,
    [IsDeleted]     BIT    DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_DirectorSubDirector] PRIMARY KEY CLUSTERED ([IdSubDirector] ASC, [IdDirector] ASC),
    CONSTRAINT [FK_DirectorSubDirector_Director] FOREIGN KEY ([IdDirector]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_DirectorSubDirector_IdDirector]
    ON [dbo].[tbl_DirectorSubDirector]([IdDirector] ASC);

