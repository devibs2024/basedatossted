CREATE TABLE [dbo].[tbl_ValidateUserAccount] (
    [IdValidarCuenta]   INT            IDENTITY (1, 1) NOT NULL,
    [IdEmpleado]        BIGINT         NULL,
    [CorreoEmpleado]    NVARCHAR (MAX) NOT NULL,
    [CodigoVerficacion] NVARCHAR (MAX) NOT NULL,
    [fechaExpiracion]   DATETIME       NOT NULL,
    [TipoCodigo]        NVARCHAR (50)  NOT NULL,
    [IsDeleted]         BIT            NOT NULL,
    CONSTRAINT [PK_tbl_ValidateUserAccount] PRIMARY KEY CLUSTERED ([IdValidarCuenta] ASC)
);

