CREATE TABLE [dbo].[tbl_Empleados] (
    [IdEmpleado]      BIGINT          IDENTITY (1, 1) NOT NULL,
    [NumeroContrato]  NUMERIC (18)    NOT NULL,
    [Nombres]         NVARCHAR (30)   NOT NULL,
    [ApellidoMaterno] NVARCHAR (20)   NULL,
    [ApellidoPaterno] NVARCHAR (20)   NULL,
    [Direccion]       NVARCHAR (100)  NOT NULL,
    [IdMunicipio]     INT             NOT NULL,
    [Telefono]        NVARCHAR (20)   NOT NULL,
    [Correo]          NVARCHAR (75)   NOT NULL,
    [Salario]         DECIMAL (18, 2) NULL,
    [IdTipoEmpleado]  INT             NULL,
    [IdSegmento]      INT             NULL,
    [SMG]             DECIMAL (18, 2) NULL,
    [IsDeleted]       BIT             DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_Empleados] PRIMARY KEY CLUSTERED ([IdEmpleado] ASC),
    CONSTRAINT [FK_Empleados_Municipio] FOREIGN KEY ([IdMunicipio]) REFERENCES [dbo].[tbl_CatalogoMunicipio] ([IdMunicipio])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_Empleados_IdMunicipio]
    ON [dbo].[tbl_Empleados]([IdMunicipio] ASC);

