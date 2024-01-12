CREATE TABLE [dbo].[tbl_Horario] (
    [IdHorario]  BIGINT   IDENTITY (1, 1) NOT NULL,
    [IdDia]      INT      NOT NULL,
    [HoraInicio] TIME (7) NULL,
    [HoraFin]    TIME (7) NULL,
    [Activo]     BIT      NULL,
    [IsDeleted]  BIT      DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_Horario] PRIMARY KEY CLUSTERED ([IdHorario] ASC),
    CONSTRAINT [FK_Horario_Dias] FOREIGN KEY ([IdDia]) REFERENCES [dbo].[tbl_CatalogoDias] ([IdDia])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Horario_IdDia]
    ON [dbo].[tbl_Horario]([IdDia] ASC);

