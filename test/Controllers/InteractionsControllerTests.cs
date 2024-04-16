using app.Controllers;
using app.DTOs;
using app.Models;
using app.Service;
using Azure.Core;
using FakeItEasy;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Primitives;
using Microsoft.IdentityModel.Tokens;
using Moq;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Linq.Expressions;
using System.Net;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using static app.Controllers.AuthController;

namespace test.Controllers
{
    public class InteractionsControllerTests
    {
        private readonly EasyPublishingContext _context;
        private Mock<EasyPublishingContext> _contextMock;
        private Mock<MsgService> _msgServiceMock;
        private readonly Mock<HttpRequest> _requestMock;
        private readonly InteractionsController _controller;
        private Mock<HttpContext> _mockHttpContext;
        private Mock<HttpRequest> _mockHttpRequest;
        private Mock<IHeaderDictionary> _mockHeaders;
        private Mock<ClaimsPrincipal> _mockUser;
        private Mock<ClaimsIdentity> _mockIdentity;
        private Mock<IHttpContextAccessor> _httpContextAccessorMock;
        private readonly IConfiguration _configuration;
        private readonly Mock<HttpContext> _httpContextMock = new Mock<HttpContext>();

        private readonly HttpRequest httpRequest;

        public InteractionsControllerTests() {
            _context = new EasyPublishingContext();
            _contextMock = new Mock<EasyPublishingContext>();
             _controller = new InteractionsController(_contextMock.Object);
            _requestMock = new Mock<HttpRequest>();
            _mockHttpContext = new Mock<HttpContext>();
            _mockHttpRequest = new Mock<HttpRequest>();
            _mockHeaders = new Mock<IHeaderDictionary>();
            _mockUser = new Mock<ClaimsPrincipal>();
            _mockIdentity = new Mock<ClaimsIdentity>();
            _configuration = A.Fake<IConfiguration>();
            _httpContextAccessorMock = new Mock<IHttpContextAccessor>();
            httpRequest = A.Fake<HttpRequest>();

        }
        [Fact]
        public async Task LikeStory_InvalidUser_Unauthorized()
        {
            // Arrange
            var storyId = 1;
            var userId = 10;
            var existingInteraction = new StoryFollowLike { UserId = userId, StoryId = storyId, Follow = false, Like = false };
            var storyInteraction = new StoryInteraction { StoryId = storyId, Like = 0 };

            _mockHttpContext.Setup(c => c.Request).Returns(_mockHttpRequest.Object);
            _mockHttpRequest.Setup(r => r.Headers).Returns(_mockHeaders.Object);
            _mockHttpContext.Setup(c => c.User).Returns(_mockUser.Object);
            _mockIdentity.Setup(i => i.IsAuthenticated).Returns(true);
            _mockUser.Setup(u => u.Identity).Returns(_mockIdentity.Object);
             

            // Act
            var result = await _controller.LikeStory(1);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Đăng nhập trước",
            });
        }

        [Fact]
        public async Task LikeStory_ValidUser_LikeStory()
        {
            // Arrange
            var controller = new InteractionsController(_contextMock.Object);

            _httpContextAccessorMock.Setup(m => m.HttpContext).Returns(_httpContextMock.Object);
            controller = new InteractionsController(_contextMock.Object)
            {
                ControllerContext = new ControllerContext { HttpContext = _httpContextMock.Object },
            };
            string access_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0IiwiZW1haWwiOiJCb29raWVfVXNlcjJAcWEudGVhbSIsInVzZXJuYW1lIjoibmFtbmQiLCJuYmYiOjE3MTI0ODk2NDAsImV4cCI6MTcxMjU3NjA0MCwiaWF0IjoxNzEyNDg5NjQwLCJpc3MiOiJhZG1pbiIsImF1ZCI6InVzZXIifQ.QZMfWqafNNdVA6M2RzKhevUf1he-uiuPVQGq4zqjBlI";
            _httpContextMock.SetupGet(c => c.User.Identity.IsAuthenticated).Returns(true);
            _httpContextMock.SetupGet(c => c.Request.Cookies["access_token"]).Returns(access_token);
            // Act
            var result = await _controller.LikeStory(2);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Bạn đã thích truyện",
            });
        }

    }
}
