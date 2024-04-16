using app.Controllers;
using app.Models;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static app.Controllers.ChaptersController;
using static OfficeOpenXml.ExcelErrorValue;

namespace Genesis_Easy_Publishing_BE.Tests.Controllers
{
    public class ChaptersControllerTests
    {
        private readonly Mock<EasyPublishingContext> _contextMock = new Mock<EasyPublishingContext>();
        private readonly ChaptersController _controller;

        public ChaptersControllerTests()
        {
            _controller = new ChaptersController(_contextMock.Object);

        }
        public static DbSet<T> CreateMockDbSet<T>(IEnumerable<T> data) where T : class
        {
            var queryable = data.AsQueryable();

            var mockSet = new Mock<DbSet<T>>();
            mockSet.As<IQueryable<T>>().Setup(m => m.Provider).Returns(queryable.Provider);
            mockSet.As<IQueryable<T>>().Setup(m => m.Expression).Returns(queryable.Expression);
            mockSet.As<IQueryable<T>>().Setup(m => m.ElementType).Returns(queryable.ElementType);
            mockSet.As<IQueryable<T>>().Setup(m => m.GetEnumerator()).Returns(queryable.GetEnumerator());

            return mockSet.Object;
        }
        [Fact]
        public async Task AddVolume_ShouldReturnBadRequest_WhenVolumeTitleIsNullOrEmpty()
        {
            // Arrange
            var volume = new AddVolumeForm
            {
                StoryId = 2,
                VolumeTitle = null,
            };

            // Act
            var result = await _controller.AddVolume(volume);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Thêm tập thất bại!",
            });
        }
        [Fact]
        public async Task AddVolume_ShouldReturnBadRequest_WhenStoryDoesNotExist()
        {
            // Arrange
            var volume = new AddVolumeForm
            {
                VolumeTitle = "Test Volume",
                StoryId = 1 
            };
            var volumes = new List<Volume>
            {
                new Volume
                {
                    VolumeId = 1,
                   VolumeTitle = "Volume 1",
                   StoryId= 2,
                   CreateTime = DateTime.Now,
                   UpdateTime = DateTime.Now,
                   VolumeNumber = 1,
                   Chapters = null
                },
                new Volume { StoryId = 1, VolumeNumber = 2 }
            };
            var chaptersCount = 1;
            var volumeDbSet = CreateMockDbSet(volumes);
            _contextMock.Setup(c => c.Volumes).Returns(volumeDbSet);

            // Act
            var result = await _controller.AddVolume(volume);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Không thể tạo thêm tập mới",
            });
        }
        [Fact]
        public async Task AddVolume_ShouldReturnSuccess_WhenValid()
        {
            // Arrange
            var volume = new AddVolumeForm
            {
                VolumeTitle = "Test Volume",
                StoryId = 1 
            };

            var volumes = new List<Volume>(); 
            var chaptersCount = 1;
            var volumeDbSet = CreateMockDbSet(volumes);
            _contextMock.Setup(c => c.Volumes).Returns(volumeDbSet);

            // Act
            var result = await _controller.AddVolume(volume);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Thêm tập mới thành công",
            });
        }
    }
}
