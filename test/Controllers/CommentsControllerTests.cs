using app.Controllers;
using app.DTOs;
using app.Models;
using app.Service;
using FakeItEasy;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using static app.Controllers.AuthController;
using static app.Controllers.CommentsController;

namespace test.Controllers
{
    public class CommentsControllerTests
    {
        [Fact]
        public async Task SendComment_ReturnsSuccess_WhenCommentIsSent()
        {

            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var _context = new EasyPublishingContext();
            var controller = new CommentsController(mockContext.Object);
            var _configuration =  A.Fake<IConfiguration>();
            var commentDTO = new CommentDTO
            {
                StoryId = 1,
                ChapterId = 1,
                CommentContent = "Test comment content"
            };
            var data = new LoginForm
            {
                EmailOrUsername = "Bookie_User2@qa.team",
                Password = "654321",
                Remember = true
            };
            int userId = 1;

            controller.ControllerContext.HttpContext = new DefaultHttpContext();
            controller.ControllerContext.HttpContext.User = new ClaimsPrincipal(new ClaimsIdentity(new Claim[]
            {
                new Claim(ClaimTypes.NameIdentifier, userId.ToString())
            }));
            var AuthController = new AuthController(_context, _configuration);
            // Act
            var result = await controller.SendComment(commentDTO);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Bình luận thành công"
            });
        }

        [Fact]
        public async Task EditComment_ReturnsSuccess_WhenCommentIsEdited()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var _context = new EasyPublishingContext();
            var controller = new CommentsController(mockContext.Object);
            var _configuration = A.Fake<IConfiguration>();
            var commentDTO = new CommentDTO
            {
                StoryId = 1,
                ChapterId = 1,
                CommentContent = "Test comment content"
            };
            var data = new LoginForm
            {
                EmailOrUsername = "Bookie_User2@qa.team",
                Password = "654321",
                Remember = true
            };
            var AuthController = new AuthController(_context, _configuration);

            var commentId = 1;
            var userId = 1;
            var cmtUpdate = new CommentUpdateModel
            {
                CommentContent = "Updated comment content"
            };
            controller.ControllerContext.HttpContext = new DefaultHttpContext();
            controller.ControllerContext.HttpContext.User = new ClaimsPrincipal(new ClaimsIdentity(new Claim[]
            {
                new Claim(ClaimTypes.NameIdentifier, userId.ToString())
            }));
            var existingComment = new Comment
            {
                CommentId = commentId,
                UserId = userId,
                CommentContent = "Initial comment content"
            };

            // Act
            var result = await controller.EditComment(commentId, cmtUpdate);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Bình luận thành công"
            });
        }
    }
}
