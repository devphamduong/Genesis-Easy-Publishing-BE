USE [master]
GO
/****** Object:  Database [Easy_Publishing]    Script Date: 10/3/2022 12:24:24 AM ******/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'Easy_Publishing')
BEGIN
	ALTER DATABASE [Easy_Publishing] SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE [Easy_Publishing] SET ONLINE;
	DROP DATABASE [Easy_Publishing];
END
GO
CREATE DATABASE [Easy_Publishing]
GO
ALTER DATABASE [Easy_Publishing] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
BEGIN
EXEC [Easy_Publishing].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Easy_Publishing] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Easy_Publishing] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Easy_Publishing] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Easy_Publishing] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Easy_Publishing] SET ARITHABORT OFF 
GO
ALTER DATABASE [Easy_Publishing] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Easy_Publishing] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Easy_Publishing] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Easy_Publishing] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Easy_Publishing] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Easy_Publishing] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Easy_Publishing] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Easy_Publishing] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Easy_Publishing] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Easy_Publishing] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Easy_Publishing] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Easy_Publishing] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Easy_Publishing] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Easy_Publishing] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Easy_Publishing] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Easy_Publishing] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Easy_Publishing] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Easy_Publishing] SET RECOVERY FULL 
GO
ALTER DATABASE [Easy_Publishing] SET  MULTI_USER 
GO
ALTER DATABASE [Easy_Publishing] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Easy_Publishing] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Easy_Publishing] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Easy_Publishing] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Easy_Publishing] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Easy_Publishing] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Easy_Publishing', N'ON'
GO
ALTER DATABASE [Easy_Publishing] SET QUERY_STORE = OFF
GO
USE [Easy_Publishing]
GO

-- table Role
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[role_id] [int] IDENTITY(1,1) NOT NULL,
	[role_name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table User
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_fullname] [nvarchar](50) NULL,
	[gender] [bit] NULL,
	[dob] [date] NULL,
	[email] [varchar](50) NOT NULL,
	[phone] [varchar](11) NULL,
	[address] [nvarchar](200) NULL,
	[username] [nvarchar](50) NOT NULL,
	[password] [nvarchar](4000) NOT NULL,
	[user_image] [nvarchar](4000) NULL,
	[status] [bit] NULL DEFAULT 1,
	[description_markdown] [ntext] NULL,
	[description_html] [ntext] NULL,
	[role_id] [int] NOT NULL DEFAULT 2,
 CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Refund_Request
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Refund_Request](
	[request_id] [bigint] IDENTITY(1,1) NOT NULL,
	[wallet_id] [int] NOT NULL,
	[bank_id] [nvarchar](50) NULL,
	[bank_account] [nvarchar](50) NULL,
	[amount] [decimal](10, 2) NOT NULL,
	[request_time] [datetime] NOT NULL,
	[response_time] [datetime] NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_refund] PRIMARY KEY CLUSTERED 
