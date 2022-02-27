IF NOT EXISTS( SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='Student')
BEGIN
CREATE TABLE [dbo].[Student](
	[RollNo] [bigint] IDENTITY(1,1) NOT NULL,
	[StudentName] [varchar](50) NULL,
	[Department] [varchar](50) NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[RollNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
----/////////////////////////////////////////////////////////////////////////////////////////////
IF NOT EXISTS( SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='Resource')
BEGIN
CREATE TABLE [dbo].[Resource](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ResourceName] [varchar](50) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[StudentId] [int] NULL,
	[ResourceExpiryStatus]  AS (case when getdate()>[EndDate] then (1) when getdate()<[EndDate] then (0)  end),
 CONSTRAINT [PK_Resource] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
----/////////////////////////////////////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_resource]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_resource]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
CREATE PROCEDURE usp_resource
@id int,
@resourcename varchar(50),
@s_date date,
@e_date date,
@flag int = 0
AS
BEGIN
if(@flag = 0)
BEGIN
DECLARE @data INT
SET @data = (select COUNT(*) from Resource where ID = @id);
IF(@data = 0)
BEGIN
INSERT INTO Resource(ResourceName
,StartDate
,EndDate)
VALUES( @resourcename, @s_date, @e_date)
END
ELSE IF(@data = 1)
BEGIN
Update Resource SET ResourceName = @resourcename, StartDate = @s_date, EndDate= @e_date where ID = @id
END
END
END
GO
---/////////////////////////////////////////////////////////////////////////
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_student]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_student]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
CREATE PROCEDURE [dbo].[usp_student]
@rollno bigint,
@name varchar(50),
@department varchar(50),
@flag int = 0
AS
BEGIN
if(@flag = 0)
BEGIN
DECLARE @data INT
SET @data = (select COUNT(*) from Student where RollNo = @rollno);
IF(@data = 0)
BEGIN
INSERT INTO Student(StudentName
,Department)
VALUES(@name, @department)
END
ELSE IF(@data = 1)
BEGIN
Update Student SET StudentName = @name, Department = @department where RollNo = @rollno
END
END
ELSE IF(@flag = 1)
BEGIN
DELETE FROM Student WHERE RollNo = @rollno
END
END
GO
----/////////////////////////////////////////////////////////////////////////////////////////////

