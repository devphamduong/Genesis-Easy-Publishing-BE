using app.Controllers;
using app.DTOs;
using app.Service;
using Microsoft.AspNetCore.Mvc;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;
using app.Models;
using FluentAssertions;

namespace test.Controllers
{
    public class ReportsControllerTests
    {
        private readonly Mock<EasyPublishingContext> _unitOfWorkMock;
        private readonly ReportsController _controller;

        public ReportsControllerTests()
        {
            _unitOfWorkMock = new Mock<EasyPublishingContext>();
            _controller = new ReportsController(_unitOfWorkMock.Object);
        }

        [Fact]
        public async Task SendReport_ShouldReturnBadRequest_WhenUserIdIsZero()
        {
            // Arrange
            var reportDTO = new ReportDTO();

            // Act
            var result = await _controller.SendReport(reportDTO);

            // Assert

            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Yêu cầu đăng nhập",
            });
        }

        [Fact]
        public async Task SendReport_ShouldReturnBadRequest_WhenModelStateIsInvalid()
        {
            // Arrange
            _controller.ModelState.AddModelError("ReportTypeId", "ReportTypeId is required.");
            var reportDTO = new ReportDTO();

            // Act
            var result = await _controller.SendReport(reportDTO);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Thiếu điều kiện",
            });
        }


        [Fact]
        public async Task SendReport_ShouldReturnOk_WhenReportIsSentSuccessfully()
        {
            // Arrange
            var reportDTO = new ReportDTO { ReportTypeId = 1, StoryId = 1, ChapterId = 1, CommentId = 1, ReportContent = "Test report content" };

            // Act

            var result = await _controller.SendReport(reportDTO);

            // Assert

            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Báo cáo thành công",
            });
        }
    }
}
