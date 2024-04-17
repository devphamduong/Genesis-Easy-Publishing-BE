using app.Controllers;
using app.Models;
using app.Service;
using Microsoft.AspNetCore.Mvc;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static app.Controllers.ReviewsController;


using Xunit;
using Moq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using Microsoft.Extensions.Configuration;
using FluentAssertions;
using FakeItEasy;

namespace test.Controllers // Replace YourNamespace.Tests with the actual namespace of your tests
{
    public class ReviewsControllerTests
    {
        private Mock<EasyPublishingContext> _contextMock;
        private Mock<MailService> _mailServiceMock;
        private ReviewsController _controller;
        private IConfiguration configuration;
        public ReviewsControllerTests()
        {
            _contextMock = new Mock<EasyPublishingContext>();
            _mailServiceMock = new Mock<MailService>();
            configuration = A.Fake<IConfiguration>();
            _controller = new ReviewsController(_contextMock.Object,configuration);
        }

        [Fact]
        public async Task SendReview_WithValidReview_ReturnsSuccess()
        {
            // Arrange
            int userId = 1;
            int chapterId = 1;
            var reviewForm = new ReviewForm
            {
                ChapterId = chapterId,
                // Set other properties as needed
            };

            var user = new User { UserId = userId, RoleId = 1 /* Assuming user is not a reviewer */ };
            var chapter = new Chapter { ChapterId = chapterId };
            _contextMock.Setup(m => m.Users.FirstOrDefault(u => u.UserId == userId)).Returns(user);
            _contextMock.Setup(m => m.Chapters.FirstOrDefault(c => c.ChapterId == chapterId)).Returns(chapter);

            // Act
            var result = await _controller.SendReview(reviewForm);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Gửi review thành công",
            });
        }

        [Fact]
        public async Task SendReview_WhenUserIsNotLoggedIn_ReturnsUnauthorized()
        {
            // Arrange
            var reviewForm = new ReviewForm
            {
                // Set properties as needed
            };

            // Act
            var result = await _controller.SendReview(reviewForm);

            // Assert

            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Yêu cầu đăng nhập",
            });
        }

        [Fact]
        public async Task SendReview_WhenUserIsReviewer_ReturnsUnauthorized()
        {
            // Arrange
            int userId = 1;
            var reviewForm = new ReviewForm
            {
                // Set properties as needed
            };

            var user = new User { UserId = userId, RoleId = 2 /* Assuming user is a reviewer */ };
            _contextMock.Setup(m => m.Users.FirstOrDefault(u => u.UserId == userId)).Returns(user);

            // Act
            var result = await _controller.SendReview(reviewForm);

            // Assert
     
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 1,
                EM = "Không có quyền Reviewer",
            });
        }

        [Fact]
        public async Task SendReview_WhenChapterDoesNotExist_ReturnsBadRequest()
        {
            // Arrange
            int userId = 1;
            int chapterId = 1;
            var reviewForm = new ReviewForm
            {
                ChapterId = chapterId,
                // Set other properties as needed
            };

            var user = new User { UserId = userId, RoleId = 1 /* Assuming user is not a reviewer */ };
            _contextMock.Setup(m => m.Users.FirstOrDefault(u => u.UserId == userId)).Returns(user);
            _contextMock.Setup(m => m.Chapters.FirstOrDefault(c => c.ChapterId == chapterId)).Returns((Chapter)null);

            // Act
            var result = await _controller.SendReview(reviewForm);

            // Assert
        
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 2,
                EM = "Chương không tồn tại",
            });
        }

        // Add more tests for other scenarios...

    }
}
