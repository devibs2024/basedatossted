CREATE TABLE [dbo].[tbl_CheckIn_CheckOut] (
    [IdCheck]                         BIGINT         IDENTITY (1, 1) NOT NULL,
    [IdEmpleado]                      BIGINT         NOT NULL,
    [CheckIN]                         NVARCHAR (MAX) NOT NULL,
    [CheckIn_Photo_Path]              NVARCHAR (MAX) NULL,
    [CheckIn_PhotoPerfil_Path]        NVARCHAR (MAX) NULL,
    [CheckIn_PhotoCarroExterior_Path] NVARCHAR (MAX) NULL,
    [CheckIn_PhotoCarroInterior_Path] NVARCHAR (MAX) NULL,
    [status_Entrada]                  NVARCHAR (MAX) NOT NULL,
    [IdSucursal]                      INT            NOT NULL,
    [IdSucursalActual]                INT            NULL,
    [CheckOut]                        NVARCHAR (MAX) NULL,
    [Fecha]                           DATETIME2 (7)  NOT NULL,
    [CheckOut_Photo_Perfil]           NVARCHAR (MAX) NULL,
    [CheckOut_Photo2_Uniforme]        NVARCHAR (MAX) NULL,
    [CheckOut_Photo3_Factura]         NVARCHAR (MAX) NULL,
    [width]                           INT            NOT NULL,
    [height]                          INT            NOT NULL,
    [IsDeleted]                       BIT            DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_CheckIn_CheckOut] PRIMARY KEY CLUSTERED ([IdCheck] ASC),
    CONSTRAINT [FK_CheckIn_CheckOut_Empleado] FOREIGN KEY ([IdEmpleado]) REFERENCES [dbo].[tbl_Empleados] ([IdEmpleado])
);


GO
CREATE NONCLUSTERED INDEX [IX_tbl_CheckIn_CheckOut_IdEmpleado]
    ON [dbo].[tbl_CheckIn_CheckOut]([IdEmpleado] ASC);

