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
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Genesis_Easy_Publishing_BE.Tests.Controllers
{
    public class ChaptersControllerTests
    {
        private readonly Mock<EasyPublishingContext> _contextMock = new Mock<EasyPublishingContext>();
        private readonly ChaptersController _controller;
        private readonly EasyPublishingContext _context = new EasyPublishingContext();

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
        [Fact]
        public async Task UpdateVolume_ShouldReturnBadRequest_WhenVolumeTitleIsEmptyOrNull()
        {
            // Arrange
            var volume = new UpdateVolumeForm { VolumeId = 1, VolumeTitle = "" };

            // Act
            var result = await _controller.UpdateVolume(volume);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Cập nhật thất bại!",
            });
        }
        [Fact]
        public async Task UpdateVolume_ShouldReturnBadRequest_WhenVolumeDoesNotExist()
        {
            // Arrange
            var volume = new UpdateVolumeForm { VolumeId = 1, VolumeTitle = "Updated Volume Title" };
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
            var volumeDbSet = CreateMockDbSet(volumes);
            _contextMock.Setup(c => c.Volumes).Returns(volumeDbSet);

            // Act
            var result = await _controller.UpdateVolume(volume);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Tập không tồn tại",
            });
        }

        [Fact]
        public async Task UpdateVolume_ShouldReturnOk_WhenVolumeIsUpdatedSuccessfully()
        {
            // Arrange
            var volumes = new UpdateVolumeForm
            {
                VolumeId = 1,
                VolumeTitle = "Volume 1"
            };
            var _controller = new ChaptersController(_contextMock.Object);

            // Act
            var result = await _controller.UpdateVolume(volumes);

            // Assert
         
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Cập nhật thành công",
            });

        }
        [Fact]
        public async Task DeleteChapter_ShouldReturnBadRequest_WhenChapterDoesNotExist()
        {
            // Arrange
            var chapterId = 150;
            var controller = new ChaptersController(_context);
            // Act
            var result = await controller.DeleteChapter(chapterId);

            // Assert

            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Chương không tồn tại",
            });
        }

       
        [Fact]
        public async Task DeleteChapter_ShouldReturnOk_WhenChapterIsDeletedSuccessfully()
        {
            // Arrange
            var chapterId = 1;
            var controller = new ChaptersController(_context);
            // Act
            var result = await controller.DeleteChapter(chapterId);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Xóa chương thành công",
            });
        }
        [Fact]
        public async Task AddChapter_ReturnsSuccess_WhenChapterIsAdded()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var controller = new ChaptersController(mockContext.Object);
            var form = new addChapterForm
            {
                ChapterContentHtml = "<p>Chapter content in HTML</p>",
                ChapterContentMarkdown = "Chapter content in Markdown",
                StoryId = 1,
                VolumeId = 1,
                ChapterTitle = "Chapter Title",
                ChapterPrice = 0.99m // Set the price as needed
            };

            var mockDbSet = new Mock<DbSet<Chapter>>();
            mockContext.Setup(m => m.Chapters).Returns(mockDbSet.Object);

            // Act
            var result = await controller.AddChapter(form);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Thêm chương mới thành công",
            });
        }

        [Fact]
        public async Task AddChapter_ReturnsError_WhenChapterContentIsNullOrEmpty()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var controller = new ChaptersController(mockContext.Object);
            var form = new addChapterForm
            {
                // Set other properties as needed
                ChapterContentHtml = "", // Empty content
                ChapterContentMarkdown = "Chapter content in Markdown",
                StoryId = 1,
                VolumeId = 1,
                ChapterTitle = "Chapter Title",
                ChapterPrice = 0.99m
            };

            // Act
            var result = await controller.AddChapter(form);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Không được để trống nội dung!"
            });
        }
        [Fact]
        public async Task EditChapter_ReturnsSuccess_WhenChapterIsUpdated()
        {
            // Arrange
            var chapterId = 1;
            var form = new UpdateChapterForm
            {
                ChapterId = chapterId,
                ChapterContentHtml = "<p>Updated chapter content in HTML</p>",
                ChapterContentMarkdown = "Updated chapter content in Markdown",
                ChapterTitle = "Updated Chapter Title",
                ChapterPrice = 1.99m // Set the price as needed
            };

            var existingChapter = new Chapter
            {
                ChapterId = chapterId,
                ChapterContentHtml = "<p>Initial chapter content in HTML</p>",
                ChapterContentMarkdown = "Initial chapter content in Markdown",
                ChapterTitle = "Initial Chapter Title",
                ChapterPrice = 0.99m,
                UpdateTime = DateTime.Now.AddDays(-1) // Set an older update time for the existing chapter
            };

            var mockDbSet = new Mock<DbSet<Chapter>>();
            mockDbSet.Setup(m => m.FirstOrDefault(c => c.ChapterId == chapterId)).Returns(existingChapter);

            var mockContext = new Mock<EasyPublishingContext>();
            mockContext.Setup(m => m.Chapters).Returns(mockDbSet.Object);

            var controller = new ChaptersController(mockContext.Object);

            // Act
            var result = await controller.EditChapter(form);

            // Assert
        
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Cập nhật thành công!"
            });
        }

        [Fact]
        public async Task EditChapter_ReturnsError_WhenChapterContentIsNullOrEmpty()
        {
            // Arrange
            var form = new UpdateChapterForm
            {
                ChapterId = 1,
                ChapterContentHtml = "", // Empty content
                ChapterContentMarkdown = "Updated chapter content in Markdown",
                ChapterTitle = "Updated Chapter Title",
                ChapterPrice = 1.99m
            };

            var mockContext = new Mock<EasyPublishingContext>();
            var controller = new ChaptersController(mockContext.Object);

            // Act
            var result = await controller.EditChapter(form);

            // Assert
   
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Không được để trống nội dung chương!"
            });
        }
    }
}
