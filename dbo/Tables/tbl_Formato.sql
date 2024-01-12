CREATE TABLE [dbo].[tbl_Formato] (
    [IdFormato]          INT           IDENTITY (1, 1) NOT NULL,
    [DescripcionFormato] NVARCHAR (30) NOT NULL,
    [Estado]             BIT           NOT NULL,
    [IsDeleted]          BIT           DEFAULT (CONVERT([bit],(0))) NOT NULL,
    CONSTRAINT [PK_tbl_Formato] PRIMARY KEY CLUSTERED ([IdFormato] ASC)
);

