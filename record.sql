USE [data]
GO
/****** 对象:  Table [dbo].[t_records]    脚本日期: 07/27/2018 18:42:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_records](
	[day] [datetime] NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
	[electric] [varchar](100) COLLATE Chinese_PRC_CI_AS NULL,
	[voltage] [varchar](100) COLLATE Chinese_PRC_CI_AS NULL,
	[power] [varchar](100) COLLATE Chinese_PRC_CI_AS NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF