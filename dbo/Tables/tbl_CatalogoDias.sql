CREATE TABLE [dbo].[tbl_CatalogoDias] (
    [IdDia]       INT            NOT NULL,
    [Descripcion] NVARCHAR (50)  NULL,
    [Siglas]      NVARCHAR (MAX) NULL,
    [IsDeleted]   BIT            DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_CatalogoDias] PRIMARY KEY CLUSTERED ([IdDia] ASC)
);

