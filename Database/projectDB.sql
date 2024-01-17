USE [master]
GO
/****** Object:  Database [BOOKIE]    Script Date: 10/3/2022 12:24:24 AM ******/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'BOOKIE')
BEGIN
	ALTER DATABASE [BOOKIE] SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE [BOOKIE] SET ONLINE;
	DROP DATABASE [BOOKIE];
END
GO
CREATE DATABASE [BOOKIE]
GO
ALTER DATABASE [BOOKIE] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BOOKIE].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BOOKIE] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BOOKIE] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BOOKIE] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BOOKIE] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BOOKIE] SET ARITHABORT OFF 
GO
ALTER DATABASE [BOOKIE] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BOOKIE] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BOOKIE] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BOOKIE] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BOOKIE] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BOOKIE] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BOOKIE] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BOOKIE] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BOOKIE] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BOOKIE] SET  ENABLE_BROKER 
GO
ALTER DATABASE [BOOKIE] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BOOKIE] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BOOKIE] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BOOKIE] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BOOKIE] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BOOKIE] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BOOKIE] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BOOKIE] SET RECOVERY FULL 
GO
ALTER DATABASE [BOOKIE] SET  MULTI_USER 
GO
ALTER DATABASE [BOOKIE] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BOOKIE] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BOOKIE] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BOOKIE] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BOOKIE] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BOOKIE] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BOOKIE', N'ON'
GO
ALTER DATABASE [BOOKIE] SET QUERY_STORE = OFF
GO
USE [BOOKIE]
GO
/****** Object:  Table [dbo].[Book]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](100) NULL,
	[author] [nvarchar](80) NULL,
	[categoryid] [int] NULL,
	[rating] [decimal](10, 2) NULL,
	[favourite] [int] NULL,
	[price] [decimal](10, 2) NULL,
	[is_sale] [bit] NULL,
	[image] [varchar](4000) NULL,
	[description] [nvarchar](4000) NULL,
	[views] [int] NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_book] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Book_Own]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book_Own](
	[userId] [int] NOT NULL,
	[bookId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NULL,
 CONSTRAINT [PK_category] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Chapter]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chapter](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[bookId] [int] NOT NULL,
	[volumeId] [int] NOT NULL,
	[chapter] [int] NOT NULL,
	[chapterName] [nvarchar](100) NULL,
	[status] [bit] NOT NULL,
	[content] [ntext] NOT NULL,
 CONSTRAINT [PK_chapter] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Comment]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comment](
	[bookId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[comment] [nvarchar](2000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Content]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Content](
	[chapterId] [int] NOT NULL,
	[paragraph] [int] NOT NULL,
	[content] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Favourite]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Favourite](
	[uid] [int] NOT NULL,
	[bid] [int] NOT NULL,
 CONSTRAINT [PK_favourite] PRIMARY KEY CLUSTERED 
(
	[uid] ASC,
	[bid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payment_Account]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment_Account](
	[accountNumber] [bigint] NOT NULL,
	[balance] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_Payment_Account] PRIMARY KEY CLUSTERED 
(
	[accountNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payment_Method]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment_Method](
	[paymentId] [int] IDENTITY(45678,3) NOT NULL,
	[userId] [int] NOT NULL,
	[accountNumber] [bigint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[active] [bit] NULL,
 CONSTRAINT [PK_Payment_Method] PRIMARY KEY CLUSTERED 
(
	[paymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Report]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Report](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_report] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportDetail]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportDetail](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[reportId] [int] NOT NULL,
	[bookId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[note] [nvarchar](2000) NULL,
 CONSTRAINT [PK_reportdetail] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Star]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Star](
	[bid] [int] NOT NULL,
	[uid] [int] NOT NULL,
	[star] [int] NOT NULL,
 CONSTRAINT [PK_star] PRIMARY KEY CLUSTERED 
(
	[uid] ASC,
	[bid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Token]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Token](
	[userId] [int] NOT NULL,
	[token] [varchar](20) NOT NULL,
	[expiredDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transaction]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transaction](
	[transactionId] [bigint] IDENTITY(3000000,1) NOT NULL,
	[userId] [int] NOT NULL,
	[amount] [decimal](10, 2) NOT NULL,
	[balanceAfter] [decimal](10, 2) NOT NULL,
	[transactionTime] [datetime] NULL,
	[type] [int] NOT NULL,
	[status] [int] NOT NULL,
	[description] [nvarchar](500) NULL,
	[paymentId] [int] NOT NULL,
 CONSTRAINT [PK_Transaction] PRIMARY KEY CLUSTERED 
(
	[transactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transaction_Token]    Script Date: 10/3/2022 12:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transaction_Token](
	[transactionId] [bigint] NOT NULL,
	[token] [nvarchar](50) NOT NULL,
	[status] [bit] NOT NULL,
	[createdTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Transaction_Token] PRIMARY KEY CLUSTERED 
(
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 10/3/2022 12:24:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fullname] [nvarchar](50) NULL,
	[gender] [bit] NULL,
	[dob] [date] NULL,
	[email] [varchar](50) NOT NULL,
	[phone] [varchar](11) NULL,
	[address] [nvarchar](200) NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
	[is_super] [int] NOT NULL,
	[walletNumber] [bigint] NULL,
 CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Volume]    Script Date: 10/3/2022 12:24:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Volume](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[bookId] [int] NOT NULL,
	[volume] [int] NOT NULL,
	[volumeName] [nvarchar](100) NULL,
	[summary] [nvarchar](2000) NULL,
 CONSTRAINT [PK_vol] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Book] ON 

INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (1, N'Gone Girl ', N'Gillian Flynn', 1, NULL, 0, CAST(11.99 AS Decimal(10, 2)), 1, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1554086139l/19288043.jpg', N'Marriage can be a real killer.<br>
On a warm summer morning in North Carthage, Missouri, it is Nick and Amy Dunne’s fifth wedding anniversary. Presents are being wrapped and reservations are being made when Nick’s clever and beautiful wife disappears from their rented McMansion on the Mississippi River. Husband-of-the-Year Nick isn’t doing himself any favors with cringe-worthy daydreams about the slope and shape of his wife’s head, but passages from Amy''s diary reveal the alpha-girl perfectionist could have put anyone dangerously on edge. Under mounting pressure from the police and the media—as well as Amy’s fiercely doting parents—the town golden boy parades an endless series of lies, deceits, and inappropriate behavior. Nick is oddly evasive, and he’s definitely bitter—but is he really a killer?<br>
As the cops close in, every couple in town is soon wondering how well they know the one that they love. With his twin sister, Margo, at his side, Nick stands by his innocence. Trouble is, if Nick didn’t do it, where is that beautiful wife? And what was in that silvery gift box hidden in the back of her bedroom closet?', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (2, N'And Then There Were None', N'Agatha Christie', 1, NULL, 0, CAST(12.99 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1638425885l/16299._SY475_.jpg', N'First, there were ten—a curious assortment of strangers summoned as weekend guests to a little private island off the coast of Devon. Their host, an eccentric millionaire unknown to all of them, is nowhere to be found. All that the guests have in common is a wicked past they''re unwilling to reveal—and a secret that will seal their fate. For each has been marked for murder. A famous nursery rhyme is framed and hung in every room of the mansion:<br>
"Ten little boys went out to dine; One choked his little self and then there were nine. Nine little boys sat up very late; One overslept himself and then there were eight. Eight little boys traveling in Devon; One said he''d stay there then there were seven. Seven little boys chopping up sticks; One chopped himself in half and then there were six. Six little boys playing with a hive; A bumblebee stung one and then there were five. Five little boys going in for law; One got in Chancery and then there were four. Four little boys going out to sea; A red herring swallowed one and then there were three. Three little boys walking in the zoo; A big bear hugged one and then there were two. Two little boys sitting in the sun; One got frizzled up and then there was one. One little boy left all alone; He went out and hanged himself and then there were none."<br>
When they realize that murders are occurring as described in the rhyme, terror mounts. One by one they fall prey. Before the weekend is out, there will be none. Who has choreographed this dastardly scheme? And who will be left to tell the tale? Only the dead are above suspicion.', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (3, N'The Silent Patient', N'Alex Michaelides', 1, NULL, 0, CAST(10.50 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1582759969l/40097951._SX318_.jpg', N'Alicia Berenson’s life is seemingly perfect. A famous painter married to an in-demand fashion photographer, she lives in a grand house with big windows overlooking a park in one of London’s most desirable areas. One evening her husband Gabriel returns home late from a fashion shoot, and Alicia shoots him five times in the face, and then never speaks another word.<br>
Alicia’s refusal to talk, or give any kind of explanation, turns a domestic tragedy into something far grander, a mystery that captures the public imagination and casts Alicia into notoriety. The price of her art skyrockets, and she, the silent patient, is hidden away from the tabloids and spotlight at the Grove, a secure forensic unit in North London.<br>
Theo Faber is a criminal psychotherapist who has waited a long time for the opportunity to work with Alicia. His determination to get her to talk and unravel the mystery of why she shot her husband takes him down a twisting path into his own motivations—a search for the truth that threatens to consume him....', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (4, N'The Girl on the Train', N'Paula Hawkins', 1, NULL, 0, CAST(13.99 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1574805682l/22557272.jpg', N'Rachel catches the same commuter train every morning. She knows it will wait at the same signal each time, overlooking a row of back gardens. She’s even started to feel like she knows the people who live in one of the houses. “Jess and Jason,” she calls them. Their life—as she sees it—is perfect. If only Rachel could be that happy. And then she sees something shocking. It’s only a minute until the train moves on, but it’s enough. Now everything’s changed. Now Rachel has a chance to become a part of the lives she’s only watched from afar. Now they’ll see; she’s much more than just the girl on the train...', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (5, N'Lord of the Mysteries', N'Cuttlefish That Loves Diving', 2, NULL, 0, CAST(11.99 AS Decimal(10, 2)), 1, N'https://cdn.novelupdates.com/images/2018/11/Lord-of-the-Mysteries.jpeg', N'Waking up to be faced with a string of mysteries, Zhou Mingrui finds himself reincarnated as Klein Moretti in an alternate Victorian era world where he sees a world filled with machinery, cannons, dreadnoughts, airships, difference machines, as well as Potions, Divination, Hexes, Tarot Cards, Sealed Artifacts… The Light continues to shine but the mystery has never gone far. Follow Klein as he finds himself entangled with the Churches of the world—both orthodox and unorthodox—while he slowly develops newfound powers thanks to the Beyonder potions.', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (6, N'The Shining', N' Stephen King', 2, NULL, 0, CAST(12.99 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1353277730l/11588.jpg', N'Jack Torrance''s new job at the Overlook Hotel is the perfect chance for a fresh start. As the off-season caretaker at the atmospheric old hotel, he''ll have plenty of time to spend reconnecting with his family and working on his writing. But as the harsh winter weather sets in, the idyllic location feels ever more remote...and more sinister. And the only one to notice the strange and terrible forces gathering around the Overlook is Danny Torrance, a uniquely gifted five-year-old.', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (7, N'It', N'Stephen King', 2, NULL, 0, CAST(10.50 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1334416842l/830502.jpg', N'Welcome to Derry, Maine ...<br>
It’s a small city, a place as hauntingly familiar as your own hometown. Only in Derry the haunting is real ...<br>
They were seven teenagers when they first stumbled upon the horror. Now they are grown-up men and women who have gone out into the big world to gain success and happiness. But none of them can withstand the force that has drawn them back to Derry to face the nightmare without an end, and the evil without a name.', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (8, N'A Game Of Thrones: A Song of Ice and Fire', N'George RR Martin', 2, NULL, 0, CAST(13.99 AS Decimal(10, 2)), 0, N'https://m.media-amazon.com/images/P/0553386794.01._SCLZZZZZZZ_SX500_.jpg', N'Long ago, in a time forgotten, a preternatural event threw the seasons out of balance. In a land where summers can last decades and winters a lifetime, trouble is brewing. The cold is returning, and in the frozen wastes to the north of Winterfell, sinister and supernatural forces are massing beyond the kingdom’s protective Wall. At the center of the conflict lie the Starks of Winterfell, a family as harsh and unyielding as the land they were born to. Sweeping from a land of brutal cold to a distant summertime kingdom of epicurean plenty, here is a tale of lords and ladies, soldiers and sorcerers, assassins and bastards, who come together in a time of grim omens.
<br>
Here an enigmatic band of warriors bear swords of no human metal; a tribe of fierce wildlings carry men off into madness; a cruel young dragon prince barters his sister to win back his throne; and a determined woman undertakes the most treacherous of journeys. Amid plots and counterplots, tragedy and betrayal, victory and terror, the fate of the Starks, their allies, and their enemies hangs perilously in the balance, as each endeavors to win that deadliest of conflicts: the game of thrones.', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (9, N'The Hunger Games', N'Suzanne Collins', 3, NULL, 0, CAST(15.00 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1586722975l/2767052.jpg', N'Could you survive on your own in the wild, with every one out to make sure you don''t live to see the morning?
<br>
In the ruins of a place once known as North America lies the nation of Panem, a shining Capitol surrounded by twelve outlying districts. The Capitol is harsh and cruel and keeps the districts in line by forcing them all to send one boy and one girl between the ages of twelve and eighteen to participate in the annual Hunger Games, a fight to the death on live TV.
<br>
Sixteen-year-old Katniss Everdeen, who lives alone with her mother and younger sister, regards it as a death sentence when she steps forward to take her sister''s place in the Games. But Katniss has been close to dead before—and survival, for her, is second nature. Without really meaning to, she becomes a contender. But if she is to win, she will have to start making choices that weight survival against humanity and life against love.', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (10, N'The Time Machine', N'H.G. Wells, Greg Bear', 3, NULL, 0, CAST(12.50 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1327942880l/2493.jpg', N'“I’ve had a most amazing time....”<br>
So begins the Time Traveller’s astonishing firsthand account of his journey 800,000 years beyond his own era—and the story that launched H.G. Wells’s successful career and earned him his reputation as the father of science fiction. With a speculative leap that still fires the imagination, Wells sends his brave explorer to face a future burdened with our greatest hopes...and our darkest fears. A pull of the Time Machine’s lever propels him to the age of a slowly dying Earth.  There he discovers two bizarre races—the ethereal Eloi and the subterranean Morlocks—who not only symbolize the duality of human nature, but offer a terrifying portrait of the men of tomorrow as well.  Published in 1895, this masterpiece of invention captivated readers on the threshold of a new century.', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (11, N'Outlander', N'Diana Gabaldon', 3, NULL, 0, CAST(13.99 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1529065012l/10964._SY475_.jpg', N'The year is 1945. Claire Randall, a former combat nurse, is just back from the war and reunited with her husband on a second honeymoon when she walks through a standing stone in one of the ancient circles that dot the British Isles. Suddenly she is a Sassenach—an “outlander”—in a Scotland torn by war and raiding border clans in the year of Our Lord...1743.
<br>
Hurled back in time by forces she cannot understand, Claire is catapulted into the intrigues of lairds and spies that may threaten her life, and shatter her heart. For here James Fraser, a gallant young Scots warrior, shows her a love so absolute that Claire becomes a woman torn between fidelity and desire—and between two vastly different men in two irreconcilable lives.', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (12, N'All the Light We Cannot See', N'Anthony Doerr', 3, NULL, 0, CAST(10.99 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1451445646l/18143977.jpg', N'Marie-Laure lives in Paris near the Museum of Natural History, where her father works. When she is twelve, the Nazis occupy Paris and father and daughter flee to the walled citadel of Saint-Malo, where Marie-Laure’s reclusive great uncle lives in a tall house by the sea. With them they carry what might be the museum’s most valuable and dangerous jewel.
<br>In a mining town in Germany, Werner Pfennig, an orphan, grows up with his younger sister, enchanted by a crude radio they find that brings them news and stories from places they have never seen or imagined. Werner becomes an expert at building and fixing these crucial new instruments and is enlisted to use his talent to track down the resistance. Deftly interweaving the lives of Marie-Laure and Werner, Doerr illuminates the ways, against all odds, people try to be good to one another.', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (13, N'Fullmetal Alchemist, Vol. 1', N'Hiromu Arakawa', 4, NULL, 0, CAST(9.35 AS Decimal(10, 2)), 1, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1388179331l/870.jpg', N'Breaking the laws of nature is a serious crime!
<br>In an alchemical ritual gone wrong, Edward Elric lost his arm and his leg, and his brother Alphonse became nothing but a soul in a suit of armor. Equipped with mechanical “auto-mail” limbs, Edward becomes a state alchemist, seeking the one thing that can restore his and his brother’s bodies...the legendary Philosopher’s Stone.
<br>Alchemy: the mystical power to alter the natural world; something between magic, art and science. When two brothers, Edward and Alphonse Elric, dabbled in this power to grant their dearest wish, one of them lost an arm and a leg…and the other became nothing but a soul locked into a body of living steel. Now Edward is an agent of the government, a slave of the military-alchemical complex, using his unique powers to obey orders…even to kill. Except his powers aren''t unique. The world has been ravaged by the abuse of alchemy. And in pursuit of the ultimate alchemical treasure, the Philosopher''s Stone, their enemies are even more ruthless than they are…', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (14, N'Death Note, Vol. 1: Boredom', N'Tsugumi Ohba', 4, NULL, 0, CAST(10.40 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1419952134l/13615.jpg', N'Light Yagami is an ace student with great prospects - and he''s bored out of his mind. But all that changes when he finds the Death Note, a notebook dropped by a rogue Shinigami, a death god. Any human whose name is written in the notebook dies, and now Light has vowed to use the power of the Death Note to rid the world of evil. But when criminals begin dropping dead, the authorities send the legendary detective L to track down the killer. With L hot on his heels, will Light lose sight of his noble goal... or his life?', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (15, N'One Piece, Volume 1: Romance Dawn', N'Eiichiro Oda', 4, NULL, 0, CAST(11.00 AS Decimal(10, 2)), 1, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1318523719l/1237398.jpg', N'A new shonen sensation in Japan, this series features Monkey D. Luffy, whose main ambition is to become a pirate. Eating the Gum-Gum Fruit gives him strange powers but also invokes the fruit''s curse: anybody who consumes it can never learn to swim. Nevertheless, Monkey and his crewmate Roronoa Zoro, master of the three-sword fighting style, sail the Seven Seas of swashbuckling adventure in search of the elusive treasure "One Piece."', 0, 1)
INSERT [dbo].[Book] ([id], [title], [author], [categoryid], [rating], [favourite], [price], [is_sale], [image], [description], [views], [status]) VALUES (16, N'Classroom of the Elite Vol. 1', N'Syougo Kinugasa', 4, NULL, 0, CAST(9.69 AS Decimal(10, 2)), 0, N'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1540974678l/41085104.jpg', N'Students of the prestigious Tokyo Metropolitan Advanced Nurturing High School are given remarkable freedom—if they can win, barter, or save enough points to work their way up the ranks! Ayanokoji Kiyotaka has landed at the bottom in the scorned Class D, where he meets Horikita Suzune, who’s determined to rise up the ladder to Class A. Can they beat the system in a school where cutthroat competition is the name of the game?', 0, 1)
SET IDENTITY_INSERT [dbo].[Book] OFF
GO
SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([id], [name]) VALUES (1, N'Crime, Thriller & Mystery')
INSERT [dbo].[Category] ([id], [name]) VALUES (2, N'Fantasy, Horror')
INSERT [dbo].[Category] ([id], [name]) VALUES (3, N'Science/Historical Fiction')
INSERT [dbo].[Category] ([id], [name]) VALUES (4, N'Manga&LN')
SET IDENTITY_INSERT [dbo].[Category] OFF
GO
SET IDENTITY_INSERT [dbo].[Chapter] ON 

INSERT [dbo].[Chapter] ([id], [bookId], [volumeId], [chapter], [chapterName], [status], [content]) VALUES (1, 1, 1, 1, N'NICK DUNNE', 1, N'When I think of my wife, I always think of her head. The shape of it, to begin with. The very first time I saw her, it was the back of the head I saw, and there was something lovely about it, the angles of it. Like a shiny, hard corn kernel or a riverbed fossil. She had what the Victorians would call a finely shaped head. You could imagine the skull quite easily.
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
INSERT [dbo].[Chapter] ([id], [bookId], [volumeId], [chapter], [chapterName], [status], [content]) VALUES (2, 1, 1, 2, N'AMY ELLIOTT JANUARY 8, 2005', 1, N'– Diary entry –
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
INSERT [dbo].[Chapter] ([id], [bookId], [volumeId], [chapter], [chapterName], [status], [content]) VALUES (3, 1, 1, 3, N'NICK DUNNE', 0, N'I swung wide the door of my bar, slipped into the darkness, and took my first real deep breath of the day, took in the smell of cigarettes and beer, the spice of a dribbled bourbon, the tang of old popcorn. There was only one customer in the bar, sitting by herself at the far, far end: an older woman named Sue who had come in every Thursday with her husband until he died three months back. Now she came alone every Thursday, never much for conversation, just sitting with a beer and a crossword, preserving a ritual.
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
Amy was gone.')
INSERT [dbo].[Chapter] ([id], [bookId], [volumeId], [chapter], [chapterName], [status], [content]) VALUES (4, 1, 1, 4, N'Amy Elliott September 18, 2005', 1, N'– Diary entry –
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
INSERT [dbo].[Chapter] ([id], [bookId], [volumeId], [chapter], [chapterName], [status], [content]) VALUES (5, 1, 1, 5, N'Nick Dunne', 1, N'I waited for the police first in the kitchen, but the acrid smell of the burnt teakettle was curling up in the back of my throat, underscoring my need to retch, so I drifted out on the front porch, sat on the top stair, and willed myself to be calm. I kept trying Amy’s cell, and it kept going to voice mail, that quick-clip cadence swearing she’d phone right back. Amy always phoned right back. It had been three hours, and I’d left five messages, and Amy had not phoned back.
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
SET IDENTITY_INSERT [dbo].[Chapter] OFF
GO
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (0, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (2, CAST(1541.47 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (3, CAST(4120.33 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (4, CAST(1442.86 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5, CAST(1079.29 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (6, CAST(3782.48 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (7, CAST(3407.86 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8, CAST(7827.57 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (9, CAST(2443.45 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (10, CAST(9.17 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (11, CAST(5982.25 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (12, CAST(909.46 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (13, CAST(3551.77 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (14, CAST(6174.18 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (15, CAST(77.97 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (16, CAST(2703.23 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (17, CAST(455.40 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (18, CAST(5027.96 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (19, CAST(4319.66 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (20, CAST(4195.68 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (21, CAST(7731.47 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (22, CAST(5349.61 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (23, CAST(5313.50 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (24, CAST(2078.36 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (25, CAST(6675.17 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (26, CAST(1440.90 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (27, CAST(14.59 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (28, CAST(760.99 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (29, CAST(6765.91 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (30, CAST(7622.32 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (31, CAST(826.10 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (32, CAST(85.16 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (33, CAST(3136.10 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (34, CAST(76.44 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (35, CAST(4839.84 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (36, CAST(5480.93 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (37, CAST(3678.42 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (38, CAST(4267.66 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (39, CAST(5559.76 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (40, CAST(981.02 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (41, CAST(8808.18 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (42, CAST(4875.06 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (43, CAST(8112.23 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (44, CAST(2829.23 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (45, CAST(6999.18 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (46, CAST(6558.10 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (47, CAST(7931.99 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (48, CAST(7476.40 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (49, CAST(4480.66 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (50, CAST(1196.33 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (51, CAST(3107.50 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (52, CAST(1721.74 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (53, CAST(7169.71 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (54, CAST(2465.22 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (55, CAST(8525.55 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (56, CAST(1163.63 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (57, CAST(1910.84 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (58, CAST(1578.50 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (59, CAST(2177.29 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (60, CAST(5623.95 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (61, CAST(5093.20 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (62, CAST(8543.68 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (63, CAST(5424.55 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (64, CAST(1068.78 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (65, CAST(2659.99 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (66, CAST(6317.44 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (67, CAST(531.91 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (68, CAST(4332.51 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (69, CAST(5425.50 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (70, CAST(8037.13 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (71, CAST(6357.76 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (72, CAST(3767.05 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (73, CAST(7528.66 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (74, CAST(7135.03 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (75, CAST(979.24 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (76, CAST(1645.65 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (77, CAST(5195.25 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (78, CAST(6283.85 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (79, CAST(4977.79 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (80, CAST(5043.27 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (81, CAST(381.53 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (82, CAST(5080.89 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (83, CAST(16.69 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (84, CAST(3547.69 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (85, CAST(3475.33 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (86, CAST(1805.99 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (87, CAST(7012.19 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (88, CAST(6935.14 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (89, CAST(1641.78 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (90, CAST(1300.46 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (91, CAST(7175.78 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (92, CAST(3341.84 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (93, CAST(6665.80 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (94, CAST(8094.17 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (95, CAST(1064.11 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (96, CAST(4197.52 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (97, CAST(8879.19 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (98, CAST(5057.10 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (99, CAST(3718.89 AS Decimal(10, 2)))
GO
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (100, CAST(1627.63 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (101, CAST(4261.23 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (102, CAST(4800.82 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (103, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (106, CAST(1085.23 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (107, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (108, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (109, CAST(0.00 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (37075223, CAST(1013.68 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (51173456, CAST(4708.24 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (74952141, CAST(967.37 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (139454019, CAST(2601.99 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (318071247, CAST(2773.44 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (386636643, CAST(4743.82 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (431618205, CAST(2455.83 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (446972780, CAST(868.90 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (473152984, CAST(4025.39 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (679671431, CAST(362.52 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (850401454, CAST(4467.16 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (917355251, CAST(4226.73 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (955966322, CAST(3608.38 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (972439339, CAST(575.23 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1145993637, CAST(2866.27 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1167357241, CAST(4561.42 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1283714042, CAST(4677.83 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1318334801, CAST(1650.11 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1331967611, CAST(961.05 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1332569623, CAST(2736.31 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1380002937, CAST(3917.54 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1422712096, CAST(3589.39 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1601270613, CAST(1553.94 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1836390590, CAST(3744.16 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1971979391, CAST(969.63 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (1976122113, CAST(4400.31 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (2384611197, CAST(2457.42 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (2437453828, CAST(1322.84 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (2519495624, CAST(2990.61 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (2619470944, CAST(4899.25 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (2670916914, CAST(4310.07 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (2680701419, CAST(1136.64 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (2765599235, CAST(1192.15 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (2793178405, CAST(3422.86 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (2948873856, CAST(1918.69 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (2955140061, CAST(2312.28 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (2997019069, CAST(291.88 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (3016661812, CAST(2820.45 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (3424019427, CAST(4911.65 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (3473387652, CAST(1244.30 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (3572954814, CAST(583.42 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (3905247198, CAST(1754.22 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (3908116429, CAST(4443.57 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (4146405242, CAST(3724.57 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (4482504141, CAST(1070.37 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (4519725304, CAST(4555.48 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (4678472703, CAST(2749.56 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (4681142538, CAST(1451.98 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (4964763819, CAST(3480.18 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5138125456, CAST(3009.44 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5159802194, CAST(4299.11 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5254587583, CAST(2721.74 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5355923867, CAST(982.88 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5419266462, CAST(534.61 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5429986684, CAST(2718.72 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5475360879, CAST(4401.64 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5547914765, CAST(1315.24 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5549015036, CAST(4094.62 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5557555461, CAST(1671.08 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5576484273, CAST(4683.13 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5887723221, CAST(5033.03 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5909459634, CAST(206.46 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5944525984, CAST(197.62 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (5988347845, CAST(1447.40 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (6026989470, CAST(1279.26 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (6068574838, CAST(4195.60 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (6438403365, CAST(2582.19 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (6442457323, CAST(2906.24 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (6469848160, CAST(3998.92 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (6479146192, CAST(4970.04 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (6582769227, CAST(1292.30 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (6597026015, CAST(4771.56 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (6620691933, CAST(3481.68 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (6952777387, CAST(1415.27 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (6997812930, CAST(4785.24 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (7173493771, CAST(2964.03 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (7183046243, CAST(1746.56 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (7244526304, CAST(2703.83 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (7263590060, CAST(2002.77 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (7410852963, CAST(80.61 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (7661491077, CAST(4502.04 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (7748861664, CAST(2917.27 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (7997053302, CAST(2972.38 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8042711543, CAST(2522.15 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8074129941, CAST(3073.11 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8142936699, CAST(3675.78 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8185325202, CAST(2783.86 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8227851142, CAST(3124.42 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8455971628, CAST(1162.28 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8491633133, CAST(837.44 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8500602522, CAST(1975.43 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8531866336, CAST(2978.71 AS Decimal(10, 2)))
GO
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8599753652, CAST(4145.11 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8731359880, CAST(3342.79 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8808419770, CAST(4254.97 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8881596476, CAST(3353.19 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (8910545709, CAST(2329.29 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (9135370392, CAST(4930.45 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (9215737984, CAST(3930.19 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (9335327530, CAST(4865.10 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (9430503622, CAST(4504.30 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (9872231353, CAST(4068.72 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (9876543210, CAST(244.05 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (9880788429, CAST(2740.10 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (9953524311, CAST(4946.61 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (9961111214, CAST(3763.30 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (10028714113, CAST(627.22 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (10108825850, CAST(1273.39 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (36950928992, CAST(2102.20 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (38285536832, CAST(1163.58 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (38724088357, CAST(591.05 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (41127767675, CAST(386.68 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (42534310518, CAST(2839.30 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (48071110244, CAST(1548.60 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (52301432232, CAST(1574.07 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (53097505521, CAST(518.58 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (56320572041, CAST(2727.35 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (60960915696, CAST(2478.77 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (66030440862, CAST(1444.67 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (79280419196, CAST(2384.96 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (81845189051, CAST(2746.01 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (89408126469, CAST(3820.44 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (97120071759, CAST(3615.84 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (101737393877, CAST(1059.70 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (103278207654, CAST(792.69 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (107031370718, CAST(2548.02 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (112411308346, CAST(1930.19 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (115287764998, CAST(1341.49 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (120853157158, CAST(101.32 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (122177522637, CAST(636.78 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (126440290567, CAST(3332.12 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (126503365507, CAST(2229.33 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (140475581701, CAST(692.93 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (142937696721, CAST(2497.83 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (149820848609, CAST(2315.04 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (151028402272, CAST(2969.12 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (152277997337, CAST(1206.80 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (158889565670, CAST(514.00 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (164375994213, CAST(2242.73 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (169294791218, CAST(810.10 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (174443321075, CAST(578.43 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (181523712733, CAST(1289.54 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (187897646152, CAST(2144.40 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (188177285964, CAST(921.62 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (199500188635, CAST(3101.33 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (203997350124, CAST(2578.13 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (207470283267, CAST(3806.54 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (209556166150, CAST(1946.06 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (209570001706, CAST(3772.40 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (213521244362, CAST(3947.30 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (227284879629, CAST(3762.78 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (231384165180, CAST(2799.71 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (232884349933, CAST(2278.49 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (236343429829, CAST(1981.86 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (236820266935, CAST(3598.18 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (237953430347, CAST(98.50 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (239309661578, CAST(3717.66 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (240889419410, CAST(2408.74 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (249992160549, CAST(905.87 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (250911429689, CAST(1319.74 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (254285772452, CAST(2241.19 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (262276321519, CAST(382.17 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (265245750110, CAST(3623.79 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (266121001335, CAST(695.00 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (273592303768, CAST(1560.31 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (285097785185, CAST(3933.28 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (287479779076, CAST(3579.49 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (290232933183, CAST(1469.63 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (315247907184, CAST(1718.74 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (322276924762, CAST(2272.99 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (324296175302, CAST(589.83 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (325783078690, CAST(3285.68 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (336158726699, CAST(840.99 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (336892621328, CAST(945.17 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (337513137816, CAST(1415.22 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (343420998738, CAST(3117.55 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (343845419707, CAST(401.38 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (351112611051, CAST(2672.39 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (352601308982, CAST(999.28 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (354824976571, CAST(3728.57 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (358782879216, CAST(2328.16 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (358822285150, CAST(378.48 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (359686743844, CAST(3256.72 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (376056683973, CAST(1941.16 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (377635932537, CAST(2121.85 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (379919804407, CAST(2453.54 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (385230566996, CAST(2785.31 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (385826325842, CAST(3103.24 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (386632492873, CAST(2574.62 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (391772588198, CAST(2692.54 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (392641792498, CAST(3979.04 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (393303298853, CAST(1124.97 AS Decimal(10, 2)))
GO
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (400939899392, CAST(1050.96 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (418403880497, CAST(918.15 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (419653580434, CAST(825.47 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (430294349517, CAST(3507.99 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (430294857995, CAST(1681.88 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (430544819514, CAST(3492.71 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (435485221093, CAST(1351.56 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (435520516679, CAST(784.68 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (436793751216, CAST(1719.30 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (439147026401, CAST(484.06 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (441776164259, CAST(2106.53 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (442403217350, CAST(160.72 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (460132919932, CAST(1130.09 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (466638737912, CAST(28.57 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (471679850803, CAST(2795.50 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (491002702053, CAST(1494.49 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (493636572380, CAST(840.67 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (508925563656, CAST(1323.43 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (509069112420, CAST(2998.54 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (509663821365, CAST(2482.12 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (515764677007, CAST(2050.27 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (526857701876, CAST(3981.97 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (527442113653, CAST(1737.23 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (531389704974, CAST(3580.85 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (533581768089, CAST(1086.84 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (538441503541, CAST(1646.29 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (539222392333, CAST(311.27 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (539691899706, CAST(588.84 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (549774601361, CAST(2754.81 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (558666225544, CAST(3520.23 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (564106066444, CAST(750.93 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (565260147089, CAST(2477.67 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (567670273019, CAST(3867.52 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (572487169216, CAST(25.53 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (575633364565, CAST(3142.45 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (578098751297, CAST(3536.88 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (578829806493, CAST(2216.28 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (581523864399, CAST(781.54 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (582655711819, CAST(1374.82 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (592796329443, CAST(3292.56 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (594065092479, CAST(3466.99 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (598958801803, CAST(1825.49 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (601529762710, CAST(3308.58 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (604600101293, CAST(3915.81 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (605057996983, CAST(3813.15 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (607358308340, CAST(1911.33 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (610880290584, CAST(2877.82 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (611794509420, CAST(3814.00 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (615036392323, CAST(3235.30 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (619136362013, CAST(1422.61 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (624452533539, CAST(2789.71 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (628234675672, CAST(2448.07 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (628938127662, CAST(3897.55 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (635892814748, CAST(2255.36 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (648916271688, CAST(2632.26 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (650905394193, CAST(1465.48 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (653375173447, CAST(3935.40 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (655288902107, CAST(1304.58 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (657010967037, CAST(3701.03 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (672860905964, CAST(3276.39 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (674420418742, CAST(2964.09 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (675244595871, CAST(3613.85 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (675261076995, CAST(3533.86 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (675913287543, CAST(2680.86 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (686423328185, CAST(3369.96 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (707530192293, CAST(1193.29 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (713060829477, CAST(2213.11 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (720486988035, CAST(1399.69 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (741762191662, CAST(1536.13 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (743894265434, CAST(842.31 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (746257518271, CAST(7.32 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (759078918355, CAST(2427.13 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (776000584391, CAST(2316.20 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (792850415956, CAST(721.97 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (805608027221, CAST(672.55 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (805749058436, CAST(2866.52 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (809557958533, CAST(1919.76 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (810577190687, CAST(3075.60 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (813992959234, CAST(2758.25 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (819037236035, CAST(2967.80 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (821924822637, CAST(386.50 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (824153521557, CAST(559.70 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (825143075035, CAST(2892.25 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (828934338739, CAST(194.49 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (839372661076, CAST(2682.17 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (844584438318, CAST(2328.11 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (846620874005, CAST(716.31 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (853196387942, CAST(1170.18 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (866076402536, CAST(1990.99 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (872583500031, CAST(961.33 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (875377823249, CAST(3844.24 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (878967953571, CAST(1127.58 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (888888888888, CAST(123.45 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (901338596510, CAST(1318.27 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (902663344777, CAST(3846.06 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (903213176862, CAST(1838.54 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (904597945260, CAST(28.64 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (919592383256, CAST(1957.09 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (922451159291, CAST(1967.94 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (931536916174, CAST(3123.77 AS Decimal(10, 2)))
GO
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (950478619471, CAST(3868.31 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (955067293038, CAST(1574.11 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (961407135267, CAST(2256.21 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (963262289282, CAST(3759.74 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (965397232308, CAST(0.89 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (967843195380, CAST(789.27 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (970108759513, CAST(2454.94 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (978683745760, CAST(830.31 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (982017699533, CAST(1447.45 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (985256672758, CAST(1165.42 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (989712775405, CAST(2723.93 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (998193093125, CAST(1430.44 AS Decimal(10, 2)))
INSERT [dbo].[Payment_Account] ([accountNumber], [balance]) VALUES (998433188504, CAST(3219.33 AS Decimal(10, 2)))
GO
SET IDENTITY_INSERT [dbo].[Payment_Method] ON 

INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (45678, 1, 888888888888, N'Bank 1', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (45681, 1, 7410852963, N'Bank 2', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (45684, 2, 9876543210, N'Bank 1', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47112, 1, 1, N'Wallet of admin', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47115, 1, 2955140061, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47118, 2, 2, N'Wallet of vinh', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47121, 2, 9880788429, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47127, 3, 6469848160, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47130, 4, 4, N'Wallet of user_no2', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47133, 4, 5254587583, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47136, 5, 5, N'Wallet of user_no3', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47139, 5, 679671431, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47142, 6, 6, N'Wallet of user_no4', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47145, 6, 4482504141, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47148, 7, 7, N'Wallet of user_no5', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47151, 7, 9961111214, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47154, 8, 8, N'Wallet of user_no6', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47157, 8, 1976122113, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47160, 9, 9, N'Wallet of user_no7', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47163, 9, 1145993637, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47166, 10, 10, N'Wallet of user_no8', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47169, 10, 8185325202, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47172, 11, 11, N'Wallet of user_no9', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47175, 11, 6952777387, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47178, 12, 12, N'Wallet of user_no10', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47181, 12, 5557555461, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47184, 13, 13, N'Wallet of user_no11', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47187, 13, 7183046243, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47190, 14, 14, N'Wallet of user_no12', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47193, 14, 2670916914, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47196, 15, 15, N'Wallet of user_no13', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47199, 15, 1380002937, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47202, 16, 16, N'Wallet of user_no14', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47205, 16, 5355923867, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47208, 17, 17, N'Wallet of user_no15', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47211, 17, 5944525984, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47214, 18, 18, N'Wallet of user_no16', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47217, 18, 8808419770, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47220, 19, 19, N'Wallet of user_no17', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47223, 19, 51173456, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47226, 20, 20, N'Wallet of user_no18', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47229, 20, 5475360879, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47232, 21, 21, N'Wallet of user_no19', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47235, 21, 1601270613, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47238, 22, 22, N'Wallet of user_no20', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47241, 22, 5549015036, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47244, 23, 23, N'Wallet of user_no21', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47247, 23, 5419266462, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47250, 24, 24, N'Wallet of user_no22', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47253, 24, 9335327530, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47256, 25, 25, N'Wallet of user_no23', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47259, 25, 4146405242, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47262, 26, 26, N'Wallet of user_no24', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47265, 26, 9872231353, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47268, 27, 27, N'Wallet of user_no25', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47271, 27, 9215737984, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47274, 28, 28, N'Wallet of user_no26', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47277, 28, 6026989470, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47280, 29, 29, N'Wallet of user_no27', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47283, 29, 431618205, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47286, 30, 30, N'Wallet of user_no28', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47289, 30, 1318334801, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47292, 31, 31, N'Wallet of user_no29', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47295, 31, 5909459634, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47298, 32, 32, N'Wallet of user_no30', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47301, 32, 1283714042, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47304, 33, 33, N'Wallet of user_no31', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47307, 33, 7263590060, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47313, 34, 4519725304, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47316, 35, 35, N'Wallet of user_no33', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47319, 35, 8500602522, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47322, 36, 36, N'Wallet of user_no34', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47325, 36, 3908116429, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47328, 37, 37, N'Wallet of user_no35', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47331, 37, 37075223, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47334, 38, 38, N'Wallet of user_no36', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47337, 38, 3473387652, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47340, 39, 39, N'Wallet of user_no37', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47343, 39, 6597026015, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47346, 40, 40, N'Wallet of user_no38', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47349, 40, 473152984, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47352, 41, 41, N'Wallet of user_no39', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47355, 41, 1167357241, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47358, 42, 42, N'Wallet of user_no40', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47361, 42, 2519495624, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47364, 43, 43, N'Wallet of user_no41', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47367, 43, 5159802194, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47370, 44, 44, N'Wallet of user_no42', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47373, 44, 8142936699, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47376, 45, 45, N'Wallet of user_no43', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47379, 45, 2997019069, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47382, 46, 46, N'Wallet of user_no44', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47385, 46, 6442457323, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47388, 47, 47, N'Wallet of user_no45', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47391, 47, 6068574838, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47394, 48, 48, N'Wallet of user_no46', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47397, 48, 4964763819, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47400, 49, 49, N'Wallet of user_no47', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47403, 49, 139454019, N'Linked Bank', 1)
GO
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47406, 50, 50, N'Wallet of user_no48', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47409, 50, 1836390590, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47412, 51, 51, N'Wallet of user_no49', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47415, 51, 7997053302, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47418, 52, 52, N'Wallet of user_no50', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47421, 52, 8881596476, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47424, 53, 53, N'Wallet of user_no51', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47427, 53, 955966322, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47430, 54, 54, N'Wallet of user_no52', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47433, 54, 7748861664, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47436, 55, 55, N'Wallet of user_no53', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47439, 55, 6479146192, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47442, 56, 56, N'Wallet of user_no54', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47445, 56, 1332569623, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47448, 57, 57, N'Wallet of user_no55', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47451, 57, 2793178405, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47454, 58, 58, N'Wallet of user_no56', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47457, 58, 9135370392, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47463, 59, 4678472703, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47466, 60, 60, N'Wallet of user_no58', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47469, 60, 5988347845, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47472, 61, 61, N'Wallet of user_no59', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47475, 61, 3424019427, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47478, 62, 62, N'Wallet of user_no60', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47481, 62, 8731359880, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47484, 63, 63, N'Wallet of user_no61', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47487, 63, 8910545709, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47490, 64, 64, N'Wallet of user_no62', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47493, 64, 9430503622, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47499, 65, 5576484273, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47502, 66, 66, N'Wallet of user_no64', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47505, 66, 4681142538, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47508, 67, 67, N'Wallet of user_no65', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47511, 67, 8074129941, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47514, 68, 68, N'Wallet of user_no66', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47517, 68, 318071247, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47520, 69, 69, N'Wallet of user_no67', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47523, 69, 8042711543, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47526, 70, 70, N'Wallet of user_no68', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47529, 70, 8227851142, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47532, 71, 71, N'Wallet of user_no69', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47535, 71, 8491633133, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47538, 72, 72, N'Wallet of user_no70', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47541, 72, 8531866336, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47544, 73, 73, N'Wallet of user_no71', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47547, 73, 446972780, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47550, 74, 74, N'Wallet of user_no72', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47553, 74, 6438403365, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47556, 75, 75, N'Wallet of user_no73', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47559, 75, 2765599235, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47562, 76, 76, N'Wallet of user_no74', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47565, 76, 9953524311, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47568, 77, 77, N'Wallet of user_no75', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47571, 77, 917355251, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47574, 78, 78, N'Wallet of user_no76', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47577, 78, 7661491077, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47580, 79, 79, N'Wallet of user_no77', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47583, 79, 8599753652, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47586, 80, 80, N'Wallet of user_no78', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47589, 80, 1331967611, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47592, 81, 81, N'Wallet of user_no79', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47595, 81, 972439339, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47598, 82, 82, N'Wallet of user_no80', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47601, 82, 6620691933, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47604, 83, 83, N'Wallet of user_no81', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47607, 83, 3016661812, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47610, 84, 84, N'Wallet of user_no82', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47613, 84, 3905247198, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47616, 85, 85, N'Wallet of user_no83', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47619, 85, 7173493771, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47622, 86, 86, N'Wallet of user_no84', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47625, 86, 6997812930, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47628, 87, 87, N'Wallet of user_no85', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47631, 87, 74952141, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47634, 88, 88, N'Wallet of user_no86', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47637, 88, 1971979391, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47640, 89, 89, N'Wallet of user_no87', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47643, 89, 850401454, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47646, 90, 90, N'Wallet of user_no88', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47649, 90, 6582769227, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47652, 91, 91, N'Wallet of user_no89', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47655, 91, 5138125456, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47658, 92, 92, N'Wallet of user_no90', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47661, 92, 2619470944, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47667, 93, 1422712096, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47673, 94, 386636643, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47676, 95, 95, N'Wallet of user_no93', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47679, 95, 3572954814, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47682, 96, 96, N'Wallet of user_no94', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47685, 96, 2948873856, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47688, 97, 97, N'Wallet of user_no95', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47691, 97, 5887723221, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47694, 98, 98, N'Wallet of user_no96', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47697, 98, 7244526304, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47700, 99, 99, N'Wallet of user_no97', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47703, 99, 8455971628, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47706, 100, 100, N'Wallet of user_no98', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47709, 100, 2437453828, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47712, 101, 101, N'Wallet of user_no99', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47715, 101, 2384611197, N'Linked Bank', 1)
GO
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47718, 102, 102, N'Wallet of user_no100', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47721, 102, 2680701419, N'Linked Bank', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47724, 65, 65, N'Wallet of user_no63', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47727, 59, 59, N'Wallet of user_no57', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47730, 3, 3, N'Wallet of user_no_3', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47733, 93, 93, N'Wallet of user_no91', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47736, 94, 94, N'Wallet of user_no92', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47739, 2, 10028714113, N'Bank 3', 1)
INSERT [dbo].[Payment_Method] ([paymentId], [userId], [accountNumber], [name], [active]) VALUES (47763, 109, 109, N'Wallet of tester', 1)
SET IDENTITY_INSERT [dbo].[Payment_Method] OFF
GO
SET IDENTITY_INSERT [dbo].[Report] ON 

INSERT [dbo].[Report] ([id], [title]) VALUES (1, N'Sexual Content')
INSERT [dbo].[Report] ([id], [title]) VALUES (2, N'Violent or repulsive content')
INSERT [dbo].[Report] ([id], [title]) VALUES (3, N'Hateful or abusive content')
INSERT [dbo].[Report] ([id], [title]) VALUES (4, N'Harassment or bullying')
INSERT [dbo].[Report] ([id], [title]) VALUES (5, N'Harmful or dangerous acts')
INSERT [dbo].[Report] ([id], [title]) VALUES (6, N'Child abuse')
INSERT [dbo].[Report] ([id], [title]) VALUES (7, N'Promotes terrorism')
INSERT [dbo].[Report] ([id], [title]) VALUES (8, N'Spam or misleading')
INSERT [dbo].[Report] ([id], [title]) VALUES (9, N'Infringes my rights')
INSERT [dbo].[Report] ([id], [title]) VALUES (10, N'Caption issue')
SET IDENTITY_INSERT [dbo].[Report] OFF
GO
SET IDENTITY_INSERT [dbo].[Transaction] ON 

INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000001, 2, CAST(297.69 AS Decimal(10, 2)), CAST(297.69 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:10.323' AS DateTime), 1, 2, N'Recharge money from Bank 1', 45684)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000002, 3, CAST(4120.33 AS Decimal(10, 2)), CAST(4120.33 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:10.380' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47127)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000003, 4, CAST(1442.86 AS Decimal(10, 2)), CAST(1442.86 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:10.430' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47133)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000004, 5, CAST(1079.29 AS Decimal(10, 2)), CAST(1079.29 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:10.493' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47139)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000005, 6, CAST(3782.48 AS Decimal(10, 2)), CAST(3782.48 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:10.557' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47145)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000006, 7, CAST(3407.86 AS Decimal(10, 2)), CAST(3407.86 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:10.617' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47151)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000007, 8, CAST(7827.57 AS Decimal(10, 2)), CAST(7827.57 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:10.670' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47157)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000008, 9, CAST(2443.45 AS Decimal(10, 2)), CAST(2443.45 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:10.753' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47163)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000009, 10, CAST(9.17 AS Decimal(10, 2)), CAST(9.17 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:10.820' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47169)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000010, 11, CAST(5982.25 AS Decimal(10, 2)), CAST(5982.25 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:10.890' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47175)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000011, 12, CAST(909.46 AS Decimal(10, 2)), CAST(909.46 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:10.953' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47181)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000012, 13, CAST(3551.77 AS Decimal(10, 2)), CAST(3551.77 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.010' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47187)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000013, 14, CAST(6174.18 AS Decimal(10, 2)), CAST(6174.18 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.073' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47193)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000014, 15, CAST(77.97 AS Decimal(10, 2)), CAST(77.97 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.130' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47199)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000015, 16, CAST(2703.23 AS Decimal(10, 2)), CAST(2703.23 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.190' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47205)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000016, 17, CAST(455.40 AS Decimal(10, 2)), CAST(455.40 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.263' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47211)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000017, 18, CAST(5027.96 AS Decimal(10, 2)), CAST(5027.96 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.320' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47217)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000018, 19, CAST(4319.66 AS Decimal(10, 2)), CAST(4319.66 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.373' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47223)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000019, 20, CAST(4195.68 AS Decimal(10, 2)), CAST(4195.68 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.433' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47229)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000020, 21, CAST(7731.47 AS Decimal(10, 2)), CAST(7731.47 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.490' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47235)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000021, 22, CAST(5349.61 AS Decimal(10, 2)), CAST(5349.61 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.547' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47241)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000022, 23, CAST(5313.50 AS Decimal(10, 2)), CAST(5313.50 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.603' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47247)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000023, 24, CAST(2078.36 AS Decimal(10, 2)), CAST(2078.36 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.650' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47253)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000024, 25, CAST(6675.17 AS Decimal(10, 2)), CAST(6675.17 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.700' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47259)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000025, 26, CAST(1440.90 AS Decimal(10, 2)), CAST(1440.90 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.747' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47265)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000026, 27, CAST(14.59 AS Decimal(10, 2)), CAST(14.59 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.797' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47271)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000027, 28, CAST(760.99 AS Decimal(10, 2)), CAST(760.99 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.850' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47277)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000028, 29, CAST(6765.91 AS Decimal(10, 2)), CAST(6765.91 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.897' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47283)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000029, 30, CAST(7622.32 AS Decimal(10, 2)), CAST(7622.32 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.940' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47289)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000030, 31, CAST(826.10 AS Decimal(10, 2)), CAST(826.10 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:11.983' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47295)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000031, 32, CAST(85.16 AS Decimal(10, 2)), CAST(85.16 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.040' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47301)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000032, 33, CAST(3136.10 AS Decimal(10, 2)), CAST(3136.10 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.093' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47307)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000033, 34, CAST(76.44 AS Decimal(10, 2)), CAST(76.44 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.143' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47313)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000034, 35, CAST(4839.84 AS Decimal(10, 2)), CAST(4839.84 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.203' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47319)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000035, 36, CAST(5480.93 AS Decimal(10, 2)), CAST(5480.93 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.307' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47325)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000036, 37, CAST(3678.42 AS Decimal(10, 2)), CAST(3678.42 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.357' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47331)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000037, 38, CAST(4267.66 AS Decimal(10, 2)), CAST(4267.66 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.403' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47337)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000038, 39, CAST(5559.76 AS Decimal(10, 2)), CAST(5559.76 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.453' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47343)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000039, 40, CAST(981.02 AS Decimal(10, 2)), CAST(981.02 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.507' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47349)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000040, 41, CAST(8808.18 AS Decimal(10, 2)), CAST(8808.18 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.553' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47355)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000041, 42, CAST(4875.06 AS Decimal(10, 2)), CAST(4875.06 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.597' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47361)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000042, 43, CAST(8112.23 AS Decimal(10, 2)), CAST(8112.23 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.643' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47367)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000043, 44, CAST(2829.23 AS Decimal(10, 2)), CAST(2829.23 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.693' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47373)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000044, 45, CAST(6999.18 AS Decimal(10, 2)), CAST(6999.18 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.740' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47379)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000045, 46, CAST(6558.10 AS Decimal(10, 2)), CAST(6558.10 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.787' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47385)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000046, 47, CAST(7931.99 AS Decimal(10, 2)), CAST(7931.99 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.837' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47391)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000047, 48, CAST(7476.40 AS Decimal(10, 2)), CAST(7476.40 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.897' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47397)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000048, 49, CAST(4480.66 AS Decimal(10, 2)), CAST(4480.66 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.943' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47403)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000049, 50, CAST(1196.33 AS Decimal(10, 2)), CAST(1196.33 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:12.990' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47409)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000050, 51, CAST(3107.50 AS Decimal(10, 2)), CAST(3107.50 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.037' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47415)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000051, 52, CAST(1721.74 AS Decimal(10, 2)), CAST(1721.74 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.083' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47421)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000052, 53, CAST(7169.71 AS Decimal(10, 2)), CAST(7169.71 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.133' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47427)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000053, 54, CAST(2465.22 AS Decimal(10, 2)), CAST(2465.22 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.180' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47433)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000054, 55, CAST(8525.55 AS Decimal(10, 2)), CAST(8525.55 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.227' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47439)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000055, 56, CAST(1163.63 AS Decimal(10, 2)), CAST(1163.63 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.270' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47445)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000056, 57, CAST(1910.84 AS Decimal(10, 2)), CAST(1910.84 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.320' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47451)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000057, 58, CAST(1578.50 AS Decimal(10, 2)), CAST(1578.50 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.370' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47457)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000058, 59, CAST(2177.29 AS Decimal(10, 2)), CAST(2177.29 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.423' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47463)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000059, 60, CAST(5623.95 AS Decimal(10, 2)), CAST(5623.95 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.473' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47469)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000060, 61, CAST(5093.20 AS Decimal(10, 2)), CAST(5093.20 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.530' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47475)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000061, 62, CAST(8543.68 AS Decimal(10, 2)), CAST(8543.68 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.593' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47481)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000062, 63, CAST(5424.55 AS Decimal(10, 2)), CAST(5424.55 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.643' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47487)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000063, 64, CAST(1068.78 AS Decimal(10, 2)), CAST(1068.78 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.700' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47493)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000064, 65, CAST(2659.99 AS Decimal(10, 2)), CAST(2659.99 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.757' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47499)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000065, 66, CAST(6317.44 AS Decimal(10, 2)), CAST(6317.44 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.817' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47505)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000066, 67, CAST(531.91 AS Decimal(10, 2)), CAST(531.91 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.883' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47511)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000067, 68, CAST(4332.51 AS Decimal(10, 2)), CAST(4332.51 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:13.953' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47517)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000068, 69, CAST(5425.50 AS Decimal(10, 2)), CAST(5425.50 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.017' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47523)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000069, 70, CAST(8037.13 AS Decimal(10, 2)), CAST(8037.13 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.080' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47529)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000070, 71, CAST(6357.76 AS Decimal(10, 2)), CAST(6357.76 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.163' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47535)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000071, 72, CAST(3767.05 AS Decimal(10, 2)), CAST(3767.05 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.223' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47541)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000072, 73, CAST(7528.66 AS Decimal(10, 2)), CAST(7528.66 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.277' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47547)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000073, 74, CAST(7135.03 AS Decimal(10, 2)), CAST(7135.03 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.333' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47553)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000074, 75, CAST(979.24 AS Decimal(10, 2)), CAST(979.24 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.390' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47559)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000075, 76, CAST(1645.65 AS Decimal(10, 2)), CAST(1645.65 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.450' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47565)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000076, 77, CAST(5195.25 AS Decimal(10, 2)), CAST(5195.25 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.500' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47571)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000077, 78, CAST(6283.85 AS Decimal(10, 2)), CAST(6283.85 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.543' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47577)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000078, 79, CAST(4977.79 AS Decimal(10, 2)), CAST(4977.79 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.597' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47583)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000079, 80, CAST(5043.27 AS Decimal(10, 2)), CAST(5043.27 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.647' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47589)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000080, 81, CAST(381.53 AS Decimal(10, 2)), CAST(381.53 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.690' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47595)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000081, 82, CAST(5080.89 AS Decimal(10, 2)), CAST(5080.89 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.737' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47601)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000082, 83, CAST(16.69 AS Decimal(10, 2)), CAST(16.69 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.787' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47607)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000083, 84, CAST(3547.69 AS Decimal(10, 2)), CAST(3547.69 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.837' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47613)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000084, 85, CAST(3475.33 AS Decimal(10, 2)), CAST(3475.33 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.883' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47619)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000085, 86, CAST(1805.99 AS Decimal(10, 2)), CAST(1805.99 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.927' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47625)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000086, 87, CAST(7012.19 AS Decimal(10, 2)), CAST(7012.19 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:14.973' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47631)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000087, 88, CAST(6935.14 AS Decimal(10, 2)), CAST(6935.14 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.017' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47637)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000088, 89, CAST(1641.78 AS Decimal(10, 2)), CAST(1641.78 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.067' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47643)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000089, 90, CAST(1300.46 AS Decimal(10, 2)), CAST(1300.46 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.110' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47649)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000090, 91, CAST(7175.78 AS Decimal(10, 2)), CAST(7175.78 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.157' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47655)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000091, 92, CAST(3341.84 AS Decimal(10, 2)), CAST(3341.84 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.203' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47661)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000092, 93, CAST(6665.80 AS Decimal(10, 2)), CAST(6665.80 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.247' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47667)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000093, 94, CAST(8094.17 AS Decimal(10, 2)), CAST(8094.17 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.293' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47673)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000094, 95, CAST(1064.11 AS Decimal(10, 2)), CAST(1064.11 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.337' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47679)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000095, 96, CAST(4197.52 AS Decimal(10, 2)), CAST(4197.52 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.387' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47685)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000096, 97, CAST(8879.19 AS Decimal(10, 2)), CAST(8879.19 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.433' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47691)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000097, 98, CAST(5057.10 AS Decimal(10, 2)), CAST(5057.10 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.483' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47697)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000098, 99, CAST(3718.89 AS Decimal(10, 2)), CAST(3718.89 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.530' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47703)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000099, 100, CAST(1627.63 AS Decimal(10, 2)), CAST(1627.63 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.580' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47709)
GO
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000100, 101, CAST(4261.23 AS Decimal(10, 2)), CAST(4261.23 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.627' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47715)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000101, 102, CAST(4800.82 AS Decimal(10, 2)), CAST(4800.82 AS Decimal(10, 2)), CAST(N'2022-10-01T05:52:15.683' AS DateTime), 1, 2, N'Recharge money from Linked Bank', 47721)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000102, 2, CAST(150.13 AS Decimal(10, 2)), CAST(147.56 AS Decimal(10, 2)), CAST(N'2022-10-01T22:25:58.213' AS DateTime), 2, 2, N'Withdraw from wallet to Bank 1.', 45684)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000103, 2, CAST(1235.42 AS Decimal(10, 2)), CAST(1783.24 AS Decimal(10, 2)), CAST(N'2022-10-01T22:31:43.330' AS DateTime), 1, 2, N'Recharge from Linked Bank into wallet.', 47121)
INSERT [dbo].[Transaction] ([transactionId], [userId], [amount], [balanceAfter], [transactionTime], [type], [status], [description], [paymentId]) VALUES (3000104, 2, CAST(241.77 AS Decimal(10, 2)), CAST(1541.47 AS Decimal(10, 2)), CAST(N'2022-10-01T22:32:21.120' AS DateTime), 2, 2, N'Withdraw from wallet to Bank 1.', 45684)
SET IDENTITY_INSERT [dbo].[Transaction] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (1, N'Vinh Nguyen', 1, CAST(N'2002-12-25' AS Date), N'vinhnthe163219@fpt.edu.vn', N'0382132025', N'FBT University ', N'admin', N'admin', 5, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (2, N'Vinh Nguyen', 1, CAST(N'2002-12-25' AS Date), N'vinhvn102@gmail.com', N'0382132025', N'FBT University ', N'vinh', N'2002', 2, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (3, N'Ivory Marcel', 0, CAST(N'1969-09-20' AS Date), N'Bookie_User1@qa.team', N'6128170843', N'E312R', N'user_no1', N'9v9SJ2gqt1', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (4, N'Mary Barisol', 1, CAST(N'1970-02-16' AS Date), N'Bookie_User2@qa.team', N'7134690959', N'F012R', N'user_no2', N'i64LIeOm56', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (5, N'Eden Frost', 1, CAST(N'1984-03-13' AS Date), N'Bookie_User3@qa.team', N'8252042139', N'B438R', N'user_no3', N'IMG2x1T1iv', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (6, N'Benidict Robinett', 1, CAST(N'1966-02-10' AS Date), N'Bookie_User4@qa.team', N'3999059789', N'A400R', N'user_no4', N'mq8q4KfNjV', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (7, N'Zera Farmer', 0, CAST(N'1961-02-10' AS Date), N'Bookie_Admin5@qa.team', N'5706825096', N'E271R', N'user_no5', N'2bh7UnCPxT', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (8, N'Ceil Howell', 1, CAST(N'1992-09-16' AS Date), N'Bookie_User6@qa.team', N'5374439245', N'C146R', N'user_no6', N'kURf75I4QQ', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (9, N'Taylor Marcel', 0, CAST(N'2000-09-04' AS Date), N'Bookie_User7@qa.team', N'9180387665', N'E402L', N'user_no7', N'1FF4G03cId', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (10, N'Wisley Ray', 1, CAST(N'1971-10-28' AS Date), N'Bookie_User8@qa.team', N'8155814231', N'B398R', N'user_no8', N'T4dI4P82Ab', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (11, N'Aiken Pope', 1, CAST(N'1979-05-01' AS Date), N'Bookie_User9@qa.team', N'7770308417', N'F421L', N'user_no9', N'op6An5T76g', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (12, N'Rodolphe Blossom', 1, CAST(N'2001-02-19' AS Date), N'Bookie_User10@qa.team', N'6610856429', N'A168L', N'user_no10', N'2203lupus8', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (13, N'Alex Rogze', 0, CAST(N'1987-08-07' AS Date), N'Bookie_Admin11@qa.team', N'9326626549', N'B508R', N'user_no11', N'Lngixrl107', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (14, N'Jean Padilla', 1, CAST(N'1967-11-16' AS Date), N'Bookie_User12@qa.team', N'3348144073', N'E545L', N'user_no12', N'63Q38IrHQ6', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (15, N'Dana Franklin', 1, CAST(N'1965-08-28' AS Date), N'Bookie_User13@qa.team', N'0621966375', N'E501R', N'user_no13', N'2n70PtX3x3', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (16, N'Elluka Bush', 0, CAST(N'1996-11-19' AS Date), N'Bookie_User14@qa.team', N'5303149491', N'E329R', N'user_no14', N'656H6NLX8R', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (17, N'Kenelm Binder', 1, CAST(N'1962-04-16' AS Date), N'Bookie_User15@qa.team', N'8319378641', N'E300R', N'user_no15', N'EaMR6k40vW', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (18, N'Narcissus Freezis', 0, CAST(N'2000-02-19' AS Date), N'Bookie_User16@qa.team', N'5209703781', N'C223R', N'user_no16', N'pC0EkBn3S7', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (19, N'Michelle Reynolds', 0, CAST(N'1996-05-24' AS Date), N'Bookie_User17@qa.team', N'9960504670', N'A076L', N'user_no17', N'j75wC2vU9T', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (20, N'Callie Banica', 0, CAST(N'2003-03-28' AS Date), N'Bookie_User18@qa.team', N'6314402583', N'B591L', N'user_no18', N'AdqKEjAvT2', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (21, N'Malceria Freezis', 0, CAST(N'1992-02-20' AS Date), N'Bookie_User19@qa.team', N'2483694818', N'E536R', N'user_no19', N'40PC98quFo', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (22, N'Jasmine Shepard', 1, CAST(N'1973-08-09' AS Date), N'Bookie_User20@qa.team', N'9780125454', N'C555L', N'user_no20', N'6G6nwxj3XG', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (23, N'Mia Franklin', 0, CAST(N'1970-04-02' AS Date), N'Bookie_User21@qa.team', N'5381738475', N'B033R', N'user_no21', N'FCKNmmEX80', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (24, N'Schick Reyes', 1, CAST(N'2001-09-15' AS Date), N'Bookie_User22@qa.team', N'2832297215', N'F554R', N'user_no22', N'xNWW1u0t5t', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (25, N'Allen Reese', 1, CAST(N'1985-02-09' AS Date), N'Bookie_User23@qa.team', N'5189606718', N'E434R', N'user_no23', N'6pRG2f75Xu', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (26, N'Elman Baxter', 0, CAST(N'1990-08-29' AS Date), N'Bookie_User24@qa.team', N'4250803384', N'F399L', N'user_no24', N'V0N5FSoh48', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (27, N'Willard Jordan', 0, CAST(N'1962-08-23' AS Date), N'Bookie_User25@qa.team', N'8546595378', N'C249R', N'user_no25', N'KNTpXU0UKv', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (28, N'Winona Walton', 1, CAST(N'1972-06-28' AS Date), N'Bookie_User26@qa.team', N'2154390483', N'A271R', N'user_no26', N'0jxj5IEv81', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (29, N'Sophia Knight', 1, CAST(N'1984-03-09' AS Date), N'Bookie_User27@qa.team', N'8607919741', N'A014L', N'user_no27', N'A4fN001VmH', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (30, N'Hank Wade', 0, CAST(N'1965-03-12' AS Date), N'Bookie_User28@qa.team', N'7523062315', N'D388R', N'user_no28', N'2Bfmh791kK', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (31, N'Mia Dinwiddie', 0, CAST(N'1999-02-28' AS Date), N'Bookie_User29@qa.team', N'0246122286', N'F208L', N'user_no29', N'NOxv1OoN1e', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (32, N'Ronald Chandler', 1, CAST(N'1997-10-31' AS Date), N'Bookie_User30@qa.team', N'2828181439', N'E367R', N'user_no30', N'w46Ju1i8L9', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (33, N'Elluka Ackerman', 1, CAST(N'1981-04-17' AS Date), N'Bookie_User31@qa.team', N'9156318073', N'D567R', N'user_no31', N'5uF4wFljD4', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (34, N'Jude Gilbert', 1, CAST(N'1981-11-09' AS Date), N'Bookie_User32@qa.team', N'0169512308', N'F273R', N'user_no32', N'FFdch7h6LS', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (35, N'Philbert Schultz', 0, CAST(N'1989-01-22' AS Date), N'Bookie_User33@qa.team', N'6849016541', N'C488R', N'user_no33', N'4779u17pT0', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (36, N'Lamia Fowler', 0, CAST(N'1967-11-26' AS Date), N'Bookie_User34@qa.team', N'2741015314', N'A021R', N'user_no34', N'hMtBqGhT7W', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (37, N'Gererd Pope', 1, CAST(N'1997-01-03' AS Date), N'Bookie_User35@qa.team', N'3065738164', N'C082R', N'user_no35', N'FUKg17DIa2', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (38, N'Thetal Shepard', 1, CAST(N'1999-05-29' AS Date), N'Bookie_User36@qa.team', N'9823201684', N'B218R', N'user_no36', N'CQ29Nd4kw3', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (39, N'Yocaski Blossom', 0, CAST(N'1968-06-03' AS Date), N'Bookie_User37@qa.team', N'8540069619', N'B203L', N'user_no37', N'IMlu2mqOpO', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (40, N'Danielle Hodges', 1, CAST(N'1987-07-08' AS Date), N'Bookie_User38@qa.team', N'6019926882', N'C533L', N'user_no38', N'0EHMq4RtiX', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (41, N'Darlene Feron', 0, CAST(N'1979-01-25' AS Date), N'Bookie_User39@qa.team', N'1335700997', N'D352L', N'user_no39', N'q6D9MT721A', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (42, N'Hadden Chandler', 0, CAST(N'2001-10-30' AS Date), N'Bookie_User40@qa.team', N'6968727500', N'C048R', N'user_no40', N'ihctjAx8Ca', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (43, N'Sateriasis Hardy', 1, CAST(N'1996-06-13' AS Date), N'Bookie_User41@qa.team', N'2222683128', N'B011L', N'user_no41', N'Q5nX178217', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (44, N'Mia Carpenter', 1, CAST(N'1969-10-24' AS Date), N'Bookie_User42@qa.team', N'7098290406', N'C121L', N'user_no42', N'7TN6q8oT22', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (45, N'Kit Nerune', 1, CAST(N'1986-06-20' AS Date), N'Bookie_User43@qa.team', N'8061375590', N'E086R', N'user_no43', N'D5OmM2G0Hf', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (46, N'Rodolphe Frost', 0, CAST(N'1991-10-11' AS Date), N'Bookie_Admin44@qa.team', N'8079576071', N'B166L', N'user_no44', N'633fiUne77', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (47, N'Jesse Watts', 1, CAST(N'1962-01-09' AS Date), N'Bookie_User45@qa.team', N'6734813546', N'A079R', N'user_no45', N'8xKCPgxkG6', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (48, N'Carl Crawford', 0, CAST(N'1966-09-23' AS Date), N'Bookie_User46@qa.team', N'9164323101', N'A587R', N'user_no46', N'8Ogl6495GC', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (49, N'Ronald Robinett', 1, CAST(N'1975-09-13' AS Date), N'Bookie_User47@qa.team', N'1939248911', N'F056L', N'user_no47', N'9nvm39FdG4', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (50, N'Zera Stanley', 1, CAST(N'1962-06-22' AS Date), N'Bookie_Admin48@qa.team', N'3023618105', N'A242L', N'user_no48', N'WV2x0jNQL8', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (51, N'Harley Avadonia', 1, CAST(N'1998-05-30' AS Date), N'Bookie_User49@qa.team', N'2549882790', N'A524L', N'user_no49', N'63XQKOsfP5', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (52, N'Butglar Gray', 0, CAST(N'2001-11-07' AS Date), N'Bookie_User50@qa.team', N'7015229259', N'E391L', N'user_no50', N't6NaNclluX', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (53, N'Joe Baxter', 1, CAST(N'1978-05-19' AS Date), N'Bookie_User51@qa.team', N'8763978419', N'C297R', N'user_no51', N'10VLDxiejW', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (54, N'Ward Wagner', 0, CAST(N'1995-02-15' AS Date), N'Bookie_User52@qa.team', N'2458631214', N'F312L', N'user_no52', N'JaWagx8363', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (55, N'Charlie Reese', 1, CAST(N'1978-11-07' AS Date), N'Bookie_User53@qa.team', N'8751908426', N'B598R', N'user_no53', N'0gT2B1b3uX', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (56, N'Windsor Dinwiddie', 0, CAST(N'1988-01-22' AS Date), N'Bookie_User54@qa.team', N'0217649643', N'D467R', N'user_no54', N'BvR10X7Be7', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (57, N'Charon Walton', 0, CAST(N'1965-05-05' AS Date), N'Bookie_User55@qa.team', N'3488293409', N'A094L', N'user_no55', N'gQ5mp7Ln9B', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (58, N'Hank Michaelis', 1, CAST(N'1994-07-09' AS Date), N'Bookie_User56@qa.team', N'2886762525', N'F063R', N'user_no56', N'VKeuCjdDo7', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (59, N'Seth Manning', 1, CAST(N'1973-05-06' AS Date), N'Bookie_User57@qa.team', N'7193619411', N'B266R', N'user_no57', N'9B8txaGLUn', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (60, N'Seth Manning', 0, CAST(N'1978-12-07' AS Date), N'Bookie_User58@qa.team', N'3562422001', N'B018R', N'user_no58', N'P3VOu0cHE9', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (61, N'Light Jenning', 0, CAST(N'1992-12-11' AS Date), N'Bookie_User59@qa.team', N'5399302391', N'F278R', N'user_no59', N'5MOL5X7w2m', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (62, N'David Barisol', 1, CAST(N'1962-04-12' AS Date), N'Bookie_Admin60@qa.team', N'1262618674', N'C060L', N'user_no60', N'cAEscuX0bp', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (63, N'Michaela Kelley', 1, CAST(N'1988-11-13' AS Date), N'Bookie_Admin61@qa.team', N'9181933819', N'C120L', N'user_no61', N'c3Kp2w1ePD', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (64, N'Melody Elphen', 1, CAST(N'1981-12-04' AS Date), N'Bookie_User62@qa.team', N'8636081048', N'F542R', N'user_no62', N'L0nU3qkIqD', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (65, N'Elluka Norman', 0, CAST(N'1991-03-07' AS Date), N'Bookie_User63@qa.team', N'6646101635', N'F258L', N'user_no63', N'8b6k4lf3bX', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (66, N'Strange Feron', 0, CAST(N'1998-01-10' AS Date), N'Bookie_User64@qa.team', N'1135823939', N'F393R', N'user_no64', N'V36337U7LQ', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (67, N'Taylor Valdez', 1, CAST(N'1991-12-03' AS Date), N'Bookie_User65@qa.team', N'3733355471', N'E585L', N'user_no65', N'TRQjooaqPE', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (68, N'Dana Macy', 0, CAST(N'1990-10-11' AS Date), N'Bookie_User66@qa.team', N'8754299135', N'F407L', N'user_no66', N'1LjH434D2f', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (69, N'Jean Valdez', 0, CAST(N'1982-10-15' AS Date), N'Bookie_User67@qa.team', N'9735839086', N'D407L', N'user_no67', N'30uboLi0pq', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (70, N'Minis Goodwin', 1, CAST(N'2003-06-05' AS Date), N'Bookie_User68@qa.team', N'9113433152', N'C176L', N'user_no68', N'6HgQhX4vAS', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (71, N'Clay Marlon', 0, CAST(N'1976-01-03' AS Date), N'Bookie_User69@qa.team', N'8151717641', N'F276L', N'user_no69', N'h8b6Ks3aHG', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (72, N'Phil Powers', 1, CAST(N'2002-07-26' AS Date), N'Bookie_User70@qa.team', N'0859547485', N'E327L', N'user_no70', N'RGGX9xaFd9', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (73, N'Butglar Hardy', 0, CAST(N'1985-06-29' AS Date), N'Bookie_User71@qa.team', N'9494816505', N'F150L', N'user_no71', N'SuC0uP5MWc', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (74, N'Camelia Mullins', 1, CAST(N'1977-10-10' AS Date), N'Bookie_User72@qa.team', N'2264980236', N'D302R', N'user_no72', N'37ov3LQvr5', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (75, N'Lionel Stanley', 1, CAST(N'1976-07-15' AS Date), N'Bookie_User73@qa.team', N'2592270859', N'F134R', N'user_no73', N'fagIRa8sd2', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (76, N'Linda Payne', 1, CAST(N'1967-07-05' AS Date), N'Bookie_User74@qa.team', N'2138430999', N'E582L', N'user_no74', N'R6DhW5Us1U', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (77, N'Philbert Cross', 1, CAST(N'1978-02-10' AS Date), N'Bookie_User75@qa.team', N'7912138173', N'A244R', N'user_no75', N'4FbN3eR914', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (78, N'Phil Jordan', 1, CAST(N'1998-09-09' AS Date), N'Bookie_User76@qa.team', N'3171032506', N'D582L', N'user_no76', N'4HoS1o8LiQ', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (79, N'Robert Kissos', 1, CAST(N'1989-04-12' AS Date), N'Bookie_Admin77@qa.team', N'8210911505', N'B322R', N'user_no77', N'44h7516veR', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (80, N'Ronald Rios', 1, CAST(N'1974-04-27' AS Date), N'Bookie_Admin78@qa.team', N'1230714908', N'E391L', N'user_no78', N'XcT993M91U', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (81, N'Elluka Manning', 1, CAST(N'1978-01-13' AS Date), N'Bookie_User79@qa.team', N'4453821425', N'D520L', N'user_no79', N'13NMusTvTs', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (82, N'Ceil Payne', 1, CAST(N'1981-01-25' AS Date), N'Bookie_User80@qa.team', N'5169407308', N'B558R', N'user_no80', N'm1lSpbnxKR', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (83, N'Lizzy Meld', 0, CAST(N'1974-03-29' AS Date), N'Bookie_User81@qa.team', N'7971588225', N'E401L', N'user_no81', N'CQ625H6cpM', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (84, N'Camelia Miller', 0, CAST(N'1995-10-05' AS Date), N'Bookie_User82@qa.team', N'6418028724', N'D425R', N'user_no82', N'kx9qI8Lrpn', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (85, N'Diana Macy', 0, CAST(N'1987-06-15' AS Date), N'Bookie_User83@qa.team', N'0392517157', N'C064L', N'user_no83', N'NOLEd7ip6u', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (86, N'Windsor Badman', 1, CAST(N'1963-04-23' AS Date), N'Bookie_User84@qa.team', N'2211777973', N'B225L', N'user_no84', N'Oq52kK54Wt', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (87, N'Diana Obrien', 0, CAST(N'1965-09-05' AS Date), N'Bookie_User85@qa.team', N'5234651834', N'B266R', N'user_no85', N'Xg48U9vViT', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (88, N'Adam Hodges', 1, CAST(N'1991-09-17' AS Date), N'Bookie_User86@qa.team', N'8244422163', N'F547L', N'user_no86', N'69OblisKtI', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (89, N'Hansel May', 1, CAST(N'1963-04-10' AS Date), N'Bookie_User87@qa.team', N'0832781475', N'B408L', N'user_no87', N'6k69wo0082', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (90, N'Oswald Pope', 0, CAST(N'2003-06-25' AS Date), N'Bookie_User88@qa.team', N'5045023619', N'B063R', N'user_no88', N'8V0cXHnT2m', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (91, N'Alex Hardy', 1, CAST(N'1975-08-25' AS Date), N'Bookie_User89@qa.team', N'2345729992', N'D066R', N'user_no89', N'42RAMiQXtP', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (92, N'Butglar Michaelis', 0, CAST(N'1973-11-06' AS Date), N'Bookie_User90@qa.team', N'0368248093', N'C055L', N'user_no90', N'tIh5JIP0wO', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (93, N'Elman Blair', 1, CAST(N'1976-07-19' AS Date), N'Bookie_User91@qa.team', N'2461908732', N'A427R', N'user_no91', N'UnoMh1cNLM', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (94, N'Lucifer Blair', 0, CAST(N'1983-01-08' AS Date), N'Bookie_User92@qa.team', N'1323033244', N'A500L', N'user_no92', N'BAobhPn8q3', 0, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (95, N'Philbert Phantomhive', 0, CAST(N'1991-03-23' AS Date), N'Bookie_User93@qa.team', N'3364836425', N'B478R', N'user_no93', N'N7946Sgcp7', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (96, N'Albion Alexdander', 1, CAST(N'1990-10-28' AS Date), N'Bookie_User94@qa.team', N'9179724841', N'A044R', N'user_no94', N'Aom68vB96X', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (97, N'Melody Chandler', 1, CAST(N'1963-12-30' AS Date), N'Bookie_User95@qa.team', N'5587772688', N'A579L', N'user_no95', N'n7q1WnuD8L', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (98, N'Katya Corbyn', 0, CAST(N'1969-12-31' AS Date), N'Bookie_User96@qa.team', N'7693285889', N'D506R', N'user_no96', N'5M5g7rO37L', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (99, N'Rahab Octo', 0, CAST(N'1989-05-01' AS Date), N'Bookie_User97@qa.team', N'5723628843', N'A079L', N'user_no97', N'38622s3j03', 1, 0)
GO
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (100, N'Hansel May', 1, CAST(N'2003-06-22' AS Date), N'Bookie_User98@qa.team', N'0343057780', N'E443R', N'user_no98', N'1oST7ll09m', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (101, N'Luke Thayne', 0, CAST(N'1989-10-15' AS Date), N'Bookie_User99@qa.team', N'0889839198', N'D114L', N'user_no99', N'IK7S0hEEW1', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (102, N'Cyril Watson', 0, CAST(N'1999-02-15' AS Date), N'Bookie_User100@qa.team', N'5859588913', N'F550R', N'user_no100', N'aBaQq4bHD0', 1, 0)
INSERT [dbo].[User] ([id], [fullname], [gender], [dob], [email], [phone], [address], [username], [password], [is_super], [walletNumber]) VALUES (109, N'I Am Tester', 1, CAST(N'2002-01-01' AS Date), N'Bookie_User200@qa.team', N'0987654321', NULL, N'tester', N'test', 1, 109)
SET IDENTITY_INSERT [dbo].[User] OFF
GO
SET IDENTITY_INSERT [dbo].[Volume] ON 

INSERT [dbo].[Volume] ([id], [bookId], [volume], [volumeName], [summary]) VALUES (1, 1, 1, N'Part One: BOY LOSES GIRL', NULL)
INSERT [dbo].[Volume] ([id], [bookId], [volume], [volumeName], [summary]) VALUES (2, 1, 2, N'Part Two: Boy Meets Girl', NULL)
SET IDENTITY_INSERT [dbo].[Volume] OFF
GO
ALTER TABLE [dbo].[Book] ADD  DEFAULT ((0)) FOR [favourite]
GO
ALTER TABLE [dbo].[Book] ADD  CONSTRAINT [DF__Book__views__30F848ED]  DEFAULT ((0)) FOR [views]
GO
ALTER TABLE [dbo].[Book] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF__User__is_super__31EC6D26]  DEFAULT ((1)) FOR [is_super]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_balance]  DEFAULT ((0)) FOR [walletNumber]
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD  CONSTRAINT [FK__Book__categoryid__32E0915F] FOREIGN KEY([categoryid])
REFERENCES [dbo].[Category] ([id])
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [FK__Book__categoryid__32E0915F]
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD FOREIGN KEY([categoryid])
REFERENCES [dbo].[Category] ([id])
GO
ALTER TABLE [dbo].[Book_Own]  WITH CHECK ADD  CONSTRAINT [FK_Book_Own_Book] FOREIGN KEY([bookId])
REFERENCES [dbo].[Book] ([id])
GO
ALTER TABLE [dbo].[Book_Own] CHECK CONSTRAINT [FK_Book_Own_Book]
GO
ALTER TABLE [dbo].[Book_Own]  WITH CHECK ADD  CONSTRAINT [FK_Book_Own_User] FOREIGN KEY([userId])
REFERENCES [dbo].[User] ([id])
GO
ALTER TABLE [dbo].[Book_Own] CHECK CONSTRAINT [FK_Book_Own_User]
GO
ALTER TABLE [dbo].[Chapter]  WITH CHECK ADD FOREIGN KEY([bookId])
REFERENCES [dbo].[Book] ([id])
GO
ALTER TABLE [dbo].[Chapter]  WITH CHECK ADD FOREIGN KEY([volumeId])
REFERENCES [dbo].[Volume] ([id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Comment]  WITH CHECK ADD FOREIGN KEY([bookId])
REFERENCES [dbo].[Book] ([id])
GO
ALTER TABLE [dbo].[Comment]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[User] ([id])
GO
ALTER TABLE [dbo].[Content]  WITH CHECK ADD FOREIGN KEY([chapterId])
REFERENCES [dbo].[Chapter] ([id])
GO
ALTER TABLE [dbo].[Favourite]  WITH CHECK ADD  CONSTRAINT [FK__Favourite__bid__2B3F6F97] FOREIGN KEY([bid])
REFERENCES [dbo].[Book] ([id])
GO
ALTER TABLE [dbo].[Favourite] CHECK CONSTRAINT [FK__Favourite__bid__2B3F6F97]
GO
ALTER TABLE [dbo].[Favourite]  WITH CHECK ADD FOREIGN KEY([bid])
REFERENCES [dbo].[Book] ([id])
GO
ALTER TABLE [dbo].[Favourite]  WITH CHECK ADD  CONSTRAINT [FK__Favourite__uid__2A4B4B5E] FOREIGN KEY([uid])
REFERENCES [dbo].[User] ([id])
GO
ALTER TABLE [dbo].[Favourite] CHECK CONSTRAINT [FK__Favourite__uid__2A4B4B5E]
GO
ALTER TABLE [dbo].[Favourite]  WITH CHECK ADD FOREIGN KEY([uid])
REFERENCES [dbo].[User] ([id])
GO
ALTER TABLE [dbo].[Payment_Method]  WITH CHECK ADD  CONSTRAINT [FK_Payment_Method_Payment_Account] FOREIGN KEY([accountNumber])
REFERENCES [dbo].[Payment_Account] ([accountNumber])
GO
ALTER TABLE [dbo].[Payment_Method] CHECK CONSTRAINT [FK_Payment_Method_Payment_Account]
GO
ALTER TABLE [dbo].[Payment_Method]  WITH CHECK ADD  CONSTRAINT [FK_Payment_Method_User] FOREIGN KEY([userId])
REFERENCES [dbo].[User] ([id])
GO
ALTER TABLE [dbo].[Payment_Method] CHECK CONSTRAINT [FK_Payment_Method_User]
GO
ALTER TABLE [dbo].[ReportDetail]  WITH CHECK ADD FOREIGN KEY([bookId])
REFERENCES [dbo].[Book] ([id])
GO
ALTER TABLE [dbo].[ReportDetail]  WITH CHECK ADD FOREIGN KEY([reportId])
REFERENCES [dbo].[Report] ([id])
GO
ALTER TABLE [dbo].[ReportDetail]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[User] ([id])
GO
ALTER TABLE [dbo].[Star]  WITH CHECK ADD  CONSTRAINT [FK__Star__bid__2E1BDC42] FOREIGN KEY([bid])
REFERENCES [dbo].[Book] ([id])
GO
ALTER TABLE [dbo].[Star] CHECK CONSTRAINT [FK__Star__bid__2E1BDC42]
GO
ALTER TABLE [dbo].[Star]  WITH CHECK ADD FOREIGN KEY([bid])
REFERENCES [dbo].[Book] ([id])
GO
ALTER TABLE [dbo].[Star]  WITH CHECK ADD  CONSTRAINT [FK__Star__uid__2F10007B] FOREIGN KEY([uid])
REFERENCES [dbo].[User] ([id])
GO
ALTER TABLE [dbo].[Star] CHECK CONSTRAINT [FK__Star__uid__2F10007B]
GO
ALTER TABLE [dbo].[Star]  WITH CHECK ADD FOREIGN KEY([uid])
REFERENCES [dbo].[User] ([id])
GO
ALTER TABLE [dbo].[Token]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[User] ([id])
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_Transaction_Payment_Method] FOREIGN KEY([paymentId])
REFERENCES [dbo].[Payment_Method] ([paymentId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_Transaction_Payment_Method]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_Transaction_User] FOREIGN KEY([userId])
REFERENCES [dbo].[User] ([id])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_Transaction_User]
GO
ALTER TABLE [dbo].[Transaction_Token]  WITH CHECK ADD  CONSTRAINT [FK_Transaction_Token_Transaction] FOREIGN KEY([transactionId])
REFERENCES [dbo].[Transaction] ([transactionId])
GO
ALTER TABLE [dbo].[Transaction_Token] CHECK CONSTRAINT [FK_Transaction_Token_Transaction]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_Payment_Account] FOREIGN KEY([walletNumber])
REFERENCES [dbo].[Payment_Account] ([accountNumber])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_Payment_Account]
GO
ALTER TABLE [dbo].[Volume]  WITH CHECK ADD FOREIGN KEY([bookId])
REFERENCES [dbo].[Book] ([id])
GO
ALTER TABLE [dbo].[Star]  WITH CHECK ADD  CONSTRAINT [chk_star] CHECK  (([star]>=(1) AND [star]<=(5)))
GO
ALTER TABLE [dbo].[Star] CHECK CONSTRAINT [chk_star]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 mean Fail, 1 mean Pending, 2 mean Successful' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transaction', @level2type=N'COLUMN',@level2name=N'status'
GO
USE [master]
GO
ALTER DATABASE [BOOKIE] SET  READ_WRITE 
GO