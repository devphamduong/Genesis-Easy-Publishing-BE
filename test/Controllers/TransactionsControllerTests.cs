using app.Controllers;
using app.Models;
using app.Service;
using FakeItEasy;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace test.Controllers
{
    public class TransactionsControllerTests
    {
        [Fact]
        public async Task AddTransactionBuyStory_ReturnsSuccess_WhenStoryIsBought()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var _httpContextAccessor = A.Fake<IHttpContextAccessor>();
            var _configuration = A.Fake<IConfiguration>();
            var controller = new TransactionsController(mockContext.Object, _configuration, _httpContextAccessor);
            var storyId = 1; // Set the story ID as needed
            var userId = 2; // Set the user ID as needed

            var user = new User
            {
                UserId = userId
            };

            var story = new Story
            {
                StoryId = storyId,
                AuthorId = 3, // Sample author ID
                StoryPrice = 10.00m, // Sample story price
                StorySale = 0, // Sample story sale percentage
            };

            var userWallet = new Wallet
            {
                WalletId = 1, // Sample user wallet ID
                UserId = userId,
                Fund = 20.00m // Sample user wallet fund
            };

            var authorWallet = new Wallet
            {
                WalletId = 2, // Sample author wallet ID
                UserId = 3, // Sample author ID
                Refund = 5.00m // Sample author wallet refund
            };

            var chapters = new List<Chapter>
            {
                new Chapter { ChapterId = 1, StoryId = storyId },
                new Chapter { ChapterId = 2, StoryId = storyId }
            };

            mockContext.Setup(m => m.Users.Where(u => u.UserId == userId)).Returns(new List<User> { user }.AsQueryable());
            mockContext.Setup(m => m.Stories.Where(s => s.StoryId == storyId)).Returns(new List<Story> { story }.AsQueryable());
            mockContext.Setup(m => m.Wallets.Where(w => w.UserId == userId)).Returns(new List<Wallet> { userWallet }.AsQueryable());
            mockContext.Setup(m => m.Wallets.Where(w => w.UserId == story.AuthorId)).Returns(new List<Wallet> { authorWallet }.AsQueryable());
            mockContext.Setup(m => m.Chapters.Where(ch => ch.StoryId == storyId)).Returns(chapters.AsQueryable());

            // Act
            var result = await controller.AddTransactionBuyStory(storyId);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            dynamic jsonData = jsonResult.Value;
            Assert.Equal(0, (int)jsonData.EC);
            Assert.Equal("Mua truyện thành công", (string)jsonData.EM);
        
        }
        [Fact]
        public async Task AddTransactionBuyChapter_ReturnsSuccess_WhenChapterIsBought()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var _httpContextAccessor = A.Fake<IHttpContextAccessor>();
            var _configuration = A.Fake<IConfiguration>();
            var controller = new TransactionsController(mockContext.Object, _configuration, _httpContextAccessor);
            var chapterId = 1; // Set the chapter ID as needed
            var userId = 2; // Set the user ID as needed

            var user = new User
            {
                UserId = userId
            };

            var chapter = new Chapter
            {
                ChapterId = chapterId,
                StoryId = 3, // Sample story ID
                ChapterPrice = 5.00m, // Sample chapter price
                ChapterNumber = 1, // Sample chapter number
                ChapterTitle = "Chapter Title" // Sample chapter title
            };

            var story = new Story
            {
                StoryId = chapter.StoryId,
                AuthorId = 4, // Sample author ID
                StoryTitle = "Story Title" // Sample story title
            };

            var userWallet = new Wallet
            {
                WalletId = 1, // Sample user wallet ID
                UserId = userId,
                Fund = 10.00m // Sample user wallet fund
            };

            var authorWallet = new Wallet
            {
                WalletId = 2, // Sample author wallet ID
                UserId = story.AuthorId,
                Refund = 15.00m // Sample author wallet refund
            };

            var userChapters = new List<Chapter>
            {
                new Chapter { ChapterId = 2, StoryId = chapter.StoryId },
                new Chapter { ChapterId = 3, StoryId = chapter.StoryId }
            };

            mockContext.Setup(m => m.Users.Where(u => u.UserId == userId)).Returns(new List<User> { user }.AsQueryable());
            mockContext.Setup(m => m.Chapters.Where(ch => ch.ChapterId == chapterId)).Returns(new List<Chapter> { chapter }.AsQueryable());
            mockContext.Setup(m => m.Stories.Where(s => s.StoryId == chapter.StoryId)).Returns(new List<Story> { story }.AsQueryable());
            mockContext.Setup(m => m.Wallets.Where(w => w.UserId == userId)).Returns(new List<Wallet> { userWallet }.AsQueryable());
            mockContext.Setup(m => m.Wallets.Where(w => w.UserId == story.AuthorId)).Returns(new List<Wallet> { authorWallet }.AsQueryable());
            mockContext.Setup(m => m.Users.Where(u => u.UserId == userId)).Returns(new List<User> { user }.AsQueryable());
            mockContext.Setup(m => m.Chapters.Where(ch => ch.StoryId == chapter.StoryId)).Returns(userChapters.AsQueryable());

            // Act
            var result = await controller.AddTransactionBuyChapter(chapterId);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            dynamic jsonData = jsonResult.Value;
            Assert.Equal(0, (int)jsonData.EC);
            Assert.Equal("Buy chapter 1 Chapter Title in story Story Title successful", (string)jsonData.EM);
         
        }
        [Fact]
        public async Task AddTransactionBuyManyChapters_ReturnsSuccess_WhenChaptersAreBought()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var _httpContextAccessor = A.Fake<IHttpContextAccessor>();
            var _configuration = A.Fake<IConfiguration>();
            var controller = new TransactionsController(mockContext.Object, _configuration, _httpContextAccessor);
            var chapterStart = 1; // Set the start chapter number as needed
            var chapterEnd = 3; // Set the end chapter number as needed
            var storyId = 1; // Set the story ID as needed
            var userId = 2; // Set the user ID as needed

            var user = new User
            {
                UserId = userId
            };

            var chapters = new List<Chapter>
            {
                new Chapter { ChapterId = 1, ChapterNumber = 1, StoryId = storyId, ChapterPrice = 5.00m },
                new Chapter { ChapterId = 2, ChapterNumber = 2, StoryId = storyId, ChapterPrice = 5.00m },
                new Chapter { ChapterId = 3, ChapterNumber = 3, StoryId = storyId, ChapterPrice = 5.00m }
            };

            var story = new Story
            {
                StoryId = storyId,
                AuthorId = 3, // Sample author ID
                StoryTitle = "Story Title" // Sample story title
            };

            var userWallet = new Wallet
            {
                WalletId = 1, // Sample user wallet ID
                UserId = userId,
                Fund = 20.00m // Sample user wallet fund
            };

            var authorWallet = new Wallet
            {
                WalletId = 2, // Sample author wallet ID
                UserId = story.AuthorId,
                Refund = 15.00m // Sample author wallet refund
            };

            var userChapters = new List<Chapter>
            {
                new Chapter { ChapterId = 4, StoryId = storyId },
                new Chapter { ChapterId = 5, StoryId = storyId }
            };

            mockContext.Setup(m => m.Users.Where(u => u.UserId == userId)).Returns(new List<User> { user }.AsQueryable());
            mockContext.Setup(m => m.Chapters.Where(ch => ch.ChapterNumber >= chapterStart && ch.ChapterNumber <= chapterEnd && ch.StoryId == storyId)).Returns(chapters.AsQueryable());
            mockContext.Setup(m => m.Chapters.Any(ch => ch.StoryId == storyId && ch.ChapterNumber == chapterEnd)).Returns(true);
            mockContext.Setup(m => m.Users.Where(u => u.UserId == userId)).Returns(new List<User> { user }.AsQueryable());
            mockContext.Setup(m => m.Chapters.Where(ch => ch.StoryId == storyId)).Returns(userChapters.AsQueryable());
            mockContext.Setup(m => m.Stories.Where(s => s.StoryId == storyId)).Returns(new List<Story> { story }.AsQueryable());
            mockContext.Setup(m => m.Wallets.Where(w => w.UserId == userId)).Returns(new List<Wallet> { userWallet }.AsQueryable());
            mockContext.Setup(m => m.Wallets.Where(w => w.UserId == story.AuthorId)).Returns(new List<Wallet> { authorWallet }.AsQueryable());

            // Act
            var result = await controller.AddTransactionBuyManyChapters(chapterStart, chapterEnd, storyId);

            // Assert
          
            var jsonResult = Assert.IsType<JsonResult>(result);
            dynamic jsonData = jsonResult.Value;
            Assert.Equal(0, (int)jsonData.EC);
            Assert.Equal("Bạn đã mua thành công", (string)jsonData.EM);
        }
        [Fact]
        public async Task AddTransactionTopUp_ReturnsSuccess_WhenAmountIsToppedUp()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var _httpContextAccessor = A.Fake<IHttpContextAccessor>();
            var _configuration = A.Fake<IConfiguration>();
            var controller = new TransactionsController(mockContext.Object, _configuration, _httpContextAccessor);
            var amount = 100; // Set the top-up amount as needed
            var userId = 2; // Set the user ID as needed

            var user = new User
            {
                UserId = userId,
                UserFullname = "John Doe" // Sample user fullname
            };

            var userWallet = new Wallet
            {
                WalletId = 1, // Sample user wallet ID
                UserId = userId,
                Fund = 50.00m // Sample user wallet fund
            };

            var adminWallet = new Wallet
            {
                WalletId = 2, // Sample admin wallet ID
                Fund = 200.00m, // Sample admin wallet fund
                Refund = 100.00m // Sample admin wallet refund
            };

            mockContext.Setup(m => m.Users.Where(u => u.UserId == userId)).Returns(new List<User> { user }.AsQueryable());
            mockContext.Setup(m => m.Wallets.Where(w => w.UserId == userId)).Returns(new List<Wallet> { userWallet }.AsQueryable());

            // Act
            var result = await controller.AddTransactionTopUp(amount);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            dynamic jsonData = jsonResult.Value;
            Assert.Equal(0, (int)jsonData.EC);
            Assert.Equal("Nạp 100000 VND thành  100 TLT : John Doe thành công", (string)jsonData.EM);
            // Add more specific assertions based on the expected behavior
        }
    }
}
