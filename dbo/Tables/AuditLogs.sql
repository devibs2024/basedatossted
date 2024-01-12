CREATE TABLE [dbo].[AuditLogs] (
    [Id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [TableName]  NVARCHAR (50)  NOT NULL,
    [EntityId]   NVARCHAR (450) NOT NULL,
    [ActionType] NVARCHAR (12)  NOT NULL,
    [UserId]     NVARCHAR (75)  NOT NULL,
    [OldValues]  NVARCHAR (MAX) NOT NULL,
    [NewValues]  NVARCHAR (MAX) NOT NULL,
    [ActionDate] DATETIME2 (7)  NOT NULL,
    CONSTRAINT [PK_AuditLogs] PRIMARY KEY CLUSTERED ([Id] ASC)
);

