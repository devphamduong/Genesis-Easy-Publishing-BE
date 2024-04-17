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
        private readonly Mock<HttpRequest> _requestMock;
        private readonly InteractionsController _controller;
  
        private Mock<IHttpContextAccessor> _httpContextAccessorMock;
        private readonly IConfiguration _configuration;
        private readonly Mock<HttpContext> _httpContextMock = new Mock<HttpContext>();

        private readonly HttpRequest httpRequest;

        public InteractionsControllerTests() {
            _context = new EasyPublishingContext();
            _contextMock = new Mock<EasyPublishingContext>();
             _controller = new InteractionsController(_contextMock.Object);
            _requestMock = new Mock<HttpRequest>();
      

        }
        [Fact]
        public async Task LikeStory_InvalidUser_Unauthorized()
        {
            // Arrange
            var storyId = 1;

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
        [Fact]
        public async Task LikeChapter_InvalidUser_Unauthorized()
        {
            // Arrange
            var storyId = 1;

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
        public async Task LikeChapter_ValidUser_LikeChapter()
        {
            // Arrange
            var controller = new InteractionsController(_contextMock.Object);

            _httpContextAccessorMock.Setup(m => m.HttpContext).Returns(_httpContextMock.Object);
            controller = new InteractionsController(_contextMock.Object)
            {
                ControllerContext = new ControllerContext { HttpContext = _httpContextMock.Object },
            };

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
        [Fact]
        public async Task FollowStory_InvalidUser_Unauthorized()
        {
            // Arrange
            var storyId = 1;

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
        public async Task FollowStory_ValidUser_Followtory()
        {
            // Arrange
            var controller = new InteractionsController(_contextMock.Object);

            _httpContextAccessorMock.Setup(m => m.HttpContext).Returns(_httpContextMock.Object);
            controller = new InteractionsController(_contextMock.Object)
            {
                ControllerContext = new ControllerContext { HttpContext = _httpContextMock.Object },
            };

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
