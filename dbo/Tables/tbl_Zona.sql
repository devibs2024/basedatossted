CREATE TABLE [dbo].[tbl_Zona] (
    [IdZona]     INT           IDENTITY (1, 1) NOT NULL,
    [NombreZona] NVARCHAR (30) NOT NULL,
    [ClaveDET]   NVARCHAR (50) NOT NULL,
    [Activa]     BIT           NOT NULL,
    [IsDeleted]  BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_Zona] PRIMARY KEY CLUSTERED ([IdZona] ASC)
);

