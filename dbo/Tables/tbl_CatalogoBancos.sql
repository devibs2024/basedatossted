CREATE TABLE [dbo].[tbl_CatalogoBancos] (
    [IdBanco]     INT           IDENTITY (1, 1) NOT NULL,
    [NombreBanco] NVARCHAR (50) NULL,
    [Activo]      BIT           NULL,
    [IsDeleted]   BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_CatalogoBancos] PRIMARY KEY CLUSTERED ([IdBanco] ASC)
);

