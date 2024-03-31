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
	[role_id] [int] NOT NULL,
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
	[bank_id] [nvarchar](50) NULL,
	[bank_account] [nvarchar](50) NULL,
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
	[story_id] [int] NOT NULL,
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
	[ticket_date] [datetime] NULL,
	[status] [bit] NULL,
	[seen] [bit] NULL,
 CONSTRAINT [PK_ticket] PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [dbo].[Refund_Request] ON 
GO

INSERT [dbo].[Refund_Request] ([request_id], [wallet_id], [amount], [request_time], [response_time], [status]) VALUES 
	(1, 2, CAST(251.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:28:50.127' AS DateTime), CAST(N'2024-03-29T23:28:50.127' AS DateTime), null),
	(2, 3, CAST(251.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:28:51.147' AS DateTime), CAST(N'2024-03-29T23:28:51.147' AS DateTime), null),
	(3, 2, CAST(1324.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:28:57.853' AS DateTime), CAST(N'2024-03-29T23:28:57.853' AS DateTime), null),
	(4, 2, CAST(13.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:01.000' AS DateTime), CAST(N'2024-03-29T23:29:01.000' AS DateTime), null),
	(5, 3, CAST(33.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), CAST(N'2024-03-29T23:29:23.750' AS DateTime), null),
	(6, 3, CAST(43.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), CAST(N'2024-03-29T23:29:23.750' AS DateTime), null),
	(7, 4, CAST(33.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), CAST(N'2024-03-29T23:29:23.750' AS DateTime), null),
	(8, 10, CAST(323.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), CAST(N'2024-03-29T23:29:23.750' AS DateTime), null),
	(9, 2, CAST(313.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), CAST(N'2024-03-29T23:29:23.750' AS DateTime), null),
	(10, 10, CAST(33.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), CAST(N'2024-03-29T23:29:23.750' AS DateTime), null),
	(11, 2, CAST(350.00 AS Decimal(10, 2)), CAST(N'2024-04-01T03:16:18.863' AS DateTime), NULL, NULL),
	(12, 3, CAST(350.00 AS Decimal(10, 2)), CAST(N'2024-04-01T03:17:42.787' AS DateTime), NULL, NULL),
	(13, 4, CAST(245.00 AS Decimal(10, 2)), CAST(N'2024-04-01T03:18:13.683' AS DateTime), NULL, NULL),
	(14, 10, CAST(245.00 AS Decimal(10, 2)), CAST(N'2024-04-01T03:18:55.787' AS DateTime), NULL, NULL)

SET IDENTITY_INSERT [dbo].[Refund_Request] OFF
GO


-- insert
SET IDENTITY_INSERT [dbo].[Role] ON 
GO
INSERT [dbo].[Role] ([role_id], [role_name])
	VALUES 
		(1, N'Admin')
		,(2, N'Normal user')
		,(3, N'Reviewer')
GO
SET IDENTITY_INSERT [dbo].[Role] OFF
GO

SET IDENTITY_INSERT [dbo].[User] ON 
GO

INSERT [dbo].[User]([user_id],[user_fullname]  ,[gender] ,[dob] ,[email] ,[phone]  ,[address] ,[username] ,[password]  ,[user_image] ,[status],[description_markdown],[description_html], [role_id])  
	VALUES
		(1, N'Duy Pham', 1, CAST(N'2002-12-25' AS Date), N'duypd@fpt.edu.vn', N'0382132025', N'FBT University ', N'duypd', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=', null
		,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. 
		The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác.
		Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* 
		Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.'
		,N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. 
		The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. 
		Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong>
		Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.</p>\n', 1)
		,(2, N'Duy Pham', 1, CAST(N'2002-12-25' AS Date), N'duypd@gmail.com', N'0382132025', N'FBT University ', N'baspdd', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(3, N'Huy', 0, CAST(N'1969-09-20' AS Date), N'Bookie_User1@qa.team', N'6128170843', N'E312R', N'huynq', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=',null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(4, N'Mary Barisol', 1, CAST(N'1970-02-16' AS Date), N'Bookie_User2@qa.team', N'7134690959', N'F012R', N'namnd', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=',null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(5, N'Eden Frost', 1, CAST(N'1984-03-13' AS Date), N'Bookie_User3@qa.team', N'8252042139', N'B438R', N'duongpc', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(6, N'Benidict Robinett', 1, CAST(N'1966-02-10' AS Date), N'Bookie_User4@qa.team', N'3999059789', N'A400R', N'user_no4', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(7, N'Zera Farmer', 0, CAST(N'1961-02-10' AS Date), N'Bookie_Admin5@qa.team', N'5706825096', N'E271R', N'user_no5', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=',null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(8, N'Ceil Howell', 1, CAST(N'1992-09-16' AS Date), N'Bookie_User6@qa.team', N'5374439245', N'C146R', N'user_no6', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(9, N'Taylor Marcel', 0, CAST(N'2000-09-04' AS Date), N'Bookie_User7@qa.team', N'9180387665', N'E402L', N'user_no7', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=',null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 2)
		,(10, N'duy pham test', 1, CAST(N'1971-10-28' AS Date), N'duypdhe160308@fpt.edu.vn', N'0943678695', N'Ha noi', N'duypdhe160308', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 2)
		,(11, N'Aiken Pope', 1, CAST(N'1979-05-01' AS Date), N'Bookie_User9@qa.team', N'7770308417', N'F421L', N'user_no9', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=',null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(12, N'Rodolphe Blossom', 1, CAST(N'2001-02-19' AS Date), N'Bookie_User10@qa.team', N'6610856429', N'A168L', N'user_no10', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(13, N'Alex Rogze', 0, CAST(N'1987-08-07' AS Date), N'Bookie_Admin11@qa.team', N'9326626549', N'B508R', N'user_no11', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(14, N'Jean Padilla', 1, CAST(N'1967-11-16' AS Date), N'Bookie_User12@qa.team', N'3348144073', N'E545L', N'user_no12', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(15, N'Dana Franklin', 1, CAST(N'1965-08-28' AS Date), N'Bookie_User13@qa.team', N'0621966375', N'E501R', N'user_no13', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(16, N'Elluka Bush', 0, CAST(N'1996-11-19' AS Date), N'Bookie_User14@qa.team', N'5303149491', N'E329R', N'user_no14', N'eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(17, N'Kenelm Binder', 1, CAST(N'1962-04-16' AS Date), N'Bookie_User15@qa.team', N'8319378641', N'E300R', N'user_no15', N'EaMR6k40vW', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(18, N'Narcissus Freezis', 0, CAST(N'2000-02-19' AS Date), N'Bookie_User16@qa.team', N'5209703781', N'C223R', N'user_no16', N'pC0EkBn3S7', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 2)
		,(19, N'Michelle Reynolds', 0, CAST(N'1996-05-24' AS Date), N'Bookie_User17@qa.team', N'9960504670', N'A076L', N'user_no17', N'j75wC2vU9T', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(20, N'Callie Banica', 0, CAST(N'2003-03-28' AS Date), N'Bookie_User18@qa.team', N'6314402583', N'B591L', N'user_no18', N'AdqKEjAvT2', null, 1,N'Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \"EP\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.',N'<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.', 3)
		,(21, N'Malceria Freezis', 0, CAST(N'1992-02-20' AS Date), N'duypdhe160308@fpt.edu.com.vn', N'2483694818', N'E536R', N'user_no19', N'40PC98quFo', null, 1, null, null, 2)
		,(22, N'Jasmine Shepard', 1, CAST(N'1973-08-09' AS Date), N'Bookie_User20@qa.team', N'9780125454', N'C555L', N'user_no20', N'6G6nwxj3XG', null, 1, null, null, 2)
		,(23, N'Mia Franklin', 0, CAST(N'1970-04-02' AS Date), N'Bookie_User21@qa.team', N'5381738475', N'B033R', N'user_no21', N'FCKNmmEX80', null, 1, null, null, 2)
		,(24, N'Schick Reyes', 1, CAST(N'2001-09-15' AS Date), N'Bookie_User22@qa.team', N'2832297215', N'F554R', N'user_no22', N'xNWW1u0t5t', null, 1, null, null, 2)
		,(25, N'Allen Reese', 1, CAST(N'1985-02-09' AS Date), N'Bookie_User23@qa.team', N'5189606718', N'E434R', N'user_no23', N'6pRG2f75Xu', null, 1, null, null, 2)
		,(26, N'Elman Baxter', 0, CAST(N'1990-08-29' AS Date), N'Bookie_User24@qa.team', N'4250803384', N'F399L', N'user_no24', N'V0N5FSoh48',null, 1, null, null, 2)
		,(27, N'Willard Jordan', 0, CAST(N'1962-08-23' AS Date), N'Bookie_User25@qa.team', N'8546595378', N'C249R', N'user_no25', N'KNTpXU0UKv', null, 1, null, null, 2)
		,(28, N'Winona Walton', 1, CAST(N'1972-06-28' AS Date), N'Bookie_User26@qa.team', N'2154390483', N'A271R', N'user_no26', N'0jxj5IEv81', null, 1, null, null, 2)
		,(29, N'Sophia Knight', 1, CAST(N'1984-03-09' AS Date), N'Bookie_User27@qa.team', N'8607919741', N'A014L', N'user_no27', N'A4fN001VmH', null, 1, null, null, 2)
		,(30, N'Hank Wade', 0, CAST(N'1965-03-12' AS Date), N'Bookie_User28@qa.team', N'7523062315', N'D388R', N'user_no28', N'2Bfmh791kK', null, 1, null, null, 2)
		,(31, N'Mia Dinwiddie', 0, CAST(N'1999-02-28' AS Date), N'Bookie_User29@qa.team', N'0246122286', N'F208L', N'user_no29', N'NOxv1OoN1e', null, 1, null, null, 2)
		,(32, N'Ronald Chandler', 1, CAST(N'1997-10-31' AS Date), N'Bookie_User30@qa.team', N'2828181439', N'E367R', N'user_no30', N'w46Ju1i8L9', null, 1, null, null, 2)
		,(33, N'Elluka Ackerman', 1, CAST(N'1981-04-17' AS Date), N'Bookie_User31@qa.team', N'9156318073', N'D567R', N'user_no31', N'5uF4wFljD4', null, 1, null, null, 2)
		,(34, N'Jude Gilbert', 1, CAST(N'1981-11-09' AS Date), N'Bookie_User32@qa.team', N'0169512308', N'F273R', N'user_no32', N'FFdch7h6LS', null, 1, null, null, 2)
		,(35, N'Philbert Schultz', 0, CAST(N'1989-01-22' AS Date), N'Bookie_User33@qa.team', N'6849016541', N'C488R', N'user_no33', N'4779u17pT0', null, 1, null, null, 2)
		,(36, N'Lamia Fowler', 0, CAST(N'1967-11-26' AS Date), N'Bookie_User34@qa.team', N'2741015314', N'A021R', N'user_no34', N'hMtBqGhT7W', null, 1, null, null, 2)
		,(37, N'Gererd Pope', 1, CAST(N'1997-01-03' AS Date), N'Bookie_User35@qa.team', N'3065738164', N'C082R', N'user_no35', N'FUKg17DIa2', null, 1, null, null, 2)
		,(38, N'Thetal Shepard', 1, CAST(N'1999-05-29' AS Date), N'Bookie_User36@qa.team', N'9823201684', N'B218R', N'user_no36', N'CQ29Nd4kw3', null, 1, null, null, 2)
		,(39, N'Yocaski Blossom', 0, CAST(N'1968-06-03' AS Date), N'Bookie_User37@qa.team', N'8540069619', N'B203L', N'user_no37', N'IMlu2mqOpO', null, 1, null, null, 2)
		,(40, N'Danielle Hodges', 1, CAST(N'1987-07-08' AS Date), N'Bookie_User38@qa.team', N'6019926882', N'C533L', N'user_no38', N'0EHMq4RtiX', null, 1, null, null, 2)
		,(41, N'Darlene Feron', 0, CAST(N'1979-01-25' AS Date), N'Bookie_User39@qa.team', N'1335700997', N'D352L', N'user_no39', N'q6D9MT721A', null, 1, null, null, 2)
		,(42, N'Hadden Chandler', 0, CAST(N'2001-10-30' AS Date), N'Bookie_User40@qa.team', N'6968727500', N'C048R', N'user_no40', N'ihctjAx8Ca', null, 1, null, null, 2)
		,(43, N'Sateriasis Hardy', 1, CAST(N'1996-06-13' AS Date), N'Bookie_User41@qa.team', N'2222683128', N'B011L', N'user_no41', N'Q5nX178217',null, 1, null, null, 2)
		,(44, N'Mia Carpenter', 1, CAST(N'1969-10-24' AS Date), N'Bookie_User42@qa.team', N'7098290406', N'C121L', N'user_no42', N'7TN6q8oT22',null, 1, null, null, 2)
		,(45, N'Kit Nerune', 1, CAST(N'1986-06-20' AS Date), N'Bookie_User43@qa.team', N'8061375590', N'E086R', N'user_no43', N'D5OmM2G0Hf', null, 1, null, null, 2)
		,(46, N'Rodolphe Frost', 0, CAST(N'1991-10-11' AS Date), N'Bookie_Admin44@qa.team', N'8079576071', N'B166L', N'user_no44', N'633fiUne77',null, 1, null, null, 2)
		,(47, N'Jesse Watts', 1, CAST(N'1962-01-09' AS Date), N'Bookie_User45@qa.team', N'6734813546', N'A079R', N'user_no45', N'8xKCPgxkG6',null, 1, null, null, 2)
		,(48, N'Carl Crawford', 0, CAST(N'1966-09-23' AS Date), N'Bookie_User46@qa.team', N'9164323101', N'A587R', N'user_no46', N'8Ogl6495GC', null, 1, null, null, 2)
		,(49, N'Ronald Robinett', 1, CAST(N'1975-09-13' AS Date), N'Bookie_User47@qa.team', N'1939248911', N'F056L', N'user_no47', N'9nvm39FdG4',null, 1, null, null, 2)
		,(50, N'Zera Stanley', 1, CAST(N'1962-06-22' AS Date), N'Bookie_Admin48@qa.team', N'3023618105', N'A242L', N'user_no48', N'WV2x0jNQL8',null, 1, null, null, 2)
		,(51, N'Harley Avadonia', 1, CAST(N'1998-05-30' AS Date), N'Bookie_User49@qa.team', N'2549882790', N'A524L', N'user_no49', N'63XQKOsfP5',null, 1, null, null, 2)
		,(52, N'Butglar Gray', 0, CAST(N'2001-11-07' AS Date), N'Bookie_User50@qa.team', N'7015229259', N'E391L', N'user_no50', N't6NaNclluX',null, 1, null, null, 2)
		,(53, N'Joe Baxter', 1, CAST(N'1978-05-19' AS Date), N'Bookie_User51@qa.team', N'8763978419', N'C297R', N'user_no51', N'10VLDxiejW',null, 1, null, null, 2)
		,(54, N'Ward Wagner', 0, CAST(N'1995-02-15' AS Date), N'Bookie_User52@qa.team', N'2458631214', N'F312L', N'user_no52', N'JaWagx8363',null, 1, null, null, 2)
		,(55, N'Charlie Reese', 1, CAST(N'1978-11-07' AS Date), N'Bookie_User53@qa.team', N'8751908426', N'B598R', N'user_no53', N'0gT2B1b3uX', null, 1, null, null, 2)
		,(56, N'Windsor Dinwiddie', 0, CAST(N'1988-01-22' AS Date), N'Bookie_User54@qa.team', N'0217649643', N'D467R', N'user_no54', N'BvR10X7Be7', null, 1, null, null, 2)
		,(57, N'Charon Walton', 0, CAST(N'1965-05-05' AS Date), N'Bookie_User55@qa.team', N'3488293409', N'A094L', N'user_no55', N'gQ5mp7Ln9B',null, 1, null, null, 2)
		,(58, N'Hank Michaelis', 1, CAST(N'1994-07-09' AS Date), N'Bookie_User56@qa.team', N'2886762525', N'F063R', N'user_no56', N'VKeuCjdDo7', null, 1, null, null, 2)
		,(59, N'Seth Manning', 1, CAST(N'1973-05-06' AS Date), N'Bookie_User57@qa.team', N'7193619411', N'B266R', N'user_no57', N'9B8txaGLUn', null, 1, null, null, 2)
		,(60, N'Seth Manning', 0, CAST(N'1978-12-07' AS Date), N'Bookie_User58@qa.team', N'3562422001', N'B018R', N'user_no58', N'P3VOu0cHE9', null, 1, null, null, 2)
		,(61, N'Light Jenning', 0, CAST(N'1992-12-11' AS Date), N'Bookie_User59@qa.team', N'5399302391', N'F278R', N'user_no59', N'5MOL5X7w2m',null, 1, null, null, 2)
		,(62, N'David Barisol', 1, CAST(N'1962-04-12' AS Date), N'Bookie_Admin60@qa.team', N'1262618674', N'C060L', N'user_no60', N'cAEscuX0bp',null, 1, null, null, 2)
		,(63, N'Michaela Kelley', 1, CAST(N'1988-11-13' AS Date), N'Bookie_Admin61@qa.team', N'9181933819', N'C120L', N'user_no61', N'c3Kp2w1ePD', null, 1, null, null, 2)
		,(64, N'Melody Elphen', 1, CAST(N'1981-12-04' AS Date), N'Bookie_User62@qa.team', N'8636081048', N'F542R', N'user_no62', N'L0nU3qkIqD', null, 1, null, null, 2)
		,(65, N'Elluka Norman', 0, CAST(N'1991-03-07' AS Date), N'Bookie_User63@qa.team', N'6646101635', N'F258L', N'user_no63', N'8b6k4lf3bX',null, 1, null, null, 2)
		,(66, N'Strange Feron', 0, CAST(N'1998-01-10' AS Date), N'Bookie_User64@qa.team', N'1135823939', N'F393R', N'user_no64', N'V36337U7LQ', null, 1, null, null, 2)
		,(67, N'Taylor Valdez', 1, CAST(N'1991-12-03' AS Date), N'Bookie_User65@qa.team', N'3733355471', N'E585L', N'user_no65', N'TRQjooaqPE', null, 1, null, null, 2)
		,(68, N'Dana Macy', 0, CAST(N'1990-10-11' AS Date), N'Bookie_User66@qa.team', N'8754299135', N'F407L', N'user_no66', N'1LjH434D2f', null, 1, null, null, 2)
		,(69, N'Jean Valdez', 0, CAST(N'1982-10-15' AS Date), N'Bookie_User67@qa.team', N'9735839086', N'D407L', N'user_no67', N'30uboLi0pq', null, 1, null, null, 2)
		,(70, N'Minis Goodwin', 1, CAST(N'2003-06-05' AS Date), N'Bookie_User68@qa.team', N'9113433152', N'C176L', N'user_no68', N'6HgQhX4vAS',null, 1, null, null, 2)
		,(71, N'Clay Marlon', 0, CAST(N'1976-01-03' AS Date), N'Bookie_User69@qa.team', N'8151717641', N'F276L', N'user_no69', N'h8b6Ks3aHG',null, 1, null, null, 2)
		,(72, N'Phil Powers', 1, CAST(N'2002-07-26' AS Date), N'Bookie_User70@qa.team', N'0859547485', N'E327L', N'user_no70', N'RGGX9xaFd9', null, 1, null, null, 2)
		,(73, N'Butglar Hardy', 0, CAST(N'1985-06-29' AS Date), N'Bookie_User71@qa.team', N'9494816505', N'F150L', N'user_no71', N'SuC0uP5MWc',null, 1, null, null, 2)
		,(74, N'Camelia Mullins', 1, CAST(N'1977-10-10' AS Date), N'Bookie_User72@qa.team', N'2264980236', N'D302R', N'user_no72', N'37ov3LQvr5',null, 1, null, null, 2)
		,(75, N'Lionel Stanley', 1, CAST(N'1976-07-15' AS Date), N'Bookie_User73@qa.team', N'2592270859', N'F134R', N'user_no73', N'fagIRa8sd2',null, 1, null, null, 2)
		,(76, N'Linda Payne', 1, CAST(N'1967-07-05' AS Date), N'Bookie_User74@qa.team', N'2138430999', N'E582L', N'user_no74', N'R6DhW5Us1U', null, 1, null, null, 2)
		,(77, N'Philbert Cross', 1, CAST(N'1978-02-10' AS Date), N'Bookie_User75@qa.team', N'7912138173', N'A244R', N'user_no75', N'4FbN3eR914',null, 1, null, null, 2)
		,(78, N'Phil Jordan', 1, CAST(N'1998-09-09' AS Date), N'Bookie_User76@qa.team', N'3171032506', N'D582L', N'user_no76', N'4HoS1o8LiQ',null, 1, null, null, 2)
		,(79, N'Robert Kissos', 1, CAST(N'1989-04-12' AS Date), N'Bookie_Admin77@qa.team', N'8210911505', N'B322R', N'user_no77', N'44h7516veR', null, 1, null, null, 2)
		,(80, N'Ronald Rios', 1, CAST(N'1974-04-27' AS Date), N'Bookie_Admin78@qa.team', N'1230714908', N'E391L', N'user_no78', N'XcT993M91U', null, 1, null, null, 2)
		,(81, N'Elluka Manning', 1, CAST(N'1978-01-13' AS Date), N'Bookie_User79@qa.team', N'4453821425', N'D520L', N'user_no79', N'13NMusTvTs',null, 1, null, null, 2)
		,(82, N'Ceil Payne', 1, CAST(N'1981-01-25' AS Date), N'Bookie_User80@qa.team', N'5169407308', N'B558R', N'user_no80', N'm1lSpbnxKR', null, 1, null, null, 2)
		,(83, N'Lizzy Meld', 0, CAST(N'1974-03-29' AS Date), N'Bookie_User81@qa.team', N'7971588225', N'E401L', N'user_no81', N'CQ625H6cpM', null, 1, null, null, 2)
		,(84, N'Camelia Miller', 0, CAST(N'1995-10-05' AS Date), N'Bookie_User82@qa.team', N'6418028724', N'D425R', N'user_no82', N'kx9qI8Lrpn', null, 1, null, null, 2)
		,(85, N'Diana Macy', 0, CAST(N'1987-06-15' AS Date), N'Bookie_User83@qa.team', N'0392517157', N'C064L', N'user_no83', N'NOLEd7ip6u', null, 1, null, null, 2)
		,(86, N'Windsor Badman', 1, CAST(N'1963-04-23' AS Date), N'Bookie_User84@qa.team', N'2211777973', N'B225L', N'user_no84', N'Oq52kK54Wt',null, 1, null, null, 2)
		,(87, N'Diana Obrien', 0, CAST(N'1965-09-05' AS Date), N'Bookie_User85@qa.team', N'5234651834', N'B266R', N'user_no85', N'Xg48U9vViT',null, 1, null, null, 2)
		,(88, N'Adam Hodges', 1, CAST(N'1991-09-17' AS Date), N'Bookie_User86@qa.team', N'8244422163', N'F547L', N'user_no86', N'69OblisKtI', null, 1, null, null, 2)
		,(89, N'Hansel May', 1, CAST(N'1963-04-10' AS Date), N'Bookie_User87@qa.team', N'0832781475', N'B408L', N'user_no87', N'6k69wo0082', null, 1, null, null, 2)
		,(90, N'Oswald Pope', 0, CAST(N'2003-06-25' AS Date), N'Bookie_User88@qa.team', N'5045023619', N'B063R', N'user_no88', N'8V0cXHnT2m', null, 1, null, null, 2)
		,(91, N'Alex Hardy', 1, CAST(N'1975-08-25' AS Date), N'Bookie_User89@qa.team', N'2345729992', N'D066R', N'user_no89', N'42RAMiQXtP', null, 1, null, null, 2)
		,(92, N'Butglar Michaelis', 0, CAST(N'1973-11-06' AS Date), N'Bookie_User90@qa.team', N'0368248093', N'C055L', N'user_no90', N'tIh5JIP0wO',null, 1, null, null, 2)
		,(93, N'Elman Blair', 1, CAST(N'1976-07-19' AS Date), N'Bookie_User91@qa.team', N'2461908732', N'A427R', N'user_no91', N'UnoMh1cNLM', null, 1, null, null, 2)
		,(94, N'Lucifer Blair', 0, CAST(N'1983-01-08' AS Date), N'Bookie_User92@qa.team', N'1323033244', N'A500L', N'user_no92', N'BAobhPn8q3', null, 1, null, null, 2)
		,(95, N'Philbert Phantomhive', 0, CAST(N'1991-03-23' AS Date), N'Bookie_User93@qa.team', N'3364836425', N'B478R', N'user_no93', N'N7946Sgcp7', null, 1, null, null, 2)
		,(96, N'Albion Alexdander', 1, CAST(N'1990-10-28' AS Date), N'Bookie_User94@qa.team', N'9179724841', N'A044R', N'user_no94', N'Aom68vB96X', null, 1, null, null, 2)
		,(97, N'Melody Chandler', 1, CAST(N'1963-12-30' AS Date), N'Bookie_User95@qa.team', N'5587772688', N'A579L', N'user_no95', N'n7q1WnuD8L', null, 1, null, null, 2)
		,(98, N'Katya Corbyn', 0, CAST(N'1969-12-31' AS Date), N'Bookie_User96@qa.team', N'7693285889', N'D506R', N'user_no96', N'5M5g7rO37L', null, 1, null, null, 2)
		,(99, N'Rahab Octo', 0, CAST(N'1989-05-01' AS Date), N'Bookie_User97@qa.team', N'5723628843', N'A079L', N'user_no97', N'38622s3j03', null, 1, null, null, 2)
		,(100, N'Hansel May', 1, CAST(N'2003-06-22' AS Date), N'Bookie_User98@qa.team', N'0343057780', N'E443R', N'user_no98', N'1oST7ll09m', null, 1, null, null, 2)

SET IDENTITY_INSERT [dbo].[User] OFF
GO

SET IDENTITY_INSERT [dbo].[Wallet] ON 
GO

INSERT [dbo].[Wallet]([wallet_id] ,[user_id]  ,[fund] ,[refund] ,[bank_id] ,[bank_account])  
	VALUES
		(1, 1, 0, CAST(97383 AS Decimal(10, 2)), null, null)
		,(2, 2, CAST(22999 AS Decimal(10, 2)), CAST(98099 AS Decimal(10, 2)), N'bidv' , N'0921321321322')
		,(3, 3, CAST(22999 AS Decimal(10, 2)), CAST(11973 AS Decimal(10, 2)), N'vcb' , N'0921321321322')
		,(4, 4, CAST(22999 AS Decimal(10, 2)), CAST(52178 AS Decimal(10, 2)), N'bidv' , N'0921321321322')
		,(5, 5, CAST(22999 AS Decimal(10, 2)), CAST(1322 AS Decimal(10, 2)), N'mb' , N'0921321321322')
		,(6, 6, CAST(22999 AS Decimal(10, 2)), CAST(234 AS Decimal(10, 2)), N'bidv' , N'0921321321322')
		,(7, 7, CAST(22999 AS Decimal(10, 2)), CAST(5223 AS Decimal(10, 2)), N'tech' , N'0921321321322')
		,(8, 8, CAST(22999 AS Decimal(10, 2)), CAST(1123 AS Decimal(10, 2)), N'bidv' , N'0921321321322')
		,(9, 9, CAST(22999 AS Decimal(10, 2)), CAST(42255 AS Decimal(10, 2)), N'agb' , N'0921321321322')
		,(10, 10, CAST(22999 AS Decimal(10, 2)), CAST(1146 AS Decimal(10, 2)), N'mb' , N'0921321321322')

	DECLARE @Counter INT = 11; -- Start with the next number after the existing data

	WHILE @Counter <= 100 -- Set the end condition
	BEGIN
		INSERT INTO [dbo].[Wallet]([wallet_id] ,[user_id]  ,[fund] ,[refund])  
		VALUES
			(@Counter, @Counter, CAST(12 AS Decimal(10, 2)), CAST(0 AS Decimal(10, 2)));

		SET @Counter = @Counter + 1; -- Increment the counter
	END;

SET IDENTITY_INSERT [dbo].[Wallet] OFF
GO

INSERT INTO [dbo].[Story_Read]([user_id],[story_id],[chapter_id],[read_time]) VALUES
	(2,1,8,CAST(N'2023-12-22' AS Date)),
	(2,3,13,CAST(N'2023-12-22' AS Date)),
	(2,17,8,CAST(N'2023-12-22' AS Date)),
	(3,1,10,CAST(N'2023-12-22' AS Date)),
	(4,1,3,CAST(N'2023-12-22' AS Date)),
	(5,17,7,CAST(N'2023-12-22' AS Date))
	

INSERT INTO [dbo].[Story_Follow_Like]([user_id],[story_id],[follow],[like]) VALUES
	(2,1,1,1),(3,1,1,1),(4,1,1,1),(5,1,1,1),
	(2,2,0,1),(3,2,1,0),(4,2,1,0),(9,2,0,1),
	(2,3,0,1),(5,3,0,1),(9,3,0,1),(13,3,0,1),
	(7,4,1,0),(10,4,1,0),
	(6,5,0,1),(7,5,0,1),
	(8,6,1,0),(9,6,1,0),
	(2,17,1,0)

INSERT INTO [dbo].[Story_Owned]([user_id],[story_id]) VALUES
	(2,1),(3,1),(4,1),(8,1),
	(2,3),(5,3),(9,3),(13,3),
	(7,4),(10,4),
	(6,5),(7,5),
	(8,6),(9,6),(15,6),
	(2,17),(5,17),(8,17),(9,17),(15,17),(23,17)

SET IDENTITY_INSERT [dbo].[Story] ON 
GO

INSERT [dbo].[Story] ([story_id] ,[story_title], [author_id], [story_price], [story_sale], [story_image], [story_description], [story_description_markdown], [story_description_html],[create_time], [update_time], [status])
	VALUES 
		( 1,N'Gone Girl ',1, CAST(119.99 AS Decimal(10, 2)) , CAST(20 AS Decimal(10, 2)), N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1554086139l/19288043.jpg',N'Marriage can be a real killer.
		On a warm summer morning in North Carthage, Missouri, it is Nick and Amy Dunne’s fifth wedding anniversary. Presents are being wrapped and reservations are being made when Nick’s clever and beautiful wife disappears from their rented McMansion on the Mississippi River. Husband-of-the-Year Nick isn’t doing himself any favors with cringe-worthy daydreams about the slope and shape of his wife’s head, but passages from Amy''s diary reveal the alpha-girl perfectionist could have put anyone dangerously on edge. Under mounting pressure from the police and the media—as well as Amy’s fiercely doting parents—the town golden boy parades an endless series of lies, deceits, and inappropriate behavior. Nick is oddly evasive, and he’s definitely bitter—but is he really a killer?
		As the cops close in, every couple in town is soon wondering how well they know the one that they love. With his twin sister, Margo, at his side, Nick stands by his innocence. Trouble is, if Nick didn’t do it, where is that beautiful wife? And what was in that silvery gift box hidden in the back of her bedroom closet?',
		N'Marriage can be a real killer.
		On a warm summer morning in North Carthage, Missouri, it is Nick and Amy Dunne’s fifth wedding anniversary. Presents are being wrapped and reservations are being made when Nick’s clever and beautiful wife disappears from their rented McMansion on the Mississippi River. Husband-of-the-Year Nick isn’t doing himself any favors with cringe-worthy daydreams about the slope and shape of his wife’s head, but passages from Amy''s diary reveal the alpha-girl perfectionist could have put anyone dangerously on edge. Under mounting pressure from the police and the media—as well as Amy’s fiercely doting parents—the town golden boy parades an endless series of lies, deceits, and inappropriate behavior. Nick is oddly evasive, and he’s definitely bitter—but is he really a killer?
		As the cops close in, every couple in town is soon wondering how well they know the one that they love. With his twin sister, Margo, at his side, Nick stands by his innocence. Trouble is, if Nick didn’t do it, where is that beautiful wife? And what was in that silvery gift box hidden in the back of her bedroom closet?'
		,N'Marriage can be a real killer.
		On a warm summer morning in North Carthage, Missouri, it is Nick and Amy Dunne’s fifth wedding anniversary. Presents are being wrapped and reservations are being made when Nick’s clever and beautiful wife disappears from their rented McMansion on the Mississippi River. Husband-of-the-Year Nick isn’t doing himself any favors with cringe-worthy daydreams about the slope and shape of his wife’s head, but passages from Amy''s diary reveal the alpha-girl perfectionist could have put anyone dangerously on edge. Under mounting pressure from the police and the media—as well as Amy’s fiercely doting parents—the town golden boy parades an endless series of lies, deceits, and inappropriate behavior. Nick is oddly evasive, and he’s definitely bitter—but is he really a killer?
		As the cops close in, every couple in town is soon wondering how well they know the one that they love. With his twin sister, Margo, at his side, Nick stands by his innocence. Trouble is, if Nick didn’t do it, where is that beautiful wife? And what was in that silvery gift box hidden in the back of her bedroom closet?',
		CAST(N'2022-01-01T05:52:10.323' AS DateTime), null, 1),
		(2, N'And Then There Were None', 2, CAST(129.99 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1638425885l/16299._SY475_.jpg', N'First, there were ten—a curious assortment of strangers summoned as weekend guests to a little private island off the coast of Devon. Their host, an eccentric millionaire unknown to all of them, is nowhere to be found. All that the guests have in common is a wicked past they''re unwilling to reveal—and a secret that will seal their fate. For each has been marked for murder. A famous nursery rhyme is framed and hung in every room of the mansion:
		"Ten little boys went out to dine; One choked his little self and then there were nine. Nine little boys sat up very late; One overslept himself and then there were eight. Eight little boys traveling in Devon; One said he''d stay there then there were seven. Seven little boys chopping up sticks; One chopped himself in half and then there were six. Six little boys playing with a hive; A bumblebee stung one and then there were five. Five little boys going in for law; One got in Chancery and then there were four. Four little boys going out to sea; A red herring swallowed one and then there were three. Three little boys walking in the zoo; A big bear hugged one and then there were two. Two little boys sitting in the sun; One got frizzled up and then there was one. One little boy left all alone; He went out and hanged himself and then there were none."
		When they realize that murders are occurring as described in the rhyme, terror mounts. One by one they fall prey. Before the weekend is out, there will be none. Who has choreographed this dastardly scheme? And who will be left to tell the tale? Only the dead are above suspicion.',  
		N'First, there were ten—a curious assortment of strangers summoned as weekend guests to a little private island off the coast of Devon. Their host, an eccentric millionaire unknown to all of them, is nowhere to be found. All that the guests have in common is a wicked past they''re unwilling to reveal—and a secret that will seal their fate. For each has been marked for murder. A famous nursery rhyme is framed and hung in every room of the mansion:
		"Ten little boys went out to dine; One choked his little self and then there were nine. Nine little boys sat up very late; One overslept himself and then there were eight. Eight little boys traveling in Devon; One said he''d stay there then there were seven. Seven little boys chopping up sticks; One chopped himself in half and then there were six. Six little boys playing with a hive; A bumblebee stung one and then there were five. Five little boys going in for law; One got in Chancery and then there were four. Four little boys going out to sea; A red herring swallowed one and then there were three. Three little boys walking in the zoo; A big bear hugged one and then there were two. Two little boys sitting in the sun; One got frizzled up and then there was one. One little boy left all alone; He went out and hanged himself and then there were none."
		When they realize that murders are occurring as described in the rhyme, terror mounts. One by one they fall prey. Before the weekend is out, there will be none. Who has choreographed this dastardly scheme? And who will be left to tell the tale? Only the dead are above suspicion.',  
		N'First, there were ten—a curious assortment of strangers summoned as weekend guests to a little private island off the coast of Devon. Their host, an eccentric millionaire unknown to all of them, is nowhere to be found. All that the guests have in common is a wicked past they''re unwilling to reveal—and a secret that will seal their fate. For each has been marked for murder. A famous nursery rhyme is framed and hung in every room of the mansion:
		"Ten little boys went out to dine; One choked his little self and then there were nine. Nine little boys sat up very late; One overslept himself and then there were eight. Eight little boys traveling in Devon; One said he''d stay there then there were seven. Seven little boys chopping up sticks; One chopped himself in half and then there were six. Six little boys playing with a hive; A bumblebee stung one and then there were five. Five little boys going in for law; One got in Chancery and then there were four. Four little boys going out to sea; A red herring swallowed one and then there were three. Three little boys walking in the zoo; A big bear hugged one and then there were two. Two little boys sitting in the sun; One got frizzled up and then there was one. One little boy left all alone; He went out and hanged himself and then there were none."
		When they realize that murders are occurring as described in the rhyme, terror mounts. One by one they fall prey. Before the weekend is out, there will be none. Who has choreographed this dastardly scheme? And who will be left to tell the tale? Only the dead are above suspicion.',  
		CAST(N'2022-02-01T05:52:10.323' AS DateTime), null, 1),
		(3, N'The Silent Patient', 3, CAST(100.50 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1582759969l/40097951._SX318_.jpg', N'Alicia Berenson’s life is seemingly perfect. A famous painter married to an in-demand fashion photographer, she lives in a grand house with big windows overlooking a park in one of London’s most desirable areas. One evening her husband Gabriel returns home late from a fashion shoot, and Alicia shoots him five times in the face, and then never speaks another word.
		Alicia’s refusal to talk, or give any kind of explanation, turns a domestic tragedy into something far grander, a mystery that captures the public imagination and casts Alicia into notoriety. The price of her art skyrockets, and she, the silent patient, is hidden away from the tabloids and spotlight at the Grove, a secure forensic unit in North London.
		Theo Faber is a criminal psychotherapist who has waited a long time for the opportunity to work with Alicia. His determination to get her to talk and unravel the mystery of why she shot her husband takes him down a twisting path into his own motivations—a search for the truth that threatens to consume him....',
		N'Alicia Berenson’s life is seemingly perfect. A famous painter married to an in-demand fashion photographer, she lives in a grand house with big windows overlooking a park in one of London’s most desirable areas. One evening her husband Gabriel returns home late from a fashion shoot, and Alicia shoots him five times in the face, and then never speaks another word.
		Alicia’s refusal to talk, or give any kind of explanation, turns a domestic tragedy into something far grander, a mystery that captures the public imagination and casts Alicia into notoriety. The price of her art skyrockets, and she, the silent patient, is hidden away from the tabloids and spotlight at the Grove, a secure forensic unit in North London.
		Theo Faber is a criminal psychotherapist who has waited a long time for the opportunity to work with Alicia. His determination to get her to talk and unravel the mystery of why she shot her husband takes him down a twisting path into his own motivations—a search for the truth that threatens to consume him....',
		N'Alicia Berenson’s life is seemingly perfect. A famous painter married to an in-demand fashion photographer, she lives in a grand house with big windows overlooking a park in one of London’s most desirable areas. One evening her husband Gabriel returns home late from a fashion shoot, and Alicia shoots him five times in the face, and then never speaks another word.
		Alicia’s refusal to talk, or give any kind of explanation, turns a domestic tragedy into something far grander, a mystery that captures the public imagination and casts Alicia into notoriety. The price of her art skyrockets, and she, the silent patient, is hidden away from the tabloids and spotlight at the Grove, a secure forensic unit in North London.
		Theo Faber is a criminal psychotherapist who has waited a long time for the opportunity to work with Alicia. His determination to get her to talk and unravel the mystery of why she shot her husband takes him down a twisting path into his own motivations—a search for the truth that threatens to consume him....',
		CAST(N'2022-03-01T05:52:10.323' AS DateTime), null, 1),
		(4, N'The Girl on the Train',4, CAST(139.99 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1574805682l/22557272.jpg', N'Rachel catches the same commuter train every morning. She knows it will wait at the same signal each time, overlooking a row of back gardens. She’s even started to feel like she knows the people who live in one of the houses. “Jess and Jason,” she calls them. Their life—as she sees it—is perfect. If only Rachel could be that happy. And then she sees something shocking. It’s only a minute until the train moves on, but it’s enough. Now everything’s changed. Now Rachel has a chance to become a part of the lives she’s only watched from afar. Now they’ll see; she’s much more than just the girl on the train...',
		N'Rachel catches the same commuter train every morning. She knows it will wait at the same signal each time, overlooking a row of back gardens. She’s even started to feel like she knows the people who live in one of the houses. “Jess and Jason,” she calls them. Their life—as she sees it—is perfect. If only Rachel could be that happy. And then she sees something shocking. It’s only a minute until the train moves on, but it’s enough. Now everything’s changed. Now Rachel has a chance to become a part of the lives she’s only watched from afar. Now they’ll see; she’s much more than just the girl on the train...',
		N'Rachel catches the same commuter train every morning. She knows it will wait at the same signal each time, overlooking a row of back gardens. She’s even started to feel like she knows the people who live in one of the houses. “Jess and Jason,” she calls them. Their life—as she sees it—is perfect. If only Rachel could be that happy. And then she sees something shocking. It’s only a minute until the train moves on, but it’s enough. Now everything’s changed. Now Rachel has a chance to become a part of the lives she’s only watched from afar. Now they’ll see; she’s much more than just the girl on the train...',
		CAST(N'2022-04-01T05:52:10.323' AS DateTime), null, 1),
		(5, N'Lord of the Mysteries',5, CAST(119.99 AS Decimal(10, 2)), CAST(10 AS Decimal(10, 2)), N'https://cdn.novelupdates.com/images/2018/11/Lord-of-the-Mysteries.jpeg', N'Waking up to be faced with a string of mysteries, Zhou Mingrui finds himself reincarnated as Klein Moretti in an alternate Victorian era world where he sees a world filled with machinery, cannons, dreadnoughts, airships, difference machines, as well as Potions, Divination, Hexes, Tarot Cards, Sealed Artifacts… The Light continues to shine but the mystery has never gone far. Follow Klein as he finds himself entangled with the Churches of the world—both orthodox and unorthodox—while he slowly develops newfound powers thanks to the Beyonder potions.',
		N'Waking up to be faced with a string of mysteries, Zhou Mingrui finds himself reincarnated as Klein Moretti in an alternate Victorian era world where he sees a world filled with machinery, cannons, dreadnoughts, airships, difference machines, as well as Potions, Divination, Hexes, Tarot Cards, Sealed Artifacts… The Light continues to shine but the mystery has never gone far. Follow Klein as he finds himself entangled with the Churches of the world—both orthodox and unorthodox—while he slowly develops newfound powers thanks to the Beyonder potions.',
		N'Waking up to be faced with a string of mysteries, Zhou Mingrui finds himself reincarnated as Klein Moretti in an alternate Victorian era world where he sees a world filled with machinery, cannons, dreadnoughts, airships, difference machines, as well as Potions, Divination, Hexes, Tarot Cards, Sealed Artifacts… The Light continues to shine but the mystery has never gone far. Follow Klein as he finds himself entangled with the Churches of the world—both orthodox and unorthodox—while he slowly develops newfound powers thanks to the Beyonder potions.',
		CAST(N'2022-05-01T05:52:10.323' AS DateTime), null,  1),
		(6, N'The Shining',6, CAST(129.99 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1353277730l/11588.jpg', N'Jack Torrance''s new job at the Overlook Hotel is the perfect chance for a fresh start. As the off-season caretaker at the atmospheric old hotel, he''ll have plenty of time to spend reconnecting with his family and working on his writing. But as the harsh winter weather sets in, the idyllic location feels ever more remote...and more sinister. And the only one to notice the strange and terrible forces gathering around the Overlook is Danny Torrance, a uniquely gifted five-year-old.',  
		N'Jack Torrance''s new job at the Overlook Hotel is the perfect chance for a fresh start. As the off-season caretaker at the atmospheric old hotel, he''ll have plenty of time to spend reconnecting with his family and working on his writing. But as the harsh winter weather sets in, the idyllic location feels ever more remote...and more sinister. And the only one to notice the strange and terrible forces gathering around the Overlook is Danny Torrance, a uniquely gifted five-year-old.',  
		N'Jack Torrance''s new job at the Overlook Hotel is the perfect chance for a fresh start. As the off-season caretaker at the atmospheric old hotel, he''ll have plenty of time to spend reconnecting with his family and working on his writing. But as the harsh winter weather sets in, the idyllic location feels ever more remote...and more sinister. And the only one to notice the strange and terrible forces gathering around the Overlook is Danny Torrance, a uniquely gifted five-year-old.',  
		CAST(N'2022-06-01T05:52:10.323' AS DateTime), null, 1),
		(7, N'It',6, CAST(109.50 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1334416842l/830502.jpg', N'Welcome to Derry, Maine ...
		It’s a small city, a place as hauntingly familiar as your own hometown. Only in Derry the haunting is real ...
		They were seven teenagers when they first stumbled upon the horror. Now they are grown-up men and women who have gone out into the big world to gain success and happiness. But none of them can withstand the force that has drawn them back to Derry to face the nightmare without an end, and the evil without a name.',  
		N'Welcome to Derry, Maine ...
		It’s a small city, a place as hauntingly familiar as your own hometown. Only in Derry the haunting is real ...
		They were seven teenagers when they first stumbled upon the horror. Now they are grown-up men and women who have gone out into the big world to gain success and happiness. But none of them can withstand the force that has drawn them back to Derry to face the nightmare without an end, and the evil without a name.',  
		N'Welcome to Derry, Maine ...
		It’s a small city, a place as hauntingly familiar as your own hometown. Only in Derry the haunting is real ...
		They were seven teenagers when they first stumbled upon the horror. Now they are grown-up men and women who have gone out into the big world to gain success and happiness. But none of them can withstand the force that has drawn them back to Derry to face the nightmare without an end, and the evil without a name.',  
		CAST(N'2022-07-01T05:52:10.323' AS DateTime), null, 1),
		(8, N'A Game Of Thrones: A Song of Ice and Fire', 7, CAST(139.99 AS Decimal(10, 2)), 0, N'https://m.media-amazon.com/images/P/0553386794.01._SCLZZZZZZZ_SX500_.jpg', N'Long ago, in a time forgotten, a preternatural event threw the seasons out of balance. In a land where summers can last decades and winters a lifetime, trouble is brewing. The cold is returning, and in the frozen wastes to the north of Winterfell, sinister and supernatural forces are massing beyond the kingdom’s protective Wall. At the center of the conflict lie the Starks of Winterfell, a family as harsh and unyielding as the land they were born to. Sweeping from a land of brutal cold to a distant summertime kingdom of epicurean plenty, here is a tale of lords and ladies, soldiers and sorcerers, assassins and bastards, who come together in a time of grim omens.
		
		Here an enigmatic band of warriors bear swords of no human metal; a tribe of fierce wildlings carry men off into madness; a cruel young dragon prince barters his sister to win back his throne; and a determined woman undertakes the most treacherous of journeys. Amid plots and counterplots, tragedy and betrayal, victory and terror, the fate of the Starks, their allies, and their enemies hangs perilously in the balance, as each endeavors to win that deadliest of conflicts: the game of thrones.', 
		N'Long ago, in a time forgotten, a preternatural event threw the seasons out of balance. In a land where summers can last decades and winters a lifetime, trouble is brewing. The cold is returning, and in the frozen wastes to the north of Winterfell, sinister and supernatural forces are massing beyond the kingdom’s protective Wall. At the center of the conflict lie the Starks of Winterfell, a family as harsh and unyielding as the land they were born to. Sweeping from a land of brutal cold to a distant summertime kingdom of epicurean plenty, here is a tale of lords and ladies, soldiers and sorcerers, assassins and bastards, who come together in a time of grim omens.
		
		Here an enigmatic band of warriors bear swords of no human metal; a tribe of fierce wildlings carry men off into madness; a cruel young dragon prince barters his sister to win back his throne; and a determined woman undertakes the most treacherous of journeys. Amid plots and counterplots, tragedy and betrayal, victory and terror, the fate of the Starks, their allies, and their enemies hangs perilously in the balance, as each endeavors to win that deadliest of conflicts: the game of thrones.', 
		N'Long ago, in a time forgotten, a preternatural event threw the seasons out of balance. In a land where summers can last decades and winters a lifetime, trouble is brewing. The cold is returning, and in the frozen wastes to the north of Winterfell, sinister and supernatural forces are massing beyond the kingdom’s protective Wall. At the center of the conflict lie the Starks of Winterfell, a family as harsh and unyielding as the land they were born to. Sweeping from a land of brutal cold to a distant summertime kingdom of epicurean plenty, here is a tale of lords and ladies, soldiers and sorcerers, assassins and bastards, who come together in a time of grim omens.
		
		Here an enigmatic band of warriors bear swords of no human metal; a tribe of fierce wildlings carry men off into madness; a cruel young dragon prince barters his sister to win back his throne; and a determined woman undertakes the most treacherous of journeys. Amid plots and counterplots, tragedy and betrayal, victory and terror, the fate of the Starks, their allies, and their enemies hangs perilously in the balance, as each endeavors to win that deadliest of conflicts: the game of thrones.', 
		CAST(N'2022-08-01T05:52:10.323' AS DateTime), null, 1),
		(9, N'The Hunger Games',8, CAST(150.00 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1586722975l/2767052.jpg', N'Could you survive on your own in the wild, with every one out to make sure you don''t live to see the morning?
		
		In the ruins of a place once known as North America lies the nation of Panem, a shining Capitol surrounded by twelve outlying districts. The Capitol is harsh and cruel and keeps the districts in line by forcing them all to send one boy and one girl between the ages of twelve and eighteen to participate in the annual Hunger Games, a fight to the death on live TV.
		
		Sixteen-year-old Katniss Everdeen, who lives alone with her mother and younger sister, regards it as a death sentence when she steps forward to take her sister''s place in the Games. But Katniss has been close to dead before—and survival, for her, is second nature. Without really meaning to, she becomes a contender. But if she is to win, she will have to start making choices that weight survival against humanity and life against love.',
		N'Could you survive on your own in the wild, with every one out to make sure you don''t live to see the morning?
		
		In the ruins of a place once known as North America lies the nation of Panem, a shining Capitol surrounded by twelve outlying districts. The Capitol is harsh and cruel and keeps the districts in line by forcing them all to send one boy and one girl between the ages of twelve and eighteen to participate in the annual Hunger Games, a fight to the death on live TV.
		
		Sixteen-year-old Katniss Everdeen, who lives alone with her mother and younger sister, regards it as a death sentence when she steps forward to take her sister''s place in the Games. But Katniss has been close to dead before—and survival, for her, is second nature. Without really meaning to, she becomes a contender. But if she is to win, she will have to start making choices that weight survival against humanity and life against love.',
		N'Could you survive on your own in the wild, with every one out to make sure you don''t live to see the morning?
		
		In the ruins of a place once known as North America lies the nation of Panem, a shining Capitol surrounded by twelve outlying districts. The Capitol is harsh and cruel and keeps the districts in line by forcing them all to send one boy and one girl between the ages of twelve and eighteen to participate in the annual Hunger Games, a fight to the death on live TV.
		
		Sixteen-year-old Katniss Everdeen, who lives alone with her mother and younger sister, regards it as a death sentence when she steps forward to take her sister''s place in the Games. But Katniss has been close to dead before—and survival, for her, is second nature. Without really meaning to, she becomes a contender. But if she is to win, she will have to start making choices that weight survival against humanity and life against love.',
		CAST(N'2022-09-01T05:52:10.323' AS DateTime), null,  1),
		(10,N'The Time Machine',9, CAST(125.50 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1327942880l/2493.jpg', N'“I’ve had a most amazing time....”
		So begins the Time Traveller’s astonishing firsthand account of his journey 800,000 years beyond his own era—and the story that launched H.G. Wells’s successful career and earned him his reputation as the father of science fiction. With a speculative leap that still fires the imagination, Wells sends his brave explorer to face a future burdened with our greatest hopes...and our darkest fears. A pull of the Time Machine’s lever propels him to the age of a slowly dying Earth.  There he discovers two bizarre races—the ethereal Eloi and the subterranean Morlocks—who not only symbolize the duality of human nature, but offer a terrifying portrait of the men of tomorrow as well.  Published in 1895, this masterpiece of invention captivated readers on the threshold of a new century.', 
		N'“I’ve had a most amazing time....”
		So begins the Time Traveller’s astonishing firsthand account of his journey 800,000 years beyond his own era—and the story that launched H.G. Wells’s successful career and earned him his reputation as the father of science fiction. With a speculative leap that still fires the imagination, Wells sends his brave explorer to face a future burdened with our greatest hopes...and our darkest fears. A pull of the Time Machine’s lever propels him to the age of a slowly dying Earth.  There he discovers two bizarre races—the ethereal Eloi and the subterranean Morlocks—who not only symbolize the duality of human nature, but offer a terrifying portrait of the men of tomorrow as well.  Published in 1895, this masterpiece of invention captivated readers on the threshold of a new century.', 
		N'“I’ve had a most amazing time....”
		So begins the Time Traveller’s astonishing firsthand account of his journey 800,000 years beyond his own era—and the story that launched H.G. Wells’s successful career and earned him his reputation as the father of science fiction. With a speculative leap that still fires the imagination, Wells sends his brave explorer to face a future burdened with our greatest hopes...and our darkest fears. A pull of the Time Machine’s lever propels him to the age of a slowly dying Earth.  There he discovers two bizarre races—the ethereal Eloi and the subterranean Morlocks—who not only symbolize the duality of human nature, but offer a terrifying portrait of the men of tomorrow as well.  Published in 1895, this masterpiece of invention captivated readers on the threshold of a new century.', 
		CAST(N'2022-09-02T05:52:10.323' AS DateTime), null, 1),
		(11, N'Outlander', 10, CAST(139.99 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1529065012l/10964._SY475_.jpg', N'The year is 1945. Claire Randall, a former combat nurse, is just back from the war and reunited with her husband on a second honeymoon when she walks through a standing stone in one of the ancient circles that dot the British Isles. Suddenly she is a Sassenach—an “outlander”—in a Scotland torn by war and raiding border clans in the year of Our Lord...1743.
		
		Hurled back in time by forces she cannot understand, Claire is catapulted into the intrigues of lairds and spies that may threaten her life, and shatter her heart. For here James Fraser, a gallant young Scots warrior, shows her a love so absolute that Claire becomes a woman torn between fidelity and desire—and between two vastly different men in two irreconcilable lives.', 
		N'The year is 1945. Claire Randall, a former combat nurse, is just back from the war and reunited with her husband on a second honeymoon when she walks through a standing stone in one of the ancient circles that dot the British Isles. Suddenly she is a Sassenach—an “outlander”—in a Scotland torn by war and raiding border clans in the year of Our Lord...1743.
		
		Hurled back in time by forces she cannot understand, Claire is catapulted into the intrigues of lairds and spies that may threaten her life, and shatter her heart. For here James Fraser, a gallant young Scots warrior, shows her a love so absolute that Claire becomes a woman torn between fidelity and desire—and between two vastly different men in two irreconcilable lives.', 
		N'The year is 1945. Claire Randall, a former combat nurse, is just back from the war and reunited with her husband on a second honeymoon when she walks through a standing stone in one of the ancient circles that dot the British Isles. Suddenly she is a Sassenach—an “outlander”—in a Scotland torn by war and raiding border clans in the year of Our Lord...1743.
		
		Hurled back in time by forces she cannot understand, Claire is catapulted into the intrigues of lairds and spies that may threaten her life, and shatter her heart. For here James Fraser, a gallant young Scots warrior, shows her a love so absolute that Claire becomes a woman torn between fidelity and desire—and between two vastly different men in two irreconcilable lives.', 
		CAST(N'2022-09-03T05:52:10.323' AS DateTime), null, 1),
		(12, N'All the Light We Cannot See', 11, CAST(100.99 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1451445646l/18143977.jpg', N'Marie-Laure lives in Paris near the Museum of Natural History, where her father works. When she is twelve, the Nazis occupy Paris and father and daughter flee to the walled citadel of Saint-Malo, where Marie-Laure’s reclusive great uncle lives in a tall house by the sea. With them they carry what might be the museum’s most valuable and dangerous jewel.
		In a mining town in Germany, Werner Pfennig, an orphan, grows up with his younger sister, enchanted by a crude radio they find that brings them news and stories from places they have never seen or imagined. Werner becomes an expert at building and fixing these crucial new instruments and is enlisted to use his talent to track down the resistance. Deftly interweaving the lives of Marie-Laure and Werner, Doerr illuminates the ways, against all odds, people try to be good to one another.',
		N'Marie-Laure lives in Paris near the Museum of Natural History, where her father works. When she is twelve, the Nazis occupy Paris and father and daughter flee to the walled citadel of Saint-Malo, where Marie-Laure’s reclusive great uncle lives in a tall house by the sea. With them they carry what might be the museum’s most valuable and dangerous jewel.
		In a mining town in Germany, Werner Pfennig, an orphan, grows up with his younger sister, enchanted by a crude radio they find that brings them news and stories from places they have never seen or imagined. Werner becomes an expert at building and fixing these crucial new instruments and is enlisted to use his talent to track down the resistance. Deftly interweaving the lives of Marie-Laure and Werner, Doerr illuminates the ways, against all odds, people try to be good to one another.',
		N'Marie-Laure lives in Paris near the Museum of Natural History, where her father works. When she is twelve, the Nazis occupy Paris and father and daughter flee to the walled citadel of Saint-Malo, where Marie-Laure’s reclusive great uncle lives in a tall house by the sea. With them they carry what might be the museum’s most valuable and dangerous jewel.
		In a mining town in Germany, Werner Pfennig, an orphan, grows up with his younger sister, enchanted by a crude radio they find that brings them news and stories from places they have never seen or imagined. Werner becomes an expert at building and fixing these crucial new instruments and is enlisted to use his talent to track down the resistance. Deftly interweaving the lives of Marie-Laure and Werner, Doerr illuminates the ways, against all odds, people try to be good to one another.',
		CAST(N'2022-09-03T05:52:10.323' AS DateTime), null, 1),
		(13, N'Fullmetal Alchemist, Vol. 1', 12 , CAST(90.35 AS Decimal(10, 2)), CAST(30 AS Decimal(10, 2)), N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1388179331l/870.jpg', N'Breaking the laws of nature is a serious crime!
		In an alchemical ritual gone wrong, Edward Elric lost his arm and his leg, and his brother Alphonse became nothing but a soul in a suit of armor. Equipped with mechanical “auto-mail” limbs, Edward becomes a state alchemist, seeking the one thing that can restore his and his brother’s bodies...the legendary Philosopher’s Stone.
		Alchemy: the mystical power to alter the natural world; something between magic, art and science. When two brothers, Edward and Alphonse Elric, dabbled in this power to grant their dearest wish, one of them lost an arm and a leg…and the other became nothing but a soul locked into a body of living steel. Now Edward is an agent of the government, a slave of the military-alchemical complex, using his unique powers to obey orders…even to kill. Except his powers aren''t unique. The world has been ravaged by the abuse of alchemy. And in pursuit of the ultimate alchemical treasure, the Philosopher''s Stone, their enemies are even more ruthless than they are…', 
		N'Breaking the laws of nature is a serious crime!
		In an alchemical ritual gone wrong, Edward Elric lost his arm and his leg, and his brother Alphonse became nothing but a soul in a suit of armor. Equipped with mechanical “auto-mail” limbs, Edward becomes a state alchemist, seeking the one thing that can restore his and his brother’s bodies...the legendary Philosopher’s Stone.
		Alchemy: the mystical power to alter the natural world; something between magic, art and science. When two brothers, Edward and Alphonse Elric, dabbled in this power to grant their dearest wish, one of them lost an arm and a leg…and the other became nothing but a soul locked into a body of living steel. Now Edward is an agent of the government, a slave of the military-alchemical complex, using his unique powers to obey orders…even to kill. Except his powers aren''t unique. The world has been ravaged by the abuse of alchemy. And in pursuit of the ultimate alchemical treasure, the Philosopher''s Stone, their enemies are even more ruthless than they are…', 
		N'Breaking the laws of nature is a serious crime!
		In an alchemical ritual gone wrong, Edward Elric lost his arm and his leg, and his brother Alphonse became nothing but a soul in a suit of armor. Equipped with mechanical “auto-mail” limbs, Edward becomes a state alchemist, seeking the one thing that can restore his and his brother’s bodies...the legendary Philosopher’s Stone.
		Alchemy: the mystical power to alter the natural world; something between magic, art and science. When two brothers, Edward and Alphonse Elric, dabbled in this power to grant their dearest wish, one of them lost an arm and a leg…and the other became nothing but a soul locked into a body of living steel. Now Edward is an agent of the government, a slave of the military-alchemical complex, using his unique powers to obey orders…even to kill. Except his powers aren''t unique. The world has been ravaged by the abuse of alchemy. And in pursuit of the ultimate alchemical treasure, the Philosopher''s Stone, their enemies are even more ruthless than they are…', 
		CAST(N'2022-09-04T05:52:10.323' AS DateTime), null, 1),
		(14,N'Death Note, Vol. 1: Boredom',13, CAST(100.40 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1419952134l/13615.jpg', N'Light Yagami is an ace student with great prospects - and he''s bored out of his mind. But all that changes when he finds the Death Note, a notebook dropped by a rogue Shinigami, a death god. Any human whose name is written in the notebook dies, and now Light has vowed to use the power of the Death Note to rid the world of evil. But when criminals begin dropping dead, the authorities send the legendary detective L to track down the killer. With L hot on his heels, will Light lose sight of his noble goal... or his life?', 
		N'Light Yagami is an ace student with great prospects - and he''s bored out of his mind. But all that changes when he finds the Death Note, a notebook dropped by a rogue Shinigami, a death god. Any human whose name is written in the notebook dies, and now Light has vowed to use the power of the Death Note to rid the world of evil. But when criminals begin dropping dead, the authorities send the legendary detective L to track down the killer. With L hot on his heels, will Light lose sight of his noble goal... or his life?', 
		N'Light Yagami is an ace student with great prospects - and he''s bored out of his mind. But all that changes when he finds the Death Note, a notebook dropped by a rogue Shinigami, a death god. Any human whose name is written in the notebook dies, and now Light has vowed to use the power of the Death Note to rid the world of evil. But when criminals begin dropping dead, the authorities send the legendary detective L to track down the killer. With L hot on his heels, will Light lose sight of his noble goal... or his life?', 
		CAST(N'2022-09-05T05:52:10.323' AS DateTime), null, 1),
		(15, N'One Piece, Volume 1: Romance Dawn',14, CAST(110.00 AS Decimal(10, 2)), CAST(10 AS Decimal(10, 2)), N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1318523719l/1237398.jpg', N'A new shonen sensation in Japan, this series features Monkey D. Luffy, whose main ambition is to become a pirate. Eating the Gum-Gum Fruit gives him strange powers but also invokes the fruit''s curse: anybody who consumes it can never learn to swim. Nevertheless, Monkey and his crewmate Roronoa Zoro, master of the three-sword fighting style, sail the Seven Seas of swashbuckling adventure in search of the elusive treasure "One Piece."', 
		N'A new shonen sensation in Japan, this series features Monkey D. Luffy, whose main ambition is to become a pirate. Eating the Gum-Gum Fruit gives him strange powers but also invokes the fruit''s curse: anybody who consumes it can never learn to swim. Nevertheless, Monkey and his crewmate Roronoa Zoro, master of the three-sword fighting style, sail the Seven Seas of swashbuckling adventure in search of the elusive treasure "One Piece."', 
		N'A new shonen sensation in Japan, this series features Monkey D. Luffy, whose main ambition is to become a pirate. Eating the Gum-Gum Fruit gives him strange powers but also invokes the fruit''s curse: anybody who consumes it can never learn to swim. Nevertheless, Monkey and his crewmate Roronoa Zoro, master of the three-sword fighting style, sail the Seven Seas of swashbuckling adventure in search of the elusive treasure "One Piece."', 
		CAST(N'2022-09-06T05:52:10.323' AS DateTime), null, 1),
		(16, N'Classroom of the Elite Vol. 1', 15, CAST(96.69 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1540974678l/41085104.jpg', N'Students of the prestigious Tokyo Metropolitan Advanced Nurturing High School are given remarkable freedom—if they can win, barter, or save enough points to work their way up the ranks! Ayanokoji Kiyotaka has landed at the bottom in the scorned Class D, where he meets Horikita Suzune, who’s determined to rise up the ladder to Class A. Can they beat the system in a school where cutthroat competition is the name of the game?',
		N'Students of the prestigious Tokyo Metropolitan Advanced Nurturing High School are given remarkable freedom—if they can win, barter, or save enough points to work their way up the ranks! Ayanokoji Kiyotaka has landed at the bottom in the scorned Class D, where he meets Horikita Suzune, who’s determined to rise up the ladder to Class A. Can they beat the system in a school where cutthroat competition is the name of the game?',
		N'Students of the prestigious Tokyo Metropolitan Advanced Nurturing High School are given remarkable freedom—if they can win, barter, or save enough points to work their way up the ranks! Ayanokoji Kiyotaka has landed at the bottom in the scorned Class D, where he meets Horikita Suzune, who’s determined to rise up the ladder to Class A. Can they beat the system in a school where cutthroat competition is the name of the game?',
		CAST(N'2022-09-09T05:52:10.323' AS DateTime), null, 1),
		(17, N'Dị Thế Tà Quân', 2, CAST(0.0 AS Decimal(10, 2)), 0, N'https://st.nhattruyenbing.com/data/comics/227/di-the-ta-quan.jpg', N'Không giống với một số tác phẩm truyện Tiên Hiệp và Kiếm Hiệp nổi tiếng, nhân vật chính thường có khởi đầu là một yếu nhân nghèo khổ. Nhưng Quân Tà trong tác phẩm Dị Thế Tà Quân của tác giả Phong Lăng Thiên Hạ lại có xuất thân là một sát thủ khét tiếng trong giới hắc đạo, với kỹ năng bắn súng cùng trình độ võ học siêu phàm.
		Tuy là một sát thủ máu lạnh, giết người vô số nhưng trong thâm tâm hắn vẫn còn lại trái tim con người với lòng cảm thương đối với những người cô thế. Đối với nhiều người, hắn là một kẻ vô cùng hiểm ác nhưng nếu bình tâm nhìn lại sẽ thấy những kẻ mà hắn giết đều là những tên cường hào ác bá, lạm dụng chức quyền hà hiếp người cô thế…
		Trong một lần tranh đoạt cổ vật với những phe cánh hắc đạo, tính mạng của y gặp phải nguy hiểm tột cùng khi rơi vào vòng vây phục kích. Trong cái rủi lại có cái may, chính lúc này, những món bảo vật huyền bí mà hắn tranh đoạt đã phát tỏa huyền năng đưa hắn trở về thế giới cổ đại, nơi mà pháp luật chỉ mang tính tượng trưng và chân lý chỉ thuộc về kẻ mạnh.
		Sống trong thế giới nhiễu nhương này, liệu rằng những kỹ năng của một sát thủ có giúp hắn yên ổn tồn tại…?
		Chúc bạn có những giây phút vui vẻ khi đọc truyện Dị Thế Tà Quân!',
		N'Không giống với một số tác phẩm truyện Tiên Hiệp và Kiếm Hiệp nổi tiếng, nhân vật chính thường có khởi đầu là một yếu nhân nghèo khổ. Nhưng Quân Tà trong tác phẩm Dị Thế Tà Quân của tác giả Phong Lăng Thiên Hạ lại có xuất thân là một sát thủ khét tiếng trong giới hắc đạo, với kỹ năng bắn súng cùng trình độ võ học siêu phàm.
		Tuy là một sát thủ máu lạnh, giết người vô số nhưng trong thâm tâm hắn vẫn còn lại trái tim con người với lòng cảm thương đối với những người cô thế. Đối với nhiều người, hắn là một kẻ vô cùng hiểm ác nhưng nếu bình tâm nhìn lại sẽ thấy những kẻ mà hắn giết đều là những tên cường hào ác bá, lạm dụng chức quyền hà hiếp người cô thế…
		Trong một lần tranh đoạt cổ vật với những phe cánh hắc đạo, tính mạng của y gặp phải nguy hiểm tột cùng khi rơi vào vòng vây phục kích. Trong cái rủi lại có cái may, chính lúc này, những món bảo vật huyền bí mà hắn tranh đoạt đã phát tỏa huyền năng đưa hắn trở về thế giới cổ đại, nơi mà pháp luật chỉ mang tính tượng trưng và chân lý chỉ thuộc về kẻ mạnh.
		Sống trong thế giới nhiễu nhương này, liệu rằng những kỹ năng của một sát thủ có giúp hắn yên ổn tồn tại…?
		Chúc bạn có những giây phút vui vẻ khi đọc truyện Dị Thế Tà Quân!',N'Không giống với một số tác phẩm truyện Tiên Hiệp và Kiếm Hiệp nổi tiếng, nhân vật chính thường có khởi đầu là một yếu nhân nghèo khổ. Nhưng Quân Tà trong tác phẩm Dị Thế Tà Quân của tác giả Phong Lăng Thiên Hạ lại có xuất thân là một sát thủ khét tiếng trong giới hắc đạo, với kỹ năng bắn súng cùng trình độ võ học siêu phàm.
		Tuy là một sát thủ máu lạnh, giết người vô số nhưng trong thâm tâm hắn vẫn còn lại trái tim con người với lòng cảm thương đối với những người cô thế. Đối với nhiều người, hắn là một kẻ vô cùng hiểm ác nhưng nếu bình tâm nhìn lại sẽ thấy những kẻ mà hắn giết đều là những tên cường hào ác bá, lạm dụng chức quyền hà hiếp người cô thế…
		Trong một lần tranh đoạt cổ vật với những phe cánh hắc đạo, tính mạng của y gặp phải nguy hiểm tột cùng khi rơi vào vòng vây phục kích. Trong cái rủi lại có cái may, chính lúc này, những món bảo vật huyền bí mà hắn tranh đoạt đã phát tỏa huyền năng đưa hắn trở về thế giới cổ đại, nơi mà pháp luật chỉ mang tính tượng trưng và chân lý chỉ thuộc về kẻ mạnh.
		Sống trong thế giới nhiễu nhương này, liệu rằng những kỹ năng của một sát thủ có giúp hắn yên ổn tồn tại…?
		Chúc bạn có những giây phút vui vẻ khi đọc truyện Dị Thế Tà Quân!',
		CAST(N'2023-09-01T05:52:10.323' AS DateTime), null, 1),
		(18, N'Dị Thế', 2, CAST(0.0 AS Decimal(10, 2)), 0, N'https://st.nhattruyenbing.com/data/comics/227/di-the-ta-quan.jpg', N'Không giống với một số tác phẩm truyện Tiên Hiệp và Kiếm Hiệp nổi tiếng, nhân vật chính thường có khởi đầu là một yếu nhân nghèo khổ. Nhưng Quân Tà trong tác phẩm Dị Thế Tà Quân của tác giả Phong Lăng Thiên Hạ lại có xuất thân là một sát thủ khét tiếng trong giới hắc đạo, với kỹ năng bắn súng cùng trình độ võ học siêu phàm.
		Tuy là một sát thủ máu lạnh, giết người vô số nhưng trong thâm tâm hắn vẫn còn lại trái tim con người với lòng cảm thương đối với những người cô thế. Đối với nhiều người, hắn là một kẻ vô cùng hiểm ác nhưng nếu bình tâm nhìn lại sẽ thấy những kẻ mà hắn giết đều là những tên cường hào ác bá, lạm dụng chức quyền hà hiếp người cô thế…
		Chúc bạn có những giây phút vui vẻ khi đọc truyện Dị Thế Tà Quân!',
		N'## Giới Thiệu

		Trong một thung lũng xa xôi nằm giữa những dãy núi đồi xanh mướt, có một khu rừng sâu kín bí. Khu rừng này được gọi là "Rừng Ma Thuật" bởi những câu chuyện về những hiện tượng kỳ bí xảy ra ở đó. Một cậu bé tên là Alex quyết định khám phá bí mật của khu rừng này, và cuộc phiêu lưu của cậu bắt đầu từ đây.

		### Chương 1: Sự Tò Mò

		Alex, một cậu bé tò mò và dũng cảm, nghe về những câu chuyện huyền bí về Rừng Ma Thuật và quyết định rẽ vào khu rừng đó để tìm hiểu sự thật. Người dân địa phương cảnh báo cậu về nguy hiểm nhưng Alex không quan tâm. Cậu bước chân vào khu rừng, không biết rằng cuộc phiêu lưu của mình sắp bắt đầu.

		### Chương 2: Gặp Gỡ Những Người Bạn

		Trong hành trình của mình, Alex gặp gỡ những người bạn mới. Đầu tiên là Mia, một cô bé có khả năng giao tiếp với động vật. Tiếp theo là Jack, một chàng trai có sở thích nghiên cứu về các hiện tượng siêu nhiên. Cùng nhau, họ quyết định khám phá bí mật của Rừng Ma Thuật.

		### Chương 3: Khám Phá Bí Mật

		Trong lúc đi sâu vào khu rừng, nhóm của Alex bắt gặp những hiện tượng kỳ lạ và gặp phải những thách thức đáng sợ. Họ phải đối mặt với những cạm bẫy tự nhiên, giải mã những bí ẩn của rừng và chạm trán với những sinh vật ma thuật đang bảo vệ bí mật của nơi này.

		### Chương 4: Sứ Mệnh Bảo Vệ

		Alex và nhóm của cậu khám phá ra rằng bí mật của Rừng Ma Thuật liên quan đến sự cân bằng tự nhiên và hòa bình của thế giới. Họ nhận ra mình phải bảo vệ bí mật này khỏi những kẻ muốn lợi dụng nó vì mục đích bất lương. Cuộc chiến giữa sự tốt lành và sự ác độc bắt đầu.',
		N'<h2>Giới Thiệu</h2>
			<p>Trong một thung lũng xa xôi nằm giữa những dãy núi đồi xanh mướt, có một khu rừng sâu kín bí. Khu rừng này được gọi là &quot;Rừng Ma Thuật&quot; bởi những câu chuyện về những hiện tượng kỳ bí xảy ra ở đó. Một cậu bé tên là Alex quyết định khám phá bí mật của khu rừng này, và cuộc phiêu lưu của cậu bắt đầu từ đây.</p>
			<h3>Chương 1: Sự Tò Mò</h3>
			<p>Alex, một cậu bé tò mò và dũng cảm, nghe về những câu chuyện huyền bí về Rừng Ma Thuật và quyết định rẽ vào khu rừng đó để tìm hiểu sự thật. Người dân địa phương cảnh báo cậu về nguy hiểm nhưng Alex không quan tâm. Cậu bước chân vào khu rừng, không biết rằng cuộc phiêu lưu của mình sắp bắt đầu.</p>
			<h3>Chương 2: Gặp Gỡ Những Người Bạn</h3>
			<p>Trong hành trình của mình, Alex gặp gỡ những người bạn mới. Đầu tiên là Mia, một cô bé có khả năng giao tiếp với động vật. Tiếp theo là Jack, một chàng trai có sở thích nghiên cứu về các hiện tượng siêu nhiên. Cùng nhau, họ quyết định khám phá bí mật của Rừng Ma Thuật.</p>
			<h3>Chương 3: Khám Phá Bí Mật</h3>
			<p>Trong lúc đi sâu vào khu rừng, nhóm của Alex bắt gặp những hiện tượng kỳ lạ và gặp phải những thách thức đáng sợ. Họ phải đối mặt với những cạm bẫy tự nhiên, giải mã những bí ẩn của rừng và chạm trán với những sinh vật ma thuật đang bảo vệ bí mật của nơi này.</p>
			<h3>Chương 4: Sứ Mệnh Bảo Vệ</h3>
			<p>Alex và nhóm của cậu khám phá ra rằng bí mật của Rừng Ma Thuật liên quan đến sự cân bằng tự nhiên và hòa bình của thế giới. Họ nhận ra mình phải bảo vệ bí mật này khỏi những kẻ muốn lợi dụng nó vì mục đích bất lương. Cuộc chiến giữa sự tốt lành và sự ác độc bắt đầu.</p>
			<h3>Chương 5: Kết Thúc</h3>
			<p>Cuối cùng, sau nhiều thử thách và gian khổ, Alex và nhóm của cậu chiến thắng được sự ác độc và bảo vệ được bí mật của Rừng Ma Thuật. Họ trở về ngôi làng của mình với lòng biết ơn về những trải nghiệm và sự gắn kết mà cuộc phiêu lưu đã mang lại. Rừng Ma Thuật tiếp tục tồn tại, giữ vững sự cân bằng và hòa bình cho thế giới.</p>',
		CAST(N'2023-09-01T05:52:10.323' AS DateTime), null, 2),
		(19, N'Tà Quân', 2, CAST(60.0 AS Decimal(10, 2)), 0, N'https://st.nhattruyenbing.com/data/comics/227/di-the-ta-quan.jpg', N'Không giống với một số tác phẩm truyện Tiên Hiệp và Kiếm Hiệp nổi tiếng, nhân vật chính thường có khởi đầu là một yếu nhân nghèo khổ. Nhưng Quân Tà trong tác phẩm Dị Thế Tà Quân của tác giả Phong Lăng Thiên Hạ lại có xuất thân là một sát thủ khét tiếng trong giới hắc đạo, với kỹ năng bắn súng cùng trình độ võ học siêu phàm.
		Tuy là một sát thủ máu lạnh, giết người vô số nhưng trong thâm tâm hắn vẫn còn lại trái tim con người với lòng cảm thương đối với những người cô thế. Đối với nhiều người, hắn là một kẻ vô cùng hiểm ác nhưng nếu bình tâm nhìn lại sẽ thấy những kẻ mà hắn giết đều là những tên cường hào ác bá, lạm dụng chức quyền hà hiếp người cô thế…
		Chúc bạn có những giây phút vui vẻ khi đọc truyện Dị Thế Tà Quân!',
		N'## Giới Thiệu

		Trong một thung lũng xa xôi nằm giữa những dãy núi đồi xanh mướt, có một khu rừng sâu kín bí. Khu rừng này được gọi là "Rừng Ma Thuật" bởi những câu chuyện về những hiện tượng kỳ bí xảy ra ở đó. Một cậu bé tên là Alex quyết định khám phá bí mật của khu rừng này, và cuộc phiêu lưu của cậu bắt đầu từ đây.

		### Chương 1: Sự Tò Mò

		Alex, một cậu bé tò mò và dũng cảm, nghe về những câu chuyện huyền bí về Rừng Ma Thuật và quyết định rẽ vào khu rừng đó để tìm hiểu sự thật. Người dân địa phương cảnh báo cậu về nguy hiểm nhưng Alex không quan tâm. Cậu bước chân vào khu rừng, không biết rằng cuộc phiêu lưu của mình sắp bắt đầu.

		### Chương 2: Gặp Gỡ Những Người Bạn

		Trong hành trình của mình, Alex gặp gỡ những người bạn mới. Đầu tiên là Mia, một cô bé có khả năng giao tiếp với động vật. Tiếp theo là Jack, một chàng trai có sở thích nghiên cứu về các hiện tượng siêu nhiên. Cùng nhau, họ quyết định khám phá bí mật của Rừng Ma Thuật.

		### Chương 3: Khám Phá Bí Mật

		Trong lúc đi sâu vào khu rừng, nhóm của Alex bắt gặp những hiện tượng kỳ lạ và gặp phải những thách thức đáng sợ. Họ phải đối mặt với những cạm bẫy tự nhiên, giải mã những bí ẩn của rừng và chạm trán với những sinh vật ma thuật đang bảo vệ bí mật của nơi này.

		### Chương 4: Sứ Mệnh Bảo Vệ

		Alex và nhóm của cậu khám phá ra rằng bí mật của Rừng Ma Thuật liên quan đến sự cân bằng tự nhiên và hòa bình của thế giới. Họ nhận ra mình phải bảo vệ bí mật này khỏi những kẻ muốn lợi dụng nó vì mục đích bất lương. Cuộc chiến giữa sự tốt lành và sự ác độc bắt đầu.',
		N'<h2>Giới Thiệu</h2>
			<p>Trong một thung lũng xa xôi nằm giữa những dãy núi đồi xanh mướt, có một khu rừng sâu kín bí. Khu rừng này được gọi là &quot;Rừng Ma Thuật&quot; bởi những câu chuyện về những hiện tượng kỳ bí xảy ra ở đó. Một cậu bé tên là Alex quyết định khám phá bí mật của khu rừng này, và cuộc phiêu lưu của cậu bắt đầu từ đây.</p>
			<h3>Chương 1: Sự Tò Mò</h3>
			<p>Alex, một cậu bé tò mò và dũng cảm, nghe về những câu chuyện huyền bí về Rừng Ma Thuật và quyết định rẽ vào khu rừng đó để tìm hiểu sự thật. Người dân địa phương cảnh báo cậu về nguy hiểm nhưng Alex không quan tâm. Cậu bước chân vào khu rừng, không biết rằng cuộc phiêu lưu của mình sắp bắt đầu.</p>
			<h3>Chương 2: Gặp Gỡ Những Người Bạn</h3>
			<p>Trong hành trình của mình, Alex gặp gỡ những người bạn mới. Đầu tiên là Mia, một cô bé có khả năng giao tiếp với động vật. Tiếp theo là Jack, một chàng trai có sở thích nghiên cứu về các hiện tượng siêu nhiên. Cùng nhau, họ quyết định khám phá bí mật của Rừng Ma Thuật.</p>
			<h3>Chương 3: Khám Phá Bí Mật</h3>
			<p>Trong lúc đi sâu vào khu rừng, nhóm của Alex bắt gặp những hiện tượng kỳ lạ và gặp phải những thách thức đáng sợ. Họ phải đối mặt với những cạm bẫy tự nhiên, giải mã những bí ẩn của rừng và chạm trán với những sinh vật ma thuật đang bảo vệ bí mật của nơi này.</p>
			<h3>Chương 4: Sứ Mệnh Bảo Vệ</h3>
			<p>Alex và nhóm của cậu khám phá ra rằng bí mật của Rừng Ma Thuật liên quan đến sự cân bằng tự nhiên và hòa bình của thế giới. Họ nhận ra mình phải bảo vệ bí mật này khỏi những kẻ muốn lợi dụng nó vì mục đích bất lương. Cuộc chiến giữa sự tốt lành và sự ác độc bắt đầu.</p>
			<h3>Chương 5: Kết Thúc</h3>
			<p>Cuối cùng, sau nhiều thử thách và gian khổ, Alex và nhóm của cậu chiến thắng được sự ác độc và bảo vệ được bí mật của Rừng Ma Thuật. Họ trở về ngôi làng của mình với lòng biết ơn về những trải nghiệm và sự gắn kết mà cuộc phiêu lưu đã mang lại. Rừng Ma Thuật tiếp tục tồn tại, giữ vững sự cân bằng và hòa bình cho thế giới.</p>',
		CAST(N'2023-09-01T05:52:10.323' AS DateTime), null, 2),
		(20, N'Dị Quân', 2, CAST(0.0 AS Decimal(10, 2)), 0, N'https://st.nhattruyenbing.com/data/comics/227/di-the-ta-quan.jpg', N'Không giống với một số tác phẩm truyện Tiên Hiệp và Kiếm Hiệp nổi tiếng, nhân vật chính thường có khởi đầu là một yếu nhân nghèo khổ. Nhưng Quân Tà trong tác phẩm Dị Thế Tà Quân của tác giả Phong Lăng Thiên Hạ lại có xuất thân là một sát thủ khét tiếng trong giới hắc đạo, với kỹ năng bắn súng cùng trình độ võ học siêu phàm.
		Tuy là một sát thủ máu lạnh, giết người vô số nhưng trong thâm tâm hắn vẫn còn lại trái tim con người với lòng cảm thương đối với những người cô thế. Đối với nhiều người, hắn là một kẻ vô cùng hiểm ác nhưng nếu bình tâm nhìn lại sẽ thấy những kẻ mà hắn giết đều là những tên cường hào ác bá, lạm dụng chức quyền hà hiếp người cô thế…
		Chúc bạn có những giây phút vui vẻ khi đọc truyện Dị Thế Tà Quân!',
		N'## Giới Thiệu

		Trong một thung lũng xa xôi nằm giữa những dãy núi đồi xanh mướt, có một khu rừng sâu kín bí. Khu rừng này được gọi là "Rừng Ma Thuật" bởi những câu chuyện về những hiện tượng kỳ bí xảy ra ở đó. Một cậu bé tên là Alex quyết định khám phá bí mật của khu rừng này, và cuộc phiêu lưu của cậu bắt đầu từ đây.

		### Chương 1: Sự Tò Mò

		Alex, một cậu bé tò mò và dũng cảm, nghe về những câu chuyện huyền bí về Rừng Ma Thuật và quyết định rẽ vào khu rừng đó để tìm hiểu sự thật. Người dân địa phương cảnh báo cậu về nguy hiểm nhưng Alex không quan tâm. Cậu bước chân vào khu rừng, không biết rằng cuộc phiêu lưu của mình sắp bắt đầu.

		### Chương 2: Gặp Gỡ Những Người Bạn

		Trong hành trình của mình, Alex gặp gỡ những người bạn mới. Đầu tiên là Mia, một cô bé có khả năng giao tiếp với động vật. Tiếp theo là Jack, một chàng trai có sở thích nghiên cứu về các hiện tượng siêu nhiên. Cùng nhau, họ quyết định khám phá bí mật của Rừng Ma Thuật.

		### Chương 3: Khám Phá Bí Mật

		Trong lúc đi sâu vào khu rừng, nhóm của Alex bắt gặp những hiện tượng kỳ lạ và gặp phải những thách thức đáng sợ. Họ phải đối mặt với những cạm bẫy tự nhiên, giải mã những bí ẩn của rừng và chạm trán với những sinh vật ma thuật đang bảo vệ bí mật của nơi này.

		### Chương 4: Sứ Mệnh Bảo Vệ

		Alex và nhóm của cậu khám phá ra rằng bí mật của Rừng Ma Thuật liên quan đến sự cân bằng tự nhiên và hòa bình của thế giới. Họ nhận ra mình phải bảo vệ bí mật này khỏi những kẻ muốn lợi dụng nó vì mục đích bất lương. Cuộc chiến giữa sự tốt lành và sự ác độc bắt đầu.',
		N'<h2>Giới Thiệu</h2>
			<p>Trong một thung lũng xa xôi nằm giữa những dãy núi đồi xanh mướt, có một khu rừng sâu kín bí. Khu rừng này được gọi là &quot;Rừng Ma Thuật&quot; bởi những câu chuyện về những hiện tượng kỳ bí xảy ra ở đó. Một cậu bé tên là Alex quyết định khám phá bí mật của khu rừng này, và cuộc phiêu lưu của cậu bắt đầu từ đây.</p>
			<h3>Chương 1: Sự Tò Mò</h3>
			<p>Alex, một cậu bé tò mò và dũng cảm, nghe về những câu chuyện huyền bí về Rừng Ma Thuật và quyết định rẽ vào khu rừng đó để tìm hiểu sự thật. Người dân địa phương cảnh báo cậu về nguy hiểm nhưng Alex không quan tâm. Cậu bước chân vào khu rừng, không biết rằng cuộc phiêu lưu của mình sắp bắt đầu.</p>
			<h3>Chương 2: Gặp Gỡ Những Người Bạn</h3>
			<p>Trong hành trình của mình, Alex gặp gỡ những người bạn mới. Đầu tiên là Mia, một cô bé có khả năng giao tiếp với động vật. Tiếp theo là Jack, một chàng trai có sở thích nghiên cứu về các hiện tượng siêu nhiên. Cùng nhau, họ quyết định khám phá bí mật của Rừng Ma Thuật.</p>
			<h3>Chương 3: Khám Phá Bí Mật</h3>
			<p>Trong lúc đi sâu vào khu rừng, nhóm của Alex bắt gặp những hiện tượng kỳ lạ và gặp phải những thách thức đáng sợ. Họ phải đối mặt với những cạm bẫy tự nhiên, giải mã những bí ẩn của rừng và chạm trán với những sinh vật ma thuật đang bảo vệ bí mật của nơi này.</p>
			<h3>Chương 4: Sứ Mệnh Bảo Vệ</h3>
			<p>Alex và nhóm của cậu khám phá ra rằng bí mật của Rừng Ma Thuật liên quan đến sự cân bằng tự nhiên và hòa bình của thế giới. Họ nhận ra mình phải bảo vệ bí mật này khỏi những kẻ muốn lợi dụng nó vì mục đích bất lương. Cuộc chiến giữa sự tốt lành và sự ác độc bắt đầu.</p>
			<h3>Chương 5: Kết Thúc</h3>
			<p>Cuối cùng, sau nhiều thử thách và gian khổ, Alex và nhóm của cậu chiến thắng được sự ác độc và bảo vệ được bí mật của Rừng Ma Thuật. Họ trở về ngôi làng của mình với lòng biết ơn về những trải nghiệm và sự gắn kết mà cuộc phiêu lưu đã mang lại. Rừng Ma Thuật tiếp tục tồn tại, giữ vững sự cân bằng và hòa bình cho thế giới.</p>',
		CAST(N'2023-09-01T05:52:10.323' AS DateTime), null, 2),
		(21, N'Ma Quân', 2, CAST(150.0 AS Decimal(10, 2)), 0, N'https://st.nhattruyenbing.com/data/comics/227/di-the-ta-quan.jpg', N'Không giống với một số tác phẩm truyện Tiên Hiệp và Kiếm Hiệp nổi tiếng, nhân vật chính thường có khởi đầu là một yếu nhân nghèo khổ. Nhưng Quân Tà trong tác phẩm Dị Thế Tà Quân của tác giả Phong Lăng Thiên Hạ lại có xuất thân là một sát thủ khét tiếng trong giới hắc đạo, với kỹ năng bắn súng cùng trình độ võ học siêu phàm.
		Tuy là một sát thủ máu lạnh, giết người vô số nhưng trong thâm tâm hắn vẫn còn lại trái tim con người với lòng cảm thương đối với những người cô thế. Đối với nhiều người, hắn là một kẻ vô cùng hiểm ác nhưng nếu bình tâm nhìn lại sẽ thấy những kẻ mà hắn giết đều là những tên cường hào ác bá, lạm dụng chức quyền hà hiếp người cô thế…
		Chúc bạn có những giây phút vui vẻ khi đọc truyện Dị Thế Tà Quân!',
		N'## Giới Thiệu

		Trong một thung lũng xa xôi nằm giữa những dãy núi đồi xanh mướt, có một khu rừng sâu kín bí. Khu rừng này được gọi là "Rừng Ma Thuật" bởi những câu chuyện về những hiện tượng kỳ bí xảy ra ở đó. Một cậu bé tên là Alex quyết định khám phá bí mật của khu rừng này, và cuộc phiêu lưu của cậu bắt đầu từ đây.

		### Chương 1: Sự Tò Mò

		Alex, một cậu bé tò mò và dũng cảm, nghe về những câu chuyện huyền bí về Rừng Ma Thuật và quyết định rẽ vào khu rừng đó để tìm hiểu sự thật. Người dân địa phương cảnh báo cậu về nguy hiểm nhưng Alex không quan tâm. Cậu bước chân vào khu rừng, không biết rằng cuộc phiêu lưu của mình sắp bắt đầu.

		### Chương 2: Gặp Gỡ Những Người Bạn

		Trong hành trình của mình, Alex gặp gỡ những người bạn mới. Đầu tiên là Mia, một cô bé có khả năng giao tiếp với động vật. Tiếp theo là Jack, một chàng trai có sở thích nghiên cứu về các hiện tượng siêu nhiên. Cùng nhau, họ quyết định khám phá bí mật của Rừng Ma Thuật.

		### Chương 3: Khám Phá Bí Mật

		Trong lúc đi sâu vào khu rừng, nhóm của Alex bắt gặp những hiện tượng kỳ lạ và gặp phải những thách thức đáng sợ. Họ phải đối mặt với những cạm bẫy tự nhiên, giải mã những bí ẩn của rừng và chạm trán với những sinh vật ma thuật đang bảo vệ bí mật của nơi này.

		### Chương 4: Sứ Mệnh Bảo Vệ

		Alex và nhóm của cậu khám phá ra rằng bí mật của Rừng Ma Thuật liên quan đến sự cân bằng tự nhiên và hòa bình của thế giới. Họ nhận ra mình phải bảo vệ bí mật này khỏi những kẻ muốn lợi dụng nó vì mục đích bất lương. Cuộc chiến giữa sự tốt lành và sự ác độc bắt đầu.',
		N'<h2>Giới Thiệu</h2>
			<p>Trong một thung lũng xa xôi nằm giữa những dãy núi đồi xanh mướt, có một khu rừng sâu kín bí. Khu rừng này được gọi là &quot;Rừng Ma Thuật&quot; bởi những câu chuyện về những hiện tượng kỳ bí xảy ra ở đó. Một cậu bé tên là Alex quyết định khám phá bí mật của khu rừng này, và cuộc phiêu lưu của cậu bắt đầu từ đây.</p>
			<h3>Chương 1: Sự Tò Mò</h3>
			<p>Alex, một cậu bé tò mò và dũng cảm, nghe về những câu chuyện huyền bí về Rừng Ma Thuật và quyết định rẽ vào khu rừng đó để tìm hiểu sự thật. Người dân địa phương cảnh báo cậu về nguy hiểm nhưng Alex không quan tâm. Cậu bước chân vào khu rừng, không biết rằng cuộc phiêu lưu của mình sắp bắt đầu.</p>
			<h3>Chương 2: Gặp Gỡ Những Người Bạn</h3>
			<p>Trong hành trình của mình, Alex gặp gỡ những người bạn mới. Đầu tiên là Mia, một cô bé có khả năng giao tiếp với động vật. Tiếp theo là Jack, một chàng trai có sở thích nghiên cứu về các hiện tượng siêu nhiên. Cùng nhau, họ quyết định khám phá bí mật của Rừng Ma Thuật.</p>
			<h3>Chương 3: Khám Phá Bí Mật</h3>
			<p>Trong lúc đi sâu vào khu rừng, nhóm của Alex bắt gặp những hiện tượng kỳ lạ và gặp phải những thách thức đáng sợ. Họ phải đối mặt với những cạm bẫy tự nhiên, giải mã những bí ẩn của rừng và chạm trán với những sinh vật ma thuật đang bảo vệ bí mật của nơi này.</p>
			<h3>Chương 4: Sứ Mệnh Bảo Vệ</h3>
			<p>Alex và nhóm của cậu khám phá ra rằng bí mật của Rừng Ma Thuật liên quan đến sự cân bằng tự nhiên và hòa bình của thế giới. Họ nhận ra mình phải bảo vệ bí mật này khỏi những kẻ muốn lợi dụng nó vì mục đích bất lương. Cuộc chiến giữa sự tốt lành và sự ác độc bắt đầu.</p>
			<h3>Chương 5: Kết Thúc</h3>
			<p>Cuối cùng, sau nhiều thử thách và gian khổ, Alex và nhóm của cậu chiến thắng được sự ác độc và bảo vệ được bí mật của Rừng Ma Thuật. Họ trở về ngôi làng của mình với lòng biết ơn về những trải nghiệm và sự gắn kết mà cuộc phiêu lưu đã mang lại. Rừng Ma Thuật tiếp tục tồn tại, giữ vững sự cân bằng và hòa bình cho thế giới.</p>',
		CAST(N'2023-09-01T05:52:10.323' AS DateTime), null, 2),
		(22, N'Dị Thế Tà Quân', 2, CAST(0.0 AS Decimal(10, 2)), 0, N'https://st.nhattruyenbing.com/data/comics/227/di-the-ta-quan.jpg', N'Không giống với một số tác phẩm truyện Tiên Hiệp và Kiếm Hiệp nổi tiếng, nhân vật chính thường có khởi đầu là một yếu nhân nghèo khổ. Nhưng Quân Tà trong tác phẩm Dị Thế Tà Quân của tác giả Phong Lăng Thiên Hạ lại có xuất thân là một sát thủ khét tiếng trong giới hắc đạo, với kỹ năng bắn súng cùng trình độ võ học siêu phàm.
		Tuy là một sát thủ máu lạnh, giết người vô số nhưng trong thâm tâm hắn vẫn còn lại trái tim con người với lòng cảm thương đối với những người cô thế. Đối với nhiều người, hắn là một kẻ vô cùng hiểm ác nhưng nếu bình tâm nhìn lại sẽ thấy những kẻ mà hắn giết đều là những tên cường hào ác bá, lạm dụng chức quyền hà hiếp người cô thế…
		Chúc bạn có những giây phút vui vẻ khi đọc truyện Dị Thế Tà Quân!',
		N'## Giới Thiệu

		Trong một thung lũng xa xôi nằm giữa những dãy núi đồi xanh mướt, có một khu rừng sâu kín bí. Khu rừng này được gọi là "Rừng Ma Thuật" bởi những câu chuyện về những hiện tượng kỳ bí xảy ra ở đó. Một cậu bé tên là Alex quyết định khám phá bí mật của khu rừng này, và cuộc phiêu lưu của cậu bắt đầu từ đây.

		### Chương 1: Sự Tò Mò

		Alex, một cậu bé tò mò và dũng cảm, nghe về những câu chuyện huyền bí về Rừng Ma Thuật và quyết định rẽ vào khu rừng đó để tìm hiểu sự thật. Người dân địa phương cảnh báo cậu về nguy hiểm nhưng Alex không quan tâm. Cậu bước chân vào khu rừng, không biết rằng cuộc phiêu lưu của mình sắp bắt đầu.

		### Chương 2: Gặp Gỡ Những Người Bạn

		Trong hành trình của mình, Alex gặp gỡ những người bạn mới. Đầu tiên là Mia, một cô bé có khả năng giao tiếp với động vật. Tiếp theo là Jack, một chàng trai có sở thích nghiên cứu về các hiện tượng siêu nhiên. Cùng nhau, họ quyết định khám phá bí mật của Rừng Ma Thuật.

		### Chương 3: Khám Phá Bí Mật

		Trong lúc đi sâu vào khu rừng, nhóm của Alex bắt gặp những hiện tượng kỳ lạ và gặp phải những thách thức đáng sợ. Họ phải đối mặt với những cạm bẫy tự nhiên, giải mã những bí ẩn của rừng và chạm trán với những sinh vật ma thuật đang bảo vệ bí mật của nơi này.

		### Chương 4: Sứ Mệnh Bảo Vệ

		Alex và nhóm của cậu khám phá ra rằng bí mật của Rừng Ma Thuật liên quan đến sự cân bằng tự nhiên và hòa bình của thế giới. Họ nhận ra mình phải bảo vệ bí mật này khỏi những kẻ muốn lợi dụng nó vì mục đích bất lương. Cuộc chiến giữa sự tốt lành và sự ác độc bắt đầu.',
		N'<h2>Giới Thiệu</h2>
			<p>Trong một thung lũng xa xôi nằm giữa những dãy núi đồi xanh mướt, có một khu rừng sâu kín bí. Khu rừng này được gọi là &quot;Rừng Ma Thuật&quot; bởi những câu chuyện về những hiện tượng kỳ bí xảy ra ở đó. Một cậu bé tên là Alex quyết định khám phá bí mật của khu rừng này, và cuộc phiêu lưu của cậu bắt đầu từ đây.</p>
			<h3>Chương 1: Sự Tò Mò</h3>
			<p>Alex, một cậu bé tò mò và dũng cảm, nghe về những câu chuyện huyền bí về Rừng Ma Thuật và quyết định rẽ vào khu rừng đó để tìm hiểu sự thật. Người dân địa phương cảnh báo cậu về nguy hiểm nhưng Alex không quan tâm. Cậu bước chân vào khu rừng, không biết rằng cuộc phiêu lưu của mình sắp bắt đầu.</p>
			<h3>Chương 2: Gặp Gỡ Những Người Bạn</h3>
			<p>Trong hành trình của mình, Alex gặp gỡ những người bạn mới. Đầu tiên là Mia, một cô bé có khả năng giao tiếp với động vật. Tiếp theo là Jack, một chàng trai có sở thích nghiên cứu về các hiện tượng siêu nhiên. Cùng nhau, họ quyết định khám phá bí mật của Rừng Ma Thuật.</p>
			<h3>Chương 3: Khám Phá Bí Mật</h3>
			<p>Trong lúc đi sâu vào khu rừng, nhóm của Alex bắt gặp những hiện tượng kỳ lạ và gặp phải những thách thức đáng sợ. Họ phải đối mặt với những cạm bẫy tự nhiên, giải mã những bí ẩn của rừng và chạm trán với những sinh vật ma thuật đang bảo vệ bí mật của nơi này.</p>
			<h3>Chương 4: Sứ Mệnh Bảo Vệ</h3>
			<p>Alex và nhóm của cậu khám phá ra rằng bí mật của Rừng Ma Thuật liên quan đến sự cân bằng tự nhiên và hòa bình của thế giới. Họ nhận ra mình phải bảo vệ bí mật này khỏi những kẻ muốn lợi dụng nó vì mục đích bất lương. Cuộc chiến giữa sự tốt lành và sự ác độc bắt đầu.</p>
			<h3>Chương 5: Kết Thúc</h3>
			<p>Cuối cùng, sau nhiều thử thách và gian khổ, Alex và nhóm của cậu chiến thắng được sự ác độc và bảo vệ được bí mật của Rừng Ma Thuật. Họ trở về ngôi làng của mình với lòng biết ơn về những trải nghiệm và sự gắn kết mà cuộc phiêu lưu đã mang lại. Rừng Ma Thuật tiếp tục tồn tại, giữ vững sự cân bằng và hòa bình cho thế giới.</p>',
		CAST(N'2023-09-01T05:52:10.323' AS DateTime), null, 2),
		(23, N'CEO nhất định muốn cưới tôi', 3, CAST(210.0 AS Decimal(10, 2)), 0, N'https://yymedia.codeprime.net/media/novels/202403/ceo-nhat-dinh-muon-cuoi-toi-2424ee5d5d.jpg',
		N'Cô vẫn luôn hi vọng đêm tân hôn có thể đem thứ quý giá của bản thân tặng cho hắn, tuy rằng ngượng ngùng nhưng cô vẫn hi vọng như vậy,
		mà hắn lại muốn xuất ngoại đào tạo chuyên sâu... Nhưng khi cô cầm chìa khóa bạn thân đưa cho mình, một đêm qua đi, lại phát hiện người đàn ông bên cạnh cô là một người lạ!!

		Chúc bạn có những giây phút vui vẻ khi đọc truyện CEO nhất định muốn cưới tôi!'
		,N'Cô vẫn luôn hi vọng đêm tân hôn có thể đem thứ quý giá của bản thân tặng cho hắn, tuy rằng ngượng ngùng nhưng cô vẫn hi vọng như vậy,
		mà hắn lại muốn xuất ngoại đào tạo chuyên sâu... Nhưng khi cô cầm chìa khóa bạn thân đưa cho mình, một đêm qua đi, lại phát hiện người đàn ông bên cạnh cô là một người lạ!!

		Chúc bạn có những giây phút vui vẻ khi đọc truyện CEO nhất định muốn cưới tôi!'
		,N'<p>Cô vẫn luôn hi vọng đêm tân hôn có thể đem thứ quý giá của bản thân tặng cho hắn, tuy rằng ngượng ngùng nhưng cô vẫn hi vọng như vậy,
			mà hắn lại muốn xuất ngoại đào tạo chuyên sâu... Nhưng khi cô cầm chìa khóa bạn thân đưa cho mình, một đêm qua đi, lại phát hiện người đàn ông bên cạnh cô là một người lạ!!</p>
			<h3>Chúc bạn có những giây phút vui vẻ khi đọc truyện CEO nhất định muốn cưới tôi!</h3>'
		,CAST(N'2024-01-01T05:52:10.323' AS DateTime), null, 1),
		(24, N'Bất Diệt Kiếm Quân', 3, CAST(110.0 AS Decimal(10, 2)), 0, N'https://yymedia.codeprime.net/media/novels/359afd3548.jpg',
		N'"Cái gì Thiên Kiêu, cái gì Thiên Tài, không bại được ta; ta tất bất bại..." "Nếu ta là Ma, đem san bằng Thiên Huyền, thương sinh thì lại làm sao, thiên địa phụ ta, ta liền tàn sát
		hết mảnh thiên địa này " -Công pháp chia làm Phàm giai, Huyền Giai, Linh Giai, Thần Giai, Thánh Giai; mỗi cấp bậc chia làm Thượng, Trung, Hạ. -Binh khí chia làm Phàm giai, Huyền Giai,
		Linh Giai, Bán Thần cấp, Thần Giai, Bán Thánh cấp, Thánh Giai, ~~~~~TRUYỆN HAY KHÔNG LO CHI HỐ~~~~~ + Không có tác phẩm nào gọi là tuyệt phẩm, không có cảnh giới nào gọi là đỉnh cao, 
		cũng không có cái gì trọn vẹn cả, đọc là giải trí; cảm thấy không tốt đóng tab đừng nói lời cay đắng... thank ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
		-Để ủng hộ corvert : + VOTE 10* ở dưới tên truyện + Đọc Tích Cực Và Vote (9~10) ở cuối mỗi chương nếu có nhé..! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
		P/s 1: truyện xuyên suốt pk -> xem sướng P/s2 : truyện đã set vip những bạn ủng hộ thì mình cảm ơn, nếu những bạn không có đậu thì chịu khó 7 ngày sau unvip chương
		
		Chúc bạn có những giây phút vui vẻ khi đọc truyện Bất Diệt Kiếm Quân!'
		,N'"Cái gì Thiên Kiêu, cái gì Thiên Tài, không bại được ta; ta tất bất bại..." "Nếu ta là Ma, đem san bằng Thiên Huyền, thương sinh thì lại làm sao, thiên địa phụ ta, ta liền tàn sát
		hết mảnh thiên địa này " -Công pháp chia làm Phàm giai, Huyền Giai, Linh Giai, Thần Giai, Thánh Giai; mỗi cấp bậc chia làm Thượng, Trung, Hạ. -Binh khí chia làm Phàm giai, Huyền Giai,
		Linh Giai, Bán Thần cấp, Thần Giai, Bán Thánh cấp, Thánh Giai, ~~~~~TRUYỆN HAY KHÔNG LO CHI HỐ~~~~~ + Không có tác phẩm nào gọi là tuyệt phẩm, không có cảnh giới nào gọi là đỉnh cao, 
		cũng không có cái gì trọn vẹn cả, đọc là giải trí; cảm thấy không tốt đóng tab đừng nói lời cay đắng... thank ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
		-Để ủng hộ corvert : + VOTE 10* ở dưới tên truyện + Đọc Tích Cực Và Vote (9~10) ở cuối mỗi chương nếu có nhé..! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
		P/s 1: truyện xuyên suốt pk -> xem sướng P/s2 : truyện đã set vip những bạn ủng hộ thì mình cảm ơn, nếu những bạn không có đậu thì chịu khó 7 ngày sau unvip chương
		
		Chúc bạn có những giây phút vui vẻ khi đọc truyện Bất Diệt Kiếm Quân!'
		,N'<p>"Cái gì Thiên Kiêu, cái gì Thiên Tài, không bại được ta; ta tất bất bại..." "Nếu ta là Ma, đem san bằng Thiên Huyền, thương sinh thì lại làm sao, thiên địa phụ ta, ta liền tàn sát
			hết mảnh thiên địa này " -Công pháp chia làm Phàm giai, Huyền Giai, Linh Giai, Thần Giai, Thánh Giai; mỗi cấp bậc chia làm Thượng, Trung, Hạ. -Binh khí chia làm Phàm giai, Huyền Giai,
			Linh Giai, Bán Thần cấp, Thần Giai, Bán Thánh cấp, Thánh Giai, ~~~~~TRUYỆN HAY KHÔNG LO CHI HỐ~~~~~ + Không có tác phẩm nào gọi là tuyệt phẩm, không có cảnh giới nào gọi là đỉnh cao, 
			cũng không có cái gì trọn vẹn cả, đọc là giải trí; cảm thấy không tốt đóng tab đừng nói lời cay đắng... thank ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ </p>
			<h3>-Để ủng hộ corvert : + VOTE 10* ở dưới tên truyện + Đọc Tích Cực Và Vote (9~10) ở cuối mỗi chương nếu có nhé..! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ </h3>
			<h3>P/s 1: truyện xuyên suốt pk -> xem sướng P/s2 : truyện đã set vip những bạn ủng hộ thì mình cảm ơn, nếu những bạn không có đậu thì chịu khó 7 ngày sau unvip chương</h3>
			
			<h3>Chúc bạn có những giây phút vui vẻ khi đọc truyện Bất Diệt Kiếm Quân!</h3>'
		,CAST(N'2024-01-01T05:52:10.323' AS DateTime), null, 1)
		
SET IDENTITY_INSERT [dbo].[Story] OFF
GO

INSERT [dbo].[Story_Interaction] ([story_id] ,[like], [follow], [view], [read])
	VALUES 
		(1 ,100 ,24 ,123 ,198),
		(2 ,43 ,34 ,83 ,158),
		(3 ,23 ,14 ,23 ,238),
		(4 ,43 ,24 ,33 ,48),
		(5 ,23 ,24 ,123 ,98),
		(6 ,53 ,24 ,123 ,98),
		(7 ,53 ,24 ,123 ,98),
		(8 ,53 ,24 ,123 ,98),
		(9 ,53 ,24 ,123 ,98),
		(10 ,53 ,24 ,123 ,98),
		(11 ,53 ,24 ,123 ,98),
		(12 ,53 ,24 ,123 ,98),
		(13 ,53 ,24 ,123 ,98),
		(14 ,53 ,24 ,123 ,98),
		(15 ,53 ,24 ,123 ,98),
		(16 ,53 ,24 ,123 ,98),
		(17 ,123 ,124 ,143 ,208),
		(18 ,13 ,14 ,14 ,28),
		(19 ,13 ,14 ,14 ,28),
		(20 ,13 ,14 ,14 ,28),
		(21 ,13 ,14 ,14 ,28),
		(22 ,13 ,14 ,14 ,28),
		(23 ,78 ,33 ,64 ,78),
		(24 ,128 ,73 ,24 ,128)




SET IDENTITY_INSERT [dbo].[Category] ON 
GO

INSERT [dbo].[Category] ([category_id],[category_name],[category_banner],[category_description]) 
	VALUES
		(1, N'Manhwa',N'https://yymedia.codeprime.net/media/genre_cover/bg09.jpeg',N'Truyện Hàn Quốc'),
		(2, N'Manhua',N'https://yymedia.codeprime.net/media/genre_cover/bg01.jpeg',N'Truyện của Trung Quốc'), 
		(3, N'Manga',N'https://yymedia.codeprime.net/media/genre_cover/bg14.jpeg',N'Truyện của Nhật Bản'), 
		(4, N'Truyện ngắn',N'https://yystatic.codeprime.net/desktop/page-cover/default-3.jpg',N'Những truyện ngắn,thường là 1 vài chapter'), 
		(5, N'Tiểu thuyết',N'https://yystatic.codeprime.net/desktop/page-cover/default-4.jpg',N'tiểu thuyết là sử thi của đời tư'), 
		(6, N'Comedy',N'https://yymedia.codeprime.net/media/genre_cover/bg06.jpeg',N'Thể loại có nội dung trong sáng và cảm động, thường có các tình tiết gây cười, các xung đột nhẹ nhàng'), 
		(7, N'Kinh dị',N'https://yymedia.codeprime.net/media/genre_cover/bg02.jpeg',N'Thể loại dành cho lứa tuổi 17+ bao gồm các pha bạo lực, máu me, chém giết, tình dục ở mức độ vừa'), 
		(8, N'Hành động',N'https://yymedia.codeprime.net/media/genre_cover/bg03.jpeg',N'Thể loại này thường có nội dung về đánh nhau, bạo lực, hỗn loạn, với diễn biến nhanh'), 
		(9, N'Phiêu lưu',N'https://yystatic.codeprime.net/desktop/page-cover/default-2.jpg',N'Thể loại phiêu lưu, mạo hiểm, thường là hành trình của các nhân vật'),
		(10, N'Lãng mạn',N'https://yystatic.codeprime.net/desktop/page-cover/default-6.jpg',N'Thường là những câu chuyện về tình yêu, tình cảm lãng mạn.'), 
		(11, N'Viễn tưởng',N'https://yymedia.codeprime.net/media/genre_cover/bg08.jpeg',N'Thể hiện những sức mạnh đáng kinh ngạc và không thể giải thích được, chúng thường đi kèm với những sự kiện trái ngược hoặc thách thức với những định luật vật lý'), 
		(12, N'Bí ẩn',N'https://yystatic.codeprime.net/desktop/page-cover/default-6.jpg',N'Thể loại thường xuất hiện những điều bí ấn không thể lí giải được và sau đó là những nỗ lực của nhân vật chính nhằm tìm ra câu trả lời thỏa đáng'), 
		(13, N'Khoa học',N'https://yymedia.codeprime.net/media/genre_cover/bg08.jpeg',N'Truyện liên quan đến vấn đề khoa học'),
		(14, N'Tiếng anh',N'https://yymedia.codeprime.net/media/genre_cover/bg09.jpeg',N'Truyện viết bằng tiếng anh'), 
		(15, N'Tiếng Việt',N'https://yymedia.codeprime.net/media/genre_cover/bg05.jpeg',N'Truyện viết bằng tiếng việt')

SET IDENTITY_INSERT [dbo].[Category] OFF
GO

INSERT INTO [dbo].[Story_Category]([category_id],[story_id]) VALUES
	(1,1),(12,1),(8,1),(14,1),
	(2,2),(12,2),(8,2),(14,2),
	(3,3),(12,3),(8,3),(14,3),
	(1,4),(12,4),(8,4),(14,4),
	(1,5),(8,5),(11,5),(14,5),
	(2,6),(8,6),(11,6),(14,6),
	(3,7),(8,7),(11,7),(12,7),(14,7),
	(3,8),(5,8),(6,8),(10,8),(14,8),
	(1,9),(7,9),(9,9),(13,9),(14,9),
	(3,10),(4,10),(5,10),(14,10),
	(3,11),(7,11),(8,11),(14,11),
	(2,12),(9,12),(10,12),(14,12),
	(2,13),(4,13),(14,13),
	(1,14),(4,14),(5,14),(14,14),
	(1,15),(14,15),
	(2,16),(14,16),
	(2,17),(8,17),(12,17),(15,17),
	(1,18),(2,18),(3,18),(4,18),(5,18),(6,18),(7,18),(8,18),(9,18),(10,18),(11,18),(12,18),(13,18),(14,18),(15,18),
	(1,19),(2,19),(3,19),(4,19),(5,19),(6,19),(7,19),(8,19),(9,19),(10,19),(11,19),(12,19),(13,19),(14,19),(15,19),
	(1,20),(2,20),(3,20),(4,20),(5,20),(6,20),(7,20),(8,20),(9,20),(10,20),(11,20),(12,20),(13,20),(14,20),(15,20),
	(1,21),(2,21),(3,21),(4,21),(5,21),(6,21),(7,21),(8,21),(9,21),(10,21),(11,21),(12,21),(13,21),(14,21),(15,21),
	(1,22),(2,22),(3,22),(4,22),(5,22),(6,22),(7,22),(8,22),(9,22),(10,22),(11,22),(12,22),(13,22),(14,22),(15,22),
	(5,23),(10,23),(15,23),
	(5,24),(7,24),(8,24),(9,24),(12,24),(15,24)

SET IDENTITY_INSERT [dbo].[Volume] ON 
GO

INSERT [dbo].[Volume] ([volume_id] , [volume_number], [story_id], [volume_title], [create_time])
	VALUES 
		(1, 1, 1, N'Marriage can be a real killer.', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(2, 2, 1, N'Twin sister', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(3, 3, 1, N'Turns a domestic', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(4, 1, 17, N'Tà quân Quân Tà', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(5, 2, 17, N'Quân Mạc Tà', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(6, 3, 17, N'Quân Vô Ý', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(7, 1, 2, N'Nine little boys', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(8, 1, 3, N' A famous painter', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(9, 1, 4, N' Commuter train', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(10, 1, 5, N' Waking up', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(11, 1, 6, N' One chopped', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(12, 1, 7, N' One chopped', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(13, 1, 8, N' One chopped', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(14, 1, 9, N' One chopped', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(15, 1, 10, N' One chopped', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(16, 1, 11, N' One chopped', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(17, 1, 12, N' One chopped', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(18, 1, 13, N' One chopped', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(19, 4, 1, N'Turns a domestic 1', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(20, 5, 1, N'Turns a domestic 2', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(21, 6, 1, N'Turns a domestic 3', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(22, 7, 1, N'Turns a domestic 4', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(23, 8, 1, N'Turns a domestic 5', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(24, 9, 1, N'Turns a domestic 6', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(25, 10, 1, N'Turns a domestic 7', CAST(N'2022-01-01T05:52:10.323' AS DateTime)),
		(26, 1, 23, N'Ngủ Với Người Lạ', CAST(N'2024-01-01T05:52:10.323' AS DateTime)),
		(27, 2, 23, N'Đây Không Phải Là Giao Dịch', CAST(N'2024-01-01T05:52:10.323' AS DateTime)),
		(28, 3, 23, N'Bị Ép Chia Tay', CAST(N'2024-01-01T05:52:10.323' AS DateTime)),
		(29, 1, 24, N'Trời sinh Song Mạch', CAST(N'2024-01-02T05:52:10.323' AS DateTime)),
		(30, 2, 24, N'Phần thưởng ngươi', CAST(N'2024-01-03T05:52:10.324' AS DateTime)),
		(31, 3, 24, N'4 ngồi đều kinh hãi', CAST(N'2024-01-04T05:52:10.324' AS DateTime)),
		(32, 4, 24, N'Bạch Ngọc Thiên Thê', CAST(N'2024-01-05T05:52:10.324' AS DateTime)),
		(33, 5, 24, N'Rung động', CAST(N'2024-01-06T05:52:10.323' AS DateTime))

SET IDENTITY_INSERT [dbo].[Volume] OFF
GO


SET IDENTITY_INSERT [dbo].[Chapter] ON 
GO

INSERT [dbo].[Chapter]([chapter_id],[chapter_number],[story_id],[volume_id],[chapter_price],[chapter_title],[create_time],[update_time],[status],[chapter_content_html]) 
	VALUES
		(1, 1, 1, 1, 5, N'NICK DUNNE',CAST(N'2022-01-01T05:52:10.323' AS DateTime),null, 1, N'When I think of my wife, I always think of her head. The shape of it, to begin with. The very first time I saw her, it was the back of the head I saw, and there was something lovely about it, the angles of it. Like a shiny, hard corn kernel or a riverbed fossil. She had what the Victorians would call a finely shaped head. You could imagine the skull quite easily.
		I’d know her head anywhere.
		And what’s inside it. I think of that, too: her mind. Her brain, all those coils, and her thoughts shuttling through those coils like fast, frantic centipedes. Like a child, I picture opening her skull, unspooling her brain and sifting through it, trying to catch and pin down her thoughts. What are you thinking, Amy? The question I’ve asked most often during our marriage, if not out loud, if not to the person who could answer. I suppose these questions stormcloud over every marriage: What are you thinking? How are you feeling? Who are you? What have we done to each other? What will we do?
		My eyes flipped open at exactly six a.m. This was no avian fluttering of the lashes, no gentle blink toward consciousness. The awakening was mechanical. A spooky ventriloquist-dummy click of the lids: The world is black and then, showtime! 6-0-0 the clock said – in my face, first thing I saw. 6-0-0. It felt different. I rarely woke at such a rounded time. I was a man of jagged risings: 8:43, 11:51, 9:26. My life was alarmless.
		At that exact moment, 6-0-0, the sun climbed over the skyline of oaks, revealing its full summer angry-God self. Its reflection flared across the river toward our house, a long, blaring finger aimed at me through our frail bedroom curtains. Accusing: You have been seen. You will be seen.
		I wallowed in bed, which was our New York bed in our new house, which we still called the new house, even though we’d been back here for two years. It’s a rented house right along the Mississippi River, a house that screams Suburban Nouveau Riche, the kind of place I aspired to as a kid from my split-level, shag-carpet side of town. The kind of house that is immediately familiar: a generically grand, unchallenging, new, new, new house that my wife would – and did – detest.
		‘Should I remove my soul before I come inside?’ Her first line upon arrival. It had been a compromise: Amy demanded we rent, not buy, in my little Missouri hometown, in her firm hope that we wouldn’t be stuck here long. But the only houses for rent were clustered in this failed development: a miniature ghost town of bank-owned, recession-busted, price-reduced mansions, a neighborhood that closed before it ever opened. It was a compromise, but Amy didn’t see it that way, not in the least. To Amy, it was a punishing whim on my part, a nasty, selfish twist of the knife. I would drag her, caveman-style, to a town she had aggressively avoided, and make her live in the kind of house she used to mock. I suppose it’s not a compromise if only one of you considers it such, but that was what our compromises tended to look like. One of us was always angry. Amy, usually.
		Do not blame me for this particular grievance, Amy. The Missouri Grievance. Blame the economy, blame bad luck, blame my parents, blame your parents, blame the Internet, blame people who use the Internet. I used to be a writer. I was a writer who wrote about TV and movies and books. Back when people read things on paper, back when anyone cared about what I thought. I’d arrived in New York in the late ’90s, the last gasp of the glory days, although no one knew it then. New York was packed with writers, real writers, because there were magazines, real magazines, loads of them. This was back when the Internet was still some exotic pet kept in the corner of the publishing world – throw some kibble at it, watch it dance on its little leash, oh quite cute, it definitely won’t kill us in the night. Think about it: a time when newly graduated college kids could come to New York and get paid to write. We had no clue that we were embarking on careers that would vanish within a decade.
		I had a job for eleven years and then I didn’t, it was that fast. All around the country, magazines began shuttering, succumbing to a sudden infection brought on by the busted economy. Writers (my kind of writers: aspiring novelists, ruminative thinkers, people whose brains don’t work quick enough to blog or link or tweet, basically old, stubborn blowhards) were through. We were like women’s hat makers or buggy-whip manufacturers: Our time was done. Three weeks after I got cut loose, Amy lost her job, such as it was. (Now I can feel Amy looking over my shoulder, smirking at the time I’ve spent discussing my career, my misfortune, and dismissing her experience in one sentence. That, she would tell you, is typical. Just like Nick, she would say. It was a refrain of hers: Just like Nick to … and whatever followed, whatever was just like me, was bad.) Two jobless grown-ups, we spent weeks wandering around our Brooklyn brownstone in socks and pajamas, ignoring the future, strewing unopened mail across tables and sofas, eating ice cream at ten a.m. and taking thick afternoon naps.
		Then one day the phone rang. My twin sister was on the other end. Margo had moved back home after her own New York layoff a year before – the girl is one step ahead of me in everything, even shitty luck. Margo, calling from good ole North Carthage, Missouri, from the house where we grew up, and as I listened to her voice, I saw her at age ten, with a dark cap of hair and overall shorts, sitting on our grandparents’ back dock, her body slouched over like an old pillow, her skinny legs dangling in the water, watching the river flow over fish-white feet, so intently, utterly self-possessed even as a child.
		Go’s voice was warm and crinkly even as she gave this cold news: Our indomitable mother was dying. Our dad was nearly gone – his (nasty) mind, his (miserable) heart, both murky as he meandered toward the great gray beyond. But it looked like our mother would beat him there. About six months, maybe a year, she had. I could tell that Go had gone to meet with the doctor by herself, taken her studious notes in her slovenly handwriting, and she was teary as she tried to decipher what she’d written. Dates and doses.
		‘Well, fuck, I have no idea what this says, is it a nine? Does that even make sense?’ she said, and I interrupted. Here was a task, a purpose, held out on my sister’s palm like a plum. I almost cried with relief.
		‘I’ll come back, Go. We’ll move back home. You shouldn’t have to do this all by yourself.’
		She didn’t believe me. I could hear her breathing on the other end.
		‘I’m serious, Go. Why not? There’s nothing here.’
		A long exhale. ‘What about Amy?’
		That is what I didn’t take long enough to consider. I simply assumed I would bundle up my New York wife with her New York interests, her New York pride, and remove her from her New York parents – leave the frantic, thrilling futureland of Manhattan behind – and transplant her to a little town on the river in Missouri, and all would be fine.
		I did not yet understand how foolish, how optimistic, how, yes, just like Nick I was for thinking this. The misery it would lead to.
		‘Amy will be fine. Amy …’ Here was where I should have said, ‘Amy loves Mom.’ But I couldn’t tell Go that Amy loved our mother, because after all that time, Amy still barely knew our mother. Their few meetings had left them both baffled. Amy would dissect the conversations for days after – ‘And what did she mean by …,’ – as if my mother were some ancient peasant tribeswoman arriving from the tundra with an armful of raw yak meat and some buttons for bartering, trying to get something from Amy that wasn’t on offer.
		Amy didn’t care to know my family, didn’t want to know my birthplace, and yet for some reason, I thought moving home would be a good idea.
		My morning breath warmed the pillow, and I changed the subject in my mind. Today was not a day for second-guessing or regret, it was a day for doing. Downstairs, I could hear the return of a long-lost sound: Amy making breakfast. Banging wooden cupboards (rump-thump!), rattling containers of tin and glass (ding-ring!), shuffling and sorting a collection of metal pots and iron pans (ruzz-shuzz!). A culinary orchestra tuning up, clattering vigorously toward the finale, a cake pan drumrolling along the floor, hitting the wall with a cymballic crash. Something impressive was being created, probably a crepe, because crepes are special, and today Amy would want to cook something special.
		It was our five-year anniversary.
		I walked barefoot to the edge of the steps and stood listening, working my toes into the plush wall-to-wall carpet Amy detested on principle, as I tried to decide whether I was ready to join my wife. Amy was in the kitchen, oblivious to my hesitation. She was humming something melancholy and familiar. I strained to make it out – a folk song? a lullabye? – and then realized it was the theme to M.A.S.H. Suicide is painless. I went downstairs.
		I hovered in the doorway, watching my wife. Her yellow-butter hair was pulled up, the hank of ponytail swinging cheerful as a jumprope, and she was sucking distractedly on a burnt fingertip, humming around it. She hummed to herself because she was an unrivaled botcher of lyrics. When we were first dating, a Genesis song came on the radio: ‘She seems to have an invisible touch, yeah.’ And Amy crooned instead, ‘She takes my hat and puts it on the top shelf.’ When I asked her why she’d ever think her lyrics were remotely, possibly, vaguely right, she told me she always thought the woman in the song truly loved the man because she put his hat on the top shelf. I knew I liked her then, really liked her, this girl with an explanation for everything.
		There’s something disturbing about recalling a warm memory and feeling utterly cold.
		Amy peered at the crepe sizzling in the pan and licked something off her wrist. She looked triumphant, wifely. If I took her in my arms, she would smell like berries and powdered sugar.
		When she spied me lurking there in grubby boxers, my hair in full Heat Miser spike, she leaned against the kitchen counter and said, ‘Well, hello, handsome.’
		Bile and dread inched up my throat. I thought to myself: Okay, go.
		I was very late getting to work. My sister and I had done a foolish thing when we both moved back home. We had done what we always talked about doing. We opened a bar. We borrowed money from Amy to do this, eighty thousand dollars, which was once nothing to Amy but by then was almost everything. I swore I would pay her back, with interest. I would not be a man who borrowed from his wife – I could feel my dad twisting his lips at the very idea. Well, there are all kinds of men, his most damning phrase, the second half left unsaid, and you are the wrong kind.
		But truly, it was a practical decision, a smart business move. Amy and I both needed new careers; this would be mine. She would pick one someday, or not, but in the meantime, here was an income, made possible by the last of Amy’s trust fund. Like the McMansion I rented, the bar featured symbolically in my childhood memories – a place where only grown-ups go, and do whatever grown-ups do. Maybe that’s why I was so insistent on buying it after being stripped of my livelihood. It’s a reminder that I am, after all, an adult, a grown man, a useful human being, even though I lost the career that made me all these things. I won’t make that mistake again: The once plentiful herds of magazine writers would continue to be culled – by the Internet, by the recession, by the American public, who would rather watch TV or play video games or electronically inform friends that, like, rain sucks! But there’s no app for a bourbon buzz on a warm day in a cool, dark bar. The world will always want a drink.
		Our bar is a corner bar with a haphazard, patchwork aesthetic. Its best feature is a massive Victorian backbar, dragon heads and angel faces emerging from the oak – an extravagant work of wood in these shitty plastic days. The remainder of the bar is, in fact, shitty, a showcase of the shabbiest design offerings of every decade: an Eisenhower-era linoleum floor, the edges turned up like burnt toast; dubious wood-paneled walls straight from a ’70s home-porn video; halogen floor lamps, an accidental tribute to my 1990s dorm room. The ultimate effect is strangely homey – it looks less like a bar than someone’s benignly neglected fixer-upper. And jovial: We share a parking lot with the local bowling alley, and when our door swings wide, the clatter of strikes applauds the customer’s entrance.
		We named the bar The Bar. ‘People will think we’re ironic instead of creatively bankrupt,’ my sister reasoned.
		Yes, we thought we were being clever New Yorkers – that the name was a joke no one else would really get, not get like we did. Not meta-get. We pictured the locals scrunching their noses: Why’d you name it The Bar? But our first customer, a gray-haired woman in bifocals and a pink jogging suit, said, ‘I like the name. Like in Breakfast at Tiffany’s and Audrey Hepburn’s cat was named Cat.’
		We felt much less superior after that, which was a good thing.
		I pulled into the parking lot. I waited until a strike erupted from the bowling alley – thank you, thank you, friends – then stepped out of the car. I admired the surroundings, still not bored with the broken-in view: the squatty blond-brick post office across the street (now closed on Saturdays), the unassuming beige office building just down the way (now closed, period). The town wasn’t prosperous, not anymore, not by a long shot. Hell, it wasn’t even original, being one of two Carthage, Missouris – ours is technically North Carthage, which makes it sound like a twin city, although it’s hundreds of miles from the other and the lesser of the two: a quaint little 1950s town that bloated itself into a basic midsize suburb and dubbed it progress. Still, it was where my mom grew up and where she raised me and Go, so it had some history. Mine, at least.
		As I walked toward the bar across the concrete-and-weed parking lot, I looked straight down the road and saw the river. That’s what I’ve always loved about our town: We aren’t built on some safe bluff overlooking the Mississippi – we are on the Mississippi. I could walk down the road and step right into the sucker, an easy three-foot drop, and be on my way to Tennessee. Every building downtown bears hand-drawn lines from where the river hit during the Flood of ’61, ’75, ’84, ’93, ’07, ’08, ’11. And so on.
		The river wasn’t swollen now, but it was running urgently, in strong ropy currents. Moving apace with the river was a long single-file line of men, eyes aimed at their feet, shoulders tense, walking steadfastly nowhere. As I watched them, one suddenly looked up at me, his face in shadow, an oval blackness. I turned away.
		I felt an immediate, intense need to get inside. By the time I’d gone twenty feet, my neck bubbled with sweat. The sun was still an angry eye in the sky. You have been seen.
		My gut twisted, and I moved quicker. I needed a drink.'),
		(2, 2, 1, 1, 5, N'AMY ELLIOTT JANUARY 8, 2005',CAST(N'2022-01-02T05:52:10.323' AS DateTime),null, 1, N'– Diary entry –
		Tra and la! I am smiling a big adopted-orphan smile as I write this. I am embarrassed at how happy I am, like some Technicolor comic of a teenage girl talking on the phone with my hair in a ponytail, the bubble above my head saying: I met a boy!
		But I did. This is a technical, empirical truth. I met a boy, a great, gorgeous dude, a funny, cool-ass guy. Let me set the scene, because it deserves setting for posterity (no, please, I’m not that far gone, posterity! feh). But still. It’s not New Year’s, but still very much the new year. It’s winter: early dark, freezing cold.
		Carmen, a newish friend – semi-friend, barely friend, the kind of friend you can’t cancel on – has talked me into going out to Brooklyn, to one of her writers’ parties. Now, I like a writer party, I like writers, I am the child of writers, I am a writer. I still love scribbling that word – WRITER – any time a form, questionnaire, document asks for my occupation. Fine, I write personality quizzes, I don’t write about the Great Issues of the Day, but I think it’s fair to say I am a writer. I’m using this journal to get better: to hone my skills, to collect details and observations. To show don’t tell and all that other writery crap. (Adopted-orphan smile, I mean, that’s not bad, come on.) But really, I do think my quizzes alone qualify me on at least an honorary basis. Right?
		At a party you find yourself surrounded by genuine talented writers, employed at high-profile, respected newspapers and magazines.
		You merely write quizzes for women’s rags. When someone asks what you do for a living, you:
		a) Get embarrassed and say, ‘I’m just a quiz writer, it’s silly stuff!’
		b) Go on the offense: ‘I’m a writer now, but I’m considering something more challenging and worthwhile – why, what do you do?’
		c) Take pride in your accomplishments: ‘I write personality quizzes using the knowledge gleaned from my master’s degree in psychology – oh, and fun fact: I am the inspiration for a beloved children’s-book series, I’m sure you know it, Amazing Amy? Yeah, so suck it, snobdouche!
		Answer: C, totally C
		Anyway, the party is being thrown by one of Carmen’s good friends who writes about movies for a movie magazine, and is very funny, according to Carmen. I worry for a second that she wants to set us up: I am not interested in being set up. I need to be ambushed, caught unawares, like some sort of feral love-jackal. I’m too self-conscious otherwise. I feel myself trying to be charming, and then I realize I’m obviously trying to be charming, and then I try to be even more charming to make up for the fake charm, and then I’ve basically turned into Liza Minnelli: I’m dancing in tights and sequins, begging you to love me. There’s a bowler and jazz hands and lots of teeth.
		But no, I realize, as Carmen gushes on about her friend: She likes him. Good.
		We climb three flights of warped stairs and walk into a whoosh of body heat and writerness: many black-framed glasses and mops of hair; faux western shirts and heathery turtlenecks; black wool pea-coats flopped all across the couch, puddling to the floor; a German poster for The Getaway (Ihre Chance war gleich Null!) covering one paint-cracked wall. Franz Ferdinand on the stereo: ‘Take Me Out.’
		A clump of guys hovers near a card table where all the alcohol is set up, tipping more booze into their cups after every few sips, all too aware of how little is left to go around. I nudge in, aiming my plastic cup in the center like a busker, get a clatter of ice cubes and a splash of vodka from a sweet-faced guy wearing a Space Invaders T-shirt.
		A lethal-looking bottle of green-apple liqueur, the host’s ironic purchase, will soon be our fate unless someone makes a booze run, and that seems unlikely, as everyone clearly believes they made the run last time. It is a January party, definitely, everyone still glutted and sugar-pissed from the holidays, lazy and irritated simultaneously. A party where people drink too much and pick cleverly worded fights, blowing cigarette smoke out an open window even after the host asks them to go outside. We’ve already talked to one another at a thousand holiday parties, we have nothing left to say, we are collectively bored, but we don’t want to go back into the January cold; our bones still ache from the subway steps.
		I have lost Carmen to her host-beau – they are having an intense discussion in a corner of the kitchen, the two of them hunching their shoulders, their faces toward each other, the shape of a heart. Good. I think about eating to give myself something to do besides standing in the center of the room, smiling like the new kid in the lunchroom. But almost everything is gone. Some potato-chip shards sit in the bottom of a giant Tupperware bowl. A supermarket deli tray full of hoary carrots and gnarled celery and a semeny dip sits untouched on a coffee table, cigarettes littered throughout like bonus vegetable sticks. I am doing my thing, my impulse thing: What if I leap from the theater balcony right now? What if I tongue the homeless man across from me on the subway? What if I sit down on the floor of this party by myself and eat everything on that deli tray, including the cigarettes?
		‘Please don’t eat anything in that area,’ he says. It is him (bum bum BUMMM!), but I don’t yet know it’s him (bum-bum-bummm). I know it’s a guy who will talk to me, he wears his cockiness like an ironic T-shirt, but it fits him better. He is the kind of guy who carries himself like he gets laid a lot, a guy who likes women, a guy who would actually fuck me properly. I would like to be fucked properly! My dating life seems to rotate around three types of men: preppy Ivy Leaguers who believe they’re characters in a Fitzgerald novel; slick Wall Streeters with money signs in their eyes, their ears, their mouths; and sensitive smart-boys who are so self-aware that everything feels like a joke. The Fitzgerald fellows tend to be ineffectively porny in bed, a lot of noise and acrobatics to very little end. The finance guys turn rageful and flaccid. The smart-boys fuck like they’re composing a piece of math rock: This hand strums around here, and then this finger offers a nice bass rhythm … I sound quite slutty, don’t I? Pause while I count how many … eleven. Not bad. I’ve always thought twelve was a solid, reasonable number to end at.
		‘Seriously,’ Number 12 continues. (Ha!) ‘Back away from the tray. James has up to three other food items in his refrigerator. I could make you an olive with mustard. Just one olive, though.’
		Just one olive, though. It is a line that is only a little funny, but it already has the feel of an inside joke, one that will get funnier with nostalgic repetition. I think: A year from now, we will be walking along the Brooklyn Bridge at sunset and one of us will whisper, ‘Just one olive, though,’ and we’ll start to laugh. (Then I catch myself. Awful. If he knew I was doing a year from now already, he’d run and I’d be obliged to cheer him on.)
		Mainly, I will admit, I smile because he’s gorgeous. Distractingly gorgeous, the kind of looks that make your eyes pinwheel, that make you want to just address the elephant – ‘You know you’re gorgeous, right?’ – and move on with the conversation. I bet dudes hate him: He looks like the rich-boy villain in an ’80s teen movie – the one who bullies the sensitive misfit, the one who will end up with a pie in the puss, the whipped cream wilting his upturned collar as everyone in the cafeteria cheers.
		He doesn’t act that way, though. His name is Nick. I love it. It makes him seem nice, and regular, which he is. When he tells me his name, I say, ‘Now, that’s a real name.’ He brightens and reels off some line: ‘Nick’s the kind of guy you can drink a beer with, the kind of guy who doesn’t mind if you puke in his car. Nick!’
		He makes a series of awful puns. I catch three fourths of his movie references. Two thirds, maybe. (Note to self: Rent The Sure Thing.) He refills my drink without me having to ask, somehow ferreting out one last cup of the good stuff. He has claimed me, placed a flag in me: I was here first, she’s mine, mine. It feels nice, after my recent series of nervous, respectful post-feminist men, to be a territory. He has a great smile, a cat’s smile. He should cough out yellow Tweety Bird feathers, the way he smiles at me. He doesn’t ask what I do for a living, which is fine, which is a change. (I’m a writer, did I mention?) He talks to me in his river-wavy Missouri accent; he was born and raised outside of Hannibal, the boyhood home of Mark Twain, the inspiration for Tom Sawyer. He tells me he worked on a steamboat when he was a teenager, dinner and jazz for the tourists. And when I laugh (bratty, bratty New York girl who has never ventured to those big unwieldy middle states, those States Where Many Other People Live), he informs me that Missoura is a magical place, the most beautiful in the world, no state more glorious. His eyes are mischievous, his lashes are long. I can see what he looked like as a boy.
		We share a taxi home, the streetlights making dizzy shadows and the car speeding as if we’re being chased. It is one a.m. when we hit one of New York’s unexplained deadlocks twelve blocks from my apartment, so we slide out of the taxi into the cold, into the great What Next? and Nick starts walking me home, his hand on the small of my back, our faces stunned by the chill. As we turn the corner, the local bakery is getting its powdered sugar delivered, funneled into the cellar by the barrelful as if it were cement, and we can see nothing but the shadows of the deliverymen in the white, sweet cloud. The street is billowing, and Nick pulls me close and smiles that smile again, and he takes a single lock of my hair between two fingers and runs them all the way to the end, tugging twice, like he’s ringing a bell. His eyelashes are trimmed with powder, and before he leans in, he brushes the sugar from my lips so he can taste me.')
		,(3, 3, 1, 2, 5, N'NICK DUNNE',CAST(N'2022-01-03T05:52:10.323' AS DateTime),null, 1, N'I swung wide the door of my bar, slipped into the darkness, and took my first real deep breath of the day, took in the smell of cigarettes and beer, the spice of a dribbled bourbon, the tang of old popcorn. There was only one customer in the bar, sitting by herself at the far, far end: an older woman named Sue who had come in every Thursday with her husband until he died three months back. Now she came alone every Thursday, never much for conversation, just sitting with a beer and a crossword, preserving a ritual.
		My sister was at work behind the bar, her hair pulled back in nerdy-girl barrettes, her arms pink as she dipped the beer glasses in and out of hot suds. Go is slender and strange-faced, which is not to say unattractive. Her features just take a moment to make sense: the broad jaw; the pinched, pretty nose; the dark globe eyes. If this were a period movie, a man would tilt back his fedora, whistle at the sight of her, and say, ‘Now, there’s a helluva broad!’ The face of a ’30s screwball-movie queen doesn’t always translate in our pixie-princess times, but I know from our years together that men like my sister, a lot, which puts me in that strange brotherly realm of being both proud and wary.
		‘Do they still make pimento loaf?’ she said by way of greeting, not looking up, just knowing it was me, and I felt the relief I usually felt when I saw her: Things might not be great, but things would be okay.
		My twin, Go. I’ve said this phrase so many times, it has become a reassuring mantra instead of actual words: Mytwingo. We were born in the ’70s, back when twins were rare, a bit magical: cousins of the unicorn, siblings of the elves. We even have a dash of twin telepathy. Go is truly the one person in the entire world I am totally myself with. I don’t feel the need to explain my actions to her. I don’t clarify, I don’t doubt, I don’t worry. I don’t tell her everything, not anymore, but I tell her more than anyone else, by far. I tell her as much as I can. We spent nine months back to back, covering each other. It became a lifelong habit. It never mattered to me that she was a girl, strange for a deeply self-conscious kid. What can I say? She was always just cool.
		‘Pimento loaf, that’s like lunch meat, right? I think they do.’
		‘We should get some,’ she said. She arched an eyebrow at me. ‘I’m intrigued.’
		Without asking, she poured me a draft of PBR into a mug of questionable cleanliness. When she caught me staring at the smudged rim, she brought the glass up to her mouth and licked the smudge away, leaving a smear of saliva. She set the mug squarely in front of me. ‘Better, my prince?’
		Go firmly believes that I got the best of everything from our parents, that I was the boy they planned on, the single child they could afford, and that she sneaked into this world by clamping onto my ankle, an unwanted stranger. (For my dad, a particularly unwanted stranger.) She believes she was left to fend for herself throughout childhood, a pitiful creature of random hand-me-downs and forgotten permission slips, tightened budgets and general regret. This vision could be somewhat true; I can barely stand to admit it.
		‘Yes, my squalid little serf,’ I said, and fluttered my hands in royal dispensation.
		I huddled over my beer. I needed to sit and drink a beer or three. My nerves were still singing from the morning.
		‘What’s up with you?’ she asked. ‘You look all twitchy.’ She flicked some suds at me, more water than soap. The air-conditioning kicked on, ruffling the tops of our heads. We spent more time in The Bar than we needed to. It had become the childhood clubhouse we never had. We’d busted open the storage boxes in our mother’s basement one drunken night last year, back when she was alive but right near the end, when we were in need of comfort, and we revisited the toys and games with much oohing and ahhing between sips of canned beer. Christmas in August. After Mom died, Go moved into our old house, and we slowly relocated our toys, piecemeal, to The Bar: a Strawberry Shortcake doll, now scentless, pops up on a stool one day (my gift to Go). A tiny Hot Wheels El Camino, one wheel missing, appears on a shelf in the corner (Go’s to me).
		We were thinking of introducing a board game night, even though most of our customers were too old to be nostalgic for our Hungry Hungry Hippos, our Game of Life with its tiny plastic cars to be filled with tiny plastic pinhead spouses and tiny plastic pinhead babies. I couldn’t remember how you won. (Deep Hasbro thought for the day.)
		Go refilled my beer, refilled her beer. Her left eyelid drooped slightly. It was exactly noon, 12–00, and I wondered how long she’d been drinking. She’s had a bumpy decade. My speculative sister, she of the rocket-science brain and the rodeo spirit, dropped out of college and moved to Manhattan in the late ’90s. She was one of the original dot-com phenoms – made crazy money for two years, then took the Internet bubble bath in 2000. Go remained unflappable. She was closer to twenty than thirty; she was fine. For act two, she got her degree and joined the gray-suited world of investment banking. She was midlevel, nothing flashy, nothing blameful, but she lost her job – fast – with the 2008 financial meltdown. I didn’t even know she’d left New York until she phoned me from Mom’s house: I give up. I begged her, cajoled her to return, hearing nothing but peeved silence on the other end. After I hung up, I made an anxious pilgrimage to her apartment in the Bowery and saw Gary, her beloved ficus tree, yellow-dead on the fire escape, and knew she’d never come back.
		The Bar seemed to cheer her up. She handled the books, she poured the beers. She stole from the tip jar semi-regularly, but then she did more work than me. We never talked about our old lives. We were Dunnes, and we were done, and strangely content about it.
		‘So, what?’ Go said, her usual way of beginning a conversation.
		‘Eh.’
		‘Eh, what? Eh, bad? You look bad.’
		I shrugged a yes; she scanned my face.
		‘Amy?’ she asked. It was an easy question. I shrugged again – a confirmation this time, a whatcha gonna do? shrug.
		Go gave me her amused face, both elbows on the bar, hands cradling chin, hunkering down for an incisive dissection of my marriage. Go, an expert panel of one. ‘What about her?’
		‘Bad day. It’s just a bad day.’
		‘Don’t let her worry you.’ Go lit a cigarette. She smoked exactly one a day. ‘Women are crazy.’ Go didn’t consider herself part of the general category of women, a word she used derisively.
		I blew Go’s smoke back to its owner. ‘It’s our anniversary today. Five years.’
		‘Wow.’ My sister cocked her head back. She’d been a bridesmaid, all in violet – ‘the gorgeous, raven-haired, amethyst-draped dame,’ Amy’s mother had dubbed her – but anniversaries weren’t something she’d remember. ‘Jeez. Fuck. Dude. That came fast.’ She blew more smoke toward me, a lazy game of cancer catch. ‘She going to do one of her, uh, what do you call it, not scavenger hunt—’
		‘Treasure hunt,’ I said.
		My wife loved games, mostly mind games, but also actual games of amusement, and for our anniversary she always set up an elaborate treasure hunt, with each clue leading to the hiding place of the next clue until I reached the end, and my present. It was what her dad always did for her mom on their anniversary, and don’t think I don’t see the gender roles here, that I don’t get the hint. But I did not grow up in Amy’s household, I grew up in mine, and the last present I remember my dad giving my mom was an iron, set on the kitchen counter, no wrapping paper.
		‘Should we make a wager on how pissed she’s going to get at you this year?’ Go asked, smiling over the rim of her beer.
		The problem with Amy’s treasure hunts: I never figured out the clues. Our first anniversary, back in New York, I went two for seven. That was my best year. The opening parley:
		This place is a bit of a hole in the wall,
		But we had a great kiss there one Tuesday last fall.
		Ever been in a spelling bee as a kid? That snowy second after the announcement of the word as you sift your brain to see if you can spell it? It was like that, the blank panic.
		‘An Irish bar in a not-so-Irish place,’ Amy nudged.
		I bit the side of my lip, started a shrug, scanning our living room as if the answer might appear. She gave me another very long minute.
		‘We were lost in the rain,’ she said in a voice that was pleading on the way to peeved.
		I finished the shrug.
		‘McMann’s, Nick. Remember, when we got lost in the rain in Chinatown trying to find that dim sum place, and it was supposed to be near the statue of Confucius but it turns out there are two statues of Confucius, and we ended up at that random Irish bar all soaking wet, and we slammed a few whiskeys, and you grabbed me and kissed me, and it was—’
		‘Right! You should have done a clue with Confucius, I would have gotten that.’
		‘The statue wasn’t the point. The place was the point. The moment. I just thought it was special.’ She said these last words in a childish lilt that I once found fetching.
		‘It was special.’ I pulled her to me and kissed her. ‘That smooch right there was my special anniversary reenactment. Let’s go do it again at McMann’s.’
		At McMann’s, the bartender, a big, bearded bear-kid, saw us come in and grinned, poured us both whiskeys, and pushed over the next clue.
		When I’m down and feeling blue
		There’s only one place that will do.
		That one turned out to be the Alice in Wonderland statue at Central Park, which Amy had told me – she’d told me, she knew she’d told me many times – lightened her moods as a child. I do not remember any of those conversations. I’m being honest here, I just don’t. I have a dash of ADD, and I’ve always found my wife a bit dazzling, in the purest sense of the word: to lose clear vision, especially from looking at bright light. It was enough to be near her and hear her talk, it didn’t always matter what she was saying. It should have, but it didn’t.
		By the time we got to the end of the day, to exchanging our actual presents – the traditional paper presents for the first year of marriage – Amy was not speaking to me.
		‘I love you, Amy. You know I love you,’ I said, tailing her in and out of the family packs of dazed tourists parked in the middle of the sidewalk, oblivious and openmouthed. Amy was slipping through the Central Park crowds, maneuvering between laser-eyed joggers and scissor-legged skaters, kneeling parents and toddlers careering like drunks, always just ahead of me, tight-lipped, hurrying nowhere. Me trying to catch up, grab her arm. She stopped finally, gave me a face unmoved as I explained myself, one mental finger tamping down my exasperation: ‘Amy, I don’t get why I need to prove my love to you by remembering the exact same things you do, the exact same way you do. It doesn’t mean I don’t love our life together.’
		A nearby clown blew up a balloon animal, a man bought a rose, a child licked an ice cream cone, and a genuine tradition was born, one I’d never forget: Amy always going overboard, me never, ever worthy of the effort. Happy anniversary, asshole.
		‘I’m guessing –five years – she’s going to get really pissed,’ Go continued. ‘So I hope you got her a really good present.’
		‘On the to-do list.’
		‘What’s the, like, symbol, for five years? Paper?’
		‘Paper is first year,’ I said. At the end of Year One’s unexpectedly wrenching treasure hunt, Amy presented me with a set of posh stationery, my initials embossed at the top, the paper so creamy I expected my fingers to come away moist. In return, I’d presented my wife with a bright red dime-store paper kite, picturing the park, picnics, warm summer gusts. Neither of us liked our presents; we’d each have preferred the other’s. It was a reverse O. Henry.
		‘Silver?’ guessed Go. ‘Bronze? Scrimshaw? Help me out.’
		‘Wood,’ I said. ‘There’s no romantic present for wood.’
		At the other end of the bar, Sue neatly folded her newspaper and left it on the bartop with her empty mug and a five-dollar bill. We all exchanged silent smiles as she walked out.
		‘I got it,’ Go said. ‘Go home, fuck her brains out, then smack her with your penis and scream, “There’s some wood for you, bitch!”
		We laughed. Then we both flushed pink in our cheeks in the same spot. It was the kind of raunchy, unsisterly joke that Go enjoyed tossing at me like a grenade. It was also the reason why, in high school, there were always rumors that we secretly screwed. Twincest. We were too tight: our inside jokes, our edge-of-the-party whispers. I’m pretty sure I don’t need to say this, but you are not Go, you might misconstrue, so I will: My sister and I have never screwed or even thought of screwing. We just really like each other.
		Go was now pantomiming dick-slapping my wife.
		No, Amy and Go were never going to be friends. They were each too territorial. Go was used to being the alpha girl in my life, Amy was used to being the alpha girl in everyone’s life. For two people who lived in the same city – the same city twice: first New York, now here – they barely knew each other. They flitted in and out of my life like well-timed stage actors, one going out the door as the other came in, and on the rare occasions when they both inhabited the same room, they seemed somewhat bemused at the situation.
		Before Amy and I got serious, got engaged, got married, I would get glimpses of Go’s thoughts in a sentence here or there. It’s funny, I can’t quite get a bead on her, like who she really is. And: You just seem kind of not yourself with her. And: There’s a difference between really loving someone and loving the idea of her. And finally: The important thing is she makes you really happy.
		Back when Amy made me really happy.
		Amy offered her own notions of Go: She’s very … Missouri, isn’t she? And: You just have to be in the right mood for her. And: She’s a little needy about you, but then I guess she doesn’t have anyone else.
		I’d hoped when we all wound up back in Missouri, the two would let it drop – agree to disagree, free to be you and me. Neither did. Go was funnier than Amy, though, so it was a mismatched battle. Amy was clever, withering, sarcastic. Amy could get me riled up, could make an excellent, barbed point, but Go always made me laugh. It is dangerous to laugh at your spouse.
		‘Go, I thought we agreed you’d never mention my genitalia again,’ I said. ‘That within the bounds of our sibling relationship, I have no genitalia.’
		The phone rang. Go took one more sip of her beer and answered, gave an eyeroll and a smile. ‘He sure is here, one moment, please!’ To me, she mouthed: ‘Carl.’
		Carl Pelley lived across the street from me and Amy. Retired three years. Divorced two years. Moved into our development right after. He’d been a traveling salesman – children’s party supplies – and I sensed that after four decades of motel living, he wasn’t quite at home being home. He showed up at the bar nearly every day with a pungent Hardee’s bag, complaining about his budget until he was offered a first drink on the house. (This was another thing I learned about Carl from his days in The Bar – that he was a functioning but serious alcoholic.) He had the good grace to accept whatever we were ‘trying to get rid of,’ and he meant it: For one full month Carl drank nothing but dusty Zimas, circa 1992, that we’d discovered in the basement. When a hangover kept Carl home, he’d find a reason to call: Your mailbox looks awfully full today, Nicky, maybe a package came. Or: It’s supposed to rain, you might want to close your windows. The reasons were bogus. Carl just needed to hear the clink of glasses, the glug of a drink being poured.
		I picked up the phone, shaking a tumbler of ice near the receiver so Carl could imagine his gin.
		‘Hey, Nicky,’ Carl’s watery voice came over. ‘Sorry to bother you. I just thought you should know … your door is wide open, and that cat of yours is outside. It isn’t supposed to be, right?’
		I gave a non-commital grunt.
		‘I’d go over and check, but I’m a little under the weather,’ Carl said heavily.
		‘Don’t worry,’ I said. ‘It’s time for me to go home anyway.’
		It was a fifteen-minute drive, straight north along River Road. Driving into our development occasionally makes me shiver, the sheer number of gaping dark houses – homes that have never known inhabitants, or homes that have known owners and seen them ejected, the house standing triumphantly voided, humanless.
		When Amy and I moved in, our only neighbors descended on us: one middle-aged single mom of three, bearing a casserole; a young father of triplets with a six-pack of beer (his wife left at home with the triplets); an older Christian couple who lived a few houses down; and of course, Carl from across the street. We sat out on our back deck and watched the river, and they all talked ruefully about ARMs, and zero percent interest, and zero money down, and then they all remarked how Amy and I were the only ones with river access, the only ones without children. ‘Just the two of you? In this whole big house?’ the single mom asked, doling out a scrambled-egg something.
		‘Just the two of us,’ I confirmed with a smile, and nodded in appreciation as I took a mouthful of wobbly egg.
		‘Seems lonely.’
		On that she was right.
		Four months later, the whole big house lady lost her mortgage battle and disappeared in the night with her three kids. Her house has remained empty. The living room window still has a child’s picture of a butterfly taped to it, the bright Magic Marker sun-faded to brown. One evening not long ago, I drove past and saw a man, bearded, bedraggled, staring out from behind the picture, floating in the dark like some sad aquarium fish. He saw me see him and flickered back into the depths of the house. The next day I left a brown paper bag full of sandwiches on the front step; it sat in the sun untouched for a week, decaying wetly, until I picked it back up and threw it out.
		Quiet. The complex was always disturbingly quiet. As I neared our home, conscious of the noise of the car engine, I could see the cat was definitely on the steps. Still on the steps, twenty minutes after Carl’s call. This was strange. Amy loved the cat, the cat was declawed, the cat was never let outside, never ever, because the cat, Bleecker, was sweet but extremely stupid, and despite the LoJack tracking device pelleted somewhere in his fat furry rolls, Amy knew she’d never see the cat again if he ever got out. The cat would waddle straight into the Mississippi River – deedle-de-dum – and float all the way to the Gulf of Mexico into the maw of a hungry bull shark.
		But it turned out the cat wasn’t even smart enough to get past the steps. Bleecker was perched on the edge of the porch, a pudgy but proud sentinel – Private Tryhard. As I pulled in to the drive, Carl came out and stood on his own front steps, and I could feel the cat and the old man both watching me as I got out of the car and walked toward the house, the red peonies along the border looking fat and juicy, asking to be devoured.
		I was about to go into blocking position to get the cat when I saw that the front door was open. Carl had said as much, but seeing it was different. This wasn’t taking-out-the-trash-back-in-a-minute open. This was wide-gaping-ominous open.
		Carl hovered across the way, waiting for my response, and like some awful piece of performance art, I felt myself enacting Concerned Husband. I stood on the middle step and frowned, then took the stairs quickly, two at a time, calling out my wife’s name.
		Silence.
		‘Amy, you home?’
		I ran straight upstairs. No Amy. The ironing board was set up, the iron still on, a dress waiting to be pressed.
		‘Amy!’
		As I ran back downstairs, I could see Carl still framed in the open doorway, hands on hips, watching. I swerved into the living room, and pulled up short. The carpet glinted with shards of glass, the coffee table shattered. End tables were on their sides, books slid across the floor like a card trick. Even the heavy antique ottoman was belly-up, its four tiny feet in the air like something dead. In the middle of the mess was a pair of good sharp scissors.
		‘Amy!’
		I began running, bellowing her name. Through the kitchen, where a kettle was burning, down to the basement, where the guest room stood empty, and then out the back door. I pounded across our yard onto the slender boat deck leading out over the river. I peeked over the side to see if she was in our rowboat, where I had found her one day, tethered to the dock, rocking in the water, her face to the sun, eyes closed, and as I’d peered down into the dazzling reflections of the river, at her beautiful, still face, she’d suddenly opened her blue eyes and said nothing to me, and I’d said nothing back and gone into the house alone.
		‘Amy!’
		She wasn’t on the water, she wasn’t in the house. Amy was not there.
		Amy was gone.'),
		(4, 4, 1, 2, 5, N'Amy Elliott September 18, 2005',CAST(N'2022-01-05T05:52:10.323' AS DateTime),null, 1, N'– Diary entry –
		Well, well, well. Guess who’s back? Nick Dunne, Brooklyn party boy, sugar-cloud kisser, disappearing act. Eight months, two weeks, couple of days, no word, and then he resurfaces, like it was all part of the plan. Turns out, he’d lost my phone number. His cell was out of juice, so he’d written it on a stickie. Then he’d tucked the stickie into his jeans pocket and put the jeans in the washer, and it turned the stickie into a piece of cyclone-shaped pulp. He tried to unravel it but could only see a 3 and an 8. (He said.)
		And then work clobbered him and suddenly it was March and too embarrassingly late to try to find me. (He said.)
		Of course I was angry. I had been angry. But now I’m not. Let me set the scene. (She said.) Today. Gusty September winds. I’m walking along Seventh Avenue, making a lunchtime contemplation of the sidewalk bodega bins – endless plastic containers of cantaloupe and honeydew and melon perched on ice like the day’s catch – and I could feel a man barnacling himself to my side as I sailed along, and I corner-eyed the intruder and realized who it was. It was him. The boy in ‘I met a boy!’
		I didn’t break my stride, just turned to him and said:
		a) ‘Do I know you?’ (manipulative, challenging)
		b) ‘Oh, wow, I’m so happy to see you!’ (eager, doormatlike)
		c) ‘Go fuck yourself.’ (aggressive, bitter)
		d) ‘Well, you certainly take your time about it, don’t you, Nick?’ (light, playful, laid-back)
		Answer: D
		And now we’re together. Together, together. It was that easy.
		It’s interesting, the timing. Propitious, if you will. (And I will.) Just last night was my parents’ book party. Amazing Amy and the Big Day. Yup, Rand and Marybeth couldn’t resist. They’ve given their daughter’s namesake what they can’t give their daughter: a husband! Yes, for book twenty, Amazing Amy is getting married! Wheeeeeee. No one cares. No one wanted Amazing Amy to grow up, least of all me. Leave her in kneesocks and hair ribbons and let me grow up, unencumbered by my literary alter ego, my paperbound better half, the me I was supposed to be.
		But Amy is the Elliott bread and butter, and she’s served us well, so I suppose I can’t begrudge her a perfect match. She’s marrying good old Able Andy, of course. They’ll be just like my parents: happy-happy.
		Still, it was unsettling, the incredibly small order the publisher put in. A new Amazing Amy used to get a first print of a hundred thousand copies back in the ’80s. Now ten thousand. The book-launch party was, accordingly, unfabulous. Off-tone. How do you throw a party for a fictional character who started life as a precocious moppet of six and is now a thirty-year-old bride-to-be who still speaks like a child? (‘Sheesh,’ thought Amy, ‘my dear fiance´ sure is a grouch-monster when he doesn’t get his way …’ That is an actual quote. The whole book made me want to punch Amy right in her stupid, spotless vagina.) The book is a nostalgia item, intended to be purchased by women who grew up with Amazing Amy, but I’m not sure who will actually want to read it. I read it, of course. I gave the book my blessing – multiple times. Rand and Marybeth feared that I might take Amy’s marriage as some jab at my perpetually single state. (‘I, for one, don’t think women should marry before thirty-five,’ said my mom, who married my dad at twenty-three.)
		My parents have always worried that I’d take Amy too personally – they always tell me not to read too much into her. And yet I can’t fail to notice that whenever I screw something up, Amy does it right: When I finally quit violin at age twelve, Amy was revealed as a prodigy in the next book. (‘Sheesh, violin can be hard work, but hard work is the only way to get better!’) When I blew off the junior tennis championship at age sixteen to do a beach weekend with friends, Amy recommitted to the game. (‘Sheesh, I know it’s fun to spend time with friends, but I’d be letting myself and everyone else down if I didn’t show up for the tournament.’) This used to drive me mad, but after I went off to Harvard (and Amy correctly chose my parents’ alma mater), I decided it was all too ridiculous to think about. That my parents, two child psychologists, chose this particular public form of passive-aggressiveness toward their child was not just fucked up but also stupid and weird and kind of hilarious. So be it.
		The book party was as schizophrenic as the book – at Bluenight, off Union Square, one of those shadowy salons with wingback chairs and art deco mirrors that are supposed to make you feel like a Bright Young Thing. Gin martinis wobbling on trays lofted by waiters with rictus smiles. Greedy journalists with knowing smirks and hollow legs, getting the free buzz before they go somewhere better.
		My parents circulate the room hand in hand – their love story is always part of the Amazing Amy story: husband and wife in mutual creative labor for a quarter century. Soul mates. They really call themselves that, which makes sense, because I guess they are. I can vouch for it, having studied them, little lonely only child, for many years. They have no harsh edges with each other, no spiny conflicts, they ride through life like conjoined jellyfish – expanding and contracting instinctively, filling each other’s spaces liquidly. Making it look easy, the soul-mate thing. People say children from broken homes have it hard, but the children of charmed marriages have their own particular challenges.
		Naturally, I have to sit on some velvety banquette in the corner of the room, out of the noise, so I can give a few interviews to a sad handful of kid interns who’ve gotten stuck with the ‘grab a quote’ assignment from their editors.
		How does it feel to see Amy finally married to Andy? Because you’re not married, right?
		Question asked by:
		a) a sheepish, bug-eyed kid balancing a notebook on top of his messenger bag
		b) an overdressed, sleek-haired young thing with fuck-me stilettos
		c) an eager, tattooed rockabilly girl who seemed way more interested in Amy than one would guess a tattooed rockabilly girl would be
		d) all of the above
		Answer: D
		Me: ‘Oh, I’m thrilled for Amy and Andy, I wish them the best. Ha, ha.’
		My answers to all the other questions, in no particular order:
		‘Some parts of Amy are inspired by me, and some are just fiction.’
		‘I’m happily single right now, no Able Andy in my life!’
		‘No, I don’t think Amy oversimplifies the male-female dynamic.’
		‘No, I wouldn’t say Amy is dated; I think the series is a classic.’
		‘Yes, I am single. No Able Andy in my life right now.’
		‘Why is Amy amazing and Andy’s just able? Well, don’t you know a lot of powerful, fabulous women who settle for regular guys, Average Joes and Able Andys? No, just kidding, don’t write that.’
		‘Yes, I am single.’
		‘Yes, my parents are definitely soul mates.’
		‘Yes, I would like that for myself one day.’
		‘Yep, single, motherfucker.’
		Same questions over and over, and me trying to pretend they’re thought-provoking. And them trying to pretend they’re thought-provoking. Thank God for the open bar.
		Then no one else wants to talk to me – that fast – and the PR girl pretends it’s a good thing: Now you can get back to your party! I wriggle back into the (small) crowd, where my parents are in full hosting mode, their faces flushed – Rand with his toothy prehistoric-monster-fish smile, Marybeth with her chickeny, cheerful head bobs, their hands intertwined, making each other laugh, enjoying each other, thrilled with each other – and I think, I am so fucking lonely.
		I go home and cry for a while. I am almost thirty-two. That’s not old, especially not in New York, but fact is, it’s been years since I even really liked someone. So how likely is it I’ll meet someone I love, much less someone I love enough to marry? I’m tired of not knowing who I’ll be with, or if I’ll be with anyone.
		I have many friends who are married – not many who are happily married, but many married friends. The few happy ones are like my parents: They’re baffled by my singleness. A smart, pretty, nice girl like me, a girl with so many interests and enthusiasms, a cool job, a loving family. And let’s say it: money. They knit their eyebrows and pretend to think of men they can set me up with, but we all know there’s no one left, no one good left, and I know that they secretly think there’s something wrong with me, something hidden away that makes me unsatisfiable, unsatisfying.
		The ones who are not soul-mated – the ones who have settled – are even more dismissive of my singleness: It’s not that hard to find someone to marry, they say. No relationship is perfect, they say – they, who make do with dutiful sex and gassy bedtime rituals, who settle for TV as conversation, who believe that husbandly capitulation – yes, honey, okay, honey – is the same as concord. He’s doing what you tell him to do because he doesn’t care enough to argue, I think. Your petty demands simply make him feel superior, or resentful, and someday he will fuck his pretty, young coworker who asks nothing of him, and you will actually be shocked. Give me a man with a little fight in him, a man who calls me on my bullshit. (But who also kind of likes my bullshit.) And yet: Don’t land me in one of those relationships where we’re always pecking at each other, disguising insults as jokes, rolling our eyes and ‘playfully’ scrapping in front of our friends, hoping to lure them to our side of an argument they could not care less about. Those awful if only relationships: This marriage would be great if only … and you sense the if only list is a lot longer than either of them realizes.
		So I know I am right not to settle, but it doesn’t make me feel better as my friends pair off and I stay home on Friday night with a bottle of wine and make myself an extravagant meal and tell myself, This is perfect, as if I’m the one dating me. As I go to endless rounds of parties and bar nights, perfumed and sprayed and hopeful, rotating myself around the room like some dubious dessert. I go on dates with men who are nice and good-looking and smart – perfect-on-paper men who make me feel like I’m in a foreign land, trying to explain myself, trying to make myself known. Because isn’t that the point of every relationship: to be known by someone else, to be understood? He gets me. She gets me. Isn’t that the simple magic phrase?
		So you suffer through the night with the perfect-on-paper man – the stutter of jokes misunderstood, the witty remarks lobbed and missed. Or maybe he understands that you’ve made a witty remark but, unsure of what to do with it, he holds it in his hand like some bit of conversational phlegm he will wipe away later. You spend another hour trying to find each other, to recognise each other, and you drink a little too much and try a little too hard. And you go home to a cold bed and think, That was fine. And your life is a long line of fine.
		And then you run into Nick Dunne on Seventh Avenue as you’re buying diced cantaloupe, and pow, you are known, you are recognised, the both of you. You both find the exact same things worth remembering. (Just one olive, though). You have the same rhythm. Click. You just know each other. All of a sudden you see reading in bed and waffles on Sunday and laughing at nothing and his mouth on yours. And it’s so far beyond fine that you know you can never go back to fine. That fast. You think: Oh, here is the rest of my life. It’s finally arrived.')
		,(5, 5, 1, 3, 5, N'Nick Dunne',CAST(N'2022-01-06T05:52:10.323' AS DateTime),null, 1, N'I waited for the police first in the kitchen, but the acrid smell of the burnt teakettle was curling up in the back of my throat, underscoring my need to retch, so I drifted out on the front porch, sat on the top stair, and willed myself to be calm. I kept trying Amy’s cell, and it kept going to voice mail, that quick-clip cadence swearing she’d phone right back. Amy always phoned right back. It had been three hours, and I’d left five messages, and Amy had not phoned back.
		I didn’t expect her to. I’d tell the police: Amy would never have left the house with the teakettle on. Or the door open. Or anything waiting to be ironed. The woman got shit done, and she was not one to abandon a project (say, her fixer-upper husband, for instance), even if she decided she didn’t like it. She’d made a grim figure on the Fiji beach during our two-week honeymoon, battling her way through a million mystical pages of The Wind-Up Bird Chronicle, casting pissy glances at me as I devoured thriller after thriller. Since our move back to Missouri, the loss of her job, her life had revolved (devolved?) around the completion of endless tiny, inconsequential projects. The dress would have been ironed.
		And there was the living room, signs pointing to a struggle. I already knew Amy wasn’t phoning back. I wanted the next part to start.
		It was the best time of day, the July sky cloudless, the slowly setting sun a spotlight on the east, turning everything golden and lush, a Flemish painting. The police rolled up. It felt casual, me sitting on the steps, an evening bird singing in the tree, these two cops getting out of their car at a leisurely pace, as if they were dropping by a neighborhood picnic. Kid cops, mid-twenties, confident and uninspired, accustomed to soothing worried parents of curfew-busting teens. A Hispanic girl, her hair in a long dark braid, and a black guy with a marine’s stance. Carthage had become a bit (a very tiny bit) less Caucasian while I was away, but it was still so severely segregated that the only people of color I saw in my daily routine tended to be occupational roamers: delivery men, medics, postal workers. Cops. (‘This place is so white, it’s disturbing,’ said Amy, who, back in the melting pot of Manhattan, counted a single African-American among her friends. I accused her of craving ethnic window dressing, minorities as backdrops. It did not go well.)
		‘Mr Dunne? I’m Officer Velásquez,’ said the woman, ‘and this is Officer Riordan. We understand you’re concerned about your wife?’
		Riordan looked down the road, sucking on a piece of candy. I could see his eyes follow a darting bird out over the river. Then he snapped his gaze back toward me, his curled lips telling me he saw what everyone else did. I have a face you want to punch: I’m a working-class Irish kid trapped in the body of a total trust-fund douchebag. I smile a lot to make up for my face, but this only sometimes works. In college, I even wore glasses for a bit, fake spectacles with clear lenses that I thought would lend me an affable, unthreatening vibe. ‘You do realize that makes you even more of a dick?’ Go reasoned. I threw them out and smiled harder.
		I waved in the cops: ‘Come inside the house and see.’
		The two climbed the steps, accompanied by the squeaking and shuffling noises of their belts and guns. I stood in the entry to the living room and pointed at the destruction.
		‘Oh,’ said Officer Riordan, and gave a brisk crack of his knuckles. He suddenly looked less bored.
		Riordan and Velásquez leaned forward in their seats at the dining room table as they asked me all the initial questions: who, where, how long. Their ears were literally pricked. A call had been made out of my hearing, and Riordan informed me that detectives were being dispatched. I had the grave pride of being taken seriously.
		Riordan was asking me for the second time if I’d seen any strangers in the neighborhood lately, was reminding me for the third time about Carthage’s roving bands of homeless men, when the phone rang. I launched myself across the room and grabbed it.
		A surly woman’s voice: ‘Mr Dunne, this is Comfort Hill Assisted Living.’ It was where Go and I boarded our Alzheimer’s-riddled father.
		‘I can’t talk right now, I’ll call you back,’ I snapped, and hung up. I despised the women who staffed Comfort Hill: unsmiling, uncomforting. Underpaid, gruelingly underpaid, which was probably why they never smiled or comforted. I knew my anger toward them was misdirected – it absolutely infuriated me that my father lingered on while my mom was in the ground.
		It was Go’s turn to send the check. I was pretty sure it was Go’s turn for July. And I’m sure she was positive it was mine. We’d done this before. Go said we must be mutually subliminally forgetting to mail those checks, that what we really wanted to forget was our dad.
		I was telling Riordan about the strange man I’d seen in our neighbor’s vacated house when the doorbell rang. The doorbell rang. It sounded so normal, like I was expecting a pizza.
		The two detectives entered with end-of-shift weariness. The man was rangy and thin, with a face that tapered severely into a dribble of a chin. The woman was surprisingly ugly – brazenly, beyond the scope of everyday ugly: tiny round eyes set tight as buttons, a long twist of a nose, skin spackled with tiny bumps, long lank hair the color of a dust bunny. I have an affinity for ugly women. I was raised by a trio of women who were hard on the eyes – my grandmother, my mom, her sister – and they were all smart and kind and funny and sturdy, good, good women. Amy was the first pretty girl I ever dated, really dated.
		The ugly woman spoke first, an echo of Miss Officer Velásquez. ‘Mr Dunne? I’m Detective Rhonda Boney. This is my partner, Detective Jim Gilpin. We understand there are some concerns about your wife.’
		My stomach growled loud enough for us all to hear it, but we pretended we didn’t.
		‘We take a look around, sir?’ Gilpin said. He had fleshy bags under his eyes and scraggly white whiskers in his mustache. His shirt wasn’t wrinkled, but he wore it like it was; he looked like he should stink of cigarettes and sour coffee, even though he didn’t. He smelled like Dial soap.
		I led them a few short steps to the living room, pointed once again at the wreckage, where the two younger cops were kneeling carefully, as if waiting to be discovered doing something useful. Boney steered me toward a chair in the dining room, away from but in view of the signs of struggle.
		Rhonda Boney walked me through the same basics I’d told Velásquez and Riordan, her attentive sparrow eyes on me. Gilpin squatted down on a knee, assessing the living room.
		‘Have you phoned friends or family, people your wife might be with?’ Rhonda Boney asked.
		‘I … No. Not yet. I guess I was waiting for you all.’
		‘Ah.’ She smiled. ‘Let me guess: baby of the family.’
		‘What?’
		‘You’re the baby.’
		‘I have a twin sister.’ I sensed some internal judgment being made. ‘Why?’ Amy’s favorite vase was lying on the floor, intact, bumped up against the wall. It was a wedding present, a Japanese masterwork that Amy put away each week when our housecleaner came because she was sure it would get smashed.
		‘Just a guess of mine, why you’d wait for us: You’re used to someone else always taking the lead,’ Boney said. ‘That’s what my little brother is like. It’s a birth-order thing.’ She scribbled something on a notepad.
		‘Okay.’ I gave an angry shrug. ‘Do you need my sun sign too, or can we get started?’
		Boney smiled at me kindly, waiting.
		‘I waited to do something because, I mean, she’s obviously not with a friend,’ I said, pointing at the disarray in the living room.
		‘You’ve lived here, what, Mr Dunne, two years?’ she asked.
		‘Two years September.’
		‘Moved from where?’
		‘New York.’
		‘City?’
		‘Yes.’
		She pointed upstairs, asking permission without asking, and I nodded and followed her, Gilpin following me.
		‘I was a writer there,’ I blurted out before I could stop myself. Even now, two years back here, and I couldn’t bear for someone to think this was my only life.
		Boney: ‘Sounds impressive.’
		Gilpin: ‘Of what?’
		I timed my answer to my stair climbing: I wrote for a magazine (step), I wrote about pop culture (step) for a men’s magazine (step). At the top of the stairs, I turned to see Gilpin looking back at the living room. He snapped to.
		‘Pop culture?’ he called up as he began climbing. ‘What exactly does that entail?’
		‘Popular culture,’ I said. We reached the top of the stairs, Boney waiting for us. ‘Movies, TV, music, but, uh, you know, not high arts, nothing hifalutin.’ I winced: hifalutin? How patronizing. You two bumpkins probably need me to translate my English, Comma, Educated East Coast into English, Comma, Midwest Folksy. Me do sum scribbling of stuffs I get in my noggin after watchin’ them movin’ pitchers!
		‘She loves movies,’ Gilpin said, gesturing toward Boney. Boney nodded: I do.
		‘Now I own The Bar, downtown,’ I added. I taught a class at the junior college too, but to add that suddenly felt too needy. I wasn’t on a date.
		Boney was peering into the bathroom, halting me and Gilpin in the hallway. ‘The Bar?’ she said. ‘I know the place. Been meaning to drop by. Love the name. Very meta.’
		‘Sounds like a smart move,’ Gilpin said. Boney made for the bedroom, and we followed. ‘A life surrounded by beer ain’t too bad.’
		‘Sometimes the answer is at the bottom of a bottle,’ I said, then winced again at the inappropriateness.
		We entered the bedroom.
		Gilpin laughed. ‘Don’t I know that feeling.’
		‘See how the iron is still on?’ I began.
		Boney nodded, opened the door of our roomy closet, and walked inside, flipping on the light, fluttering her latexed hands over shirts and dresses as she moved toward the back. She made a sudden noise, bent down, turned around – holding a perfectly square box covered in elaborate silver wrapping.
		My stomach seized.
		‘Someone’s birthday?’ she asked.
		‘It’s our anniversary.’
		Boney and Gilpin both twitched like spiders and pretended they didn’t.
		By the time we returned to the living room, the kid officers were gone. Gilpin got down on his knees, eyeing the overturned ottoman.
		‘Uh, I’m a little freaked out, obviously,’ I started.
		‘I don’t blame you at all, Nick,’ Gilpin said earnestly. He had pale blue eyes that jittered in place, an unnerving tic.
		‘Can we do something? To find my wife. I mean, because she’s clearly not here.’
		Boney pointed at the wedding portrait on the wall: me in my tux, a block of teeth frozen on my face, my arms curved formally around Amy’s waist; Amy, her blond hair tightly coiled and sprayed, her veil blowing in the beach breeze of Cape Cod, her eyes open too wide because she always blinked at the last minute and she was trying so hard not to blink. The day after Independence Day, the sulfur from the fireworks mingling with the ocean salt – summer.
		The Cape had been good to us. I remember discovering several months in that Amy, my girlfriend, was also quite wealthy, a treasured only child of creative-genius parents. An icon of sorts, thanks to a namesake book series that I thought I could remember as a kid. Amazing Amy. Amy explained this to me in calm, measured tones, as if I were a patient waking from a coma. As if she’d had to do it too many times before and it had gone badly – the admission of wealth that’s greeted with too much enthusiasm, the disclosure of a secret identity that she herself didn’t create.
		Amy told me who and what she was, and then we went out to the Elliotts’ historically registered home on Nantucket Sound, went sailing together, and I thought: I am a boy from Missouri, flying across the ocean with people who’ve seen much more than I have. If I began seeing things now, living big, I could still not catch up with them. It didn’t make me feel jealous. It made me feel content. I never aspired to wealth or fame. I was not raised by big-dreamer parents who pictured their child as a future president. I was raised by pragmatic parents who pictured their child as a future office worker of some sort, making a living of some sort. To me, it was heady enough to be in the Elliotts’ proximity, to skim across the Atlantic and return to a plushly restored home built in 1822 by a whaling captain, and there to prepare and eat meals of organic, healthful foods whose names I didn’t know how to pronounce. Quinoa. I remember thinking quinoa was a kind of fish.
		So we married on the beach on a deep blue summer day, ate and drank under a white tent that billowed like a sail, and a few hours in, I sneaked Amy off into the dark, toward the waves, because I was feeling so unreal, I believed I had become merely a shimmer. The chilly mist on my skin pulled me back, Amy pulled me back, toward the golden glow of the tent, where the Gods were feasting, everything ambrosia. Our whole courtship was just like that.
		Boney leaned in to examine Amy. ‘Your wife is very pretty.’
		‘She is, she’s beautiful,’ I said, and felt my stomach lilt.
		‘What anniversary today?’ she asked.
		‘Five.’
		I was jittering from one foot to another, wanting to do something. I didn’t want them to discuss how lovely my wife was, I wanted them to go out and search for my fucking wife. I didn’t say this out loud, though; I often don’t say things out loud, even when I should. I contain and I compartmentalize to a disturbing degree: In my belly-basement are hundreds of bottles of rage, despair, fear, but you’d never guess from looking at me.
		‘Five, big one. Let me guess, reservations at Houston’s?’ Gilpin asked. It was the only upscale restaurant in town. You all really need to try Houston’s, my mom had said when we moved back, thinking it was Carthage’s unique little secret, hoping it might please my wife.
		‘Of course, Houston’s.’
		It was my fifth lie to the police. I was just starting.')
		,(6, 1, 17, 4, 0, N'Tà quân Quân Tà',CAST(N'2023-10-06T05:52:10.323' AS DateTime),null, 1, 
			N'Hắn thậm chí còn chưa kịp mở mắt nhưng tay phải theo bản năng vỗ một cái xuống
			đất nhảy lên. Đây là một nơi phức tạp, sự sống và cái chết luôn cận kề nhau,
			vì vậy không thể ở lâu!
			Đây là suy nghĩ đầu tiên của hắn khi tỉnh lại, là cảm giác gần như đã trở
			thành bản năng của một sát thủ vĩ đại!
			Cơ thể thuận thế định bật lên nhưng bỗng nhiên cánh tay của hắn lại trở nên
			mềm nhũn, hoàn toàn không còn khả năng chống đỡ nổi sức nặng của thân thể nên
			"bịch" một tiếng, hắn lại nặng nề ngã trở lại.
			Sau một thời gian định thần, Quân Tà vô cùng kinh hãi. Chuyện này rốt cuộc là
			chuyện gì? Ngay sau đó hắn đột nhiên phát hiện phía dưới mình là một chiếc
			giường mềm mại.! Đưa mắt nhìn xung quanh, thì ra mình đang nằm trong một gian
			phòng được trang trí lộng lẫy. Chỉ có điều gian phòng này chẳng có một cái gì
			ngoại trừ một chiếc bàn bốn cạnh cùng một cái giường lớn mà mình đang nằm trên
			đó. Thực ra chiếc giường lớn này ít nhất phải ngủ được tới bảy tám người, thậm
			chí bảy tám người nằm trên đó còn không có cảm giác chật chội.
			“ Chuyện này là sao? Ta không phải vẫn còn đang chiến đấu với người ta sao?
			Tại sao giờ lại ở trên giường thế này?”
			Giờ phút này, suy nghĩ của Quân Tà vẫn còn đang lưu lại trước khi ngủ say,
			hoặc phải nói là...tạm thời còn đang suy nghĩ về thời khắc cuối cùng ở kiếp
			trước.
			.................................................. .....
			Quân Tà là một sát thủ, hơn nữa là một kim bài sát thủ vô cùng vĩ đại. Từ khi
			hắn xuất đạo tới nay đã được năm năm nhưng mỗi lần ra tay mọi việc đều rất
			thuận lợi và có xác xuất thành công đạt tới trăm phần trăm. Một thành tích mà
			người xưa chưa từng có. Bởi vậy mà hắn đã trở thành sát thủ đứng đầu trong Sát
			Thủ bảng. Mà cái tên "Tà Quân" này cũng vì thế mà đứng vị trí hàng đầu trong
			giới hắc đạo. Mà hắn còn có một vinh quang khác nữa, chính là được đứng thứ
			nhất trong suốt ba năm ròng của Huyền Thưởng bảng, một bảng danh sách liệt kê
			những nhân vật bị đuổi giết được treo giải thưởng trên toàn thế giới.
			Nhưng ở đó cũng không phải là không có người dám tiếp nhận mà là không có
			người có khả năng tiếp nhận vụ đó. Bởi vì không ai có bản lĩnh để giết chết vị
			sát thủ gần như đã trở thành truyền thuyết này.
			Đã từng có rất nhiều sát thủ hạng nhất tiếp nhận nhiệm vụ kia, nhưng mà bọn họ
			đều đã chết, còn Tà quân lại vẫn còn sống phây phây.
			Ở nước Y có một ông trùm đã treo giải một trăm triệu đô la Mỹ để mua lấy tính
			mạng của Tà quân. Mà hai sát thủ tiếp nhận vụ mua bán này thì cả hai đều là
			những sát thủ hàng đầu cùng nổi danh với Tà quân trên thế giới. Nhưng sau ba
			ngày, cả hai người này đều chuyển nghề đi bán muối và uống trà với các cụ cao
			tằng cố tổ. Và cũng vì đó mà sau đó không còn người nào đồng ý nhận cái nhiệm
			vụ tử vong này, bọn họ mỗi người đều kính nhi viễn chi, cho dù giải thưởng có
			tiếp tục tăng hết lần này tới lần khác nhưng từ đầu đến cuối không người nào
			dám nhận.
			Tiền tuy có nhiều nhưng không còn mạng để hưởng thì còn ý nghĩa gì nữa chứ!
			Cái tên Tà quân trở thành cấm kỵ trên Huyền Thưởng bảng của hắc đạo.
			Mà cái tên Tà quân cũng uy hiếp đến hắc đạo của các quốc gia. Có rất nhiều
			người biết tới kỳ nhân Tà quân nhưng không có một ai hiểu rõ vị Vua sát thủ Tà
			quân này rốt cuộc là có dáng vẻ như thế nào cả, và chung quy hắn là loại người
			ra sao đây?
			Tính cách của Quân Tà, đúng là người cũng như tên. Một chữ: Tà! Hai chữ: Rất
			Tà! Ba chữ: Vô cùng Tà!
			Hắn cho tới bây giờ đều chuyên quyền độc đoán, không hề liên thủ với bất cứ kẻ
			nào, lại càng không có một nửa người bạn. Hơn nữa, hắn nhận một vụ làm ăn thì
			không chỉ muốn xem xét người mua mà còn muốn chọn cả mục tiêu nữa.
			Hắn nếu nhìn người thuê mà không vừa mắt, cho dù tiền có nhiều hơn đi nữa thì
			có mới hắn đi giết một tên ăn mày không có năng lực phản kháng, hắn cũng sẽ
			không chút do dự cự tuyệt. Nhưng hắn nếu thấy một người nào đó đáng chết thì
			hắn lại tự động xuống tay rồi sau đó tìm nhà đối thủ của kẻ đó đòi thù lao. Mà
			thường thường những nhà đó cũng chưa từng thuê hắn ta, thậm chí ngay cả nghe
			tới tên của hắn còn chưa từng nghe qua.
			Tương truyền.... có một lần, hắn giết một tên buôn người tội ác tày trời nhưng
			lại không tìm thấy khổ chủ. Không còn cách nào khác hắn đành đòi một tiểu cô
			nương bị lừa bán được một vài cắc tiền xu, còn nói một cách hùng hồn rằng, tôi
			cho tới giờ chưa từng làm một vụ mua bán nào mà không có thù lao cả, tuyệt đối
			không có cái gì ngoại lệ................
			Tính cách này của hắn cũng khiến những người hiểu hắn như sư phụ cùng các sư
			huynh đệ cũng không biết phải nói gì hơn....
			Tương truyền............ có một lần, khi sư phụ của hắn ta đi giải quyết nỗi
			buồn bị hắn chôm giấy trong WC đi. Không có giấy, sự phụ hắn liền gọi hắn mang
			tới chút giấy vệ sinh. Kết quả hắn nhân cơ hội đòi năm trăm nghìn đô phí dịch
			vụ, khiến sư phụ hắn biết thế nào là gian xảo
			Còn tại sao sư phụ hắn lại phải chịu quả đắng.....
			Đó là bởi vì ngày đó hắn gọi tất cả sư huynh muội tới cửa WC, còn mới cả mấy
			vị mỹ nữ tới tham quan nữa...............')
			,(7, 2, 17, 4, 0, N'Tà quân Quân Tà',CAST(N'2023-10-06T05:52:10.323' AS DateTime),null, 1, 
			N'Nhưng mà hắn cho rằng thiếu sót lớn nhất của bản thân chính là hắn thật sự rất
			có lòng thương yêu. Làm một sát thủ, hơn nữa là một sát thủ hàng đầu hai tay
			dính đầy máu tươi nên những lời này từng khiến vô số người khịt mũi khinh bỉ.
			Chẳng qua gia hỏa này tự xưng có lòng thương yêu kỳ thật cũng có chút căn cứ.
			Trong nước, hắn rất không thích nhìn cảnh người giàu chèn ép người nghèo, và
			nhất là trông thấy cảnh quan lại hà hiếp dân chúng. Ở nước ngoài, hắn không
			nhìn nổi cảnh có người ức hiếp người nước mình. Vì tính cách của hắn là một
			người "Yêu nước", và cũng vì thế mà hắn không biết đã gặp phải bao nhiêu tai
			họa ngập trời.
			Nhưng một người như vậy vẫn có vô số người đổ xô đi thuê hắn. Đó là bởi vì kỹ
			thuật bắn súng của hắn chẳng những siêu quần, bách phát bách trúng mà còn có
			một thân võ nghệ quỷ thần khó lường. Bất luận tu vi quyền chưởng hay đao kiếm
			đều không tầm thường. Đó mới là nguyên nhân lớn nhất giúp tỉ lệ thành công
			trong các nhiệm vụ của hắn trước sau vẫn là trăm phần trăm. Thành tích này mặc
			dù chưa chắc sau này sẽ không có, nhưng tuyệt đối là chưa từng có từ trước tới
			giờ.
			Hắn hoàn toàn xứng đáng là chung cực sát thủ trong giới sát thủ!
			Cũng là một cường giả đỉnh phong trong giới sát thủ, là người duy nhất chưa
			bao giờ bị thất thủ trên toàn thế giới từ trước tới giờ!
			Nhưng vị sát thủ kim bài này từ trong cốt tủy lại là một thanh niên có khuynh
			hướng dân tộc chủ nghĩa cực đoan.
			Hắn nghe nói gián điệp nước M khai quật được một bí bảo vô giá tại núi Côn Lôn
			Trung Quốc. Tin tức này lộ ra khiến một người có khuynh hướng dân tộc chủ
			nghĩa cực đoan như Quân Tà nổi giận.
			Bảo vật của Trung Quốc rộng lớn sao có thể rơi vào tay người nước M được cơ
			chứ?!
			Quân Tà đơn thương độc mã giết tới. Hắn một mình cuồng ngạo tới cùng cực chọi
			với cả gần một trăm đặc công của nước M, thi triển hết mọi thủ đoạn từ ám sát,
			cuối cùng là tới đánh chính diện. Sau khi giết chết hơn bảy mươi tên, hắn cuối
			cùng cũng cướp được bí bảo kia vào tay. Mà lúc đó đám đặc công của nước M đều
			bị giết tới vỡ gan vỡ mật nên nếu hắn muốn bỏ chạy thì nhất định có thể ung
			dung mà rời khỏi đi. Mà trong lòng Quân Tà cũng tuyệt đối nắm chắc được điều
			này.
			Nhưng sau khi tay hắn tiếp xúc với kiện bí bảo kia- một pho Lung Linh bảo tháp
			lớn bằng một bàn tay thì một việc thần kỳ ngoài ý muốn tới cực điểm liền xuất
			hiện. Bàn tay hắn bị thương cầm tiểu tháp kia thì đột nhiên toàn thân bỗng
			dưng cảm thấy tê liệt, đến cả cử động cũng không thể cử động được, thậm chí
			cho dù là nháy mắt cũng không thể làm được.
			Hắn không hề chú ý tới một việc, máu tươi từ miệng vết thương của mình đang
			không ngừng chảy ra rồi nhập vào bên trong tiểu tháp trông rất tinh xảo, rất
			lung linh và cũng rất tà môn kia.
			Kí ức cuối cùng của hắn chính là, không dưới năm mươi quả lựu đạn loại mini
			đang bay về phía hắn, đồng thời hơn hai mươi nòng súng các loại cũng hướng về
			phía hắn mà bắt đâu khạc lửa. Mà uổng cho một thân bản lĩnh của hắn, một thân
			bản lĩnh có thể trong một lần giết chết được những kẻ này nhưng thật là bi ai,
			bi ai tới cùng cực, bi ai vì hắn muốn động của không thể động được.
			Cảm giác này thật khiến người ta nổi điên!
			“Không thể tưởng được Quân Tà ta tung hoành một đời, không có địch thủ là lại
			chết oan chết uổng trong tay những tên này. Chỉ có điều, ông đây có chết cũng
			không tính là bị lỗ. Cả đời này, những tên tham quan ô lại, cường hào ác bá
			rồi đặc công của các quốc gia, chết dưới tay ta tổng cộng có tới hơn một ngàn
			tên. Thế cũng coi như là hoà vốn rồi! Đáng! Rất đáng!”
			“Người khác thì mỉm cười dưới cửu tuyền thì ông đây cũng cười hô hố mà xuống
			địa ngục!”
			“Một đời này ta sống oanh oanh liệt liệt! Vô cùng tiêu sái! Không thẹn với
			lương tâm!”
			“Mặc dù ta giết không ít người nhưng những người đó tuyệt đối không có một tên
			nào là không đáng giết cả! Nếu đã như vậy thì có giết, cũng không hối hận! Cho
			dù có vì thế mà xuống địa ngục thì có làm sao?!”
			“Giết giết giết giết giết giết! Giết hết mọi thứ dơ bẩn thối nát! Gột rửa tất
			cả mọi tội ác! Ngay cả ta có làm một sát thủ bị người ta khinh miệt thì có làm
			sao?!!”
			“Ung dung sống trên thế gian thì liệu có thể sống một cách phóng khoáng như ta
			không? Quả là vô cùng sảng khoái?!”
			- Ha ha ha...........
			Quân Tà nghĩ tới đây mà không khỏi cười cả ra tiếng.
			- Thiếu gia, người... người làm sao vậy?
			Một giọng nói rụt rè vang lên bên cạnh, hình như là bị hành động vừa rồi của
			hắn làm cho sợ hãi mà đang có xu hướng muốn khóc. Tiếp theo đó, một bàn tay
			nhỏ bé lạnh giá sờ lên trán hắn.
			" Thiếu gia? Ta hiện tại không phải đang nằm mơ chứ? Không phải tới địa ngục
			rồi à?!"
			Quân Tà giật mình rồi đột ngột mở mắt. Tiếp đó, một ký ức lạ lẫm đột nhiên
			dâng lên từ đáy lòng hắn! Ký ức lạ lẫm đó như thủy triều tiến vào trong đầu
			hắn. Mà Quân Tà giống như bị sét đánh, giật mình ngơ ngác!
			“ Mình đang... đang ở trong một thân thể khác sao? Đầu thai chuyển thế ư?
			Nhưng trí nhớ kiếp trước sao vẫn còn rõ ràng vậy? Chẳng lẽ mình chưa uống canh
			Mạnh bà?! Hay là mượn xác hoàn hồn?!”
			Một là xuyên việt?
			Hai là phụ thể sống lại?!
			Quân Tà trừng mắt sững sờ tới nửa ngày cũng không hiểu chuyện gì đang xảy ra.
			Cả nửa ngày hắn cũng chẳng buồn nhúc nhích.
			Chỉ khi bàn tay nhỏ bé đang kinh hãi kia quơ quơ vài cái trước mặt hắn thì
			đúng lúc đó Quân Tà đột nhiên hớn hở kêu:
			- Con mẹ nó! Quả nhiên người tốt tất có báo đáp! Bất kể là chuyện gì đang
			diễn ra nhưng dù thế nào đi nữa ông đây vẫn chưa chết. Không ngờ lại có chuyện
			tốt như vậy. Xem ra kiếp trước bổn đại gia nhất định đã tích lũy được vô số
			công đức, chắc chắn là vô số công đức? ! Ha ha ha.....
			Một tiếng kêu sợ hãi vâng lên. Một tiểu cô nương chừng mười tuổi đang run run
			rẩy rẩy đứng ở bên cạnh. Đôi mắt to tròn xinh đẹp kinh hoảng nhìn chằm chằm
			vào vị "thiếu gia" đang gặp ác mộng trước mặt. Thân thể nhỏ nhắn xinh xắn
			không ngừng run rẩy, sắc mặt tái nhợt, tựa như một con chim cút đang vô cùng
			sợ hãi.
			Lại một tiếng kêu sợ hãi nữa vang lên. Một tiếng kêu nghe thật là thê lương.
			Và tiếng kêu sợ hãi đó chính là từ miệng Quân Tà phát ra. Bởi vì hắn đột nhiên
			phát hiện giọng nói vừa rồi của mình lại the thé giống như giọng của một nữ
			hài tử vậy. Chẳng lẻ cái kia của mình mất rồi. Không phải chứ! Phản ứng đầu
			tiên của Quân Tà đó là không thèm để ý tới hình tượng, không quả tới có một
			tiểu muội muội đang đứng bên người, một trảo chụp vào đũng quần của mình.
			Cuối cùng khi đã nắm được cái khối thịt quen thuộc kia Quân Tà mới thở dài một
			hơi. Ông trời đối xử với ta thật không tệ! Vẫn có cái thứ này! Haizzz!
			Vừa rồi làm ta sợ muốn chết. Ông đây còn muốn xuyên vào cái đó đó...... Quân
			Tà lau mồ hôi lạnh.
			Lấy lại bình tĩnh, Quân Tà bắt đầu xem xét thân thể mới của mình.
			Kinh mạch ứ đọng. Cơ thể nhão nhoẹt. Các đốt ngón tay cứng ngắc.....
			" Cái thân thể này sao hỗn tạp vậy? Cơ thể lại yếu đuối nữa? Không xong rồi!"
			Quân Tà thầm thì.
			" Nhưng không sao, chỉ cần kinh mạch không bị vỡ thì chỉ cần ba tới bảy năm,
			bổn đại gia lại đứng trên đỉnh của thế giới!”
			Sau khi quyết định xong, Quân Tà lúc này mới để ý tới mình giờ đang ở một thế
			giới có vẻ hoàn toàn xa lạ!')
			,(8, 3, 17, 4, 0, N'Tà quân Quân Tà',CAST(N'2023-10-07T05:52:10.323' AS DateTime),null, 1, 
			N'Ở đây sao lại không giống địa cầu mà mình quen thuộc vậy? Mình ở đây thực sự
			không quen, cái gì cũng không biết, cái gì cũng không hiểu. Với cả phép tắc
			của thế giới này là gì? Và thế giới này có những cái gì?
			Thoáng suy nghĩ qua mấy vấn đề đó, với tố chất tâm lý cả vị sát thủ lãnh huyết
			vốn được gọi là Tà quân này không ngờ cũng có chút chán nản.
			Nhìn đồ dùng cũng chiếc gường có phong cách cổ xưa, cả bộ quần áo đặc thù của
			thời đại này trên người lập tức niềm vui sướng khi biết được mình vẫn chưa
			chết, hơn nữa còn xuyên việt dần dần trở nên bình tĩnh rồi tiếp đó tâm tư hắn
			bỗng rối loạn.......
			Thì ra....... thì ra thực sự là mình có thể sống lại..............
			Ban đầu điều này sẽ khiến hắn vô cùng phấn chấn nhưng về sau từ đáy lòng hắn
			lại dâng lên nỗi niềm mất mát cùng sự thống khổ tới vô cùng. Đó là một cảm
			giác vi diệu dập dềnh không ổn định, khiến mũi hắn hơi cảm thấy chua xót,
			khiến mắt hắn cũng có chút gì đó cay cay, khiến lòng người có chút buồn phiền.
			Quân Tà tự giễu một câu, khóa miệng khẽ nhếch lên. Cả đời hắn gần như chưa bao
			giờ rơi lệ mà vừa rồi suýt nữa là hắn đã rơi lệ.
			Cố quốc xa xôi, cố hương cách trở! Ta vốn tưởng rằng mình có thể rất tiêu sái,
			vốn tưởng rằng mình có thể dễ dàng buông bỏ. Nhưng khi mọi việc xảy ra ở trước
			mắt và tất cả đều rất chân thực thì ta mới đột nhiên phát hiện ra rằng, ta
			không buông được. Ta thực sự không buông bỏ được!
			Vốn tưởng rằng trên đời này sớm đã không còn gì liên quan, không còn gì để
			mình mình phải vướng bận. Nhưng giờ mình mới phát hiện ra, những thứ mà mình
			quan tâm lại nhiều vô kể! Mà quan trọng nhất chính là tại đây, một nơi lạ lẫm
			này mình không thể tìm thấy những cái, những phần thuộc về chính mình! thuộc
			về chính mình.........
			Từ trong cốt tủy, ta vĩnh viễn từ đầu tới cuối chỉ là một người
			ngoài............
			Quân Tà lẳng lặng nhắm hai mắt lại, nhẹ nhàng nghiêng đầu và khi không còn ai
			có thể nhìn thấy được, một giọt nước mắt nhẹ nhàng, không một tiếng động chảy
			xuống...........
			Đây là giọt nước mắt đầu tiên của hai kiếp làm người!
			Nam nhi không rơi lệ chỉ vì chưa tới lúc đau lòng!
			<hr>
			Kinh ngạc nhìn khuôn mặt trẻ tuổi có chút non nớt, gầy yếu với đôi môi mỏng,
			cặp lông mi nghiêng dài, đôi mắt hơi chút dài nhỏ đầy vẻ sắc bén bên trong
			chiếc gương đồng trước mặt mà Quân Tà chỉ biết cười khổ một tiếng, thì thào
			nói:
			- Không thể không nói bộ dạng của tên gia hỏa này cũng không tệ, rất thanh tú
			đó! Chỉ là có chút gì đó yếu đuối, ẻo lả, lại hơi mặt trắng!
			Nhớ lại kiếp trước, mình thật uy phong biết bao, dữ tợn tới mức nào? Mặc dù bề
			ngoài cũng không có gì đặc biết khiến người ta yêu thích, mắt có nhỏ, mũi có
			thấp một chút, về tổng thể thì có chút đại chúng nhưng bản thân mình chính là
			một nam nhân tiêu chuẩn! Tiểu bạch kiểm này tuy rằng là nam nhân, là đại
			trượng phu nhưng mình lại khinh thường những kẻ như vậy. Song không thể tưởng
			được rằng khi xuyên việt mình lại xuyên tới một tên tiểu bạch kiểm tiêu chuẩn
			như thế này, nhất là tiểu bạch kiểm này lại còn rất là xinh đẹp nữa...........
			" Anh bạn, là anh mang ta tới đây sao? "
			Tay phải nhẹ nhàng vuốt ve hoa văn hình tháp nhỏ trên cổ tay trái mà hoa văn
			bảo tháp kia rất giống một hình xăm. Trên khuôn mặt Quân Tà lộ vẻ kiêu ngạo.
			Ngay cả khi ta xuyên việt thì thứ này vẫn ở trong tay người Trung Quốc mà
			không bị rơi vào tay bọn Dương quỷ tử.
			Hoa văn bảo tháp này giống y hệt cái Linh Lung tiểu tháp mà Quân Tà đã liều
			mạng cướp đoạt! Mặc dù nó đã biến thành một hoa văn nhỏ bé trên tay mình nhưng
			Quân Tà có thể khẳng định rằng đây chính là cái tiểu tháp kia! Chính hắn cũng
			không biết vì sao trong lòng lại có cảm giác này, rất chân thực, mà cũng rất
			huyền diệu.
			Thấy hoa văn tiểu tháp, niềm an ủi duy nhất có thể được mình mang từ kiếp
			trước đến này mà trong lòng Quân Tà bỗng nổi sóng dữ dội, tới chính hắn cũng
			không hiểu đây là cảm giác gì nữa. Chỉ là do tâm tính của hắn luôn trầm ổn nên
			trên khuôn mặt không để lộ ra bất cứ một cái gì cả.
			Vẫn lãnh đạm, vẫn trầm tĩnh như xưa!
			Đột nhiên, hoa văn tiểu tháp đang bị hắn nhẹ nhàng vuốt ve bỗng phát ra một
			hồi ánh sáng màu vàng, sau đó Quân Tà đột nhiên cảm thấy nặng đầu, tiếp theo
			trong đầu hắn hình như có thêm một cái gì đó, mà hoa văn trên tay kia cũng đột
			nhiên biến mất!
			" Chuyện lạ!"
			Lắc lắc đầu, Quân Tà cảm thấy kỳ quái. Trò này đúng thật là kỳ quái. Trước
			tiên một tiểu tháp lớn bằng bàn tay biến thành một hình xăm trên người mình,
			tiếp theo lại biến mất một cách thần kỳ. Chẳng lẻ đồ chơi này lại là bảo bối
			gì gì đó của thần tiên trong truyền thuyết ư?
			- Thiếu gia, lão thái gia mời người qua đó.
			Khi Quân Tà đang định xem xét xem trong đầu mình rốt cuộc có thêm cái gì thì
			đột nhiên một giọng nói vang lên.
			- Mời ta qua ư?
			Quân Tà nhíu mày.
			- Để làm gì?
			Bằng vào cái gì mà lão già kia bảo ta qua bên đó là ta phải qua chứ? Ta là
			chàu của lão à?! Nhưng những lời này còn chưa thốt ra khỏi mồm thì lúc này hắn
			mới chợt nhớ ra, có vẻ như lão già kia quả đúng là gia gia của mình. Ít nhất
			là gia gia của thân thể này.
			- Điều này..... nô tỳ không biết.
			Tiểu cô nương hoảng sợ nhìn hắn một cái rồi cúi đầu. Đôi hàng lông mi dài dài
			bối rối nháy nháy liên tục. Hai chân một trước một sau, thân thể nhỏ nhắn hơi
			nghiêng nghiêng, bộ dáng chuẩn bị để bất cứ lúc nào cũng có thể co chân chạy
			trốn.')
			,(9, 4, 17, 5, 0, N'Quân Mạc Tà',CAST(N'2023-10-19T05:52:10.323' AS DateTime),null, 1, 
			N'Trách không được tại sao ngươi bị xuyên việt. Ngoại hiệu trước kia của ta là
			Tà Quân tên là Quân Tà mà ngươi được gọi là Mạc Tà. Điều này không phải là
			xung khắc trời sinh sao? Ngươi không oan nha.
			Trong đầu xem lại một chút hành vi thường ngày của tên này mà Quân Tà thở dài.
			Nếu đổi lại kiếp trước thì hắn chính là đối tượng mình muốn giết. Mà chính
			mình cũng đâu có tệ sao lại dính ngay cái thân rác rưởi này? Thiên ý sao?
			Người ta thường nói nhân quả phật gia. Một đời này giết heo thì kiếp sau sẽ
			trở thành con heo. Lời này xem ra cũng có đạo lý. Chính mình kiếp trước giết
			không ít tên hoàn khố đó chứ…
			Tổ phụ của tên tiểu tử hoàn khố này là Quân Chiến Thiên, là Huyết Lan Hoa đại
			công tước cũng là nhân vật nắm quyền quân đội. Phụ thân chính là Quân Vô Hối.
			Từng là đại tướng của đế quốc, mười năm trước chết trận trên chiến trường. Mẫu
			thân thì chín năm trước do buồn bực quá độ nên đã đi đoàn tụ với cha hắn dưới
			suối vàng. Hai vị ca ca là Quân Mạc Sầu, Quân Mạc Ưu đã chết trận trong đại
			chiến lừng lẫy trước kia.
			Còn có một vị thúc thúc gọi là Quân Vô Ý cũng bị thương trong chiến trận ở
			mười năm trước. Tuy rằng giữ được cái mệnh nhưng nửa phần dưới eo bị tê liệt…
			Một gia tộc khổng lồ như thế có thể được nói là cả nhà trung liệt. Đáng tiếc
			đã rơi vào tình trạng xuống dốc trầm trọng. Còn lại một cây nối dõi Quân Mạc
			Tà bị Quân Tà xuyên việt. Nếu sau này Quân Tà có con thì trên lý luận cũng
			chính là huyết mạch của Quân gia. Xem như trời cao đã ban ân với Quân gia rồi…
			Nếu như ông trời quyết định như vậy cũng xem trên quân tích của gia tộc. Bổn
			đại sát thủ này đành phải thay ngươi sống một đời thật tốt đi a. Quân Tà nhếch
			miệng cười nhún nhún vai. Thật ra lão tử cũng không muốn phá thanh danh để cho
			lão tử bị mắng làm chi.
			Đẩy cửa phòng, Quân Tà cất bước đi ra, ánh mặt trời chiếu sáng khắp nơi. Nhìn
			ánh sáng mặt trời một lúc lâu, Quân Tà thở dài. Mặt trời kia chính là mặt trời
			a… Mà ta cũng không phải là ta. Quân Mạc Tà không phải là Quân Tà.
			Tâm của ta chính là tâm của Tà Quân? Dị thế là như thế nào?
			Bên ngoài cửa có hai tên người hầu khom người nói: “Thiếu gia mạnh giỏi…”
			Quân Tà nhàn nhạt gật đầu. Nhìn bốn tên hạ nhân đang bận rộn cách đó không xa
			lại nhìn lại bên người liền lắc lắc đầu.
			Nhìn một cái những hạ nhân bên cạnh. Các công tử khác đều có mỹ nữ thiên kiều
			bách mỵ hầu hạ. Mà người hầu trẻ nhất của chính mình chỉ có một đứa hầu gái
			tên là La Lỵ mười hai tuổi. Trong ấn tượng thì đây là do gia gia cường thế của
			mình an bài. Những hạ nhân của mình đều có một đặc điểm, đó chính là rất khỏe
			mạnh và cường tráng.
			- Bọn họ đang làm gì?
			Ngẩng đầu nhìn mấy đầy tớ già kia Quân Tà hỏi.
			- Bọn họ... Đang giúp những con chim và chó đấu thú của thiếu gia.
			Một người đầy tớ già cúi đầu trả lời.
			- Ồ?
			Quân Tà thong thả đi qua. Ừ, đúng là "rực rỡ vô cùng". Bảy tám lồng sắt đặt
			chỉnh tề, bên trong đó có mấy con chim bất đồng nhan sắc bay đến bay lui trông
			rất hoạt bát. Cách đó không xa có mấy con chó lớn đang le lưỡi nằm trên đất.
			Xa hơn là có mấy ống trúc nhỏ phát ra tiếng kêu của dế mèn. Xem ra là những
			con rất chuyên đấu thú...
			Ừa. Xem ra vị công tử này có sở thích rộng rãi đó chứ. Bên cạnh có hai lồng
			sắt nuôi hai con độc xà đầy màu sắc đang le lưỡi vào ra...
			Nhìn những cái này đầy chán nghét, Quân Tà nhíu mày nói:
			- Gọi người đến đưa bọn chúng bán đi. Nếu bán không được thì làm thịt. Đừng
			đặt chổ này làm gì. Đây là nơi dành cho người chứ không phải là vườn thú.
			Hả?
			Vừa nghe những lời này thì sáu người hầu già và La lỵ đi theo sau lưng Quân Tà
			đều trợn mắt lên. Không nhịn được nhìn thiếu gia mình. Một khắc sau, trong đầu
			bảy người đều xuất hiện một ý nghĩ giống nhau: "Vị thiếu gia này hôm nay bị
			điên rồi sao? Những cái này đều là do ngài tìm mua với giá cao đó. Trước giờ
			vẫn là bảo bối mà? Hôm nay ném đi mai lại mua tiếp?"
			- Ách! Hai con rắn kia đừng bán! Chờ ta quay lại nấu canh uống.
			Đi được hai bước thì Quân Tà không quay đầu lại nói tiếp.
			Cả đám ngẩn tò te không biết phải nói gì.
			Đi xuyên qua một hoa viên, mấy tòa lầu các, một thao trường lại đi đến một hồ
			cá thật lớn. Dọc theo hàng cây bờ hồ đi thêm nửa canh giờ mới đến chỗ Quân lão
			gia tử. Lúc này Quân Tà mới phát hiện khu vực mình ở và nơi của Quân lão gia
			tử đúng là một nam một bắc. Nếu tính khoảng cách theo đường chim bay chắc cũng
			được năm sáu dặm đường. Xem ra gia tộc này của mình thật lớn. Nếu mình nhớ
			không lầm thì nơi đây chính là kinh thành của một quốc gia. Có thể ở trong
			kinh thành xây dựng gia viên lớn hơn mười mẫu thì ngoại trừ hoàng cung ra chỉ
			sợ không được mấy nhà.
			Quân lão gia tử ngồi phía sau bàn, mặc dù tuổi đã qua lục tuần nhưng râu tóc
			vẫn đen mượt, mới nhìn như người chỉ bốn mươi tuổi. Khuôn mặt uy nghiêm lộ ra
			vẻ bất đắc dĩ. Nhìn đứa cháu lười biếng hữu khí vô lực tiến vào mà không nhịn
			được tức giận.
			Lão gia tử Quân Chiến Thiên có xuất thân từ nghèo khổ, thời trẻ làm tướng tung
			hoành thiên hạ khiến cho quân địch mỗi nước đều kinh sợ. Không chỉ văn thao vũ
			lược vô cùng cao minh mà cũng chính là một trong những Huyền cấp cao thủ tại
			Thiên Hương Quốc. Tính cách trầm ổn kiên nghị, buồn vui không biểu lộ ra
			ngoài.')
			,(10, 5, 17, 5, 0, N'Quân Mạc Tà',CAST(N'2023-10-20T05:52:10.323' AS DateTime),null, 1, 
			N'Chỉ cần một câu "xuất thân nghèo khổ, thiếu niên làm tướng" có thể nhìn ra
			được một hài tử nghèo khổ như nhau thì mấy ai làm được vị trí tướng quân này?
			Càng huống chi làm tướng từ khi trẻ...
			Quân Chiến Thiên từ một người dân nghèo khổ trở thành Huyết Hoa Lan đại công
			tước trong vòng không đến bốn mươi năm. Mặc dù nói thời thế tạo anh hùng nhưng
			xem lại lịch sử cũng không có mấy người làm được như vậy. Chỉ với điều đó thôi
			cũng đủ để kiêu ngạo. Nhưng bây giờ nhìn thấy đứa cháu còn lại duy nhất của
			mình trong lòng bất đắc dĩ không thôi. Trong lòng ''Hận sắt không thành thép"
			Lão gia tử thật sự không nghĩ rằng với huyết thống của gia tộc và sự quản lý
			chặt chẽ vậy mà vẫn sinh ra một nghiệt chướng! Tiểu tử này văn không tốt võ
			không hay. Cầm sách liền ngủ gục, nghe luyện công liền bỏ chạy nhanh hơn thỏ.
			Con cháu nhà người ta trên ngực đã có cẩm tú, có chút danh vọng; đều đã tu
			luyện huyền khí nhập quỹ đạo cũng đạt ít nhất là ngũ phẩm. Mà bảo bối của mình
			trước sau thay đổi năm vị thư sinh dạy cho, huyền khí tu luyện đến nay chỉ
			được tam phẩm.
			Một người như vậy không làm nên thể thống gì nhưng ăn uống chơi bời đúng là
			"vô sự tự thông". Mấy phương diện này có thể nói là thiên tài. Một đời anh
			hùng mình mình lại có đứa cháu "tốt" như vậy...
			Thở dài vô lực, Quân lão gia tử nhịn không được nhớ lại con mình và hai đứa
			cháu kia. Nghĩ đến đây liền cười tự giễu một chút: "Đem đứa cháu duy nhất
			nuông chiều thành như vậy? Năm đó khi Vô Hối con mình tử trận, bản thân cố
			gắng không rơi lệ. Tự xưng là con trai của lão tử chính là anh hùng. Sau khi
			hai đứa cháu Mạc Ưu Mạc Sầu chết nơi xa trường cũng mạnh mẽ nhịn đau không rơi
			nước mắt. Cháu mình là anh hùng hảo hán. Nhưng sau khi Vô Ý bị tàn phế thân
			thể thì bản thân cũng là lần đầu tiên rơi nước mắt từ sau khi chào đời. Nhưng
			trong lòng còn một tia may mắn, mình vẫn còn một đứa cháu. Hương khói của Quân
			gia có thể duy trì. Nhưng hôm nay thấy cháu mình là một tiểu hỗn đản, một tên
			bại hoại không ra gì. Phải làm gì bây giờ?"
			- Nghe nói đêm qua ngươi té từ giường xuống nhưng lại hôn mê bất tỉnh đúng
			không?
			Thu lại lòng cảm khái trong lòng, Quân Chiến Thiên thản nhiên hỏi.
			- Ách?
			Quân Tà ngẩng đầu, trong lòng có chút nghi hoặc cũng có chút thoải mái. Nếu là
			hỏi chuyện của hắn thì có thể dựa theo trí nhớ trong đầu để trả lời. Nhưng
			chuyện này hắn lại không hề biết gì. Còn có chuyện này thật kỳ lạ, trong lòng
			Quân Tà nghi hoặc: sáng nay ngủ dậy liền thấy thân thể này không có gì bất
			thường thì mình xuyên việt bằng cách nào? Lúc này lão gia tử hỏi mới biết được
			là do tên này té giường chết.
			Thật sự là hoàn khố mà. Ngủ rớt giường cũng có thể chết sao =))
			Trong lòng Quân Tà âm thầm hâm mộ không thôi. Một nhân vật cao nhân như vậy
			thật đáng ngưỡng mộ mà.
			- Ách gì mà ách?
			Quân lão gia tử vỗ bàn, thổi ria mép trừng mắt. Nhìn bộ dáng lười biếng của
			hắn muốn đánh cho một cái:
			- Hỗn trướng. Ngươi bị người khác hạ độc thủ mà cũng không biết? Nếu không
			phải lão phu đã sớm đề phòng thì ngươi sớm đã đi gặp diêm vương rồi. Nói xem
			ngươi có tiền đồ không hả?
			Thì ra là tiểu tử kia bị hạ độc thủ mà chết. Trong lòng Quân Tà âm thầm bĩu
			môi, thầm nghĩ lão sớm đã đề phòng cũng không tốt gì. Cháu của lão vì sự đề
			phòng mà đã đi đầu thai rồi.
			Thấy hắn không nói gì khiến cho Quân lão gia tử cảm thấy kinh ngạc. Với tính
			tình ngu ngốc của hắn thì sao có thể an tĩnh như vậy được? Nếu là trước kia
			nghe được người khác hạ độc thủ thì sớm đã nhảy dựng lên. Bây giờ lại thản
			nhiên lơ đễnh như đã đoán trước rồi. Mơ hồ có thái độ lạnh lùng.
			Ta không nhìn lầm chứ? Quân lão gia tử không thể tin được đứa cháu yếu kém của
			mình có thái độ như vậy.')
			,(11, 6, 17, 6, 0, N'Quân Mạc Tà',CAST(N'2023-10-21T05:52:10.323' AS DateTime),null, 1, 
			N'Quân Chiến Thiên nhìn Quân Tà thật sâu, giọng nói mang vẻ bi thương nhàn nhạt.
			Dù tên tiểu tử này có quậy phá, có là một tên bất thành khí đi chăng nữa, hắn
			vẫn là con cháu của lão, hơn nữa còn là huyết mạch duy nhất của gia tộc. Mặc
			dù lúc này mọi việc đều trôi đi lặng lẽ, có vẻ sóng lặng gió yên, nhưng mấy vị
			hoàng tử đều đang dần trưởng thành, cơn sóng ngầm dữ dội trong triều không
			biết lúc nào sẽ cuộn trào sôi sục, thân là người đứng đầu quân đội, nắm trong
			tay binh quyền, Quân Chiến Thiên lão chẳng khác nào một quả núi yên ổn mà ai
			cũng muốn dựa vào, nếu không thì cũng muốn ngấm ngầm mượn tay lão để tiêu diệt
			kẻ đối nghịch. Tá đao sát nhân, còn gì tuyệt hơn, còn gì hoàn hảo hơn là xuống
			tay với huyết mạch duy nhất của gia tộc lão rồi vu oan giá họa cho kẻ thù? Lão
			không thể yên tâm khi Quân Tà vẫn chưa nằm trong vòng tay bảo hộ của mình, ai
			biết sự tình sau này sẽ diễn biến tới đâu?
			- Không cần đâu ông, con ở đó rất tốt!
			Quân Tà lập tức cười cười cự tuyệt. Hắn đang tò mò muốn biết mấy tên sát thủ ở
			thế giới này có bộ dạng ra sao, nếu dọn đi thì khác nào tự đánh mất cơ hội
			trời cho ấy? Vì thế, khi nghe Quân lão gia tử đem tình hình nguy hiểm ra dọa
			nạt để khuyên hắn, trong lòng hắn không giấu được hưng phấn cùng chờ mong.
			Sát thủ.... lúc này đối với hắn vừa là dĩ vãng xa xôi, vừa là hoài niệm da
			diết.
			- Ngươi!...... Hỗn láo!
			Quân lão gia tử khí giận công tâm, đứng bật dậy giơ chưởng lên muốn đập cho
			đứa cháu ngỗ ngược một cái, nhưng chợt ngẫm nghĩ rồi lại ngồi xuống, thở dài
			nói:
			- Ngươi...... lui ra đi.
			Chuyện gì xảy ra với tên tiểu tử này vậy? Hắn dám công nhiên chống lại mệnh
			lệnh của ta, lần đầu tiên! Hơn nữa, hắn còn cự tuyệt một cách cực kì dứt
			khoát! Điềm gở hay điềm tốt đây?
			Quân Tà cúi người hành lễ rồi lập tức đứng thẳng lên, xoay người bước ra.
			- Chậm đã, ta còn muốn nhắc nhở ngươi một chuyện, sau này không được có ý dây
			dưa gì với Linh Mộng công chúa nữa, việc này tuyệt đối không có gì để thương
			lượng hết!
			Quân lão gia tử giọng nói nhuốm đầy mệt mỏi, thậm chí còn ẩn chứa mấy phần tâm
			tàn tro lạnh.
			Mấy năm qua, Quân gia dù bề ngoài quyền khuynh thiên hạ, ngạo thị triều đình,
			nhưng bên trong lại ẩn chứa một khuyết điểm chí mạng, chính là huyết mạch kế
			thừa ít tới mức đáng thương. Con cháu đời thứ ba chỉ có duy nhất tên tiểu tử
			vô dụng Quân Mạc Tà này mà thôi, Quân lão gia tử đã sống đến chừng này tuổi,
			sao còn không biết nếu vạn nhất một ngày nào đó mình nhắm mắt xuôi tay, Quân
			gia sẽ bị người khác lập tức chà đạp, thậm chí vĩnh viễn biến mất trên đời.
			Nhìn "tài năng" mà Quân Mạc Tà đã "thể hiện", e rằng đây là một cái kết hiển
			nhiên cho Quân gia, một cái kết bi thảm đã được dự báo từ trước.
			Vì muốn tránh cái sự không ai muốn ấy, Quân Chiến Thiên trước đây đã từng
			hướng tới Hoàng đế xin cho người con gái yêu của người là công chúa Linh Mộng
			về làm dâu Quân gia. Nếu việc có thể thành, sau này dù lão đã nhắm mắt quy
			thiên, Quân Mạc Tà chỉ cần dựa hơi tổ tiên để lại cùng với thân phận Phò mã
			hoàng thất, nếu hắn không quá phận thì việc duy trì hương hỏa cho Quân gia
			cũng không có gì đáng ngại.
			Làm chồng của đấng Kim chi ngọc diệp, nhìn có vẻ phong quang xán lạn, nhưng sự
			thực lại là thứ gân gà khó chịu bậc nhất, thậm chí các đại tộc, các gia đình
			quyền thế đều thắp hương khấn vái cầu cho Hoàng đế đừng nổi dạ yêu quý đoái
			thương bất tử mà ban cho họ một cô công chúa về làm dâu trong nhà. Công chúa
			là con dâu, ừ, nhưng vẫn là công chúa cơ mà? Thế nên sẽ có chuyện dở khóc dở
			cười loạn ngầu diễn ra: ông chồng đáng lẽ phải ngồi trên thì lại phải quỳ
			xuống hành lễ với bà vợ, rồi cha chồng mẹ phu quân đến ho trước mặt nàng dâu
			cũng không dám chứ nói gì đến lên mặt dạy dỗ? Đặc biệt nếu không có sự đồng ý
			của vị "phu nhân đặc biệt", thì phò mã cứ ngoan ngoãn mà tuân thủ chế độ một
			vợ một chồng văn minh đi, đừng tơ tưởng làm gì cho mất công. Công chúa dễ dãi
			biết hòa nhập thì không sao, nhưng hãy thử tưởng tượng ngươi vớ phải một bà cô
			đành hanh ưa kiểu cách lên mặt, quen với cái nếp cả thiên hạ nằm dưới gấu váy,
			vậy thì chúc mừng, gia đình ngươi hẳn sẽ vô cùng "hạnh phúc"!.
			Đối với người khác là vậy, nhưng ngược lại, trong mắt Quân Chiến Thiên mà nói,
			đây lại là một điều đại hỷ đối với tên tiểu tử Quân Mạc Tà, thân phận phò mã
			nếu có chính là một tấm bùa bảo hộ tuyệt với cho hắn trong tương lai. Vì vậy,
			lão đành cắn răng hướng tới Hoàng đế yêu cầu hôn sự, âu cũng là do tình thế ép
			buộc, đáng thương.
			Hoàng đế bệ hạ tự nhiên hiểu rõ tâm ý vị lão chiến hữu của mình, cũng có chút
			động tâm thương hại, nhưng sau khi cẩn thận tìm hiểu tư cách chàng rể tương
			lai, biết được những "thành tích" khác người của chàng, cộng với thái độ thà
			chết chứ không chấp nhận của con gái yêu, cuối cùng lão Hoàng đế đành ngậm
			ngùi nói lời từ chối.
			" Quân đại ca, không phải kẻ làm tiểu đệ này không nể mặt đại ca, nhưng nói gì
			thì nói tiểu đệ cũng là một người cha, Linh Mộng lại là đứa con gái mà đệ yêu
			quý nhất. Huynh nói đi, làm sao đệ có thể đem con gái của mình gửi gắm cho
			một...... Ôi!" Quân Chiến Thiên nhớ lại tình cảnh lúc ấy, khi Hoàng đế bệ hạ
			còn chưa dứt lời, lão đã thấy cổ họng mình nghẹn đắng lại.
			Thân là người làm cha sao? Vì nữ nhi của mình mà suy nghĩ sao? Nực cười! Rắm
			chó! Nếu là mười năm trước, lúc Quân gia ta đang trong thời kì thịnh vượng
			nhất, thì dù tiểu tử Mạc Tà có khốn kiếp, có vô dụng gấp mười lần bây giờ đi
			chăng nữa, sợ rằng ngươi mới nghe ta mở miệng yêu cầu hôn sự đã mừng quýnh lên
			mà gật đầu đến sái cổ. Ôi, nhân tình ấm lạnh, lòng người đa đoan, sự đời đã
			thế, biết trách ai đây?
			- Vâng, con biết rồi.
			Quân Tà hơi dừng chân trước cửa, nhàn nhạt nói, giọng nói bình thản như mặt
			nước hồ thu, không buồn không vui, nói xong hắn lập tức bước ra ngoài.
			Quân lão đang chìm trong suy tưởng, bị câu nói lạnh nhạt của gã cháu bất tử
			này doạ cho giật mình té rớt khỏi mộng đẹp.
			Lúc trước, khi Quân lão gia tử vừa mới bộc lộ ý định biến Quân Tà thành phò
			mã, tên tiểu tử liền dương dương tự coi mình đã là hôn phu của Linh Mộng công
			chúa, đi đâu cũng không ngừng lên mặt khoe khoang khiến nàng cảm thấy phiền
			não khôn nguôi. Nhưng Quân lão thấy bộ dáng lãnh đạm không chút quan tâm của
			cháu mình lúc này thì hơi giật mình, cảm thấy bất ngờ. Quân Tà nổi giận, Quân
			Tà ủ rũ thê thảm, Quân Tà nhảy cẫng lên la hét, thậm chí chửi bới thóa mạ,
			Quân Tà .... nói tóm lại là biểu hiện kích động, thất vọng thì lão chẳng lấy
			gì làm ngạc nhiên. Nhưng ô hay, hôm nay thằng cháu lão giở chứng thay đổi,
			khiến lão chịu giật mình không ít, quả là nguy hiểm cho tim mạch người già!
			" Mới có mấy ngày, sao tính tình lại thay đổi ghê gớm đến thế nhỉ?" Quân lão
			gia tử vân vê râu mép, nhìn vào bóng lưng đứa cháu vừa bước ra cửa, đôi mắt
			thâm thúy có vài phần tư lự. Một lúc sau lão mới từ trong suy tư tỉnh lại, đập
			tay đánh "chát" xuống bàn, lẩm bẩm như tự nói với chính mình:
			- Phải phái thêm vài tay hảo thủ, ngày đêm hộ vệ bên người thiếu gia, không
			cho phép bất kì một sơ suất nào tái diễn! Chỉ cần là kẻ lạ mặt xuất hiện, lập
			tức giết chết! Không cần cố kị điều gì!.
			Sự tình kiểu thế này, chỉ có thể diễn ra một lần, tuyệt đối không được có cơ
			hội lặp lại, hừ, đứa cháu yêu của Chiến Thiên ta, ta xem kẻ nào dám động vào
			hắn? Hàn ý trong mắt Quân lão chợt xạ ra mãnh liệt.
			Trong sảnh hoàn toàn vắng lặng đột nhiên vang lên một âm thanh lãng đãng, như
			có như không:
			- Rõ!')
			,(12, 7, 17, 6, 0, N'Quân Mạc Tà',CAST(N'2023-10-24T05:52:10.323' AS DateTime),null, 0, 
			N'Quân Tà bước ra ngoài, hắn khẽ nhắm mắt cảm nhận ánh mặt trời ấm áp đang dịu
			dàng tỏa nắng trên cao. Từng vầng sáng ấm áp nhẹ nhàng ôm ấp, sưởi ấm thân
			hình và khuôn mặt có phần tiều tụy của hắn, Quân Tà chậm rãi đi về phía tiểu
			viện mà hắn vẫn sinh sống, trên đường người hầu nườm nượp qua lại liên tục dạt
			sang hai bên hành lễ và tránh đường cho hắn, nhưng hắn không hề để ý, vẫn tiếp
			tục chìm trong suy tưởng. Không ai biết rằng, trong đầu vị Quân gia tam công
			tử không ngừng lặp đi lặp lại một đoạn đối thoại:
			" Sát thủ là gì? Nghe tên là biết, chính là kẻ giết người trong bóng tối, "hắc
			thủ"! Nhất định phải nhớ kĩ một chữ "hắc", chính là yếu quyết tối quan trọng
			trong nghề!"
			" Sát thủ, xưa nay đều huyền bí, đến từ nơi phiêu miểu, tan biến vào hư
			không!"
			" Thế nào là một sát thủ thành công? Nếu cho đến lúc chết vẫn không ai biết
			ngươi từng là một tên sát thủ tay nhuốm đầy máu tanh, ngươi chính là một kẻ
			thành công!"
			" Vậy, thế nào mới được coi là một siêu cấp sát thủ , một siêu cấp sát thủ
			thực sự?"
			" Sát thủ thực sự, thì trong bất kì tình huống nào vẫn có cách ẩn tàng bản
			thân! Ngồi cạnh văn nhân; văn nhân coi hắn là mặc khách tri kỉ, sống cạnh hoạ
			sĩ, hắn múa cọ chẳng kém gì người; đi với lưu manh, hắn là thần côn khốn
			khiếp; ở cùng quý phụ hắn là quý ông, là thân sĩ tiêu chuẩn; đứng cạnh sắc
			lang, hắn trở thành dâm thần, đứng bên anh hùng, hắn là hán tử đỉnh thiên lập
			địa!"
			" Trong sa mạc, hắn là thằn lằn; trên thảo nguyên, hắn đính thị sói chúa; trở
			về sơn lâm, hắn biến thành mãnh hổ - vạn thú chi vương; vùng vẫy trong đại
			dương, hắn sẽ là thần long hô mưa gọi gió!"
			" Có thể làm như vậy, hắn mới là một sát thủ, một sát thủ đúng nghĩa!"
			" Một kẻ chỉ biết giết người, nhiều nhất hắn thì hắn được coi là tên đồ tể!"
			" Giết người vì mục đích, cho dù bách sát bách thành, cùng lắm người ta gọi
			ngươi là thích khách ưu tú!"
			" Giết người, bản thân nó đã là một môn nghệ thuật! Thân là một sát thủ, ngươi
			cần ngàn lần nhớ kĩ, tuyệt đối không được có ý nghĩ coi thường bộ môn nghệ
			thuật cao nhã này!"
			.............
			Đây là đoạn đối thoại mà Quân Tà được sư phụ hắn tại kiếp trước từng đàm luận,
			nghĩ đến đó, hắn không khỏi cười khổ tự giễu:"...... Bổ sung thêm một điều, ở
			trong loại gia đình kiểu này, ta chính là một tên khốn vô dụng chỉ biết ăn
			chực như heo, nhị thế tổ ăn hại vô dụng!"
			Đột nhiên, một thanh âm lạnh lùng vang lên: " Sai! Ngươi không phải là nhị thế
			tổ! Ta mới là nhị thế tổ, còn ngươi, là tam thế tổ!')

		DECLARE @Counter_Story INT = 2; -- Start with the next number after the existing data
		DECLARE @Counter_Chapter INT = 13;
		DECLARE @Counter_Volume INT = 7;
		WHILE @Counter_Story <= 12 -- Set the end condition
		BEGIN
			INSERT [dbo].[Chapter]([chapter_id],[chapter_number],[story_id],[volume_id],[chapter_price],[chapter_title],[create_time],[update_time],[status],[chapter_content_html]) 
				VALUES
					(@Counter_Chapter, 1, @Counter_Story, @Counter_Volume, 5, N'NICK DUNNE',CAST(N'2022-09-24T05:52:10.323' AS DateTime),null, 1, N'When I think of my wife, I always think of her head. The shape of it, to begin with. The very first time I saw her, it was the back of the head I saw, and there was something lovely about it, the angles of it. Like a shiny, hard corn kernel or a riverbed fossil. She had what the Victorians would call a finely shaped head. You could imagine the skull quite easily.
					I’d know her head anywhere.
					And what’s inside it. I think of that, too: her mind. Her brain, all those coils, and her thoughts shuttling through those coils like fast, frantic centipedes. Like a child, I picture opening her skull, unspooling her brain and sifting through it, trying to catch and pin down her thoughts. What are you thinking, Amy? The question I’ve asked most often during our marriage, if not out loud, if not to the person who could answer. I suppose these questions stormcloud over every marriage: What are you thinking? How are you feeling? Who are you? What have we done to each other? What will we do?
					My eyes flipped open at exactly six a.m. This was no avian fluttering of the lashes, no gentle blink toward consciousness. The awakening was mechanical. A spooky ventriloquist-dummy click of the lids: The world is black and then, showtime! 6-0-0 the clock said – in my face, first thing I saw. 6-0-0. It felt different. I rarely woke at such a rounded time. I was a man of jagged risings: 8:43, 11:51, 9:26. My life was alarmless.
					At that exact moment, 6-0-0, the sun climbed over the skyline of oaks, revealing its full summer angry-God self. Its reflection flared across the river toward our house, a long, blaring finger aimed at me through our frail bedroom curtains. Accusing: You have been seen. You will be seen.
					I wallowed in bed, which was our New York bed in our new house, which we still called the new house, even though we’d been back here for two years. It’s a rented house right along the Mississippi River, a house that screams Suburban Nouveau Riche, the kind of place I aspired to as a kid from my split-level, shag-carpet side of town. The kind of house that is immediately familiar: a generically grand, unchallenging, new, new, new house that my wife would – and did – detest.
					‘Should I remove my soul before I come inside?’ Her first line upon arrival. It had been a compromise: Amy demanded we rent, not buy, in my little Missouri hometown, in her firm hope that we wouldn’t be stuck here long. But the only houses for rent were clustered in this failed development: a miniature ghost town of bank-owned, recession-busted, price-reduced mansions, a neighborhood that closed before it ever opened. It was a compromise, but Amy didn’t see it that way, not in the least. To Amy, it was a punishing whim on my part, a nasty, selfish twist of the knife. I would drag her, caveman-style, to a town she had aggressively avoided, and make her live in the kind of house she used to mock. I suppose it’s not a compromise if only one of you considers it such, but that was what our compromises tended to look like. One of us was always angry. Amy, usually.
					Do not blame me for this particular grievance, Amy. The Missouri Grievance. Blame the economy, blame bad luck, blame my parents, blame your parents, blame the Internet, blame people who use the Internet. I used to be a writer. I was a writer who wrote about TV and movies and books. Back when people read things on paper, back when anyone cared about what I thought. I’d arrived in New York in the late ’90s, the last gasp of the glory days, although no one knew it then. New York was packed with writers, real writers, because there were magazines, real magazines, loads of them. This was back when the Internet was still some exotic pet kept in the corner of the publishing world – throw some kibble at it, watch it dance on its little leash, oh quite cute, it definitely won’t kill us in the night. Think about it: a time when newly graduated college kids could come to New York and get paid to write. We had no clue that we were embarking on careers that would vanish within a decade.
					I had a job for eleven years and then I didn’t, it was that fast. All around the country, magazines began shuttering, succumbing to a sudden infection brought on by the busted economy. Writers (my kind of writers: aspiring novelists, ruminative thinkers, people whose brains don’t work quick enough to blog or link or tweet, basically old, stubborn blowhards) were through. We were like women’s hat makers or buggy-whip manufacturers: Our time was done. Three weeks after I got cut loose, Amy lost her job, such as it was. (Now I can feel Amy looking over my shoulder, smirking at the time I’ve spent discussing my career, my misfortune, and dismissing her experience in one sentence. That, she would tell you, is typical. Just like Nick, she would say. It was a refrain of hers: Just like Nick to … and whatever followed, whatever was just like me, was bad.) Two jobless grown-ups, we spent weeks wandering around our Brooklyn brownstone in socks and pajamas, ignoring the future, strewing unopened mail across tables and sofas, eating ice cream at ten a.m. and taking thick afternoon naps.
					Then one day the phone rang. My twin sister was on the other end. Margo had moved back home after her own New York layoff a year before – the girl is one step ahead of me in everything, even shitty luck. Margo, calling from good ole North Carthage, Missouri, from the house where we grew up, and as I listened to her voice, I saw her at age ten, with a dark cap of hair and overall shorts, sitting on our grandparents’ back dock, her body slouched over like an old pillow, her skinny legs dangling in the water, watching the river flow over fish-white feet, so intently, utterly self-possessed even as a child.
					Go’s voice was warm and crinkly even as she gave this cold news: Our indomitable mother was dying. Our dad was nearly gone – his (nasty) mind, his (miserable) heart, both murky as he meandered toward the great gray beyond. But it looked like our mother would beat him there. About six months, maybe a year, she had. I could tell that Go had gone to meet with the doctor by herself, taken her studious notes in her slovenly handwriting, and she was teary as she tried to decipher what she’d written. Dates and doses.
					‘Well, fuck, I have no idea what this says, is it a nine? Does that even make sense?’ she said, and I interrupted. Here was a task, a purpose, held out on my sister’s palm like a plum. I almost cried with relief.
					‘I’ll come back, Go. We’ll move back home. You shouldn’t have to do this all by yourself.’
					She didn’t believe me. I could hear her breathing on the other end.
					‘I’m serious, Go. Why not? There’s nothing here.’
					A long exhale. ‘What about Amy?’
					That is what I didn’t take long enough to consider. I simply assumed I would bundle up my New York wife with her New York interests, her New York pride, and remove her from her New York parents – leave the frantic, thrilling futureland of Manhattan behind – and transplant her to a little town on the river in Missouri, and all would be fine.
					I did not yet understand how foolish, how optimistic, how, yes, just like Nick I was for thinking this. The misery it would lead to.
					‘Amy will be fine. Amy …’ Here was where I should have said, ‘Amy loves Mom.’ But I couldn’t tell Go that Amy loved our mother, because after all that time, Amy still barely knew our mother. Their few meetings had left them both baffled. Amy would dissect the conversations for days after – ‘And what did she mean by …,’ – as if my mother were some ancient peasant tribeswoman arriving from the tundra with an armful of raw yak meat and some buttons for bartering, trying to get something from Amy that wasn’t on offer.
					Amy didn’t care to know my family, didn’t want to know my birthplace, and yet for some reason, I thought moving home would be a good idea.
					My morning breath warmed the pillow, and I changed the subject in my mind. Today was not a day for second-guessing or regret, it was a day for doing. Downstairs, I could hear the return of a long-lost sound: Amy making breakfast. Banging wooden cupboards (rump-thump!), rattling containers of tin and glass (ding-ring!), shuffling and sorting a collection of metal pots and iron pans (ruzz-shuzz!). A culinary orchestra tuning up, clattering vigorously toward the finale, a cake pan drumrolling along the floor, hitting the wall with a cymballic crash. Something impressive was being created, probably a crepe, because crepes are special, and today Amy would want to cook something special.
					It was our five-year anniversary.
					I walked barefoot to the edge of the steps and stood listening, working my toes into the plush wall-to-wall carpet Amy detested on principle, as I tried to decide whether I was ready to join my wife. Amy was in the kitchen, oblivious to my hesitation. She was humming something melancholy and familiar. I strained to make it out – a folk song? a lullabye? – and then realized it was the theme to M.A.S.H. Suicide is painless. I went downstairs.
					I hovered in the doorway, watching my wife. Her yellow-butter hair was pulled up, the hank of ponytail swinging cheerful as a jumprope, and she was sucking distractedly on a burnt fingertip, humming around it. She hummed to herself because she was an unrivaled botcher of lyrics. When we were first dating, a Genesis song came on the radio: ‘She seems to have an invisible touch, yeah.’ And Amy crooned instead, ‘She takes my hat and puts it on the top shelf.’ When I asked her why she’d ever think her lyrics were remotely, possibly, vaguely right, she told me she always thought the woman in the song truly loved the man because she put his hat on the top shelf. I knew I liked her then, really liked her, this girl with an explanation for everything.
					There’s something disturbing about recalling a warm memory and feeling utterly cold.
					Amy peered at the crepe sizzling in the pan and licked something off her wrist. She looked triumphant, wifely. If I took her in my arms, she would smell like berries and powdered sugar.
					When she spied me lurking there in grubby boxers, my hair in full Heat Miser spike, she leaned against the kitchen counter and said, ‘Well, hello, handsome.’
					Bile and dread inched up my throat. I thought to myself: Okay, go.
					I was very late getting to work. My sister and I had done a foolish thing when we both moved back home. We had done what we always talked about doing. We opened a bar. We borrowed money from Amy to do this, eighty thousand dollars, which was once nothing to Amy but by then was almost everything. I swore I would pay her back, with interest. I would not be a man who borrowed from his wife – I could feel my dad twisting his lips at the very idea. Well, there are all kinds of men, his most damning phrase, the second half left unsaid, and you are the wrong kind.
					But truly, it was a practical decision, a smart business move. Amy and I both needed new careers; this would be mine. She would pick one someday, or not, but in the meantime, here was an income, made possible by the last of Amy’s trust fund. Like the McMansion I rented, the bar featured symbolically in my childhood memories – a place where only grown-ups go, and do whatever grown-ups do. Maybe that’s why I was so insistent on buying it after being stripped of my livelihood. It’s a reminder that I am, after all, an adult, a grown man, a useful human being, even though I lost the career that made me all these things. I won’t make that mistake again: The once plentiful herds of magazine writers would continue to be culled – by the Internet, by the recession, by the American public, who would rather watch TV or play video games or electronically inform friends that, like, rain sucks! But there’s no app for a bourbon buzz on a warm day in a cool, dark bar. The world will always want a drink.
					Our bar is a corner bar with a haphazard, patchwork aesthetic. Its best feature is a massive Victorian backbar, dragon heads and angel faces emerging from the oak – an extravagant work of wood in these shitty plastic days. The remainder of the bar is, in fact, shitty, a showcase of the shabbiest design offerings of every decade: an Eisenhower-era linoleum floor, the edges turned up like burnt toast; dubious wood-paneled walls straight from a ’70s home-porn video; halogen floor lamps, an accidental tribute to my 1990s dorm room. The ultimate effect is strangely homey – it looks less like a bar than someone’s benignly neglected fixer-upper. And jovial: We share a parking lot with the local bowling alley, and when our door swings wide, the clatter of strikes applauds the customer’s entrance.
					We named the bar The Bar. ‘People will think we’re ironic instead of creatively bankrupt,’ my sister reasoned.
					Yes, we thought we were being clever New Yorkers – that the name was a joke no one else would really get, not get like we did. Not meta-get. We pictured the locals scrunching their noses: Why’d you name it The Bar? But our first customer, a gray-haired woman in bifocals and a pink jogging suit, said, ‘I like the name. Like in Breakfast at Tiffany’s and Audrey Hepburn’s cat was named Cat.’
					We felt much less superior after that, which was a good thing.
					I pulled into the parking lot. I waited until a strike erupted from the bowling alley – thank you, thank you, friends – then stepped out of the car. I admired the surroundings, still not bored with the broken-in view: the squatty blond-brick post office across the street (now closed on Saturdays), the unassuming beige office building just down the way (now closed, period). The town wasn’t prosperous, not anymore, not by a long shot. Hell, it wasn’t even original, being one of two Carthage, Missouris – ours is technically North Carthage, which makes it sound like a twin city, although it’s hundreds of miles from the other and the lesser of the two: a quaint little 1950s town that bloated itself into a basic midsize suburb and dubbed it progress. Still, it was where my mom grew up and where she raised me and Go, so it had some history. Mine, at least.
					As I walked toward the bar across the concrete-and-weed parking lot, I looked straight down the road and saw the river. That’s what I’ve always loved about our town: We aren’t built on some safe bluff overlooking the Mississippi – we are on the Mississippi. I could walk down the road and step right into the sucker, an easy three-foot drop, and be on my way to Tennessee. Every building downtown bears hand-drawn lines from where the river hit during the Flood of ’61, ’75, ’84, ’93, ’07, ’08, ’11. And so on.
					The river wasn’t swollen now, but it was running urgently, in strong ropy currents. Moving apace with the river was a long single-file line of men, eyes aimed at their feet, shoulders tense, walking steadfastly nowhere. As I watched them, one suddenly looked up at me, his face in shadow, an oval blackness. I turned away.
					I felt an immediate, intense need to get inside. By the time I’d gone twenty feet, my neck bubbled with sweat. The sun was still an angry eye in the sky. You have been seen.
					My gut twisted, and I moved quicker. I needed a drink.')

			SET @Counter_Story = @Counter_Story + 1; -- Increment the counter
			SET @Counter_Volume = @Counter_Volume + 1;
			SET @Counter_Chapter = @Counter_Chapter + 1; -- Increment the counter
		END;

		DECLARE @Counter_ChapterNum INT = 6; -- Start with the next number after the existing data
		DECLARE @Counter_Chapters INT = 24;
		DECLARE @Counter_Volumes INT = 19;
		WHILE @Counter_ChapterNum <= 25 -- Set the end condition
		BEGIN
			INSERT [dbo].[Chapter]([chapter_id],[chapter_number],[story_id],[volume_id],[chapter_price],[chapter_title],[create_time],[update_time],[status],[chapter_content_html]) 
				VALUES
					(@Counter_Chapters, @Counter_ChapterNum, 1, @Counter_Volumes, 5, N'NICK DUNNE',CAST(N'2022-09-24T05:52:10.323' AS DateTime),null, 1, N'When I think of my wife, I always think of her head. The shape of it, to begin with. The very first time I saw her, it was the back of the head I saw, and there was something lovely about it, the angles of it. Like a shiny, hard corn kernel or a riverbed fossil. She had what the Victorians would call a finely shaped head. You could imagine the skull quite easily.
					I’d know her head anywhere.
					And what’s inside it. I think of that, too: her mind. Her brain, all those coils, and her thoughts shuttling through those coils like fast, frantic centipedes. Like a child, I picture opening her skull, unspooling her brain and sifting through it, trying to catch and pin down her thoughts. What are you thinking, Amy? The question I’ve asked most often during our marriage, if not out loud, if not to the person who could answer. I suppose these questions stormcloud over every marriage: What are you thinking? How are you feeling? Who are you? What have we done to each other? What will we do?
					My eyes flipped open at exactly six a.m. This was no avian fluttering of the lashes, no gentle blink toward consciousness. The awakening was mechanical. A spooky ventriloquist-dummy click of the lids: The world is black and then, showtime! 6-0-0 the clock said – in my face, first thing I saw. 6-0-0. It felt different. I rarely woke at such a rounded time. I was a man of jagged risings: 8:43, 11:51, 9:26. My life was alarmless.
					At that exact moment, 6-0-0, the sun climbed over the skyline of oaks, revealing its full summer angry-God self. Its reflection flared across the river toward our house, a long, blaring finger aimed at me through our frail bedroom curtains. Accusing: You have been seen. You will be seen.
					I wallowed in bed, which was our New York bed in our new house, which we still called the new house, even though we’d been back here for two years. It’s a rented house right along the Mississippi River, a house that screams Suburban Nouveau Riche, the kind of place I aspired to as a kid from my split-level, shag-carpet side of town. The kind of house that is immediately familiar: a generically grand, unchallenging, new, new, new house that my wife would – and did – detest.
					‘Should I remove my soul before I come inside?’ Her first line upon arrival. It had been a compromise: Amy demanded we rent, not buy, in my little Missouri hometown, in her firm hope that we wouldn’t be stuck here long. But the only houses for rent were clustered in this failed development: a miniature ghost town of bank-owned, recession-busted, price-reduced mansions, a neighborhood that closed before it ever opened. It was a compromise, but Amy didn’t see it that way, not in the least. To Amy, it was a punishing whim on my part, a nasty, selfish twist of the knife. I would drag her, caveman-style, to a town she had aggressively avoided, and make her live in the kind of house she used to mock. I suppose it’s not a compromise if only one of you considers it such, but that was what our compromises tended to look like. One of us was always angry. Amy, usually.
					Do not blame me for this particular grievance, Amy. The Missouri Grievance. Blame the economy, blame bad luck, blame my parents, blame your parents, blame the Internet, blame people who use the Internet. I used to be a writer. I was a writer who wrote about TV and movies and books. Back when people read things on paper, back when anyone cared about what I thought. I’d arrived in New York in the late ’90s, the last gasp of the glory days, although no one knew it then. New York was packed with writers, real writers, because there were magazines, real magazines, loads of them. This was back when the Internet was still some exotic pet kept in the corner of the publishing world – throw some kibble at it, watch it dance on its little leash, oh quite cute, it definitely won’t kill us in the night. Think about it: a time when newly graduated college kids could come to New York and get paid to write. We had no clue that we were embarking on careers that would vanish within a decade.
					I had a job for eleven years and then I didn’t, it was that fast. All around the country, magazines began shuttering, succumbing to a sudden infection brought on by the busted economy. Writers (my kind of writers: aspiring novelists, ruminative thinkers, people whose brains don’t work quick enough to blog or link or tweet, basically old, stubborn blowhards) were through. We were like women’s hat makers or buggy-whip manufacturers: Our time was done. Three weeks after I got cut loose, Amy lost her job, such as it was. (Now I can feel Amy looking over my shoulder, smirking at the time I’ve spent discussing my career, my misfortune, and dismissing her experience in one sentence. That, she would tell you, is typical. Just like Nick, she would say. It was a refrain of hers: Just like Nick to … and whatever followed, whatever was just like me, was bad.) Two jobless grown-ups, we spent weeks wandering around our Brooklyn brownstone in socks and pajamas, ignoring the future, strewing unopened mail across tables and sofas, eating ice cream at ten a.m. and taking thick afternoon naps.
					Then one day the phone rang. My twin sister was on the other end. Margo had moved back home after her own New York layoff a year before – the girl is one step ahead of me in everything, even shitty luck. Margo, calling from good ole North Carthage, Missouri, from the house where we grew up, and as I listened to her voice, I saw her at age ten, with a dark cap of hair and overall shorts, sitting on our grandparents’ back dock, her body slouched over like an old pillow, her skinny legs dangling in the water, watching the river flow over fish-white feet, so intently, utterly self-possessed even as a child.
					Go’s voice was warm and crinkly even as she gave this cold news: Our indomitable mother was dying. Our dad was nearly gone – his (nasty) mind, his (miserable) heart, both murky as he meandered toward the great gray beyond. But it looked like our mother would beat him there. About six months, maybe a year, she had. I could tell that Go had gone to meet with the doctor by herself, taken her studious notes in her slovenly handwriting, and she was teary as she tried to decipher what she’d written. Dates and doses.
					‘Well, fuck, I have no idea what this says, is it a nine? Does that even make sense?’ she said, and I interrupted. Here was a task, a purpose, held out on my sister’s palm like a plum. I almost cried with relief.
					‘I’ll come back, Go. We’ll move back home. You shouldn’t have to do this all by yourself.’
					She didn’t believe me. I could hear her breathing on the other end.
					‘I’m serious, Go. Why not? There’s nothing here.’
					A long exhale. ‘What about Amy?’
					That is what I didn’t take long enough to consider. I simply assumed I would bundle up my New York wife with her New York interests, her New York pride, and remove her from her New York parents – leave the frantic, thrilling futureland of Manhattan behind – and transplant her to a little town on the river in Missouri, and all would be fine.
					I did not yet understand how foolish, how optimistic, how, yes, just like Nick I was for thinking this. The misery it would lead to.
					‘Amy will be fine. Amy …’ Here was where I should have said, ‘Amy loves Mom.’ But I couldn’t tell Go that Amy loved our mother, because after all that time, Amy still barely knew our mother. Their few meetings had left them both baffled. Amy would dissect the conversations for days after – ‘And what did she mean by …,’ – as if my mother were some ancient peasant tribeswoman arriving from the tundra with an armful of raw yak meat and some buttons for bartering, trying to get something from Amy that wasn’t on offer.
					Amy didn’t care to know my family, didn’t want to know my birthplace, and yet for some reason, I thought moving home would be a good idea.
					My morning breath warmed the pillow, and I changed the subject in my mind. Today was not a day for second-guessing or regret, it was a day for doing. Downstairs, I could hear the return of a long-lost sound: Amy making breakfast. Banging wooden cupboards (rump-thump!), rattling containers of tin and glass (ding-ring!), shuffling and sorting a collection of metal pots and iron pans (ruzz-shuzz!). A culinary orchestra tuning up, clattering vigorously toward the finale, a cake pan drumrolling along the floor, hitting the wall with a cymballic crash. Something impressive was being created, probably a crepe, because crepes are special, and today Amy would want to cook something special.
					It was our five-year anniversary.
					I walked barefoot to the edge of the steps and stood listening, working my toes into the plush wall-to-wall carpet Amy detested on principle, as I tried to decide whether I was ready to join my wife. Amy was in the kitchen, oblivious to my hesitation. She was humming something melancholy and familiar. I strained to make it out – a folk song? a lullabye? – and then realized it was the theme to M.A.S.H. Suicide is painless. I went downstairs.
					I hovered in the doorway, watching my wife. Her yellow-butter hair was pulled up, the hank of ponytail swinging cheerful as a jumprope, and she was sucking distractedly on a burnt fingertip, humming around it. She hummed to herself because she was an unrivaled botcher of lyrics. When we were first dating, a Genesis song came on the radio: ‘She seems to have an invisible touch, yeah.’ And Amy crooned instead, ‘She takes my hat and puts it on the top shelf.’ When I asked her why she’d ever think her lyrics were remotely, possibly, vaguely right, she told me she always thought the woman in the song truly loved the man because she put his hat on the top shelf. I knew I liked her then, really liked her, this girl with an explanation for everything.
					There’s something disturbing about recalling a warm memory and feeling utterly cold.
					Amy peered at the crepe sizzling in the pan and licked something off her wrist. She looked triumphant, wifely. If I took her in my arms, she would smell like berries and powdered sugar.
					When she spied me lurking there in grubby boxers, my hair in full Heat Miser spike, she leaned against the kitchen counter and said, ‘Well, hello, handsome.’
					Bile and dread inched up my throat. I thought to myself: Okay, go.
					I was very late getting to work. My sister and I had done a foolish thing when we both moved back home. We had done what we always talked about doing. We opened a bar. We borrowed money from Amy to do this, eighty thousand dollars, which was once nothing to Amy but by then was almost everything. I swore I would pay her back, with interest. I would not be a man who borrowed from his wife – I could feel my dad twisting his lips at the very idea. Well, there are all kinds of men, his most damning phrase, the second half left unsaid, and you are the wrong kind.
					But truly, it was a practical decision, a smart business move. Amy and I both needed new careers; this would be mine. She would pick one someday, or not, but in the meantime, here was an income, made possible by the last of Amy’s trust fund. Like the McMansion I rented, the bar featured symbolically in my childhood memories – a place where only grown-ups go, and do whatever grown-ups do. Maybe that’s why I was so insistent on buying it after being stripped of my livelihood. It’s a reminder that I am, after all, an adult, a grown man, a useful human being, even though I lost the career that made me all these things. I won’t make that mistake again: The once plentiful herds of magazine writers would continue to be culled – by the Internet, by the recession, by the American public, who would rather watch TV or play video games or electronically inform friends that, like, rain sucks! But there’s no app for a bourbon buzz on a warm day in a cool, dark bar. The world will always want a drink.
					Our bar is a corner bar with a haphazard, patchwork aesthetic. Its best feature is a massive Victorian backbar, dragon heads and angel faces emerging from the oak – an extravagant work of wood in these shitty plastic days. The remainder of the bar is, in fact, shitty, a showcase of the shabbiest design offerings of every decade: an Eisenhower-era linoleum floor, the edges turned up like burnt toast; dubious wood-paneled walls straight from a ’70s home-porn video; halogen floor lamps, an accidental tribute to my 1990s dorm room. The ultimate effect is strangely homey – it looks less like a bar than someone’s benignly neglected fixer-upper. And jovial: We share a parking lot with the local bowling alley, and when our door swings wide, the clatter of strikes applauds the customer’s entrance.
					We named the bar The Bar. ‘People will think we’re ironic instead of creatively bankrupt,’ my sister reasoned.
					Yes, we thought we were being clever New Yorkers – that the name was a joke no one else would really get, not get like we did. Not meta-get. We pictured the locals scrunching their noses: Why’d you name it The Bar? But our first customer, a gray-haired woman in bifocals and a pink jogging suit, said, ‘I like the name. Like in Breakfast at Tiffany’s and Audrey Hepburn’s cat was named Cat.’
					We felt much less superior after that, which was a good thing.
					I pulled into the parking lot. I waited until a strike erupted from the bowling alley – thank you, thank you, friends – then stepped out of the car. I admired the surroundings, still not bored with the broken-in view: the squatty blond-brick post office across the street (now closed on Saturdays), the unassuming beige office building just down the way (now closed, period). The town wasn’t prosperous, not anymore, not by a long shot. Hell, it wasn’t even original, being one of two Carthage, Missouris – ours is technically North Carthage, which makes it sound like a twin city, although it’s hundreds of miles from the other and the lesser of the two: a quaint little 1950s town that bloated itself into a basic midsize suburb and dubbed it progress. Still, it was where my mom grew up and where she raised me and Go, so it had some history. Mine, at least.
					As I walked toward the bar across the concrete-and-weed parking lot, I looked straight down the road and saw the river. That’s what I’ve always loved about our town: We aren’t built on some safe bluff overlooking the Mississippi – we are on the Mississippi. I could walk down the road and step right into the sucker, an easy three-foot drop, and be on my way to Tennessee. Every building downtown bears hand-drawn lines from where the river hit during the Flood of ’61, ’75, ’84, ’93, ’07, ’08, ’11. And so on.
					The river wasn’t swollen now, but it was running urgently, in strong ropy currents. Moving apace with the river was a long single-file line of men, eyes aimed at their feet, shoulders tense, walking steadfastly nowhere. As I watched them, one suddenly looked up at me, his face in shadow, an oval blackness. I turned away.
					I felt an immediate, intense need to get inside. By the time I’d gone twenty feet, my neck bubbled with sweat. The sun was still an angry eye in the sky. You have been seen.
					My gut twisted, and I moved quicker. I needed a drink.')

			SET @Counter_ChapterNum = @Counter_ChapterNum + 1; -- Increment the counter
			SET @Counter_Chapters = @Counter_Chapters + 1; -- Increment the counter
			
			 IF @Counter_ChapterNum % 3 = 0 -- Check if chapter number is divisible by 3
				BEGIN
					SET @Counter_Volumes = @Counter_Volumes + 1; -- Increment volume number
				END
		END;
	
	
INSERT [dbo].[Chapter]([chapter_id],[chapter_number],[story_id],[volume_id],[chapter_price],[chapter_title],[create_time],[update_time],[status],[chapter_content_html]) 
	VALUES
		(44, 1, 23, 26, 5, N'Ngủ Với Người Lạ',CAST(N'2024-01-01T05:52:10.323' AS DateTime),null, 1, 
		N'Cố Tư Tư cảm nhận được sự ấm ấp trong lòng đối phương, không nhịn được mà rúc vào lòng người nọ. Tuy rằng cả đêm qua đều không được nghỉ ngơi, khiến toàn thân cô đau nhức, nhưng cô một chút cũng không hối hận.
		Cô chuẩn bị lâu như vậy, chính là muốn đem mình trở thành món quà quý giá nhất tặng cho hắn!Cô và Triệu Trạch yêu nhau hai năm, mỗi lần Triệu Trạch muốn cùng cô thân mật đều sẽ bị cô cự tuyệt, 
		cô không muốn bản thân mình tùy tiện như vậy.Nhưng lần này thì khác, ngày mai Triệu Trạch sẽ xuất ngoại và đây cũng là sinh nhật hai mươi ba tuổi của cô!
		Trong ngày quan trọng như vậy, bạn thân kịch liệt đề nghị cô đặt phòng sang trọng của khách sạn Hilton, đem lần đầu tiên của cô tặng cho bạn trai.Cố Tư Tư vui vẻ ôm eo đối phương,
		thật không ngờ dáng người của Triệu Trạch Cương lại tốt như vậy.Không gầy không béo.Quả thực là vừa đẹp a~!"Ừm, Dina, em tỉnh rồi sao?" Người đàn ông trên đỉnh đầu nói: 
		"Đêm qua vất vả cho em rồi.""Anh vạn lần đừng nói như vậy, Trạch Cương, là em cam tâm tình nguyện." Cố Tư Tư dùng sức ôm eo đối phương ngọt ngào trả lời.Dina…?Trạch Cương….?
		Cố Tư Tư và người đàn ông kia đồng thời ngẩn ra, dừng lại ba giây thì đột ngột tách nhau ra, Cố Tư Tư hoảng loạn xoay người mở đèn.Đèn vừa bật lên, Cố Tư Tư nhìn thấy một gương mặt
		hoàn toàn xa lạ, nhất thời sợ hãi hét lên: "Anh là ai!"Cô kéo chăn che kín toàn thân, "Sao anh lại ở đây?""Đây là phòng của tôi! Cô là ai? Tại sao cô lại ở đây?" Trên mặt 
		người đàn ông cũng tràn ngập sự bất ngờ.Cố Tư Tư toàn thân lạnh toát, một cảm giác bất an khó tả dâng lên trong lòng, "Đây là phòng 1216, bạn thân tôi đã đưa thẻ cho tôi,
		người đàn ông phải đây lẽ ra phải là bạn trai của tôi…""À!" Doãn Tư Thần cảm thấy đây là lí do ngu ngốc nhất mà hắn từng nghe, đối với giá trị con người của hắn, bao nhiêu phụ nữ
		đều muốn leo lên người hắn, hôm nay lại gặp phải một người kêu oan! "Cô ngay cả số phòng của tôi cũng điều tra rõ như vậy, lẽ nào không phải vì để trèo lên giường của tôi? Cô còn viện lí
		do gì, nói đi, cô muốn bao nhiêu tiền?"Tên đàn ông hung hăng giễu cợt đâm vào lòng Cố Tư Tư khiến cô bình tĩnh lại, đêm qua rốt cuộc đã xảy ra chuyện gì?Cô nhớ rõ, cô và bạn thân
		Lâm Tiểu Nhã cùng nhau uống rượu, vì buổi tối Tiểu Nhã sẽ bay đến Milan tham gia trình diễn thời trang, vì để chúc mừng cô ấy lần nữa được bước lên sân khấu quốc tế, 
		đồng thời chúc mừng sinh nhật của cô.Cô đã uống hơi nhiều, Tiểu Nhã lại không ngừng xúi giục cô nhanh chóng bắt Triệu Trạch Cương lại, dù sao Triệu Trạch Cương sẽ xuất ngoại hai năm,
		Tư Tư như bị ma xui quỷ khiến liền đồng ý, sau đó cầm thẻ phòng Tiểu Nhã đưa, quẹt thẻ đi vào.Nhưng tại sao người đàn ông trong phòng lại không phải là Triệu Trạch Cương!
		'),
		(45, 2, 23, 26, 5, N'Ngủ Với Người Lạ',CAST(N'2024-01-01T05:52:10.323' AS DateTime),null, 1, 
		N'"Cái gì mà bao nhiêu tiền? Triệu Trạch Cương đâu!"Doãn Tư Thần nhíu mày, người phụ nữ trước mắt này dường như có chút kỳ quái, trước đó hình như cô cũng nói một câu "Trạch Cương"?
		Lẽ nào bọn họ thật sự bị tính kế!Đêm qua hắn rõ ràng hẹn Dina, có người quẹt thẻ vào phòng, lúc ấy trong phòng không bật đèn, mà cô gái trước mắt có hương nước hoa giống của Dina, 
		hắn đương nhiên cho rằng cô là Dina, nhưng cuối cùng lại là cô gái này.Hắn định mở miệng hỏi thì điện thoại liền vang lên, là Dina gọi đến."Dina, chuyện gì vậy?"Giọn của Dina 
		trong điện thoại tràn đầy áy náy: "Tư Thần, em thật sự xin lỗi, hôm qua em nhận được lời mời từ Milan, bọn họ muốn mời em làm người mẫu chính. Tối hôm qua em đã bay đến Milan lúc 8 giờ, 
		anh biết làm người mẫu chính luôn là ước mơ từ lâu của em, em không muốn bỏ lỡ cơ hội này, anh có thể tha thứ cho em không? À, đúng rồi, tối qua em tặng anh một món quà, xem như là bồi 
		thường, anh có hài lòng không?""Quà?" Ánh mắt Doãn Tư Thần trầm xuống, nhìn thoáng qua cô gái khoác áo choàng tắm tìm Triệu Trạch Cương trong phòng, ý tứ trong mắt có chút không rõ.
		"Đúng vậy, món quà này em đã chọn lựa rất kỹ. Cô ấy còn là xử nữ, trải nghiệm đêm qua có phải không tệ không?""Đương nhiên không tệ, có một cô người yêu chu đáo như vậy, sao có thể 
		giận chứ? Nếu em đã thích làm người mẫu như vậy, vậy thì ở Milan biểu diễn thật tốt đi." Doan Tư Thần nói xong câu này lập tức tắt điện thoại.Cố Tư Tư lúc này lục lọi khắp phòng cũng 
		không thấy Triệu Trạch Cương, cô đã không thể bình tĩnh được nữa!Cô thế nào lại cùng một người đàn ông xa lạ ngủ một đêm, sau này cô còn mặt mũi gì tìm Trạch Cương đây.
		Nước mắt cô cứ vậy mà rơi xuống, cô ngồi xổm ở góc tường, nức nở khóc không thành tiếng, không để ý đến người đàn ông kia vẫn dùng ánh mắt phức tạp nhìn cô.
		Doãn Tư Thần cất điện thoại đi, mặc kệ cô gái này đã xảy ra chuyện gì, nhưng quả nhiên đêm qua không phải cô ta đến phục vụ hắn, món quà Dina tặng có lẽ cũng không phải cô ấy. 
		Nhưng mặc kệ cô là ai, chuyện xảy ra hôm nay, nhất định không thể nói ra.Hắn tìm áo khoác, lấy ra chi phiếu, viết xong thì xé xuống, nhiều tiên như vậy, có lẽ đủ để bịt miệng chứ?
		'),
		(46, 3, 23, 27, 5, N'CEO nhất định muốn cưới tôi',CAST(N'2024-01-01T05:52:10.323' AS DateTime),null, 1, 
		N'"Cốc cốc cốc.." lúc ngày bên ngoài truyền đến tiếng gõ cửa, "Chào Doãn tiên sinh, tôi là nhân viên phục vụ khách sạn, tôi mang bữa sáng cho ngài."Doãn Tư Thần nhíu mày, 
		đặt chi phiếu lên giường rồi đi mở cửa.Bữa sáng vô cùng phong phú, Doãn Tư Thần nhìn cô gái trong góc nói: "Đến ăn trước đi đã."Kết quả, cô gái vẫn ngồi khóc.
		Doãn Tư Thần cũng không nói nhiều, liền tự mình ăn, vừa ăn vừa nói: "Chuyện tối qua, tôi sẽ cho cô một lời giải thích, tôi cho cô năm trăm vạn, chuyện của chúng ta, cô không được tiết lộ 
		với bất kỳ ai."Cố Tư Tư lúc này ngẩng đầu lên! Cô sợ hãi nhìn người đàn ông xa lạ này, cái gì mà năm trăm vạn? Anh ta cho rằng cô bán thân sao?Người đàn ông này không biết 
		làm cách nào đuổi Trạch Cương đi, rồi chạy đến đây cùng với cô…..Bây giờ lại còn muốn dùng tiền để làm nhục cô…Cố Tư Tư càng nghĩ càng đau lòng, cho dù cô thật sự ngủ với hắn, 
		cô cũng kiên quyết không nhận số tiền này."Anh yên tâm, chuyện này tôi sẽ không nói ra."Cô làm sao có thể nói ra được!Cô lặng lẽ nhặt quần áo trên mặt đất lên, 
		xoay người vào nhà tắm.Nhìn mái tóc rối bù trong gương, hai mắt đỏ bừng, trông cô vô cùng chật vật. Thật không nghĩ mọi chuyện sẽ thành ra thế này.Lúc Cố Tư Tư đi, 
		Doãn Tư Thần còn đang nhàn nhã ăn bánh mì, dường như không thèm để ý đến việc cô rời đi, chỉ là tấm chi phiếu kia vẫn còn nằm trên giường, không biết là đang trêu ngươi ai.
		Vừa rời khỏi khách sạn Hilton, điện thoại của Cố Tư Tư vang lên, là tin nhắn của Triệu Trạch Cương."Tư Tư, hôm qua anh ở trong phòng đợi em cả đêm, em cũng không đến. 
		Em là vì có chuyện nên đến muộn sao? Không sao, anh sẽ tiếp tục chờ. Anh chuẩn bị cất cánh, chờ anh về nước sẽ mang quà cho em. Yêu em, Trạch Cương.Cố Tư Tư sửng sốt, hắn căn bản là
		không ở trong phòng, sao lại nói là ở trong phòng chờ cả đêm? Rốt cuộc là sai ở điểm nào?Lẽ nào Tiểu Nhã đưa nhầm thẻ phòng? Vẫn là…không, không có khả năng, Tiểu Nhã làm sao có thể 
		làm loại chuyện này.Cố Tư Tư cất điện thoại di động, nhìn xe cộ qua lại trên đường bỗng nhiên có chút bi thương, chờ Trạch về nước, bọn họ có lẽ cũng không thể quay lại nữa?
		Có lẽ, cứ kết thúc như vậy cũng tốt.Cố Tư Tư vừa nghĩ đến việc phải rời xa Trạch Cương, trong lòng không khỏi đau đớn, run rẩy.Tất cả mọi chuyện, đều vì tối hôm qua.Tiểu Nhã, 
		thật sự là cậu làm sao?Đầu dây bên kia tuyền đến giọng nói điện tử quen thuộc "Người bạn gọi hiện đã tắt máy", lúc này Cố Tư Tư phát hiện bản thân mình đã gọi cho Lâm Tiểu Nhã.
		'),
		(47, 4, 23, 27, 5, N'CEO nhất định muốn cưới tôi',CAST(N'2024-01-01T05:52:10.323' AS DateTime),null, 1, 
		N'Nhưng tiếc là không ai trả lời.Cô bước trên đường, nhớ lại tất cả chuyện của mình và Triệu Trạch Cương.Từ lúc bắt đầu yêu nhau, cho đến sự khẩn trương vui sướng của ngày hôm qua, 
		tất cả đều là ký ức tốt đẹp, giống như một thước phim tua ngược, từng cảnh từng cảnh đều sống động như thật, dần trở nên xa vời không thể với đến.Hôm qua bọn họ còn nói đùa về hôn lễ 
		tương lai, hắn còn cam đoan với cô trong vòng hai năm, mỗi ngày sẽ đều gọi điện thoại, gửi wechat, để cô có thể được nghe giọng của hắn, nhìn thấy gương mặt của hắn.Nhưng tất cả những 
		điều này, đều trở thành nguyện vọng không thể thực hiện.Cô thật sự còn có thể xem như chưa từng xảy ra chuyện gì, cùng hắn nói chuyện điện thoại, gửi tin nhắn wechat sao?Không thể 
		nữa rồi…Bọn họ cũng không thể có hôn lễ, không thể có con…Không có, cái gì cũng không có…Mội loạt tiếng thắng xe cùng tiếng chuông điện thoại dồn dập cắt đứt dòng suy nghĩ của 
		cô, cô chợt giật mình phát hiện mình đang đứng giữa đường, một chiếc xe đang dừng rất gần cô, gần đến mức suýt thì đụng vào.Cố Tư Tư rất nhanh thanh tỉnh lại, lùi về phía sau, nhìn xe 
		hơi lần nữa đi nhanh.Chuông điện thoại vẫn vang lên, cô xem, là mẹ của Triệu Trạch Cường gọi đến.Cô nhanh chóng lau nước mắt, bắt máy: "Dì…"Không đợi Cố Tư Tư nói xong, đầu dây 
		bên kia lạnh như băng cắt ngang lời nói của cô."Cô Cố, cô cũng thấy đấy, Trạch Cương của chúng tôi hiện đã được công ty cử sang nước ngoài để đào tạo chuyên sâu, chờ nó từ nước ngoài 
		trở về, giá trị con người của nó đương nhiên sẽ khác. Trước kia hai đứa ở bên nhau, tôi vốn không đồng ý, chỉ vì Trạch Cương nhà chúng tôi thích cô, nên tôi mới không nói gì.Hiện tại nếu 
		hai người đã không ở cùng một thành phố, hi vọng cô Cố có thể chủ động rời khỏi Trạch Cương của chúng tôi, đừng dây dưa với nó nữa."Tay cầm điện thoại của Cố Tư Tư hơi run lên."Tôi 
		cũng không giấu cô, lần này Trạch Cương ra nước ngoài, bên cạnh còn có một cô gái khác. Cô gái đó gia thế rất tốt, tương lai sẽ trợ giúp Trạch Cương nhà chúng tôi. Hơn nữa con bé cũng 
		rất thích Trạch Cương, cơ hội ra nước ngoài lần này chính là cô ấy mang lại, nên chúng tôi đều mong cô ấy sẽ là con dâu tương lại của Triệu gia. Cô Cố đến từ nông thôn phải không? 
		Thân phận như vậy sao có thể xứng với Trạch Cương nhà chúng tôi? Nếu chúng tôi ngăn cản, Trạch Cương sẽ không đồng ý chia tay, nhưng nếu là cô Cố chủ động nói chia tay..."Mẹ Triệu 
		Trạch Cương nói đến đây thì không nói nữa. Tất cả đều là người thông minh, cho dù không nói, cũng sẽ hiểu ý tứ của lời nói đó là gì.Cô và Trạch Cương rõ ràng là thật lòng yêu nhau, 
		tại sao mọi người đều muốn chia rẽ bọn họ?
		'),
		(48, 5, 23, 28, 5, N'Bị Ép Chia Tay',CAST(N'2024-01-01T05:52:10.323' AS DateTime),null, 1, 
		N'Cô đã bị hủy hoại, cô đã không còn tương lai nữa rồi, sớm muộn gì cô và Trạch Cương cũng sẽ phải chia tay, cuộc điện thoại này chỉ là để ngày đó đến sớm hơn mà thôi.Cố Tư Tư cố nén
		nước mắt nghẹn ngào, nói qua điện thoại: "Cháu hiểu rồi. Cháu sẽ làm theo ý dì."Đối phương nghe được câu trả lời của Cố Tư Tư lúc này mới hài lòng cúp máy. Cúp điện thoại,
		Cố Tư Tư đứng dưới ánh mặt trời chói chang, ngẩng cao đầu, không để cho nước mắt tràn mi.Cô cảm thấy toàn thân mình rất lạnh, lạnh như chưa từng.Mặt trời chói chang trên đầu,
		lòng cô lại lạnh như băng.Liên tiếp xảy ra những chuyện như vậy, Cố Tư Tư thật sự không còn cách nào có thể ép bản thân mình sống thoải mái.Cô đến công ty xin nghỉ, kéo lê thân
		thể mệt mọi, mang theo mộ trái tim đã vụn vỡ, ngồi xe đường dài về quê.Cô vốn cho rằng, khi cô về đến nhà, ít ra còn có thể tìm được một tia an ủi.Nhưng khi cô mở cửa phòng, 
		cô đã biết, đây chỉ là hy vọng xa vời."Tiện nhân quả nhiên chỉ có thể sinh ra tiểu tiện nhân! Nhìn xem con gái ngoan của cô, tuổi còn nhỏ mà đã cùng đàn ông đi thuê phòng!"
		Mẹ cô quỳ trên mặt đất, bà nội ném một sấp ảnh lên mặt bà.Mẹ cô đã lảo đảo sắp ngã, quả nhiên là bà đã quỳ rất lâu, trên mặt còn bị thương, trán còn bị tím bầm, rõ ràng là do 
		dập đầu.Bà nội lại khi dễ mẹ cô, chỉ là lần này không biết là vì điều gì."Mẹ----" Cố Tư Tư ném túi xách trong tay xuống đất, cô nhào đến cùng mẹ cô quỳ gối trước mặt bà nội:
		"Bà nội, mẹ con lại làm sai chuyện gì, sao lại đánh bà ấy?"Bà Cố khinh bỉ nhìn cô, bà cầm một tấm ảnh trên bàn, hung hăng ném vào mặt cô."Mày còn mặt mũi để hỏi đã làm sai điều 
		gì sao? Mẹ của mày ngay cả một đứa con cũng không sinh được, đây chính là sai lầm lớn nhất! Nuôi thứ tạp chủng ở bên ngoài cũng chẳng phải là thứ tốt đẹp gì!" Bà Cố chán ghét đảo mắt
		nhìn mẹ con cô một cái, đáy mắt không giấu được sự khinh bỉ: "Hôm nay có người trực tiếp mang những tấm ảnh này đến nhà! Nói mày cùng một tên đàn ông đi uống rượu mướn phòng? Đồ hạ 
		tiện, bại hoại, thật là làm ô nhục Cố gia của ta!"Nghe được những lời này, mặt Cố Tư Tư không còn một giọt máu, cô cầm tấm ảnh trên mặt đất lên nhìn, trên đó rõ ràng là hình ảnh
		của cô và người đàn ông đó cùng nhau ân ái!Cô đem ảnh chụp ném thật xa! Đây là thứ gì! Sao lại có những bức ảnh này?!Hơn nữa...những bức ảnh này sao lại ở trong tay bà nội!
		"Bà nội..." Cô mở miệng muốn giải thích, lại phát hiện mình lời nào cũng không thốt ra được, bởi vì tất cả trên ảnh đều là sự thật!Mẹ cô cố gắng giải thích: "Mẹ, mẹ...."
		'),
		(49, 6, 23, 28, 5, N'Bị Ép Chia Tay',CAST(N'2024-01-01T05:52:10.323' AS DateTime),null, 1, 
		N'Lời của mẹ cô còn chưa nói xong, bà Cố nóng giận đập bàn quát to: "Ai cho cô lá gan, dám ngụy biện! Ảnh chụp người ta đã gửi đến tận cửa rồi, chẳng lẽ còn có thể hãm hại con gái của cô
		sao? Lớn là gà không đẻ trứng, nhỏ thì không đứng đắn!"Bà Cố cầm chén trà ném mạnh vào trán mẹ Cố Tư Tư.Cố Tư Tư thấy bà nội lại muốn ném đồ, xoay người ôm lấy mẹ.
		"Choang---" tách trà trực tiếp rơi xuống sau lưng Cố Tư Tư, vỡ nát.Cố Tư Tư chỉ cảm thấy phía sau vô cùng nóng và đau nhức, toàn bộ phía sau lưng đều trở nên nóng bỏng, 
		phảng phất đau tựa như không phải là cơ thể của cô."Tư Tư..." Mẹ cô thấy Cố Tư Tư dùng cơ thể đỡ chén trà cho bà, hốc mắt liền đỏ bừng: "Con có đau không?"Cố Tư Tư khẽ lắc đầu,
		hốc mắt cô cũng đỏ lên.Chút đau này có là gì?Nhiều năm như vậy, nỗi đau mà mẹ cô phải chịu đựng còn nhiều hơn thế này.Bà Cố hừ lạnh một tiếng, bà không muốn xem hai người họ 
		tiếp tục diễn cảnh mẹ con tình thâm.Lúc này, trong TV rốt cuộc cũng kết thúc quãng cáo, trực tiếp phát một đoạn tin tức ngắn, từng tấm ảnh chụp được tung lên."Sáng sớm hôm nay,
		người thừa kế tập đoàn Doãn Thị - Doãn Tư Thần đã cùng một cô gái thuê phòng và bị chụp ảnh lại, nhìn ảnh chụp chúng ta có thể thấy phòng vô cùng lộn xộn, quần áo đầy trên mặt đất..."
		Bà Cố nhìn ảnh Cố Tư Tư trên TV, nhất thời tức giận không chịu nổi, cầm gậy trong tay lên, vung về phía hai mẹ con."Nghiệp chướng! Thuê phòng cũng có thể lên TV! Thật là mất mặt,
		Cố gia chúng ta sao lại nuôi ra một tiểu tiện nhân như mày! Các người cút hết cho ta! Cút!"Cố Tư Tư không ngờ chuyện này lại lên TV, nhưng hiện tại cô không có thời gian nghĩ đến 
		tin tức, cô và mẹ gắt gao ôm nhau, cắn răng chịu đựng, không dám phản kháng, lại càng không dám bước ra khỏi căn nhà này.Bởi vì chỉ cần một bước rời khỏi đây, thật sự sẽ không thể 
		trở vệ.Vừa lúc đó, ngoài cửa có một người bước nhanh vào, vừa vào cửa đã kêu lên: "Mẹ..."Cố Tư Tư nghe được giọng nói, ánh mắt liền hiện lên một tia hy vọng: Ba về rồi!Cô lập 
		tức dùng ánh mắt tràn ngập mong chờ nhìn ba, hy vọng ông có thể mở miệng cầu xin thay mẹ.
		'),
		(50, 1, 24, 29, 7, N'Trời sinh Song Mạch',CAST(N'2024-01-20T05:52:10.323' AS DateTime),null, 1, 
		N'Ngọ Hậu Tà Dương khuynh sái thế gian, cỏ xanh Y Y, cành liễu theo gió lắc nhẹ, một mảnh nhạ Đại Trang Viên ở dưới ánh tà dương lộ ra rất đẹp.
			Trang viên rộng lớn, vô số đình viện lầu các mọc như rừng, từ chỗ cao nhìn xuống mà xuống, trong trang viên nơi một mảnh lớn như vậy quảng trường là bắt mắt nhất, trên quảng trường một tên tướng mạo tuấn dật thiếu niên chính bàn ngồi chung một chỗ trên bồ đoàn.
			Thiếu niên ước chừng mười lăm mười sáu tuổi, dáng dấp mày kiếm mắt sáng, trên mặt đường ranh lăng giác rõ ràng, một đầu tóc đen bó buộc ở sau lưng, hai tay đặt ở trên đầu gối, tựa hồ đang tu luyện lại không có... Chút nào biến hóa.
			Trong hô hấp phun ra nuốt vào linh khí, tuy nhiên lại không cách nào chứa vào cơ thể, thẳng đến mặt trời chiều ngã về tây thiếu niên mới từ từ mở mắt, khẽ lắc đầu mang theo thất vọng vẻ mặt.
			“Ai, lại bạch ngồi một ngày, một chút linh khí cũng câu thông không, như thế nào mới có thể đến Thông Linh cảnh a”
			Thiếu niên than thở, mới vừa muốn đứng dậy rời đi lúc, xa xa ba người đi hướng thiếu niên đi tới, người cầm đầu nhìn qua tuổi rất trẻ, cùng ngồi xếp bằng ở trên bồ đoàn thiếu niên tuổi tác tương phản, lại dáng dấp rất là phổ thông, lúc này hắn đi tới thiếu niên bên cạnh khoanh tay trên mặt lộ ra vẻ trào phúng.
			“Ồ, Tử Hàn thiếu gia, còn đang tu luyện đây? Thế nào hôm nay thành quả tu luyện không rẻ đi”
			Ngồi xếp bằng ở trên bồ đoàn thiếu niên được đặt tên là Tử Hàn, chính là Lưu Vân Hoàng Triều bên trong một trong tứ đại gia tộc Tử Tộc Lục thiếu gia, lúc này Tử Hàn vị trí mảnh này trang viên là Tử Tộc tam đại chi nhánh một trong chỗ hoa rơi thành, hoa rơi thành đang chảy Vân Hoàng Triều bên trong cũng chỉ là một tòa trung đẳng thành trì, lại bởi vì cả thành hoa rơi mà nổi tiếng.
			Tử Hàn ngẩng đầu, nhìn trước mắt thiếu niên trong mắt mang theo chán ghét vẻ mặt, người vừa tới tên là Tử Lạc, là Tử Tộc mạch chi chủ Tử đọc hôn Tôn, cũng là điều này mạch rất có thiên phú thiên tài.
			“Mắc mớ gì tới ngươi, quản tốt chính ngươi chuyện liền cám ơn trời đất”
			Tử Lạc sửng sốt một chút cũng không tức giận, tựa hồ thói quen Tử Hàn giọng, khóe miệng vén lên một tia độ cong lộ ra châm chọc nụ cười, đạo “Ta đây không phải là quan tâm Tử Hàn thiếu gia mà, Tử Hàn thiếu gia nhưng là Tử Tộc Lục thiếu gia, đi tới chúng ta này thâm sơn cùng cốc dĩ nhiên phải nhốt tâm, mỗi ngày tự mình tới ‘Thăm hỏi sức khỏe’ một lần”
			Tử Hàn nghe được câu này lúc, bên người phù qua một trận gió nhẹ, ánh mắt run lên, cười lạnh nói “Đa tạ ngươi quan tâm, nhớ thay ta thăm hỏi sức khỏe cả nhà ngươi”
			Tiếng nói vừa dứt, Tử Lạc sắc mặt nhất thời lạnh lẻo, đồng tử co rúc lại đang lúc, đạo “Tử Hàn, ngươi thật đúng là tự cho là đúng, ngươi thật đem mình làm Tử Tộc Lục thiếu gia, ngươi chẳng qua chỉ là Tử Tộc đày đi đến hoa rơi thành vứt đi, một cái mười sáu tuổi Liên Thông Linh Cảnh cũng không có đến phế vật thôi”
			“Im miệng, ngươi là cái thá gì”
			Tử Hàn sắc mặt biến được (phải) xanh mét, mở miệng rầy, vừa muốn đứng dậy, Tử Lạc lại một cước đá vào Tử Hàn trên người, nhất thời đem Tử Hàn đá lộn mèo, cút qua một bên, nâng lên một trận nhẹ Trần.
			Tử Hàn giận dữ lại còn phản ứng không kịp nữa, liền bị Tử Lạc một cước giẫm ở Tử Hàn nơi ngực, Tử Hàn chỉ cảm thấy ngực đau nhói, cơ hồ không thở nổi.
			“Ta là cái thá gì? Ở chỗ này ta đương nhiên coi là món đồ”
			Tử Lạc mở miệng, nhưng khi hắn nói xong thời điểm lại cảm thấy có gì không đúng tinh thần sức lực địa phương, chờ hắn khi phản ứng lại sau khi, lời đã không thu về được.
			“Ha ha ha”
			Tử Hàn cười to, khóe miệng còn treo móc một vệt máu, cười nói “Đúng, ngươi xác thực coi là món đồ, còn là một đồ khốn”
			Ba!
			Một cái vang dội bạt tai vang lên, ở Tử Hàn ở nói xong câu đó thời điểm, Tử Lạc một cái tát ở Tử Hàn trên mặt, một cái đỏ tươi dấu bàn tay nổi lên, năm ngón tay rõ ràng, Tử Hàn yên lặng chốc lát, sắc mặt dần dần đỏ lên, trên trán nổi gân xanh, giùng giằng muốn đứng dậy, Tử Lạc lại lần nữa nhấc chân, một cước đem Tử Hàn đá bay ra ngoài.
			“Ho khan một cái”
			Tử Hàn lần nữa lăn xuống đi ra ngoài, trong miệng phát ra tiếng ho khan, lúc này hắn chết chết cúi đầu, cả người khẽ run, mười ngón tay nắm chặt, đốt ngón tay đã bóp trắng bệch, hai cái quả đấm đang khe khẽ run rẩy đến, ngẩng đầu nhìn về phía Tử Lạc lúc, trong ánh mắt mang theo khuất nhục hận ý, mở miệng đang lúc thanh âm đang phát run “Tử Lạc, ta sẽ nhượng cho ngươi trả giá thật lớn, một tát này ngươi nhớ cho ta, ngày sau ta sẽ gấp mười gấp trăm lần trả lại ngươi”
			Phi!
			Tử Lạc hướng Tử Hàn trên mặt phun một bãi nước miếng,
			Trong mắt tất cả đều là khinh miệt, trong thanh âm tràn đầy giễu cợt, đạo “Chỉ bằng ngươi? Một đại đội linh khí cũng không cảm giác được phế vật? Thật không nghĩ ra phụ thân ngươi cũng coi như một nhân vật, làm sao biết sinh ra ngươi một phế vật như vậy đến, thật là hổ phụ khuyển tử a”
			“Im miệng, khốn kiếp”
		'),
		(51, 2, 24, 29, 7, N'Trời sinh Song Mạch',CAST(N'2024-01-20T05:52:10.323' AS DateTime),null, 1, 
		N'Tử Hàn một cái bước dài xông lên, lửa giận trong lòng dấy lên, hôm nay hắn liên tục chịu nhục, trong lòng sớm đã là lên cơn giận dữ, giơ tay lên chính là một quyền hướng Tử Lạc đánh, nhưng là Tử Hàn đứng tại chỗ khinh miệt nhìn hắn, hoàn toàn xem nhẹ hắn một quyền, giơ tay lên đang lúc bắt lại Tử Hàn cổ tay.
			“Chỉ bằng ngươi cũng dám mắng ta?”
			Tử Lạc khẽ cau mày, bàn tay dùng sức đang lúc, một cổ vặn vẹo cảm giác đau đớn từ Tử Hàn trên cánh tay truyền tới, Tử Lạc lại không có buông tay ý tứ, gắt gao nắm Tử Hàn tay, mặt đầy tất cả đều là vẻ đắc ý.
			“Ngươi quỳ xuống yêu cầu ta, hôm nay ta sẽ bỏ qua ngươi”
			Tử Hàn trên trán mồ hôi lớn chừng hạt đậu không ngừng lăn xuống, cảm giác đau đớn để cho hắn không tránh khỏi nghĩ (muốn) phải quỳ xuống, nhưng trong lòng có cảm giác nhục nhã, mà hắn vốn là một cái lòng tự ái cực mạnh người, làm sao biết tùy tiện thuyết phục, mặc dù liều mạng tay bị vặn gảy kết quả cũng phải chết cắn không nhả ra.
			“Ồ, xương còn rất cứng rắn, vậy cũng chớ trách ta”
			“Dừng tay” xa xa vang lên một đạo thanh thúy thanh thanh âm, trong mắt một tia lạnh lùng ánh mắt nhìn về phía nơi này, đó là một tên tướng mạo rất là Tú thiếu nữ xinh đẹp, lúc này chính nhìn xa xa Tử Lạc, mở miệng mắng “Tử Lạc, hôm nay ngươi quá mức”
			Tử Lạc nhìn thiếu nữ nhất thời cả kinh, ngay cả vội buông ra Tử Hàn tay, cung kính nói “Tử Nguyệt Đường tỷ”
			Tử Lạc nhìn Tử Nguyệt, thân thể khẽ run lên, phát từ đáy lòng sợ hãi, quay đầu đang lúc lạnh lùng liếc mắt nhìn Tử Hàn, lập tức mang theo hai người hướng xa xa rời đi, Tử Nguyệt lên tiếng hắn không dám còn nữa đến tiến một bước động tác, bởi vì Tử Nguyệt chính là điều này mạch lớn nhất thiên phú Thiên Chi Kiêu Nữ.
			Tử Hàn nhìn Tử Lạc đi xa, khoanh tay, hướng Tử Nguyệt đi tới, nhưng là Tử Nguyệt lại cũng không nhìn hắn cái nào, xoay người chậm rãi hướng phía sau đi tới.
			Tử Hàn nhướng mày một cái, khóe miệng có chút co quắp, do dự một chút, cuối cùng mở miệng nói “Cám ơn ngươi”
			Một trận từng cơn gió nhẹ thổi qua, Tử Nguyệt lại giống như không nghe thấy, chưa từng quay đầu, dừng chân lại, mang theo một tia cười khẽ, Tử Hàn không biết nàng vì sao mà cười, trong lúc mơ hồ lại mang theo một tia giễu cợt ý, âm thanh âm vang lên, mang theo bình thản nói “Ngươi không cần cám ơn ta, ta chỉ là thấy ngươi đáng thương thôi”
			Tử Nguyệt đi xa, từ đầu chí cuối cũng không có xem qua Tử Hàn liếc mắt
			“Chẳng qua là xem ta đáng thương thôi, ha ha”
			Tử Hàn dựa vào một cây liễu, nhìn trước mắt hồ, không ngừng hồi tưởng mới vừa rồi việc trải qua nhất mạc mạc, trong miệng không ngừng lặp lại đến câu nói kia, trong lòng mang theo khuất nhục phẫn hận không cam lòng, trên mặt nóng bỏng cảm giác như cũ không tán, một cái tay thùy rơi trên mặt đất, tựa hồ cánh tay trật khớp, một cái tay khác lại nắm chặt quả đấm một quyền đập xuống đất, trong mắt trong suốt mang theo nước mắt, lại cố gắng khống chế không để cho nước mắt chảy xuống tới.
			“Tại sao ta không thể tu hành, tại sao ta trời sinh chỉ có hai cái căn mạch, tại sao”
			Tử Hàn hướng về phía bờ hồ hô to, nhắm mắt lại hít một hơi thật sâu, muốn đem nước mắt nuốt xuống, mà thanh âm hắn quanh quẩn, quả đấm không ngừng nện mặt đất, máu tươi đã hạ xuống.
			Cách đó không xa một con gà con tử mà nghiêng người dựa vào đến một cây liễu, đậu xanh mắt to thích ý nhìn trước mắt phong cảnh, màu trắng lông chim ở dưới ánh trăng lại tỏa ra ánh sáng lung linh, đưa ra cánh nhẹ nhàng cho mình quạt gió, chậm rãi mở miệng nói “Không nghĩ tới Bản vương bị phong ấn 3000 năm, hôm nay rốt cuộc đột phá Phong Ấn”
			Vốn là đang hưởng thụ Kê Tử Nhi lại bị Tử Hàn Đột Như Kỳ Lai thanh âm dọa cho giật mình, nhìn về phía Tử Hàn chỗ phương hướng, mang theo tả oán nói “Đại buổi tối, rêu rao bậy bạ cái gì, không thì là không thể tu hành sao, không phải là chỉ có hai cái kinh mạch sao, có cái gì cùng lắm, Ừ? Vân vân, hai cái kinh mạch?”
			Kê Tử Nhi đột nhiên đứng lên nhìn cách đó không xa, thấy người thiếu niên kia bóng người, hai khỏa đậu xanh mắt to nhất thời sáng lên, hiện lên phát sáng chỉ nhìn Tử Hàn, trong thanh âm mang theo kinh hỉ.
			“Trời sinh Song Mạch, ta không nghe lầm chứ, lại là trời sinh Song Mạch”
			Con gà con nhất thời bước ra hai cái móng gà, hướng Tử Hàn chỗ phương hướng phác đằng đi, trong mắt mang theo vẻ vui mừng, vọt tới Tử Hàn trước mặt, trong mắt hiện lên hào quang nhìn Tử Hàn, không ngừng đạp nước hai cái cánh.
			Tử Hàn hít một hơi thật sâu, nhìn Kê Tử Nhi, tự giễu cười một tiếng nói “Thế nào? Tiểu Kê Tử Nhi ngươi cũng là xem ta đáng thương, tới cười nhạo ta sao?”
			“Bản vương không phải là Kê Tử Nhi”
			Tiểu Bạch Kê nhìn Tử Hàn nhất thời lộ ra vẻ tức giận, lại không có chân chính nổi giận.
			Tử Hàn nhìn Kê Tử Nhi đầu tiên là cảm thấy cả kinh, đánh giá nó kinh ngạc nói “Ai nuôi gia đình cầm, lại còn biết nói chuyện?”
			“Bản vương không phải là gia cầm, ngươi mới là gia cầm”
			“Chẳng lẽ là đi địa Kê? Thả rông?”
		'),
		(52, 3, 24, 29, 7, N'Thượng cổ truyền thừa',CAST(N'2024-01-20T05:52:10.323' AS DateTime),null, 1, 
		N'“Bản vương chính là Cửu Thiên Thập Địa, Đồ Thần diệt Thánh Huyết Nguyệt Vương”
			Kê Nhi đạp nước cánh, hạt đậu Con mắt to cố gắng trợn to nhìn Tử Hàn, hết mình có thể làm ra một bộ hình tượng cao lớn vì chính mình tranh cãi đến.
			“Ai!”
			Tử Hàn tựa hồ không có nghe thấy Kê Tử Nhi lời nói, khe khẽ thở dài một hơi nhìn phía xa, có chút thất thần đạo “Một cái gia cầm cũng so với ta có thiên phú, xem ra ta thật là cái phế vật”
			Phàm là Yêu Thú lấy huyết mạch mà nói, huyết mạch cường đại yêu thú linh trí cực cao trời sinh là được miệng nói tiếng người, thậm chí ở trong tộc đại có thể dưới sự trợ giúp đều có thể hóa thành hình người, cũng có thật nhiều Yêu Thú lấy được không tưởng được tạo hóa, cũng có thể miệng nói tiếng người.
			“Đều nói Bản vương không phải là gia cầm, Bản vương chính là Huyết Nguyệt Vương, Đồ Thần diệt Thánh Huyết Nguyệt Vương” Kê Tử Nhi rối rít có chút mất hứng dáng vẻ.
			Tử Hàn cười một tiếng đứng dậy, dọc theo bờ hồ bước từ từ, nhìn có chút đục ngầu nước hồ, đốt ngón tay đang lúc từng giọt máu tươi không ngừng nhỏ giọt xuống, nhỏ tại trong hồ, từng vòng khuếch tán ra, Kê Nhi nhìn hắn bóng lưng, đạp nước cánh vọt tới Tử Hàn trước mặt ngăn lại Tử Hàn đường đi.
			“Ngươi cũng cảm thấy ta đáng thương, muốn chế giễu ta sao?”
			Tử Hàn ngồi xổm người xuống một cái tay nâng lên Kê Nhi, Tiểu Tiểu Kê Nhi chỉ lớn chừng bàn tay, nhìn Kê Tử Nhi, trong mắt cũng không có gì kinh hỉ, cho dù nó biết nói chuyện cũng giống vậy, dù sao trong thiên địa có rất nhiều linh trí cực cao Yêu Thú, lúc mới sinh ra liền có thể miệng nói tiếng người.
			“Tiểu tử, ta cho ngươi biết, ngươi gặp phải Bản vương coi như số ngươi gặp may, Bản vương năm đó nhưng là Đồ Thần diệt Thánh, chiến vô bất thắng tồn tại, Chân Long Thiên Phượng gặp Bản vương cũng phải xa xa đường vòng đi”
			Kê Tử Nhi hai cái cánh vác chắp sau lưng, tương đối có thành tựu vừa nói, Tử Hàn nhìn nó, cũng không để ý nó nói cái gì, đạo “Ngươi hữu danh tự sao?”
			“Không phải là nói qua cho ngươi, Bản vương chính là Huyết Nguyệt Vương sao? Huyết Nguyệt Vương nghe nói qua chưa? Rất lợi hại cái đó Huyết Nguyệt Vương, ai, thật là không có kiến thức”
			“Ta gọi là ngươi Huyết Nguyệt đi”
			Tử Hàn đưa tay, đem Huyết Nguyệt để dưới đất, nhẹ giọng mở miệng nói “Huyết Nguyệt chúng ta tới trò chuyện một chút đi”
			“Trò chuyện cái gì trò chuyện, Bản vương bề bộn nhiều việc”
			Tử Hàn cũng không để ý tới nó nói cái gì, tự hồ chỉ là coi nó là làm một cái bày tỏ đối tượng, đem mình nhiều năm trước tới nay sự tình hướng về phía Huyết Nguyệt kể lể một bên, Huyết Nguyệt vốn là bất đắc dĩ nghe, sau đó đáy mắt lộ ra một tia căm giận, sau đó giận tím mặt, đánh một cái cánh mắng to lên.
			“Đồ chơi gì? Hôm nay ngươi lại là bị người đánh cho thành bộ dáng này, còn bị đánh mặt nhổ nước miếng? Quan trọng hơn là ngươi lại bị một cái cô gái nhỏ đáng thương, này cũng coi là chuyện gì? Người anh em ngươi cũng quá thảm chứ?”
			Huyết Nguyệt một bộ lão khí hoành thu tựa như quen bộ dáng, vỗ nhè nhẹ chụp Tử Hàn, Tử Hàn miễn cưỡng lộ ra một nụ cười châm biếm, lần nữa than nhẹ.
			Huyết Nguyệt lúc này mặt đầy căm giận, lải nhải không ngừng mắng, không biết tại sao, Tử Hàn nghe Huyết Nguyệt nhổ nước bọt, tâm tình dần dần chừng mấy phút, trước mắt tiểu gia hỏa không chỉ biết tiếng người lời nói hơn nữa còn rất trêu chọc, bất giác đang lúc Tử Hàn bị chọc cười.
			Mà sau một khắc, Huyết Nguyệt lại đột nhiên trở nên nghiêm túc, hết sức cẩn thận đạo “Thiếu niên Lang, ngươi nghĩ trở nên mạnh mẽ sao?”
			Tử Hàn sững sờ, sau đó khẽ cười nói “Ở cái thế giới này có ai không nghĩ trở nên mạnh mẽ, nhưng là ta trời sinh chỉ có hai cái kinh mạch, căn bản là không có cách tu hành, mười sáu tuổi ngay cả linh khí cũng câu thông không”
			“Ngươi thật là trời sinh chỉ có hai cái kinh mạch?”
			Huyết Nguyệt ánh mắt trở nên quái dị, đôi mắt sâu bên trong lại mang theo một tia nóng bỏng, có lẽ nói khao khát.
			Tử Hàn bất đắc dĩ, nhếch miệng lên vẻ tự giễu độ cong, đạo “Lừa ngươi làm gì, lừa ngươi ta còn chưa phải là chỉ có hai cái kinh mạch, thì có ích lợi gì”
			Huyết Nguyệt nghe vậy, đưa ra một cái cánh kéo Tử Hàn ngón giữa, Tử Hàn có chút quái dị nhìn nó, đột nhiên Tử Hàn nhíu mày, bởi vì một cổ linh lực chính theo ngón giữa không có vào trong thân thể hắn, đi tới cái kia chỉ có hai cái trong kinh mạch, đáy mắt dần dần lộ ra một tia mừng rỡ.
			'),
		(53, 4, 24, 29, 7, N'Thượng cổ truyền thừa 2',CAST(N'2024-01-20T05:52:10.323' AS DateTime),null, 1, 
		N'Lần đầu tiên, Tử Hàn lần đầu tiên cảm nhận được linh lực tồn tại, nhưng mà nhìn Huyết Nguyệt thời điểm đáy mắt lộ ra vẻ kinh hãi, vốn là trong mắt hắn chỉ là một cái không biết bay gia cầm,
			Thậm chí có linh lực tồn tại, nghĩ tới đây Tử Hàn vẻ mặt lại lần nữa mất mác.
			“Một cái gia cầm cũng có thể tu luyện, ta ngay cả chỉ gia cầm cũng không bằng”
			“Ha ha ha, quả nhiên chỉ có hai cái kinh mạch, ha ha ha, quả là như thế”
			Tử Hàn nghe được Huyết Nguyệt tiếng cười lớn, nhất thời nhíu mày đến, tại hắn trong tai đây là trần truồng giễu cợt, hơn nữa còn lớn tiếng như vậy, lớn lối như vậy, Tử Hàn sắc mặt xanh mét nhấc chân một cước đá vào Huyết Nguyệt trên người, nhưng là ở Tử Hàn đá vào Huyết Nguyệt trên người thời điểm, hắn cảm giác chỉ to cỡ nắm tay Huyết Nguyệt, lại như một tòa núi cao một loại không thể rung chuyển.
			“Ngay cả ngươi cũng cười nhạo ta, đáng chết đồ vật”
			Tử Hàn khập khễnh hướng phía sau đi tới, Huyết Nguyệt nhìn Tử Hàn bộ dáng, ngưng cười âm thanh, thanh âm đột nhiên trở nên nghiêm túc, đạo “Phàm nhân, Bản vương cũng không có cười nhạo ngươi”
			“Lớn tiếng như vậy còn chưa phải là cười nhạo ta? Kia nếu là cười nhạo ta lại nên như thế nào?”
			Tử Hàn quay đầu, Huyết Nguyệt vẻ mặt càng phát ra nghiêm túc nói “Thiếu niên Lang, ngươi có thể biết ngươi chính là trong truyền thuyết trời sinh thánh mạch, có tối cao thiên phú tu luyện, gặp phải ngươi như thế tư chất nghịch thiên Bản vương làm sao có thể không cười”
			“Ngươi là con gà, không khoác lác ngươi có thể chết a, nếu là ta ủng có vô thượng thiên phú, còn có thể mười sáu tuổi cũng tu luyện không ra linh lực?”
			“Phàm nhân” Huyết Nguyệt thanh âm mang theo tiếng cười khẽ vang lên, đạo “Đó là bởi vì ngươi không có thích hợp ngươi thể chất công pháp, nhưng là ngươi gặp phải Bản vương, Bản vương có thể để cho ngươi Nhất Phi Trùng Thiên, đạt tới tối cao thành tựu”
			Tử Hàn trong ánh mắt lộ ra ánh sáng, nhìn Huyết Nguyệt trong mắt mang theo một tia khao khát, dù sao hắn đã trầm luân mười sáu năm, phàm là có một chút hy vọng hắn cũng sẽ không buông khí, hắn chịu đựng quá nhiều làm nhục, hắn nghĩ (muốn) phải trở nên mạnh, tìm về thuộc về mình tôn nghiêm.
			“Thật sao?” Thanh âm hắn vào giờ khắc này lại run rẩy.
			“Ngươi cũng đã biết, trời sinh Song Mạch không người nào là có một không hai năm phiến thiên địa Tuyệt Thiên chi chi phí, trời sinh Song Mạch, được gọi là thánh mạch, nhất mạch là linh, nhất mạch là Hồn, linh lực Hòa Hồn lực hai ngày nghỉ, càn quét đồng giai vậy đều không phải là chuyện”
			Huyết Nguyệt dứt lời đưa ra cánh đang lúc, một mảnh ánh sáng màu bạc chớp động, Tử Hàn trước mắt không gian dần dần vặn vẹo, đây là hắn cho tới bây giờ chưa từng cảm thụ ba động, Huyết Nguyệt trước người xuất hiện một quyển phong cách cổ xưa điển tịch, hiện lên u ám linh lực, vô hình trung bốn phía linh khí phảng phất đang bị cuốn này điển tịch cắn nuốt.
			“Này, đây là?”
			Huyết Nguyệt một cái nhảy nhót, đứng ở trong điển tịch, đắc ý nói “Đây là thượng cổ truyền thừa, được xưng Vô Thượng Bảo Điển thượng cổ Thôn Linh Điển, Thôn Thiên Phệ Địa, không có gì không nuốt, không có gì không thôn phệ, chính là ba ngàn năm trước thượng cổ Thôn Linh Đế tối cao tuyệt học”
			Ba!
			“Ô kìa!”
			Tử Hàn, một cái tát đem phiến mở đứng ở trong điển tịch Huyết Nguyệt, hai tay nâng lên Thôn Linh Điển, Thôn Linh Điển mang theo phong cách cổ xưa thần bí ý, phảng phất trải qua tang thương, Tử Hàn hai cái tay nhẹ nhàng run rẩy, trong mắt lộ vẻ kích động cùng khao khát, nhẹ nhàng mở ra Thôn Linh Điển lại phát hiện mình căn bản lật bất động.
			“Đánh như thế nào không mở?”
			Huyết Nguyệt bò dậy, u oán nhìn Tử Hàn, đạo “Tích ra một giọt máu tươi ở phía trên, nếu như Thôn Linh Điển công nhận ngươi, ngươi liền có thể mở ra”
			“Thật sao?”
			Tử Hàn đưa ngón trỏ ra, nhướng mày một cái cắn bể đầu ngón tay, một giọt đỏ thẫm máu tươi rơi vào Thôn Linh Điển bên trên.
			Máu tươi rơi vào Thôn Linh Điển bên trên, chỉ một thoáng, một cổ u ám linh lực cuốn mà ra, tự Thôn Linh Điển bên trên càn quét đi ra ngoài, vô số đạo linh lực phá vỡ hồ, trước mắt hồ lại đang kia từng đạo linh lực ra đời sinh phá vỡ, nước chảy ngừng đang chậm rãi biến mất, giống như bị cắn nuốt một dạng vô số cây liễu ái mộ, chi điều chiết rơi vào đất, Tử Hàn thu hồi ánh mắt trong lòng không nhịn được đang rung rung.
			“Này, đây là chuyện gì xảy ra?”
			Ồn ào!
			Một vệt hào quang tự Thôn Linh Điển cuốn đi ra, Huyết Nguyệt nhìn tia sáng kia Hoa, kinh ngạc đến ngây người, đứng tại chỗ nhìn tia sáng kia Hoa, lẩm bẩm nói “Quả nhiên, Linh Đế thật công nhận hắn, trời sinh thánh mạch, hắc hắc, lần này phát, lại có thể lần nữa giả bộ X”
			Thôn Linh Điển lúc này hóa thành một đạo u ám Lưu Quang thẳng không có vào Tử Hàn mi tâm, chỉ một thoáng một cổ ý chí chỉ dẫn Tử Hàn xếp bằng ngồi dưới đất, chậm rãi nhắm mắt lại, sau một khắc khi hắn khi mở mắt ra sau khi chính mình xuất hiện ở một mảnh u ám không gian, trước mắt hắn không có một tia sáng, toàn bộ ánh sáng tựa hồ cũng bị cắn nuốt không chút tạp chất.
			Ầm!
			Một đạo to lớn âm thanh âm vang lên, vô số bóng người hiện lên u ám trong hư không, phảng phất Chư Thiên Thần Ma, hiện lên hỗn độn khí hơi thở che giấu chân thân.
			Tử Hàn nhìn về phía khắp nơi, tựa hồ có vô số con mắt theo dõi hắn.
			“Ta là Thôn Linh Thiên Đế, ngươi được (phải) Thôn Linh truyền thừa, tự mình Bản Đế truyền nhân, nay, Bản Đế truyền cho ngươi thượng cổ Đế trải qua —— Thôn Linh Điển”
			“Đế, Đế Kinh?”
			Một giọng nói vang lên, vọng về ở Tử Hàn bên tai, mang theo rộng lớn khí, giống như Tế Tự chi âm, dâng lên Thần Ma oai, từng đạo trải qua âm thanh khắc vào Tử Hàn trong đầu, không ngừng quanh quẩn, ở trước mắt hắn hiện ra từng đạo hình ảnh, một đạo vĩ ngạn bóng người, đưa tay đang lúc hóa thành một cơn lốc xoáy che giấu thiên địa, nuốt tẫn Nhật Nguyệt Tinh Thần...
			“Thiên Địa Vạn Vật, Tương Sinh Vô Tướng, Thôn Thiên Phệ Địa, Vạn Pháp Bất Xâm...”
			Tử Hàn Tĩnh Tĩnh nhìn trong thiên địa, trong đầu từng đạo hư ảnh đang ngưng kết, giờ phút này Tử Hàn hai tay Kết Ấn, ngồi xếp bằng ở bờ hồ, từng đạo u ám linh lực không có vào thân thể của hắn, đỉnh đầu hắn bên trên một cái vòng xoáy ngưng tụ, cắn nuốt trong thiên địa vô số linh lực...
		'),
		(54, 5, 24, 29, 7, N'Thông Linh cảnh',CAST(N'2024-01-20T05:52:10.323' AS DateTime),null, 1, 
		N'Tử Hàn ngồi xếp bằng ở bờ hồ, cố gắng hết sức an tĩnh, trong đầu hắc ám toàn bộ thối lui, không ngừng hồi tưởng những thứ kia cổ xưa tối tăm câu nói, trong tay bắt đầu kết xuất không lưu loát Ấn Pháp, tay tại kết xuất Ấn Pháp thời điểm lại đang không nhịn được khẽ run.
			Vô số lần thất bại Tử Hàn đã sợ thất bại, nếu như thất bại nữa, chỉ sợ hắn thật sẽ mất đi thật sự có lòng tin, không biết như thế nào tự xử, từ nay chưa gượng dậy nổi.
			“Thiếu niên Lang, trầm Tâm Tĩnh khí, tập trung ý chí, bắt đầu vận chuyển Thôn Linh Điển”
			Huyết Nguyệt âm thanh âm vang lên, Tử Hàn tâm niệm vừa động, sau một khắc một đạo yếu ớt linh khí hội tụ đến trong tay hắn Ấn Pháp bên trên, nhẹ nhàng lưu chuyển đang lúc không có vào thân thể của hắn, tụ vào hắn Linh Mạch bên trong, cảm nhận được này một tia biến hóa rất nhỏ, Tử Hàn trong lòng khẽ run lên.
			Dựa theo Thôn Linh Điển bên trên công pháp vận chuyển, từng đạo linh khí toàn bộ hướng Tử Hàn thu liễm, không có vào trong thân thể hắn, từng luồng linh khí ở Ấn Pháp bên trong hóa thành linh lực không có vào thân thể của hắn, Tử Hàn lộ ra nét mừng, lúc này hắn cảm giác mình giống như một cái vòng xoáy, chỉ cần ngồi ở chỗ đó linh khí sẽ liên tục không ngừng hướng hắn họp lại, lúc này những thứ kia ngưng tụ linh lực hướng hắn nơi mi tâm ngưng tụ hóa thành một cái tiểu điểm sáng nhỏ.
			Thời gian qua rất lâu, Tử Hàn cảm thấy quanh thân linh khí đã kinh biến đến mức mỏng manh, sau đó trong tay Ấn Pháp tản đi, Tử Hàn mở mắt đáy mắt lộ ra vẻ mừng như điên, đứng dậy phát hiện mình bị thương đều đã khỏi hẳn, hơn nữa hắn cảm thấy thân thể của hắn biến hóa cường đại lên.
			“Ta, ta thật có thể tu luyện?”
			Tử Hàn cảm giác có chút khó tin, cảm thụ chính mình nơi mi tâm có một quả điểm sáng, tiểu điểm sáng nhỏ giống như đạo thu nhỏ lại Phù Văn, lại mang theo hắn chưa bao giờ nắm giữ qua linh lực.
			“Ha ha ha, linh mẫn ấn, ta tu luyện ra Linh Ấn”
			Tử Hàn mừng như điên, bởi vì chính mình tu luyện ra Linh Ấn, mà cái gọi là Linh Ấn là Tu Luyện Giả lúc tu luyện, khắc họa trong thiên địa linh khí hóa thành chính mình linh lực, chỉ có ngưng tụ Linh Ấn mới là tài năng đem linh khí hóa thành Linh Ấn, ngưng tụ Linh Ấn liền ý nghĩa Tử Hàn đạt tới Thông Linh cảnh.
			Cái gọi là Thông Linh cảnh là cái thế giới này Tu Luyện Giả yếu nhất tồn tại, kỳ trên có Hóa Linh kính, Linh Tinh cảnh, linh hướng cảnh, bị gọi là Tứ Linh cảnh, nhưng mà Tứ Linh cảnh vẫn ở chỗ cũ phàm nhân phạm vi bên trong, Tứ Linh cảnh trên còn có ba Thần Chi Cảnh, nếu muốn đạt tới ba Thần Chi Cảnh phải trải qua Linh Thần cửu chuyển, cửu chuyển sau khi phương đắc thành Thần, nếu là đạt tới ba Thần Chi Cảnh tu sĩ đem sẽ có long trời lở đất biến hóa, không chỉ có thể nắm giữ kéo dài Thọ Nguyên, hơn nữa có thể hô phong hoán vũ, điều động trong thiên địa lực lượng, giống như thần linh.
			Nghe Tử Hàn tiếng cười điên cuồng, cách đó không xa một tảng đá cạnh, Huyết Nguyệt chính nghiêng người dựa vào đến, lười biếng nói “Ta liền nói với Bản vương lăn lộn không sai đi”
			Tử Hàn tiến lên, trong lòng vui mừng, cảm nhận được chính mình tốc độ thậm chí có chất tăng lên, cảm thụ thân thể của mình bên trong dũng động lực lượng, nghĩ (muốn) lên mình ban đầu tại sao lại ở Tử Lạc trong tay không còn sức đánh trả chút nào, lúc này Tử Hàn mới hiểu được phàm nhân cùng tu sĩ chênh lệch đến tột cùng là bao lớn.
			“Cám ơn ngươi, thật là rất cảm tạ”
			Tử Hàn duỗi tay nắm lấy Huyết Nguyệt cánh dùng sức giũ, Huyết Nguyệt một trận choáng váng đầu, đánh văng ra Tử Hàn tay, nhìn hắn, mở miệng nói “Nhĩ kích động cái rắm, không phải là đột phá cái Thông Linh cảnh sao? Tại sao ư nhĩ”
			“Nhĩ sẽ không hiểu ta tâm tình lúc này, chỉ có nắm giữ thực lực ta mới sẽ không lại bị người lăng nhục, mới có thể giống người như thế còn sống, lấy được người khác tôn trọng”
			“Ai, đáng thương oa”
			Huyết Nguyệt ngông nghênh đi tới Tử Hàn bên cạnh, nói “Nhĩ sau này đi theo Bản vương lăn lộn, Bản vương cho ngươi ăn ngon mặc đẹp, mang theo nhĩ giả bộ X, mang ngươi bay”
			Tử Hàn hiếu kỳ nhìn Huyết Nguyệt, hỏi “Nhĩ không phải là chỉ gia cầm sao? Sẽ còn bay?”
			“Nói cho ngươi biết Bản vương không phải là gia cầm, nhĩ lại nói Bản vương là gia cầm, Bản vương với ngươi tuyệt giao”
			Ngạch
			Tử Hàn có chút không nói gì, nhớ tới mình và nó tựa hồ thật không có giao tình gì, bất quá lại thật cảm kích Huyết Nguyệt, dù sao không có Huyết Nguyệt, hắn không thể nào tu luyện, cười nói “Huyết Nguyệt, thật là cám ơn ngươi, ngay cả quý giá như vậy công pháp cũng không tiếc cho ta”
			"Xài cho đúng tác dụng nha,
			Nếu thích hợp nhĩ đưa nhĩ lại ngại gì "
			Huyết Nguyệt một bộ phóng khoáng bộ dáng, Tử Hàn cảm thụ thân thể của mình bên trong sóng linh lực, kích động nhìn Huyết Nguyệt nói “Công pháp này lợi hại như vậy, chỉ sợ là Huyền Giai công pháp chứ?”
			“Huyền Giai?”
			Huyết Nguyệt đột nhiên nhìn Tử Hàn, giống như nhìn người ngu ngốc như thế, đạp nước cánh, la lên “Huyền nhĩ đại gia, như vậy công pháp nghịch thiên nhĩ nói cho ta là Huyền Giai công pháp? Nhĩ kia ngọn núi tới Dã Nhân?”
			Trên cái thế giới này có rất nhiều tu luyện công pháp, đại khái chia làm Phàm giai, Huyền Giai, Linh Giai, Thần Giai, Thánh Giai năm cá cấp bậc, mỗi một đăng cấp công pháp lại chia ra làm Thượng Trung Hạ ba cái Phẩm Giai, mà Phàm giai công pháp bình thường nhất, rất nhiều tu sĩ cũng có thể có được, mà Thần Giai công pháp nhưng là chí bảo, ở thế lực lớn bên trong bị coi như nòng cốt bảo vật, Thánh Giai loại này đẳng cấp công pháp tựa hồ chỉ tồn tại ở trong truyền thuyết.
			Tử Hàn bất đắc dĩ, hai mắt tỏa sáng, nhìn Huyết Nguyệt, đạo “Chẳng lẽ đây là Linh Giai công pháp hay sao? Chúng ta Tử Tộc cũng mới có một quyển Linh Giai hạ phẩm công pháp, lần này thật là nhặt được bảo”
			“Ngươi một cái Dã Nhân, ngươi là nhiều lắm không có kiến thức a, ai”
			Huyết Nguyệt khe khẽ thở dài một hơi, không nghĩ để ý tới Tử Hàn.
			Tử Hàn lại hết sức cao hứng, lần nữa cảm thụ thân thể của mình bên trong linh lực, cười nói “Xem ra ta ngày mai có thể đi Tàng Thư Lâu tìm hai quyển vũ kỹ tu luyện, lại đi tìm Tử Lạc báo thù”
			“Vũ kỹ? Còn dùng đi tìm? Muốn bao nhiêu, Bản vương thưởng cho nhĩ”
			Huyết Nguyệt thờ ơ thanh âm nhớ tới, một cái lông chim móc lỗ mũi.
			“Nhĩ còn có vũ kỹ? Chẳng lẽ lại linh mẫn cấp vũ kỹ? Phát, phát” Tử Hàn cố gắng hết sức kinh hỉ, tâm tình càng là thật tốt.
			“Phàm nhân”
			Huyết Nguyệt cánh khinh động, một vệt ngân quang nhàn nhạt lần nữa sáng lên, sau đó hai quyển phong cách cổ xưa quyển trục hiện lên, ném về Tử Hàn, nhàn nhạt nói “Đây là một quyển Huyền Giai hạ phẩm vũ kỹ Thôn Linh Chưởng, còn có một quyển kiếm quyết, Bản vương cũng không biết tên gọi là gì, cũng không biết Phẩm Giai, cầm đi chơi đi”
			Tử Hàn nhặt lên hai quyển vũ kỹ, trên mặt lần nữa lộ ra kinh hỉ, đạo “Oa, Huyết Nguyệt, nhĩ quá giàu có đi, Huyền Giai hạ phẩm Chưởng Pháp cũng có thể tùy tiện lấy ra”
			“Một đống rác như thế ở Bản vương nơi này chất mấy ngàn năm, nhĩ thích cũng cho ngươi tốt”
			“Ai, thật là không có từng va chạm xã hội”
			Tử Hàn nhìn một chút trong tay Thôn Linh Chưởng, sau đó lại liếc mắt nhìn kia quyển kiếm quyết, lại không có tên, thậm chí ngay cả Phẩm Giai cũng không có, nhưng là Tử Hàn nghĩ lại nhìn Huyết Nguyệt, da mặt một phúc hậu “Cho ta kiếm quyết, ngay cả kiếm cũng không cho một thanh, lấy cái gì Luyện? Ngươi nghĩ cũng quá không chu đáo”
			“Cho ngươi”
			Huyết Nguyệt một cánh cánh, một thanh kiếm thẳng cắm ở Tử Hàn bên cạnh, Tử Hàn nhìn trước mắt trường kiếm, kiếm dài bốn thước, trên đó khắc họa đến vô số phồn áo hoa văn, phong cách cổ xưa bên trong mang theo tang thương cảm giác, mủi kiếm còn đang rung động nhè nhẹ phát ra ông minh âm thanh.
			Làm Huyết Nguyệt xuất ra thanh trường kiếm này lúc, nó ánh mắt chết nhìn chòng chọc trường kiếm, trong mắt trong lúc mơ hồ mang theo mong đợi, Tử Hàn nhìn trước mắt trường kiếm hoan hỉ không phải, bàn tay đặt ở chỗ chuôi kiếm, năm ngón tay nắm chặt, một cổ linh lực hướng trường kiếm bên trong dũng động, chợt rút ra.
			Khanh!
			Trường kiếm hí, nhưng là Huyết Nguyệt con mắt cũng sắp té xuống, nhìn Tử Hàn nắm trường kiếm, hồi lâu không nói gì, không biết thế nào, nó nhìn Tử Hàn cầm trường kiếm thời điểm trong mắt tràn đầy nóng bỏng, trong lòng không nhịn được nhẹ nhàng run rẩy.
			Tử Hàn triển động trường kiếm, một đạo kiếm khí dày đặc không trung mà hiện tại, một vệt Xích Sắc linh quang chợt lóe lên, kiếm khí chém ngang lên, chém xuống ở bên cạnh trên cây liễu, chậu rửa mặt lớn như vậy cây liễu lại đang một kiếm xuống suýt nữa bị hắn chặt đứt.
			“Oa, Huyết Nguyệt, lợi hại như vậy một thanh kiếm là cái gì Phẩm Giai à?”
			Huyết Nguyệt ngưng trọng nhìn Tử Hàn, trong thanh âm mang theo nghiêm túc, đạo “Thanh kiếm này không có Phẩm Giai, nó tùy theo từng người, bởi vì lực mà khác”
			“Còn có như vậy quái kiếm a”
			Huyết Nguyệt né người, hai cánh như cùng người tay như thế vác chắp sau lưng, ý vị thâm trường nói “Thiếu niên Lang, ngươi cũng đã biết thanh kiếm này là như thế nào lai lịch”
			Huyết Nguyệt lời nói rất trịnh trọng, nhưng là Huyết Nguyệt lời nói, lại hồi lâu không có trả lời, làm Huyết Nguyệt quay đầu thời điểm Tử Hàn chạy tới xa xa, nghiêm túc nhìn kia hai quyển quyển trục, bên người chuôi này cổ kiếm nghiêng xen vào ở bên cạnh.
			“Ta đi nhĩ đại gia, thật là lãng phí biểu tình, Bản vương đang cùng ngươi nói chuyện, nhĩ có còn hay không điểm lễ phép, nhĩ”
			Nhưng mà sau một khắc, Huyết Nguyệt ngừng chửi rủa, chết nhìn chòng chọc Tử Hàn bóng người, thiếu chút nữa liền xuống ba cũng kinh điệu, lúc này Tử Hàn lại đang Luyện bàn tay, phảng phất trước học qua một dạng tự học, sau một khắc trong tay trường kiếm, trường kiếm trong tay hoành vũ lên, trên không trung vạch qua một vệt độ cong
			Chỉ lưu lại Huyết Nguyệt ở trong gió xốc xếch, nhìn Tử Hàn, Huyết Nguyệt đôi mắt trở nên thâm thúy đứng lên.
			“Trời sinh thánh mạch, coi là thật bất phàm”'),
			(55, 5, 24, 29, 7, N'Ác Nô Khi Chủ',CAST(N'2024-01-20T05:52:10.323' AS DateTime),null, 1, 
			N'Đêm đã khuya, Huyết Nguyệt ngáp một cái, nghiêng dựa vào bên cây nhìn phía xa Tử Hàn, trong tay múa kiếm chính Luyện phi thường cao hứng, trong lúc mơ hồ hội tụ ra một loại Kiếm Thế, trên mũi kiếm có từng luồng kiếm khí lưu chuyển, trường kiếm hiện ra sắc bén ý, Tử Hàn lúc này khí chất đại biến đã là có dần dần lộ phong mang cảm giác.</p>
			<p>Làm Tử Hàn thu hồi trường kiếm, nhìn đến trường kiếm trong tay, càng xem càng là hoan hỉ, bàn tay nhẹ nhàng ma sát thân kiếm, ngẩng đầu nhìn liếc mắt sắc trời, hướng Tử gia trang viên đi tới.</p>
			<p>“Ai, thiếu niên Lang, ngươi không đợi Bản vương?”</p>
			<p>Tử Hàn nghe vậy, nhất thời quay đầu, Huyết Nguyệt đạp nước cánh đi tới Tử Hàn trước mặt, nhảy đến Tử Hàn đầu vai.</p>
			<p>Tử Hàn nghiêng đầu nhìn trên bả vai mình Kê Tử Nhi nói “Nguyên lai ngươi còn chưa đi à?”</p>
			<p>“Đi? Ngươi để cho Bản vương đi thì sao? Ai, ngươi sẽ không cần qua sông rút cầu đi, Bản vương bây giờ nhưng là tuyệt lộ, lại nói Bản vương còn phải dẫn ngươi lăn lộn đâu rồi, làm sao có thể đi”</p>
			<p>Tử Hàn nghe vậy, có chút cau mày, nói “Ta còn tưởng rằng ta giống như lão trong dân cư cố sự như thế, gặp phải một cái cao thủ tuyệt thế, sau đó lấy được nghịch thiên truyền thừa, sau đó cao nhân tuyệt trần rời đi, không được xuất bản tục đây”</p>
			<p>“Đó là cố sự, cho nên sau này ngươi phải thật tốt đi theo Bản vương, lại nói nếu như không có Bản vương dạy dỗ, ngươi thế nào Ngạo Thị Thiên Hạ, đi đâu tìm nhiều như vậy nghịch thiên vũ kỹ?”</p>
			<p>“Cũng là” Tử Hàn gật đầu, rồi sau đó nhìn Huyết Nguyệt, nghiêm túc nói “Nhưng là có một việc, ngươi phải rõ ràng”</p>
			<p>Huyết Nguyệt trên cánh một cái lông chim móc lỗ mũi, ngạo mạn nói “Chuyện gì?”</p>
			<p>“Là ngươi đi theo ta, không phải là ta theo đến ngươi”</p>
			<p>Tử Hàn lòng tràn đầy hoan hỉ đi tới cửa trang viên, xa xa nhìn lại, trang viên to lớn, là cả hoa rơi thành xa xỉ nhất một tòa trang viên, cả thành hoa rơi lên, mà tòa trang viên này cũng là Lưu Vân Hoàng Triều một trong tứ đại gia tộc Tử Tộc mạch chỗ, Tự Nhiên sang trọng.</p>
			<p>Huyết Nguyệt nhìn xa xa trang viên nói “Cũng không tệ lắm, căn này nhà nhỏ so với Bản vương trong cung điện nhà vệ sinh cũng chênh lệch không bao nhiêu, bất quá loại này thâm sơn cùng cốc địa phương, Bản vương cũng chỉ có thể tạm đến ở”</p>
			<p>“Nhà ngươi nhà vệ sinh lớn như vậy a” Tử Hàn nghe Huyết Nguyệt lời nói, khóe miệng nhẹ nhàng co quắp, lại bắt đầu thói quen con gà này tử mà nói mạnh miệng, dần dần cảm giác không có gì kỳ quái.</p>
			<p>Tử Hàn vừa nói đi tới cửa, làm Tử Hàn vừa muốn bước lên nấc thang thời điểm, hai thanh trường mâu tương giao, vang vang chi tiếng vang lên, ngăn trở đường đi, Tử Hàn nhướng mày một cái, ngẩng đầu nhìn lại, hai trung niên nam nhân lúc này đứng ở cửa, một người mở miệng mang theo nghiêm nghị, nói “Tới người nào, lại ban đêm xông vào Tử Phủ không muốn sống”</p>
			<p>Tử Hàn khẽ cau mày, sắc mặt nhất thời trở nên âm trầm, có chút nổi nóng.</p>
			<p>Thủ môn người tên là Tử Lực chỉ là Tử gia nô tài, bởi vì đem em gái mình hiến tặng cho Tử Lạc phong lưu một đêm mới đổi lấy một cái thủ môn chức vị, hơn nữa Tử Lực thường xuyên ỷ thế hiếp người, mười phần tiểu nhân mặt nhọn.</p>
			<p>Tử Lực biết rất rõ ràng người đến là ai, lại cố ý ngăn lại hắn đi đường, chẳng qua là là cho hắn khó chịu, đi tới hoa rơi thành mấy năm này Tử Hàn tựa như ư đã thành thói quen, toàn bộ mạch trên dưới từ gia chủ khi đến người không người để mắt hắn.</p>
			<p>Có thể là đối với những thứ này Tử Hàn chỉ có thể im hơi lặng tiếng, chính mình cái gì làm không, bởi vì hắn không có thực lực.</p>
			<p>“Ta là Tử Hàn”</p>
			<p>Tử Hàn mở miệng, ngẩng đầu nhìn về phía hai người, Tử Lực làm bộ xít lại gần nhìn Tử Hàn liếc mắt, như có sở ngộ nói “Nguyên lai là Tử Hàn thiếu gia a, thế nào trễ như vậy mới trở về”</p>
			<p>Tử Lực vừa nói lại không có chút nào nhường đường ý tứ, như cũ cư cao lâm hạ nhìn Tử Hàn, khóe miệng mang theo cười khẽ, ánh mắt liếc xéo nhìn hắn.</p>
			<p>“Thiếu niên Lang, đây không phải là nhà ngươi sao?”</p>
			<p>“Đây không phải là nhà ta”</p>
			<p>“Ngươi thế nào thảm như vậy, không thể tu luyện coi như, vẫn như thế nghèo, ngay cả như vậy một căn phòng hư tử ngươi cũng không có”</p>
			<p>Tử Hàn sắc mặt càng âm trầm, ngẩng đầu nhìn hai cái Người giữ cửa, lần nữa mở miệng nói “Ta đi chỗ nào có liên quan gì tới ngươi, tránh ra”</p>
			<p>Tử Lực nghe được Tử Hàn lời nói, có chút quái dị nhìn Tử Hàn, không nghĩ tới hôm nay Tử Hàn như thế này mà ngạnh khí, ngay sau đó cười lạnh nói "Ta chỉ là quan tâm một chút Tử Hàn thiếu gia,</p>
			<p>Dù sao Tử Hàn thiếu gia ngươi nhưng là chủ nhà tới thiếu gia, nếu như có sơ xuất gì lời nói, chúng ta có thể đảm đương không nổi "</p>
			<p>“Lời này thật chua”</p>
			<p>Huyết Nguyệt âm thanh âm vang lên, Tử Lực mặt lộ vẻ kinh dị, lại cũng không có ngạc nhiên, như cũ cản trở Tử Hàn đường đi, không có thả Tử Hàn đi qua ý tứ.</p>
			<p>“Các ngươi có nhường hay không, không để cho cũng đừng trách ta không khách khí”</p>
			<p>Tử Hàn thanh âm trở nên lạnh giá, nắm trường kiếm tay, đang nhẹ nhàng ma sát chuôi kiếm, tựa hồ chuẩn bị một món chặt xuống trước mắt Tử Lực đầu.</p>
			<p>“Ồ, Tử Hàn Đại thiếu gia đây là tới đây là muốn ở trước mặt chúng ta đùa bỡn thiếu gia tính khí đây? Thật là đáng sợ a” Tử Lực vừa nói, trong thanh âm mang theo chế giễu, cố gắng làm ra một bộ sợ hãi vẻ mặt, sau đó lộ ra một vệt vẻ trào phúng.</p>
			<p>Tử Hàn nhất thời giận dữ, mắng “Cẩu nô tài, ngươi là cái thá gì, có tư cách gì ở Bản Thiếu Gia trước mặt châm chọc”</p>
			<p>Tử Lực nghe vậy, sắc mặt nhất thời trầm xuống, cười lạnh, nói “Tử Hàn, ngươi thật đúng là đem mình làm món đồ, không phải là một phế vật sao? Chẳng lẽ ngươi còn muốn ỷ vào chủ nhà thiếu gia thân phận tới đùa bỡn uy phong hay sao?”</p>
			<p>“Ô kìa ta đi, thiếu niên Lang, ngươi này lăn lộn cũng không ai, đều bị nô tài cỡi ở trên cổ đi ị”</p>
			<p>Huyết Nguyệt dứt lời ở Tử Hàn trong tai, Tử Hàn nhìn Tử Lực, lạnh lùng nói “Cẩu nô tài”</p>
			<p>Ba!</p>
			<p>Tử Hàn đưa tay đang lúc một cái tát ở Tử Lực trên mặt, thanh thúy ba tiếng vỗ tay vang lên, Tử Lực kịp phản ứng trừng mắt to nhìn Tử Hàn, nắm trường mâu thủ ở khẽ run, trong mắt tóe ra tức giận, tựa hồ được bao lớn khuất nhục.</p>
			<p>“Ngươi dám đánh ta?”</p>
			<p>Tử Lực lớn tiếng nói.</p>
			<p>“Đánh ngươi thì thế nào, ngươi bất quá là một nô tài mà thôi, ngươi còn muốn cùng ta động thủ hay sao?”</p>
			<p>Tử Hàn trường kiếm trong tay một lăng, nhìn Tử Lực không sợ chút nào, nếu là đổi thành lúc trước Tử Hàn căn bản không có dũng khí đánh ra Nadic bàn tay, nhưng là lúc này đã không giống ngày xưa.</p>
			<p>“Ngươi cái phế vật, hôm nay ta không giáo huấn ngươi, ngươi cũng không phân rõ mình là ai”</p>
			<p>Tử Hàn sau lùi một bước, nhìn Tử Lực, lúc này Tử Lực trong tay trường mâu vũ động, hướng Tử Hàn chặt chém tới, trường mâu hiện lên hàn quang, Tử Hàn không ngừng lùi lại đến, né tránh trường mâu.</p>
			<p>“Tử Lực, ngươi bất quá là một nô tài, lại dám động thủ với ta”</p>
			<p>Tử Hàn biết rõ mình nói là nói nhảm, nhưng là đây là hắn cố ý nói ra, Tử Lực lại cười lạnh một tiếng nói “Ra tay với ngươi thì thế nào, chỉ cần không đem ngươi đánh chết, gia chủ thì sẽ không để ý tới, ngươi bất quá là một phế vật thôi, có cái gì tốt phách lối”</p>
			<p>Tử Lực nói trong tay trường mâu hướng Tử Hàn đâm tới, Tử Hàn sắc mặt nhất thời lạnh lẻo, trường kiếm trong tay chém ngang ngăn trở trường mâu, Tử Lực cảm thấy trong lòng giật mình, có chút khó tin nhìn Tử Hàn, Tử Hàn thu hồi trường kiếm chém xuống một kiếm, Tử Lực thu hồi trường mâu hoành ngăn hồ sơ đang lúc, một vệt kiếm quang chợt lóe, trường mâu trực tiếp bị chém đứt.</p>
			<p>Tử Lực nắm bị chém đứt trường mâu, không ngừng lùi lại “Không thể nào, ngươi cái phế vật này làm sao có thể chống đỡ được ta, ta nhưng là Thông Linh cảnh sơ kỳ cường giả”</p>
			<p>Tử Hàn thu kiếm, lạnh lùng nói “Mở miệng một tiếng phế vật, nói đủ chưa?”</p>
			<p>Huyết Nguyệt mặt đầy khinh bỉ nhìn Tử Lực nói “Lúc nào Thông Linh cảnh sơ kỳ đều được cường giả?”</p>
			<p>Oành!</p>
			<p>Tử Hàn tiến lên một cước đá vào Tử Lực trên mặt, đạp Tử Lực luôn miệng gào thét bi thương, mặc dù Tử Lực là Thông Linh cảnh sơ kỳ cùng Tử Hàn một cảnh giới, tuy nhiên lại căn bản không phải Tử Hàn đối thủ, Tử Hàn trường kiếm trong tay sắc bén, để cho hắn bất ngờ, lúc này Tử Hàn thừa thắng xông lên, để cho Tử Lực vội vàng không kịp chuẩn bị.</p>
			<p>Tử Hàn tiến lên một cái tát lần nữa phiến ở Tử Lực trên mặt, một đạo huyết thủy hoành bay ra ngoài, không tưởng tượng nổi nhìn Tử Hàn, giống như nhìn quái vật.</p>
			<p>“Ngươi làm sao có thể, ngươi không phải là không thể tu hành sao?”</p>
			<p>“Mắc mớ gì tới ngươi, Lão Tử nhẫn đủ”</p>
			<p>Tử Hàn vừa nói một cước giẫm ở Tử Lực trên mặt, quan sát Tử Lực lúc cảm nhận được một loại khoan dung, loại cảm giác này rất vi diệu, để cho hắn có chút hoảng hốt, hơi nhún chân đạp đi, lạnh lùng nói “Ta hiện ngày sẽ dạy ngươi làm gì nô tài”</p>
			<p>Tử Hàn vừa nói một cước đem Tử Lực đá bay ra ngoài, bước chân đạp một cái đi tới Tử Lực bên cạnh một cước lần nữa giẫm đạp ở trên người hắn, trường kiếm trong tay nhấc lên nhìn Tử Lực.</p>
			<p>“Ngươi, không thể giết ta, ngươi giết ta Tử Lạc thiếu gia sẽ không bỏ qua cho ngươi”</p>
			<p>“Giết ngươi? Ta sợ bẩn ta kiếm, hơn nữa ai đi quan tâm ngươi tên nô tài này sống chết”</p>
			<p>Tử Lực kinh hoàng nhìn Tử Hàn, hắn đột nhiên nhướng mày một cái ánh mắt lộ ra vẻ hàn quang, vận chuyển linh lực, một chưởng hướng Tử Hàn đánh.</p>
			<p>Tử Hàn cau mày, trường kiếm trong tay vót ngang tới, một đạo huyết thủy văng lên.</p>
			<p>“A!”</p>
			<p>Tử Lực kêu thảm thiết, bàn tay hắn rơi ở một bên, cánh tay còn đang không ngừng chảy máu tươi.</p>
			<p>“Ngươi cái phế vật, ta sẽ nhượng cho Tử Lạc thiếu gia giết ngươi”</p>
			<p>“A!”</p>
			<p>Tử Lực lần nữa kêu thảm một tiếng, Tử Hàn trường kiếm trong tay chặt đứt hắn một chân, một cước đưa hắn đá bay ra ngoài, lạnh lùng nói “Tử Lạc là cái thá gì, chẳng qua chỉ là Tử Tộc chi nhánh người thôi”</p>
			<p>Tử Hàn nói đến trường kiếm trong tay lần nữa nâng lên, Tử Lực đáy mắt lộ ra vẻ hoảng sợ, lập tức hô lớn “Tử Hàn thiếu gia tha mạng, tiểu nhân không dám, không dám, ngài đại nhân có đại lượng tha ta mạng chó đi”</p>
			<p>Tử Hàn lạnh lùng liếc hắn một cái, do dự một chút trường kiếm trong tay từ đầu đến cuối không có hạ xuống, Tử Hàn một cước nặng nề đá ở trên người hắn, Tử Lực lần nữa bay ra, Tử Hàn thu hồi ánh mắt lạnh lùng nhìn một gã khác Người giữ cửa, lạnh lùng nói “Bây giờ ngươi còn dám ngăn cản ta sao?”</p>
			<p>Một tên khác Người giữ cửa nhất thời quỳ xuống, hắn nghe rất rõ, Tử Hàn nói chuyện không phải là còn muốn, mà là còn dám, lập tức sợ hãi, mang theo ý cầu khẩn nói “Tiểu nhân không dám”</p>
			<p>Tử Hàn thủ đoạn ngay cả Huyết Nguyệt nhìn cũng có chút kinh ngạc, hắn cũng không nghĩ tới Tử Hàn lại có thể như thế cường thế, dù ai cũng không cách nào tưởng tượng Tử Hàn lúc trước cứu qua có nhiều khuất nhục, bây giờ mới sẽ hung hăng như vậy, chỉ có Tử Hàn mình mới rõ ràng, hắn trải qua cái gì.</p>
			<p>“Hừ”</p>
			<p>Tử Hàn nhẹ rên một tiếng, cầm kiếm hướng trong trang viên đi tới, Người giữ cửa nhìn nằm ở một bên Tử Lực, nhìn Tử Hàn biến mất ở trong màn đêm bóng lưng, lập tức liền lăn một vòng hướng đình viện sâu bên trong chạy đi.'),
			(56, 5, 24, 29, 7, N'Tàng Thư Lâu trước',CAST(N'2024-01-20T05:52:10.323' AS DateTime),null, 1, 
			N'"Thiếu niên, mới vừa học được tu luyện liền hung hăng như vậy? Bản vương thế nào cảm giác ngươi có loại trả thù trong lòng a”</p>
			<p>Tử Hàn đứng ở trong gió, nhìn dưới đất có ba lượng trích (dạng) vết máu khô khốc, cười nói “Hôm nay chính là ở chỗ này, ta bị Tử Lạc làm nhục, bị một người đàn bà đáng thương, ngươi cũng thấy ngay cả cái nô tài đều không đem coi ra gì, dám cưỡi ở trên đầu ta”</p>
			<p>Huyết Nguyệt bật xuống Tử Hàn đầu vai, nhẹ nhàng gõ đầu như có điều suy nghĩ nói “Xác thực, một cái nô tài cũng lớn lối như vậy, Bản vương cũng quả thực không nhìn nổi”</p>
			<p>Tử Hàn nhẹ nhàng cười cười, nói “Đi thôi, ngày mai đi Tàng Thư Lâu”</p>
			<p>“Đi Tàng Thư Lâu làm gì, chẳng lẽ Bản vương cho ngươi vũ kỹ vào không ngươi mắt hay sao?”</p>
			<p>Tử Hàn ánh mắt khẽ híp một cái, cười nói “Ngày mai ngươi cũng biết”</p>
			<p>Tử Hàn xuyên qua tu luyện tràng, đi tới một mảnh Thủy Đàm trước mặt, bên đầm nước có một gian căn phòng nhỏ, liếc mắt nhìn sang cố gắng hết sức đơn sơ, Tử Hàn thẳng hướng phòng nhỏ đi vào, Huyết Nguyệt với sau lưng Tử Hàn kinh ngạc nhìn gian phòng này, khi nó đi vào thời điểm nhất thời liền kinh ngạc đến ngây người.</p>
			<p>“Thiếu niên Lang, đây chính là ngươi chỗ ở?”</p>
			<p>Tử Hàn quan sát một phen nhà, có chút lòng chua xót nói “Cũng không tệ lắm phải không, ít nhất có thể có một đặt chân phương, không đến nổi đầu đường xó chợ”</p>
			<p>Huyết Nguyệt liếc mắt nhìn sang, lại nhìn một cái không sót gì, một tấm rách nát giường gỗ, cũng chính là hai cây trên cái băng thả gỗ miếng bản, phía trên cửa hàng để một tầng sợi bông, trước giường có một cái bàn gỗ, cái bàn gỗ cũ nát không chịu nổi, trên bàn để một ngọn đèn dầu, không có Đăng Tâm cũng không có đèn dầu hoàn toàn chính là một chưng bày, sau đó, sau đó cũng chưa có</p>
			<p>Nóc nhà còn có một lổ lớn, căn bản ngăn cản không mưa gió.</p>
			<p> Huyết Nguyệt nhìn hết thảy các thứ này nhất thời liền giận, đứng ở trên bàn một cước đá lộn mèo trên bàn ngọn đèn dầu, nổi giận mắng “Thứ gì a, ngươi không phải là Tử Tộc Lục thiếu gia sao? Mang đến mạch bên trong lại cho ngươi ở đây loại rách nát địa phương?”</p>
			<p>Tử Hàn tự giễu cười một tiếng, nhẹ khẽ than thở ngồi ở tấm ván đạt được trên giường, cười nói “Ta có biện pháp gì, ai bảo ta không cách nào tu hành, coi như là Tử Tộc Lục thiếu gia thì thế nào, ở cha sau khi rời khỏi ta sinh hoạt trở nên chẳng bằng con chó”</p>
			<p>“Vương Bát Đản, đám này Thiên Sát, lại cho Bản vương truyền nhân ở loại địa phương này, có cái xẻng sao? Bản vương phải đi đào nhà hắn mộ tổ tiên”</p>
			<p>Huyết Nguyệt vừa nói liền muốn xông ra đi, Tử Hàn tiến lên bắt Huyết Nguyệt, trong lòng có loại không khỏi làm rung động, dù sao hắn và Huyết Nguyệt quen biết mới bất quá mấy giờ, nhưng là Huyết Nguyệt lại có thể lấy bất bình dùm cho mình, Tử Hàn nhẹ nhàng thư một hơi thở nói “Không việc gì, một ngày nào đó thuộc về ta đều sẽ cầm về”</p>
			<p>Huyết Nguyệt thấy Tử Hàn trong ánh mắt lộ ra một vệt vẻ kiên nghị, nhẹ nhàng gõ đầu ánh mắt lộ ra công nhận vẻ mặt.</p>
			<p>Huyết Nguyệt nằm ở Tử Hàn phá ngủ trên giường đi qua, Tử Hàn lại không chút nào buồn ngủ, đi tới bên đầm nước, lần nữa xuất ra Huyết Nguyệt cho hắn Thôn Linh Chưởng, chăm chỉ luyện tập đứng lên, nơi mi tâm từng tia linh lực rót vào hắn Tứ Chi Bách Hài, từng lần một đánh.</p>
			<p>“Thôn Linh Chưởng”</p>
			<p>Tử Hàn một chưởng đánh ở bên cạnh một cây liễu bên trên, to cở miệng chén cây liễu bị Tử Hàn miễn cưỡng một chưởng chặn ngang cắt đứt, Tử Hàn nhìn mình tay kinh ngạc nhìn ngã xuống cây liễu, sau một khắc ánh mắt lộ ra một vẻ vui mừng.</p>
			<p>Lúc này Huyết Nguyệt đứng ở cửa Tĩnh Tĩnh nhìn Tử Hàn, nó ánh mắt lộ ra kinh hãi ý.</p>
			<p>“Trời sinh thánh mạch lại đối với võ đạo hiểu sâu như vậy khắc, một bộ Huyền Giai hạ phẩm Chưởng Pháp lại bị hắn ở thời gian ngắn như vậy tu luyện thành công, hắn hôm nay mới khó khăn lắm phá vỡ mà vào Thông Linh cảnh mà thôi”</p>
			<p>Tử Hàn nhướng mày một cái, hắn nghe được Huyết Nguyệt lời nói, hắn Ngũ Cảm ở tối nay trở nên phá lệ bén nhạy, Huyết Nguyệt thanh âm rất nhẹ, hắn lại nghe chân thiết, quay đầu đang lúc, thấy Huyết Nguyệt, nói “Ngươi không phải là ngủ đi?”</p>
			<p>“Bản vương nghe phía bên ngoài động tĩnh đặc biệt đến xem thử, không nghĩ tới coi như Bản vương truyền nhân, ngươi biểu hiện vẫn không tệ nha, lại nhưng đã luyện thành Thôn Linh Chưởng”</p>
			<p>Tử Hàn lộ ra một nụ cười, nói "Nhưng là ta cảm giác một chưởng này bổ xuống,</p>
			<p>Ta linh lực tựa hồ cũng tiêu hao sắp tới 1 phần 3 "</p>
			<p>“Thiếu niên Lang, đừng nóng, ngươi mới Thông Linh sơ kỳ, hơn nữa Thôn Linh Chưởng nhưng là Huyền Giai Chưởng Pháp tinh diệu rất, đối với ngươi mà nói Tự Nhiên tiêu hao đại”</p>
			<p>Huyết Nguyệt nhìn Tử Hàn đáy mắt lộ ra vẻ quái dị, lần nữa mở miệng nói “Đi, với Bản vương vào nhà, cho ngươi đồ tốt”</p>
			<p>“Thứ gì?”</p>
			<p>Huyết Nguyệt không nói gì, đi vào phòng, cánh trôi lơ lửng đang lúc một vệt ánh sáng màu bạc chợt lóe, một khối to lớn Ngọc Thạch nổi lên, rơi trên mặt đất, cả nhà nhẹ nhàng run rẩy, lớn như vậy Ngọc Thạch giống như một giường lớn như thế.</p>
			<p>Tử Hàn nhìn trước mắt Ngọc Thạch, há to mồm nói “Khối ngọc lớn như vậy, có thể bán không ít tiền đi”</p>
			<p>“Thật là không có kiến thức, đây chính là Thánh Ngọc chế tạo, lớn như vậy khối Thánh Ngọc, ngươi có nhiều tiền hơn nữa cũng mua không được, này nhưng năm đó Bản vương trải qua Cửu Tử Nhất Sinh mới đến chí bảo”</p>
			<p>Tử Hàn duỗi tay sờ xoạng đến Thánh Ngọc giường, một cổ cực kỳ linh khí nồng nặc truyền tới, nhất thời hắn lần nữa cảm thấy giật mình.</p>
			<p>“Sau này ngươi ngay tại Thánh trên giường ngọc tu luyện tu hành, một năm tu hành tốc độ sánh được ở thiên địa linh khí đậm đà Bảo Địa tu luyện ba năm”</p>
			<p>Tử Hàn trừng mắt to nhìn Thánh Ngọc giường, ở phía trên khoanh chân ngồi xuống, một cổ linh khí nồng nặc nhất thời tràn vào thân thể của hắn hóa thành linh lực, Tử Hàn há hốc miệng ba, sau đó hơi khẽ cau mày nhìn Huyết Nguyệt, hỏi “Ngươi là thế nào mang theo lớn như vậy món đồ”</p>
			<p>“Bản vương có không gian bảo vật, cái gì không thể mang, coi như đem cả tòa thành trì dọn đi cũng không có vấn đề gì”</p>
			<p>“Oa” Tử Hàn nhìn Huyết Nguyệt ánh mắt lộ ra vẻ nôn nóng, nói “Có thể cho ta mượn dùng hai ngày sao?”</p>
			<p>Huyết Nguyệt một cái lông chim ở móc mũi, một đôi mắt nhỏ hơi nheo lại, nói “Lợi hại như vậy đồ vật tại sao có thể tùy tiện dùng linh tinh”</p>
			<p>Tử Hàn cười một tiếng, sau đó ở Thánh trên giường ngọc bắt đầu tu luyện, một đạo Ấn Pháp kết xuất, từng đạo linh khí không có vào thân thể của hắn tụ vào mi tâm hóa thành linh lực, thẳng đến trời sáng, Tử Hàn mở mắt, ngạc nhiên phát hiện trải qua một đêm tu luyện trong thân thể linh lực so với trước muốn hùng hậu rất nhiều, trong lúc mơ hồ sắp đạt tới Thông Linh trung kỳ.</p>
			<p>Tử Hàn đứng dậy, nói “Đi thôi, hôm nay lần đầu tiên, nên đi Tàng Thư Lâu”</p>
			<p>Huyết Nguyệt vô cùng không tình nguyện bò dậy, lần nữa đem Thánh Ngọc giường thu, nằm ở Tử Hàn đầu vai, đi theo hắn đi ra ngoài, Tử Hàn trong tay sau lưng cõng lấy sau lưng trường kiếm, đi xuyên qua tu luyện tràng, đi tới một tòa kiến trúc cao lớn lâu vũ trước, lâu vũ chi trên có ba cái thiếp vàng chữ to —— Tàng Thư Lâu.</p>
			<p>Ở Tử Tộc hoa rơi thành chi nhánh bên trong, mỗi tháng ban đầu nhất gia tộc Trung Võ người đều có thể đi vào Tàng Thư Lâu xem duyệt công pháp võ thuật, cho nên mỗi tháng lần đầu tiên thời điểm luôn là trong gia tộc võ giả tụ tập nhiều khi nhất sau khi, lúc này Tử Hàn đi tới Tàng Thư Lâu trước.</p>
			<p>Lúc này mới khó khăn lắm lúc sáng sớm, đã có rất nhiều trong gia tộc đệ tử đi tới Tàng Thư Lâu trước chờ đợi lầu cửa mở ra.</p>
			<p>Làm Tử Hàn đi tới nơi này thời điểm, nhất thời hội tụ vô số quái dị ánh mắt, Tử Hàn mặc dù không có thể tu hành, nhưng là ở Tử Tộc cái này chi nhánh bên trong nhưng là cực kỳ Nổi danh ". Bởi vì là mọi người đều biết Tử tộc chủ nhà Lục thiếu gia là một không thể tu hành phế vật, là bị chủ nhà đày đi tới đây chờ chết.</p>
			<p>“Đây không phải là chủ nhà Lục thiếu gia sao? Hắn thế nào cũng tới Tàng Thư Lâu?”</p>
			<p>“Tên phế vật kia thật đúng là không biết tự lượng sức mình, muốn tiến vào Tàng Thư Lâu?”</p>
			<p>Tử Hàn thẳng tắp đứng ở Tàng Thư Lâu trước, bọn họ lời nói lại rõ ràng rơi tại chính mình trong tai, nhưng là Tử Hàn lại chưa từng chút nào để ý, tựa như ư đã thành thói quen.</p>
			<p>“Các ngươi quá mức, chớ nói người ta như vậy”</p>
			<p>Tử Hàn hơi kinh ngạc, có chút ghé mắt, một tên mười bốn mười lăm tuổi thiếu nữ người mặc quần dài màu lam nhạt, non nớt khuôn mặt nhỏ nhắn rất là thanh tú, nàng được đặt tên là Tử Diệp, là Tử Tộc điều này chi nhánh thiên tài, lúc này Tử Diệp đang nhìn Tử Hàn hiếu kỳ đánh giá.</p>
			<p>Tử Hàn ghé mắt hướng về phía Tử Diệp nhẹ nhàng cười cười, Tử Diệp đầu tiên là sửng sốt một chút sau đó đi lên, đứng ở Tử Hàn trước mặt, mở miệng nói “Tử Hàn ca ca, ngươi đi nhanh đi, đợi một hồi Tử Lạc tới hắn khẳng định lại phải đánh ngươi”</p>
			<p>“Nữ Oa, ngươi là có nhiều khinh bỉ hắn a, chẳng lẽ hắn cũng chỉ có thể là bị đánh đoán?”</p>
			<p>Huyết Nguyệt nhàn nhạt liếc mắt nhìn Tử Diệp, Tử Diệp đánh giá Huyết Nguyệt cảm giác mười phần tức cười, đưa tay thì đi bắt Huyết Nguyệt muốn ngắt nhéo một cái.</p>
			<p>Mọi người nghe được Huyết Nguyệt mở miệng mới vừa chú ý tới cái này chưa đủ ba tấc Tiểu Thú, mặc dù là có chút ngạc nhiên, lại cũng không phải là như thế nào ý, dù sao thế giới lớn không thiếu cái lạ, rất nhiều Yêu Thú linh trí cực cao, trời sinh liền có thể miệng nói tiếng người, bị người thu làm Linh Sủng, nhưng là mọi người kinh dị chỗ nhưng ở với trong mắt bọn họ cái phế vật này thiếu gia đi nơi nào thu Linh Sủng.</p>
			<p>Tử Hàn hướng về phía Tử Diệp cười nói “Cám ơn ngươi, Tử Diệp, bất quá ta không sợ hắn”</p>
			<p>Tử Diệp thu tay về nhìn Tử Hàn giương mắt nói “Không được, ngươi đánh không lại hắn, đến lúc đó ngươi lại phải đau chừng mấy ngày”</p>
			<p>Tử Hàn ôn uyển cười một tiếng, vừa muốn mở miệng, xa xa Tử Lạc đi đi tới, trong mắt mang theo vẻ ngạo mạn căn bản không đem Tử Hàn coi vào đâu, sau lưng như cũ đi theo ngày hôm qua hai người kia, hai người trong mắt mang theo vẻ châm chọc nhìn Tử Hàn, khinh thường nói “Ồ, một đêm không thấy Tử Hàn thiếu gia dài tính khí, thậm chí ngay cả Tử Lạc đại ca cũng không sợ?”</p>
			<p>Tử Diệp nhìn Tử Lạc đi tới, nhút nhát tránh qua một bên, không dám nhìn nữa Tử Hàn, Tử Hàn nhìn Tử Diệp lại không có một tia trách cứ ý tứ, ngược lại đáy lòng có một tia ấm áp, dù sao cùng hắn nói như vậy những năm gần đây cũng liền một cái Tử Diệp mà thôi.</p>
			<p>Mọi người thấy Tử Lạc đi tới, ánh mắt lộ ra một bộ vẻ chờ mong, có người nhẹ nhàng mở miệng nói “Xem ra hôm nay lại có trò hay nhìn, Tử Lạc nhưng là một mực không ưa Tử Hàn a”</p>
			<p>“Ai, cái này chủ nhà thiếu gia thật là đáng thương a, phỏng chừng lần này nửa tháng đều xuống không giường”</p>
			<p>Ngay tại cũng cho là Tử Hàn sẽ ảo não chạy trốn lúc, Tử Hàn khóe miệng vén lên một tia độ cong, khẽ cười nói “Ta Tử Hàn chính là chủ nhà thiếu gia, ngươi coi là cái gì chó má, coi như ngươi mạch gia chủ cũng không xứng nói với ta như vậy”</p>
			<p>Hí!</p>
			<p>Tử Hàn lời nói một nơi, mọi người đều là hít một hơi lãnh khí, có chút khiếp sợ nhìn Tử Hàn, nhưng mà lại lộ ra một vệt thương hại ánh mắt.'),
			(57, 5, 24, 29, 7, N'Tàng Thư Lâu trước',CAST(N'2024-01-20T05:52:10.323' AS DateTime),null, 1, 
			N'"Thiếu niên, mới vừa học được tu luyện liền hung hăng như vậy? Bản vương thế nào cảm giác ngươi có loại trả thù trong lòng a”</p>
			<p>Tử Hàn đứng ở trong gió, nhìn dưới đất có ba lượng trích (dạng) vết máu khô khốc, cười nói “Hôm nay chính là ở chỗ này, ta bị Tử Lạc làm nhục, bị một người đàn bà đáng thương, ngươi cũng thấy ngay cả cái nô tài đều không đem coi ra gì, dám cưỡi ở trên đầu ta”</p>
			<p>Huyết Nguyệt bật xuống Tử Hàn đầu vai, nhẹ nhàng gõ đầu như có điều suy nghĩ nói “Xác thực, một cái nô tài cũng lớn lối như vậy, Bản vương cũng quả thực không nhìn nổi”</p>
			<p>Tử Hàn nhẹ nhàng cười cười, nói “Đi thôi, ngày mai đi Tàng Thư Lâu”</p>
			<p>“Đi Tàng Thư Lâu làm gì, chẳng lẽ Bản vương cho ngươi vũ kỹ vào không ngươi mắt hay sao?”</p>
			<p>Tử Hàn ánh mắt khẽ híp một cái, cười nói “Ngày mai ngươi cũng biết”</p>
			<p>Tử Hàn xuyên qua tu luyện tràng, đi tới một mảnh Thủy Đàm trước mặt, bên đầm nước có một gian căn phòng nhỏ, liếc mắt nhìn sang cố gắng hết sức đơn sơ, Tử Hàn thẳng hướng phòng nhỏ đi vào, Huyết Nguyệt với sau lưng Tử Hàn kinh ngạc nhìn gian phòng này, khi nó đi vào thời điểm nhất thời liền kinh ngạc đến ngây người.</p>
			<p>“Thiếu niên Lang, đây chính là ngươi chỗ ở?”</p>
			<p>Tử Hàn quan sát một phen nhà, có chút lòng chua xót nói “Cũng không tệ lắm phải không, ít nhất có thể có một đặt chân phương, không đến nổi đầu đường xó chợ”</p>
			<p>Huyết Nguyệt liếc mắt nhìn sang, lại nhìn một cái không sót gì, một tấm rách nát giường gỗ, cũng chính là hai cây trên cái băng thả gỗ miếng bản, phía trên cửa hàng để một tầng sợi bông, trước giường có một cái bàn gỗ, cái bàn gỗ cũ nát không chịu nổi, trên bàn để một ngọn đèn dầu, không có Đăng Tâm cũng không có đèn dầu hoàn toàn chính là một chưng bày, sau đó, sau đó cũng chưa có</p>
			<p>Nóc nhà còn có một lổ lớn, căn bản ngăn cản không mưa gió.</p>
			<p> Huyết Nguyệt nhìn hết thảy các thứ này nhất thời liền giận, đứng ở trên bàn một cước đá lộn mèo trên bàn ngọn đèn dầu, nổi giận mắng “Thứ gì a, ngươi không phải là Tử Tộc Lục thiếu gia sao? Mang đến mạch bên trong lại cho ngươi ở đây loại rách nát địa phương?”</p>
			<p>Tử Hàn tự giễu cười một tiếng, nhẹ khẽ than thở ngồi ở tấm ván đạt được trên giường, cười nói “Ta có biện pháp gì, ai bảo ta không cách nào tu hành, coi như là Tử Tộc Lục thiếu gia thì thế nào, ở cha sau khi rời khỏi ta sinh hoạt trở nên chẳng bằng con chó”</p>
			<p>“Vương Bát Đản, đám này Thiên Sát, lại cho Bản vương truyền nhân ở loại địa phương này, có cái xẻng sao? Bản vương phải đi đào nhà hắn mộ tổ tiên”</p>
			<p>Huyết Nguyệt vừa nói liền muốn xông ra đi, Tử Hàn tiến lên bắt Huyết Nguyệt, trong lòng có loại không khỏi làm rung động, dù sao hắn và Huyết Nguyệt quen biết mới bất quá mấy giờ, nhưng là Huyết Nguyệt lại có thể lấy bất bình dùm cho mình, Tử Hàn nhẹ nhàng thư một hơi thở nói “Không việc gì, một ngày nào đó thuộc về ta đều sẽ cầm về”</p>
			<p>Huyết Nguyệt thấy Tử Hàn trong ánh mắt lộ ra một vệt vẻ kiên nghị, nhẹ nhàng gõ đầu ánh mắt lộ ra công nhận vẻ mặt.</p>
			<p>Huyết Nguyệt nằm ở Tử Hàn phá ngủ trên giường đi qua, Tử Hàn lại không chút nào buồn ngủ, đi tới bên đầm nước, lần nữa xuất ra Huyết Nguyệt cho hắn Thôn Linh Chưởng, chăm chỉ luyện tập đứng lên, nơi mi tâm từng tia linh lực rót vào hắn Tứ Chi Bách Hài, từng lần một đánh.</p>
			<p>“Thôn Linh Chưởng”</p>
			<p>Tử Hàn một chưởng đánh ở bên cạnh một cây liễu bên trên, to cở miệng chén cây liễu bị Tử Hàn miễn cưỡng một chưởng chặn ngang cắt đứt, Tử Hàn nhìn mình tay kinh ngạc nhìn ngã xuống cây liễu, sau một khắc ánh mắt lộ ra một vẻ vui mừng.</p>
			<p>Lúc này Huyết Nguyệt đứng ở cửa Tĩnh Tĩnh nhìn Tử Hàn, nó ánh mắt lộ ra kinh hãi ý.</p>
			<p>“Trời sinh thánh mạch lại đối với võ đạo hiểu sâu như vậy khắc, một bộ Huyền Giai hạ phẩm Chưởng Pháp lại bị hắn ở thời gian ngắn như vậy tu luyện thành công, hắn hôm nay mới khó khăn lắm phá vỡ mà vào Thông Linh cảnh mà thôi”</p>
			<p>Tử Hàn nhướng mày một cái, hắn nghe được Huyết Nguyệt lời nói, hắn Ngũ Cảm ở tối nay trở nên phá lệ bén nhạy, Huyết Nguyệt thanh âm rất nhẹ, hắn lại nghe chân thiết, quay đầu đang lúc, thấy Huyết Nguyệt, nói “Ngươi không phải là ngủ đi?”</p>
			<p>“Bản vương nghe phía bên ngoài động tĩnh đặc biệt đến xem thử, không nghĩ tới coi như Bản vương truyền nhân, ngươi biểu hiện vẫn không tệ nha, lại nhưng đã luyện thành Thôn Linh Chưởng”</p>
			<p>Tử Hàn lộ ra một nụ cười, nói "Nhưng là ta cảm giác một chưởng này bổ xuống,</p>
			<p>Ta linh lực tựa hồ cũng tiêu hao sắp tới 1 phần 3 "</p>
			<p>“Thiếu niên Lang, đừng nóng, ngươi mới Thông Linh sơ kỳ, hơn nữa Thôn Linh Chưởng nhưng là Huyền Giai Chưởng Pháp tinh diệu rất, đối với ngươi mà nói Tự Nhiên tiêu hao đại”</p>
			<p>Huyết Nguyệt nhìn Tử Hàn đáy mắt lộ ra vẻ quái dị, lần nữa mở miệng nói “Đi, với Bản vương vào nhà, cho ngươi đồ tốt”</p>
			<p>“Thứ gì?”</p>
			<p>Huyết Nguyệt không nói gì, đi vào phòng, cánh trôi lơ lửng đang lúc một vệt ánh sáng màu bạc chợt lóe, một khối to lớn Ngọc Thạch nổi lên, rơi trên mặt đất, cả nhà nhẹ nhàng run rẩy, lớn như vậy Ngọc Thạch giống như một giường lớn như thế.</p>
			<p>Tử Hàn nhìn trước mắt Ngọc Thạch, há to mồm nói “Khối ngọc lớn như vậy, có thể bán không ít tiền đi”</p>
			<p>“Thật là không có kiến thức, đây chính là Thánh Ngọc chế tạo, lớn như vậy khối Thánh Ngọc, ngươi có nhiều tiền hơn nữa cũng mua không được, này nhưng năm đó Bản vương trải qua Cửu Tử Nhất Sinh mới đến chí bảo”</p>
			<p>Tử Hàn duỗi tay sờ xoạng đến Thánh Ngọc giường, một cổ cực kỳ linh khí nồng nặc truyền tới, nhất thời hắn lần nữa cảm thấy giật mình.</p>
			<p>“Sau này ngươi ngay tại Thánh trên giường ngọc tu luyện tu hành, một năm tu hành tốc độ sánh được ở thiên địa linh khí đậm đà Bảo Địa tu luyện ba năm”</p>
			<p>Tử Hàn trừng mắt to nhìn Thánh Ngọc giường, ở phía trên khoanh chân ngồi xuống, một cổ linh khí nồng nặc nhất thời tràn vào thân thể của hắn hóa thành linh lực, Tử Hàn há hốc miệng ba, sau đó hơi khẽ cau mày nhìn Huyết Nguyệt, hỏi “Ngươi là thế nào mang theo lớn như vậy món đồ”</p>
			<p>“Bản vương có không gian bảo vật, cái gì không thể mang, coi như đem cả tòa thành trì dọn đi cũng không có vấn đề gì”</p>
			<p>“Oa” Tử Hàn nhìn Huyết Nguyệt ánh mắt lộ ra vẻ nôn nóng, nói “Có thể cho ta mượn dùng hai ngày sao?”</p>
			<p>Huyết Nguyệt một cái lông chim ở móc mũi, một đôi mắt nhỏ hơi nheo lại, nói “Lợi hại như vậy đồ vật tại sao có thể tùy tiện dùng linh tinh”</p>
			<p>Tử Hàn cười một tiếng, sau đó ở Thánh trên giường ngọc bắt đầu tu luyện, một đạo Ấn Pháp kết xuất, từng đạo linh khí không có vào thân thể của hắn tụ vào mi tâm hóa thành linh lực, thẳng đến trời sáng, Tử Hàn mở mắt, ngạc nhiên phát hiện trải qua một đêm tu luyện trong thân thể linh lực so với trước muốn hùng hậu rất nhiều, trong lúc mơ hồ sắp đạt tới Thông Linh trung kỳ.</p>
			<p>Tử Hàn đứng dậy, nói “Đi thôi, hôm nay lần đầu tiên, nên đi Tàng Thư Lâu”</p>
			<p>Huyết Nguyệt vô cùng không tình nguyện bò dậy, lần nữa đem Thánh Ngọc giường thu, nằm ở Tử Hàn đầu vai, đi theo hắn đi ra ngoài, Tử Hàn trong tay sau lưng cõng lấy sau lưng trường kiếm, đi xuyên qua tu luyện tràng, đi tới một tòa kiến trúc cao lớn lâu vũ trước, lâu vũ chi trên có ba cái thiếp vàng chữ to —— Tàng Thư Lâu.</p>
			<p>Ở Tử Tộc hoa rơi thành chi nhánh bên trong, mỗi tháng ban đầu nhất gia tộc Trung Võ người đều có thể đi vào Tàng Thư Lâu xem duyệt công pháp võ thuật, cho nên mỗi tháng lần đầu tiên thời điểm luôn là trong gia tộc võ giả tụ tập nhiều khi nhất sau khi, lúc này Tử Hàn đi tới Tàng Thư Lâu trước.</p>
			<p>Lúc này mới khó khăn lắm lúc sáng sớm, đã có rất nhiều trong gia tộc đệ tử đi tới Tàng Thư Lâu trước chờ đợi lầu cửa mở ra.</p>
			<p>Làm Tử Hàn đi tới nơi này thời điểm, nhất thời hội tụ vô số quái dị ánh mắt, Tử Hàn mặc dù không có thể tu hành, nhưng là ở Tử Tộc cái này chi nhánh bên trong nhưng là cực kỳ Nổi danh ". Bởi vì là mọi người đều biết Tử tộc chủ nhà Lục thiếu gia là một không thể tu hành phế vật, là bị chủ nhà đày đi tới đây chờ chết.</p>
			<p>“Đây không phải là chủ nhà Lục thiếu gia sao? Hắn thế nào cũng tới Tàng Thư Lâu?”</p>
			<p>“Tên phế vật kia thật đúng là không biết tự lượng sức mình, muốn tiến vào Tàng Thư Lâu?”</p>
			<p>Tử Hàn thẳng tắp đứng ở Tàng Thư Lâu trước, bọn họ lời nói lại rõ ràng rơi tại chính mình trong tai, nhưng là Tử Hàn lại chưa từng chút nào để ý, tựa như ư đã thành thói quen.</p>
			<p>“Các ngươi quá mức, chớ nói người ta như vậy”</p>
			<p>Tử Hàn hơi kinh ngạc, có chút ghé mắt, một tên mười bốn mười lăm tuổi thiếu nữ người mặc quần dài màu lam nhạt, non nớt khuôn mặt nhỏ nhắn rất là thanh tú, nàng được đặt tên là Tử Diệp, là Tử Tộc điều này chi nhánh thiên tài, lúc này Tử Diệp đang nhìn Tử Hàn hiếu kỳ đánh giá.</p>
			<p>Tử Hàn ghé mắt hướng về phía Tử Diệp nhẹ nhàng cười cười, Tử Diệp đầu tiên là sửng sốt một chút sau đó đi lên, đứng ở Tử Hàn trước mặt, mở miệng nói “Tử Hàn ca ca, ngươi đi nhanh đi, đợi một hồi Tử Lạc tới hắn khẳng định lại phải đánh ngươi”</p>
			<p>“Nữ Oa, ngươi là có nhiều khinh bỉ hắn a, chẳng lẽ hắn cũng chỉ có thể là bị đánh đoán?”</p>
			<p>Huyết Nguyệt nhàn nhạt liếc mắt nhìn Tử Diệp, Tử Diệp đánh giá Huyết Nguyệt cảm giác mười phần tức cười, đưa tay thì đi bắt Huyết Nguyệt muốn ngắt nhéo một cái.</p>
			<p>Mọi người nghe được Huyết Nguyệt mở miệng mới vừa chú ý tới cái này chưa đủ ba tấc Tiểu Thú, mặc dù là có chút ngạc nhiên, lại cũng không phải là như thế nào ý, dù sao thế giới lớn không thiếu cái lạ, rất nhiều Yêu Thú linh trí cực cao, trời sinh liền có thể miệng nói tiếng người, bị người thu làm Linh Sủng, nhưng là mọi người kinh dị chỗ nhưng ở với trong mắt bọn họ cái phế vật này thiếu gia đi nơi nào thu Linh Sủng.</p>
			<p>Tử Hàn hướng về phía Tử Diệp cười nói “Cám ơn ngươi, Tử Diệp, bất quá ta không sợ hắn”</p>
			<p>Tử Diệp thu tay về nhìn Tử Hàn giương mắt nói “Không được, ngươi đánh không lại hắn, đến lúc đó ngươi lại phải đau chừng mấy ngày”</p>
			<p>Tử Hàn ôn uyển cười một tiếng, vừa muốn mở miệng, xa xa Tử Lạc đi đi tới, trong mắt mang theo vẻ ngạo mạn căn bản không đem Tử Hàn coi vào đâu, sau lưng như cũ đi theo ngày hôm qua hai người kia, hai người trong mắt mang theo vẻ châm chọc nhìn Tử Hàn, khinh thường nói “Ồ, một đêm không thấy Tử Hàn thiếu gia dài tính khí, thậm chí ngay cả Tử Lạc đại ca cũng không sợ?”</p>
			<p>Tử Diệp nhìn Tử Lạc đi tới, nhút nhát tránh qua một bên, không dám nhìn nữa Tử Hàn, Tử Hàn nhìn Tử Diệp lại không có một tia trách cứ ý tứ, ngược lại đáy lòng có một tia ấm áp, dù sao cùng hắn nói như vậy những năm gần đây cũng liền một cái Tử Diệp mà thôi.</p>
			<p>Mọi người thấy Tử Lạc đi tới, ánh mắt lộ ra một bộ vẻ chờ mong, có người nhẹ nhàng mở miệng nói “Xem ra hôm nay lại có trò hay nhìn, Tử Lạc nhưng là một mực không ưa Tử Hàn a”</p>
			<p>“Ai, cái này chủ nhà thiếu gia thật là đáng thương a, phỏng chừng lần này nửa tháng đều xuống không giường”</p>
			<p>Ngay tại cũng cho là Tử Hàn sẽ ảo não chạy trốn lúc, Tử Hàn khóe miệng vén lên một tia độ cong, khẽ cười nói “Ta Tử Hàn chính là chủ nhà thiếu gia, ngươi coi là cái gì chó má, coi như ngươi mạch gia chủ cũng không xứng nói với ta như vậy”</p>
			<p>Hí!</p>
			<p>Tử Hàn lời nói một nơi, mọi người đều là hít một hơi lãnh khí, có chút khiếp sợ nhìn Tử Hàn, nhưng mà lại lộ ra một vệt thương hại ánh mắt.')
			
		


SET IDENTITY_INSERT [dbo].[Chapter] OFF
GO

INSERT INTO [dbo].[Chapter_Owned]([user_id],[chapter_id]) VALUES
	(2,1),(3,1),(4,1),(8,1),
	(2,3),(5,3),(9,3),(13,3),
	(7,4),(10,4),
	-- (6,5),(7,5),
	(8,6),(9,6),(15,6),
	(8,7),(9,7),(15,7),
	(8,8),(9,8),(15,8),
	(8,10),(9,10),(15,10),
	(8,12),(9,12),(15,12)

INSERT INTO [dbo].[Chapter_Liked]([user_id],[chapter_id]) VALUES
	(2,1),(3,1),(4,1),(8,1),
	(2,3),(5,3),(9,3),(13,3),
	(7,4),(10,4),
	-- (6,5),(7,5),
	(8,6),(9,6),(15,6),
	(8,7),(9,7),(15,7),
	(8,8),(9,8),(15,8),
	(8,10),(9,10),(15,10),
	(8,12),(9,12),(15,12)

SET IDENTITY_INSERT [dbo].[Comment] ON
GO

DECLARE @CommentId INT = 1; -- Start comment_id from 1
DECLARE @UserId INT = 2; -- Start user_id from 1
DECLARE @StoryId INT = 1; -- Start story_id from 1

WHILE @UserId <= 20 -- End user_id at 20
BEGIN
    WHILE @StoryId <= 23 -- End story_id at 17
    BEGIN
        INSERT INTO [dbo].[Comment] ([comment_id], [user_id], [story_id], [chapter_id], [comment_content], [comment_date])
        VALUES (@CommentId, @UserId, @StoryId, null, N'Truyện hay quá', CAST(N'2023-09-24' AS DateTime));

        SET @StoryId = @StoryId + 1; -- Increment story_id
        SET @CommentId = @CommentId + 1; -- Increment comment_id
    END

    SET @StoryId = 1; -- Reset story_id to 1
    SET @UserId = @UserId + 1; -- Increment user_id
END
GO

SET IDENTITY_INSERT [dbo].[Comment] OFF
GO


-- SET IDENTITY_INSERT [dbo].[CommentResponse] ON
-- GO

-- DECLARE @Run INT = 1; -- Start comment_id from 1
-- DECLARE @CommentRepId INT = 1; -- Start comment_id from 1
-- DECLARE @CommentId INT = 1; -- Start comment_id from 1
-- DECLARE @UserId INT = 2; -- Start user_id from 1

-- WHILE @UserId <= 20 -- End user_id at 20
-- BEGIN

-- 	DECLARE @Temp INT = @UserId; -- Start user_id from 1
--     WHILE @Run <= 5 -- End story_id at 17
--     BEGIN
-- 		INSERT INTO [dbo].[CommentResponse] ([comment_response_id], [user_id], [comment_id], [comment_content], [comment_date])
-- 		VALUES (@CommentRepId, @Temp, @CommentId, 'I love u', CAST(N'2023-10-24' AS Date));

-- 		SET @Temp = @Temp + 1;
-- 		SET @Run = @Run + 1;
-- 		SET @CommentRepId = @CommentRepId + 1; -- Increment story_id
-- 	END

-- 	SET @CommentId = @CommentId + 1; -- Increment comment_id
-- 	SET @Run = 1;
--     SET @UserId = @UserId + 1; -- Increment user_id
-- END
-- GO

-- SET IDENTITY_INSERT [dbo].[CommentResponse] OFF
-- GO

SET IDENTITY_INSERT [dbo].[ReportType] ON
GO

	INSERT INTO [dbo].[ReportType] ([report_type_id], [report_type_content])
	VALUES 
		(1, N'Nội dung khiêu dâm'),
		(2, N'Nội dung bạo lực hoặc phản cảm'),
		(3, N'Nội dung thù địch hoặc lạm dụng'),
		(4, N'Quấy rối hoặc bắt nạt'),
		(5, N'Hành vi có hại hoặc nguy hiểm'),
		(6, N'Lạm dụng trẻ em'),
		(7, N'Chủ nghĩa khủng bố'),
		(8, N'Spam hoặc gây hiểu nhầm'),
		(9, N'Vi phạm quyền lợi'),
		(10, N'Vấn đề về phụ đề')

SET IDENTITY_INSERT [dbo].[ReportType] OFF
GO

SET IDENTITY_INSERT [dbo].[ReportContent] ON
GO

	INSERT INTO [dbo].[ReportContent] ([report_id], [user_id],[report_type_id],[story_id],[chapter_id],[comment_id],[report_content],[report_date],[status])
	VALUES 
		(1, 5, 1, 1, null, null, N'Truyện không phù hợp', CAST(N'2023-12-24' AS Date),null),
		(2, 12, 7, 1, null, null, N'không phù hợp', CAST(N'2023-12-24' AS Date),null),
		(3, 14, 5, 4, null, null, N' không phù hợp', CAST(N'2023-12-24' AS Date),null),
		(4, 25, 7, 3, null, null, N' không phù hợp', CAST(N'2023-12-24' AS Date),null),
		(5, 5, 8, null, 1, null, N' không phù hợp', CAST(N'2023-12-24' AS Date),null),
		(6, 24, 10, null, 4, null, N' không phù hợp', CAST(N'2023-12-24' AS Date),null),
		(7, 16, 3, null, null, 3, N' không phù hợp', CAST(N'2023-12-24' AS Date),null),
		(8, 35, 2, null, null, 14, N' không phù hợp', CAST(N'2023-12-24' AS Date),null),
		(9, 25, 6, null, null, 24, N' không phù hợp', CAST(N'2023-12-24' AS Date),null)
		
SET IDENTITY_INSERT [dbo].[ReportContent] OFF
GO

SET IDENTITY_INSERT [dbo].[Ticket] ON 
GO

INSERT INTO [dbo].[Ticket]([ticket_id],[user_id],[ticket_date],[status],[seen])
     VALUES
           (1, 2, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (2, 3, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (3, 4, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (4, 5, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (5, 6, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (6, 7, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (7, 8, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (8, 9, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (9, 10, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (10, 11, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (11, 12, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (12, 13, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (13, 14, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (14, 15, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (15, 16, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (16, 17, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (17, 18, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (18, 19, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (19, 20, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 1 , 1),
           (20, 21, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 0 , 1),
           (21, 22, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 0 , 1),
           (22, 23, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 0 , 1),
           (23, 24, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 0 , 1),
           (24, 25, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 0 , 1),
           (25, 26, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 0 , 1),
           (26, 27, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 0 , 1),
           (27, 28, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 0 , 1),
           (28, 29, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 0 , 1),
           (29, 30, CAST(N'2023-01-01T05:52:10.323' AS DateTime), 0 , 1)
GO
SET IDENTITY_INSERT [dbo].[Ticket] OFF
GO

SET IDENTITY_INSERT [dbo].[Transaction] ON
GO
INSERT INTO [dbo].[Transaction]([transaction_id],[wallet_id],[story_id],[chapter_id],[amount],[fund_before],[fund_after],[refund_before],[refund_after],[transaction_time],[status],[description])
     VALUES
		(1,1 ,12,null,20,30,10,0,0,CAST(N'2023-02-20 20:30:22.103' AS DateTime),1,N'Nhận TLH từ truyện Gone Girl '),
		(2,2 ,13,null,20,30,10,0,0,CAST(N'2023-01-20 20:32:22.103' AS DateTime),1,N'Mua 2 chương của truyện Gone Girl '),
		(3,3 ,14,null,20,50,30,0,0,CAST(N'2023-03-23 20:30:22.103' AS DateTime),1,N'Mua 2 chương của truyện Gone Girl '),
		(4,4 ,15,null,20,32,12,0,0,CAST(N'2023-03-25 20:33:22.103' AS DateTime),1,N'Mua 1 chương của truyện Gone Girl '),
		(5,5 ,10,null,20,35,15,0,0,CAST(N'2023-04-21 20:36:22.103' AS DateTime),1,N'Mua 3 chương của truyện Gone Girl '),
		(6,6 ,09,null,20,40,20,0,0,CAST(N'2024-05-20 20:2:22.103' AS DateTime),1,N'Mua 5 chương của truyện Gone Girl '),
		(7,1,1,2,5.00,0.00,0.00,5.00,0.00,CAST(N'2024-04-10 20:30:22.103' AS DateTime),1,N'Nhận TLH từ truyện Gone Girl '),
		(8,4,1,2,5.00,15.00,10.00,0.00,0.00,CAST(N'2024-05-20 20:30:22.103' AS DateTime),1,N'Mua chương 2 của truyện Gone Girl '),
		(10,1,1,3,5.00,0.00,10.00,5.00,0.00,CAST(N'2024-05-20 20:30:22.103' AS DateTime),1,N'Nhận TLH từ truyện Gone Girl'),
		(11,4,1,3,5.00,210.00,205.00,0.00,0.00,CAST(N'2025-03-20 20:30:22.103' AS DateTime),1,N'Mua chương 3 NICK DUNNE in story Gone Girl '),
		(12,2,2,NULL,12.99,0.00,0.00,34.99,22.00,CAST(N'2024-02-20 21:52:08.117' AS DateTime),1,N'Nhận TLH từ truyện And Then There Were None'),
		(13,3,NULL,NULL,200.00,10.00,210.00,0.00,0.00,CAST(N'2024-03-20 20:30:22.103' AS DateTime),1,N'Mua truyện And Then There Were None'),
		(14,1,1,3,5.00,0.00,10.00,5.00,0.00,CAST(N'2024-02-20 20:30:22.103' AS DateTime),1,N'Nhận TLH từ truyện Gone Girl'),
		(15,2,1,3,5.00,210.00,205.00,0.00,0.00,CAST(N'2024-02-20 20:30:22.103' AS DateTime),1,N'Mua chương 3 của truyện Gone Girl '),
		(16,4,1,NULL,30.00,	147.00,117.00,0.00,0.00,CAST(N'2024-01-20 20:30:22.103' AS DateTime),1,N'Buy chapter 1 to 20 in story Gone Girl '),
		(17,1,1,NULL,15.00,	0.00,0.00,85.00,70.00,CAST(N'2024-01-20 20:30:22.103' AS DateTime),1,N'Nhận TLH từ truyện Gone Girl '),
		(18,5,1,NULL,30.00,147.00,117.00,0.00,0.00,CAST(N'2024-01-20 20:30:22.103' AS DateTime),1,N'Mua 3 chương của truyện Gone Girl '),
		(19,6,1,NULL,15.00,132.00,117.00,0.00,0.00,CAST(N'2024-04-20 20:30:22.103' AS DateTime),1,N'Mua chương 1 to 20 in story Gone Girl '),
		(20,1,1,NULL,0.00,0.00,0.00,70.00,70.00,CAST(N'2024-08-20 20:30:22.103' AS DateTime),1,N'Nhận TLH từ truyện Gone Girl '),
		(21,7,1,NULL,0.00,132.00,132.00,0.00,0.00,CAST(N'2024-09-20 20:30:22.103' AS DateTime),1,N'Mua 1 chương của truyện Gone Girl '),
		(22,1,1,NULL,5.00,0.00,0.00,80.00,	75.00,CAST(N'2024-08-20 20:30:22.103' AS DateTime),1,N'Nhận TLH từ truyện Gone Girl '),
		(23,12,1,NULL,5.00,127.00,122.00,0.00,0.00,CAST(N'2024-08-20 20:30:22.103' AS DateTime),1,N'Mua 2 chương của truyện Gone Girl '),
		(24,1,1,NULL,0.00,0.00,0.00,75.00,75.00,CAST(N'2024-02-20 20:30:22.103' AS DateTime),1,N'Nhận TLH từ truyện Gone Girl '),
		(25,9,1,NULL,0.00,127.00,127.00,0.00,0.00,CAST(N'2024-01-20 20:30:22.103' AS DateTime),1,N'Mua 1 chương của truyện Gone Girl '),
		(26,1,1,NULL,0.00,0.00,0.00,75.00,75.00,CAST(N'2024-01-20 20:30:22.103' AS DateTime),1,N'Nhận TLH từ truyện Gone Girl ')
DECLARE @transaction_id INT = 27; -- Start comment_id from 1
DECLARE @wallet_id INT = 2; -- Start user_id from 1
DECLARE @transaction_time datetime = CAST(N'2024-01-20 20:30:22.103' AS DateTime);
DECLARE @wallet_admin INT = 0;

WHILE @wallet_id <= 20 -- End user_id at 20
BEGIN
    BEGIN
        INSERT INTO [dbo].[Transaction]([transaction_id],[wallet_id],[story_id],[chapter_id],[amount],[fund_before],[fund_after],[refund_before],[refund_after],[transaction_time],[status],[description])
        VALUES 
		(@transaction_id, @wallet_id, null, null, 200, 0.00,200.00,	0.00,0.00,@transaction_time,1,N'Nạp 200'),
		(@transaction_id+1, @wallet_id, null, null, 200, @wallet_admin, @wallet_admin +200.00,	0.00,0.00,@transaction_time,1,N'Nạp 200 vào hệ thống'),
		(@transaction_id+2,@wallet_id,NuLL,NULL,50.00,0.00,0.00,200.00,150.00,@transaction_time + 20,1,N'Rút 50'),
		(@transaction_id+3,@wallet_id,NuLL,NULL,50.00,0.00,0.00,@wallet_admin +200.00,@wallet_admin +200.00 -50,@transaction_time+20,1,N'Rút 50 từ hệ thống')
		;
        SET @transaction_id = @transaction_id + 4; -- Increment comment_id
		SET @wallet_admin = @wallet_admin + 200 - 50;
		SET @transaction_time = @transaction_time + 1
    END
    SET @wallet_id = @wallet_id + 1; -- Increment user_id
END

INSERT [dbo].[Transaction] ([transaction_id], [wallet_id], [story_id], [chapter_id], [amount], [fund_before], [fund_after], [refund_before], [refund_after], [transaction_time], [status], [description]) 
	VALUES 
		(103, 2, NULL, NULL, CAST(251.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), CAST(99749.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:28:50.127' AS DateTime), 1, N'Rút 251.00'),
		(104, 1, NULL, NULL, CAST(251.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(100000.00 AS Decimal(10, 2)), CAST(99749.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:28:50.127' AS DateTime), 1, N'Rút 251.00 khỏi hệ thống'),
		(105, 3, NULL, NULL, CAST(251.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(12300.00 AS Decimal(10, 2)), CAST(12049.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:28:51.147' AS DateTime), 1, N'Rút 251.00'),
		(106, 1, NULL, NULL, CAST(251.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(99749.00 AS Decimal(10, 2)), CAST(99498.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:28:51.147' AS DateTime), 1, N'Rút 251.00 khỏi hệ thống'),
		(107, 2, NULL, NULL, CAST(1324.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(99749.00 AS Decimal(10, 2)), CAST(98425.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:28:57.853' AS DateTime), 1, N'Rút 1324.00'),
		(108, 1, NULL, NULL, CAST(1324.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(99498.00 AS Decimal(10, 2)), CAST(98174.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:28:57.853' AS DateTime), 1, N'Rút 1324.00 khỏi hệ thống'),
		(109, 2, NULL, NULL, CAST(13.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(98425.00 AS Decimal(10, 2)), CAST(98412.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:01.000' AS DateTime), 1, N'Rút 13.00'),
		(110, 1, NULL, NULL, CAST(13.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(98174.00 AS Decimal(10, 2)), CAST(98161.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:01.000' AS DateTime), 1, N'Rút 13.00 khỏi hệ thống'),
		(111, 3, NULL, NULL, CAST(33.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(12049.00 AS Decimal(10, 2)), CAST(12016.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), 1, N'Rút 33.00'),
		(112, 1, NULL, NULL, CAST(33.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(98161.00 AS Decimal(10, 2)), CAST(98128.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), 1, N'Rút 33.00 khỏi hệ thống'),
		(113, 3, NULL, NULL, CAST(43.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(12016.00 AS Decimal(10, 2)), CAST(11973.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), 1, N'Rút 43.00'),
		(114, 1, NULL, NULL, CAST(43.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(98128.00 AS Decimal(10, 2)), CAST(98085.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), 1, N'Rút 43.00 khỏi hệ thống'),
		(115, 4, NULL, NULL, CAST(33.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(52211.00 AS Decimal(10, 2)), CAST(52178.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), 1, N'Rút 33.00'),
		(116, 1, NULL, NULL, CAST(33.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(98085.00 AS Decimal(10, 2)), CAST(98052.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), 1, N'Rút 33.00 khỏi hệ thống'),
		(117, 10, NULL, NULL, CAST(323.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(1502.00 AS Decimal(10, 2)), CAST(1179.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), 1, N'Rút 323.00'),
		(118, 1, NULL, NULL, CAST(323.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(98052.00 AS Decimal(10, 2)), CAST(97729.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), 1, N'Rút 323.00 khỏi hệ thống'),
		(119, 2, NULL, NULL, CAST(313.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(98412.00 AS Decimal(10, 2)), CAST(98099.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), 1, N'Rút 313.00'),
		(120, 1, NULL, NULL, CAST(313.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(97729.00 AS Decimal(10, 2)), CAST(97416.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), 1, N'Rút 313.00 khỏi hệ thống'),
		(121, 10, NULL, NULL, CAST(33.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(1179.00 AS Decimal(10, 2)), CAST(1146.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), 1, N'Rút 33.00'),
		(122, 1, NULL, NULL, CAST(33.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(97416.00 AS Decimal(10, 2)), CAST(97383.00 AS Decimal(10, 2)), CAST(N'2024-03-29T23:29:23.750' AS DateTime), 1, N'Rút 33.00 khỏi hệ thống')

SET IDENTITY_INSERT [dbo].[Transaction] OFF
GO

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

ALTER TABLE [dbo].[Review]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
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

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 mean Fail, 1 mean Pending, 2 mean Successful' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transaction', @level2type=N'COLUMN',@level2name=N'status'
GO
USE [master]
GO
ALTER DATABASE [Easy_Publishing] SET  READ_WRITE 
GO