(
	[request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Wallet
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wallet](
	[wallet_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[fund] [decimal] NOT NULL DEFAULT '0.00',
	[refund] [decimal] NOT NULL DEFAULT '0.00',
 CONSTRAINT [PK_wallet] PRIMARY KEY CLUSTERED 
(
	[wallet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Transaction
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transaction](
	[transaction_id] [bigint] IDENTITY(1,1) NOT NULL,
	[wallet_id] [int] NOT NULL,
	[story_id] [int] NULL,
	[chapter_id] [bigint] NULL,
	[amount] [decimal](10, 2) NOT NULL,
	[fund_before] [decimal](10, 2) NOT NULL,
	[fund_after] [decimal](10, 2) NOT NULL,
	[refund_before] [decimal](10, 2) NOT NULL,
	[refund_after] [decimal](10, 2) NOT NULL,
	[transaction_time] [datetime] NOT NULL,
	[status] [bit] NULL,
	[description] [nvarchar](500) NULL,
 CONSTRAINT [PK_Transaction] PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Story_Read_History
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Story_Read](
	[user_id] [int] NOT NULL,
	[story_id] [int] NOT NULL,
	[chapter_id] [bigint] NOT NULL,
	[read_time] [date] NOT NULL,
 CONSTRAINT [PK_story_read] PRIMARY KEY CLUSTERED 
(
	[user_id],[story_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Story_Follow
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Story_Follow_Like](
	[user_id] [int] NOT NULL,
	[story_id] [int] NOT NULL,
	[follow] [bit] NULL,
	[like] [bit] NULL,
 CONSTRAINT [PK_story_follow] PRIMARY KEY CLUSTERED 
(
	[user_id],[story_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Story_Owned
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Story_Owned](
	[user_id] [int] NOT NULL,
	[story_id] [int] NOT NULL,
 CONSTRAINT [PK_story_owned] PRIMARY KEY CLUSTERED 
(
	[user_id],[story_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Story
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Story](
	[story_id] [int] IDENTITY(1,1) NOT NULL,
	[story_title] [nvarchar](100) NOT NULL,
	[author_id] [int] NOT NULL,
	[story_price] [decimal](10, 2) NOT NULL,
	[story_sale] [decimal] NULL,
	[story_image] [varchar](4000) NULL,
	[story_description] [ntext] NULL,
	[story_description_markdown] [ntext] NULL,
	[story_description_html] [ntext] NULL,
	[create_time] [datetime] NOT NULL,
	[update_time] [datetime] NULL,
	[status] [int] NULL,
 CONSTRAINT [PK_story] PRIMARY KEY CLUSTERED 
(
	[story_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Story_Interaction
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Story_Interaction](
	[story_id] [int] NOT NULL,
	[like] [int] NOT NULL,
	[follow] [int] NOT NULL,
	[view] [int] NOT NULL,
	[read] [int] NOT NULL,
 CONSTRAINT [PK_story_interaction] PRIMARY KEY CLUSTERED 
(
	[story_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Category
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_name] [nvarchar](100) NULL,
	[category_banner] [nvarchar](3000) NULL,
	[category_description] [nvarchar](500) NULL,
 CONSTRAINT [PK_category] PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Story_Category
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Story_Category](
	[category_id] [int] NOT NULL,
	[story_id] [int] NOT NULL,
 CONSTRAINT [PK_story_category] PRIMARY KEY CLUSTERED 
(
	[category_id],[story_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Volume
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Volume](
	[volume_id] [int] IDENTITY(1,1) NOT NULL,
	[volume_number] [int] NOT NULL,
	[story_id] [int] NOT NULL,
	[volume_title] [nvarchar](100) NOT NULL,
	[create_time] [datetime] NOT NULL,
	[update_time] [datetime] NULL
    -- [volume_description] [nvarchar](2000) NOT NULL,
    -- [status] [bit] NULL,
  CONSTRAINT [PK_volume] PRIMARY KEY CLUSTERED 
(
	[volume_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- table Chapter
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chapter](
	[chapter_id] [bigint] IDENTITY(1,1) NOT NULL,
	[chapter_number] [bigint] NOT NULL,
	[story_id] [int] NOT NULL,
	[volume_id] [int] NOT NULL,
	[chapter_title] [nvarchar](100) NOT NULL,
	[chapter_content_markdown] [ntext] NULL,
	[chapter_content_html] [ntext] NULL,
	[chapter_price] [decimal](10, 2) NULL,
	[create_time] [datetime] NOT NULL,
	[update_time] [datetime] NULL,
	[status] [int] NULL,
  CONSTRAINT [PK_chapter] PRIMARY KEY CLUSTERED 
(
	[chapter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- table Chapter_Owned
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chapter_Owned](
	[user_id] [int] NOT NULL,
	[chapter_id] [bigint] NOT NULL,
 CONSTRAINT [PK_chapter_owned] PRIMARY KEY CLUSTERED 
(
	[user_id],[chapter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Chapter_Like
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chapter_Liked](
	[user_id] [int] NOT NULL,
	[chapter_id] [bigint] NOT NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_chapter_liked] PRIMARY KEY CLUSTERED 
(
	[user_id],[chapter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- -- table Story_Issue
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE TABLE [dbo].[Story_Issue](
-- 	[issue_id] [int] IDENTITY(1,1) NOT NULL,
-- 	[user_id] [int] NOT NULL,
-- 	[story_id] [int] NULL,
-- 	[issue_title] [nvarchar](100) NOT NULL,
-- 	[issue_content] [nvarchar](500) NOT NULL,
-- 	[issue_date] [date] NOT NULL,
--   CONSTRAINT [PK_story_issue] PRIMARY KEY CLUSTERED 
-- (
-- 	[issue_id] ASC
-- )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
-- ) ON [PRIMARY]
-- GO

-- table Comment
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comment](
	[comment_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[story_id] [int] NULL,
	[chapter_id] [bigint] NULL,
	-- [issue_id] [int] NULL,
	[comment_content] [nvarchar](2000) NOT NULL,
	[comment_date] [datetime] NOT NULL,
 CONSTRAINT [PK_comment] PRIMARY KEY CLUSTERED 
(
	[comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- -- table Comment Repsponse
-- SET ANSI_NULLS ON
-- GO
-- SET QUOTED_IDENTIFIER ON
-- GO
-- CREATE TABLE [dbo].[CommentResponse](
-- 	[comment_response_id] [int] IDENTITY(1,1) NOT NULL,
-- 	[user_id] [int] NOT NULL,
-- 	[comment_id] [int] NULL,
-- 	[comment_content] [nvarchar](2000) NOT NULL,
-- 	[comment_date] [date] NOT NULL,
--  CONSTRAINT [PK_commentresponse] PRIMARY KEY CLUSTERED 
-- (
-- 	[comment_response_id] ASC
-- )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
-- ) ON [PRIMARY]
-- GO

-- table ReportType
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportType](
	[report_type_id] [int] IDENTITY(1,1) NOT NULL,
	[report_type_content] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_reporttype] PRIMARY KEY CLUSTERED 
(
	[report_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table ReportContent
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportContent](
	[report_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[report_type_id] [int] NOT NULL,
	[story_id] [int] NULL,
	[chapter_id] [bigint] NULL,
	-- [issue_id] [int] NULL,
	[comment_id] [int] NULL,
	-- [report_title] [nvarchar](100) NOT NULL,
	[report_content] [nvarchar](2000) NULL,
	[report_date] [date] NOT NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_reportcontent] PRIMARY KEY CLUSTERED 
(
	[report_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Review
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Review](
	[review_id] [int] IDENTITY(1,1) NOT NULL,
	[chapter_id] [bigint] NOT NULL,
	[spelling_error] [bit] NOT NULL,
	[length_error] [bit] NOT NULL,
	[review_content] [nvarchar](2000) NULL,
	[political_content_error] [bit] NOT NULL,
	[distort history_error] [bit] NOT NULL,
	[secret_content_error] [bit] NOT NULL,
	[offensive_content_error] [bit] NOT NULL,
	[unhealthy_content_error] [bit] NOT NULL,
	[user_id] [int] NOT NULL,
	[review_date] [datetime] NOT NULL,
 CONSTRAINT [PK_review] PRIMARY KEY CLUSTERED 
(
	[review_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Ticket
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ticket](
	[ticket_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[ticket_date] [datetime] NOT NULL,
	[status] [bit] NULL,
	[seen] [bit] NULL,
 CONSTRAINT [PK_ticket] PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

---------------------------------------------- begin data--------------------------------------------------------------------------





---------------------------------------------------------- end data--------------------------------------------------------------

ALTER TABLE [dbo].[Refund_Request]  WITH CHECK ADD FOREIGN KEY([wallet_id])
REFERENCES [dbo].[Wallet] ([wallet_id])
GO

ALTER TABLE [dbo].[Wallet]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD FOREIGN KEY([wallet_id])
REFERENCES [dbo].[Wallet] ([wallet_id])
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD FOREIGN KEY([chapter_id])
REFERENCES [dbo].[Chapter] ([chapter_id])
GO

ALTER TABLE [dbo].[Story_Read]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Story_Read]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Story_Read]  WITH CHECK ADD FOREIGN KEY([chapter_id])
REFERENCES [dbo].[Chapter] ([chapter_id])
GO

ALTER TABLE [dbo].[Story_Follow_Like]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Story_Follow_Like]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Story_Owned]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Story_Owned]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Story]  WITH CHECK ADD FOREIGN KEY([author_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Story_Interaction]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Story_Category]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Story_Category]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[Category] ([category_id])
GO

ALTER TABLE [dbo].[Volume]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Chapter]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Chapter]  WITH CHECK ADD FOREIGN KEY([volume_id])
REFERENCES [dbo].[Volume] ([volume_id])
GO

ALTER TABLE [dbo].[Chapter_Owned]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Chapter_Owned]  WITH CHECK ADD FOREIGN KEY([chapter_id])
REFERENCES [dbo].[Chapter] ([chapter_id])
GO

ALTER TABLE [dbo].[Chapter_Liked]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Chapter_Liked]  WITH CHECK ADD FOREIGN KEY([chapter_id])
REFERENCES [dbo].[Chapter] ([chapter_id])
GO
-- ALTER TABLE [dbo].[Story_Issue]  WITH CHECK ADD FOREIGN KEY([user_id])
-- REFERENCES [dbo].[User] ([user_id])
-- GO

-- ALTER TABLE [dbo].[Story_Issue]  WITH CHECK ADD FOREIGN KEY([story_id])
-- REFERENCES [dbo].[Story] ([story_id])
-- GO

ALTER TABLE [dbo].[Comment]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Comment]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Comment]  WITH CHECK ADD FOREIGN KEY([chapter_id])
REFERENCES [dbo].[Chapter] ([chapter_id])
GO

-- ALTER TABLE [dbo].[Comment]  WITH CHECK ADD FOREIGN KEY([issue_id])
-- REFERENCES [dbo].[Story_Issue] ([issue_id])
-- GO

-- ALTER TABLE [dbo].[CommentResponse]  WITH CHECK ADD FOREIGN KEY([user_id])
-- REFERENCES [dbo].[User] ([user_id])
-- GO

-- ALTER TABLE [dbo].[CommentResponse]  WITH CHECK ADD FOREIGN KEY([comment_id])
-- REFERENCES [dbo].[Comment] ([comment_id])
-- GO

ALTER TABLE [dbo].[ReportContent]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[ReportContent]  WITH CHECK ADD FOREIGN KEY([report_type_id])
REFERENCES [dbo].[ReportType] ([report_type_id])
GO

ALTER TABLE [dbo].[ReportContent]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[ReportContent]  WITH CHECK ADD FOREIGN KEY([chapter_id])
REFERENCES [dbo].[Chapter] ([chapter_id])
GO

-- ALTER TABLE [dbo].[ReportContent]  WITH CHECK ADD FOREIGN KEY([issue_id])
-- REFERENCES [dbo].[Story_Issue] ([issue_id])
-- GO

ALTER TABLE [dbo].[ReportContent]  WITH CHECK ADD FOREIGN KEY([comment_id])
REFERENCES [dbo].[Comment] ([comment_id])
GO

ALTER TABLE [dbo].[User]  WITH CHECK ADD FOREIGN KEY([role_id])
REFERENCES [dbo].[Role] ([role_id])
GO

ALTER TABLE [dbo].[Review]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Review]  WITH CHECK ADD FOREIGN KEY([chapter_id])
REFERENCES [dbo].[Chapter] ([chapter_id])
GO

ALTER TABLE [dbo].[Ticket]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO
	
CREATE TRIGGER trg_InsertStoryInteraction
ON [dbo].[Story]
AFTER INSERT
AS
BEGIN
    INSERT INTO [dbo].[Story_Interaction] ([story_id], [like], [follow], [view], [read])
    SELECT
        inserted.[story_id],0,0,0,0  
    FROM inserted;
END;

IF NOT EXISTS (
    SELECT * 
    FROM sys.fn_listextendedproperty(N'MS_Description', 'SCHEMA', 'dbo', 'TABLE', 'Transaction', 'COLUMN', 'status')
)
BEGIN
    EXEC sys.sp_addextendedproperty 
        @name = N'MS_Description', 
        @value = N'0 means Fail, 1 means Pending, 2 means Successful',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE',  @level1name = 'Transaction',
        @level2type = N'COLUMN', @level2name = 'status';
END

GO
USE [master]
GO
ALTER DATABASE [Easy_Publishing] SET  READ_WRITE 
GO
