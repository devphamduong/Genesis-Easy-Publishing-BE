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
begin
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

-- table User
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [nvarchar](50) NULL,
	[gender] [bit] NULL,
	[dob] [date] NULL,
	[email] [varchar](50) NOT NULL,
	[phone] [varchar](11) NULL,
	[address] [nvarchar](200) NULL,
	[username] [nvarchar](50) NOT NULL,
	[password] [nvarchar](50) NOT NULL,
	[user_image] [nvarchar](4000) NULL,
 CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
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
	[transaction_id] [bigint] IDENTITY(3000000,1) NOT NULL,
	[wallet_id] [int] NOT NULL,
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

-- table Story_Follow
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Story_Follow](
	[user_id] [int] NOT NULL,
	[story_id] [int] NOT NULL,
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
	[title] [nvarchar](100) NOT NULL,
	[author_id] [int] NOT NULL,
	[story_price] [decimal](10, 2) NOT NULL,
	[story_sale] [decimal] NULL,
	[story_image] [varchar](4000) NULL,
	[story_description] [nvarchar](4000) NULL,
	[status] [bit] NULL,
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

-- table Chapter
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chapter](
	[chapter_id] [int] IDENTITY(1,1) NOT NULL,
	[story_id] [int] NOT NULL,
	[chapter_title] [nvarchar](100) NOT NULL,
	[chapter_content] [ntext] NOT NULL,
	[chapter_price] [decimal](10, 2) NULL,
	[status] [bit] NULL,
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
	[chapter_id] [int] NOT NULL,
 CONSTRAINT [PK_chapter_owned] PRIMARY KEY CLUSTERED 
(
	[user_id],[chapter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Story_Issue
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Story_Issue](
	[issue_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[story_id] [int] NULL,
	[issue_title] [nvarchar](100) NOT NULL,
	[issue_content] [nvarchar](500) NOT NULL,
	[issue_date] [date] NOT NULL,
  CONSTRAINT [PK_story_issue] PRIMARY KEY CLUSTERED 
(
	[issue_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Comment
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comment](
	[comment_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[story_id] [int] NULL,
	[chapter_id] [int] NULL,
	[issue_id] [int] NULL,
	[comment_content] [nvarchar](2000) NOT NULL,
	[comment_date] [date] NOT NULL,
 CONSTRAINT [PK_comment] PRIMARY KEY CLUSTERED 
(
	[comment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- table Report
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Report](
	[report_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[story_id] [int] NULL,
	[chapter_id] [int] NULL,
	[issue_id] [int] NULL,
	[transaction_id] [bigint] NULL,
	[comment_id] [int] NULL,
	[report_content] [nvarchar](2000) NOT NULL,
	[report_date] [date] NOT NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_report] PRIMARY KEY CLUSTERED 
(
	[report_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [dbo].[User] ON 
GO

INSERT INTO [dbo].[User] ([user_id],[user_name],[gender],[dob],[email],[phone],[address],[username],[password],[user_image])
     VALUES (1, N'Duy Pham', 1, CAST(N'2002-12-25' AS Date), N'duypd@fpt.edu.vn', N'0382132025', N'FBT University ', N'duypd', N'123', N'123')
GO

SET IDENTITY_INSERT [dbo].[User] OFF
GO


ALTER TABLE [dbo].[Wallet]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD FOREIGN KEY([wallet_id])
REFERENCES [dbo].[Wallet] ([wallet_id])
GO

ALTER TABLE [dbo].[Story_Follow]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Story_Follow]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Story_Owned]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Story_Owned]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Story_Category]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Story_Category]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[Category] ([category_id])
GO

ALTER TABLE [dbo].[Story_Interaction]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Chapter]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Chapter_Owned]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Chapter_Owned]  WITH CHECK ADD FOREIGN KEY([chapter_id])
REFERENCES [dbo].[Chapter] ([chapter_id])
GO

ALTER TABLE [dbo].[Story_Issue]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Story_Issue]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Comment]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Comment]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Comment]  WITH CHECK ADD FOREIGN KEY([chapter_id])
REFERENCES [dbo].[Chapter] ([chapter_id])
GO

ALTER TABLE [dbo].[Comment]  WITH CHECK ADD FOREIGN KEY([issue_id])
REFERENCES [dbo].[Story_Issue] ([issue_id])
GO


ALTER TABLE [dbo].[Report]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[User] ([user_id])
GO

ALTER TABLE [dbo].[Report]  WITH CHECK ADD FOREIGN KEY([story_id])
REFERENCES [dbo].[Story] ([story_id])
GO

ALTER TABLE [dbo].[Report]  WITH CHECK ADD FOREIGN KEY([chapter_id])
REFERENCES [dbo].[Chapter] ([chapter_id])
GO

ALTER TABLE [dbo].[Report]  WITH CHECK ADD FOREIGN KEY([issue_id])
REFERENCES [dbo].[Story_Issue] ([issue_id])
GO

ALTER TABLE [dbo].[Report]  WITH CHECK ADD FOREIGN KEY([transaction_id])
REFERENCES [dbo].[Transaction] ([transaction_id])
GO

ALTER TABLE [dbo].[Report]  WITH CHECK ADD FOREIGN KEY([comment_id])
REFERENCES [dbo].[Comment] ([comment_id])
GO



EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 mean Fail, 1 mean Pending, 2 mean Successful' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transaction', @level2type=N'COLUMN',@level2name=N'status'
GO
USE [master]
GO
ALTER DATABASE [Easy_Publishing] SET  READ_WRITE 
GO