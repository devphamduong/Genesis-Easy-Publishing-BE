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
using static app.Controllers.StoriesController;

namespace test.Controllers
{
    public class StoriesControllerTests
    {
        [Fact]
        public async Task SaveStory_ReturnsSuccess_WhenStoryIsSaved()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var controller = new StoriesController(mockContext.Object);
            var addStoryForm = new AddStoryForm
            {
                StoryTitle = "Test Story",
                AuthorId = 1,
                StoryDescription = "Test story description",
                StoryDescriptionHtml = "<p>Test story description in HTML</p>",
                StoryDescriptionMarkdown = "Test story description in Markdown",
                CategoryIds = new List<int> { 1, 2, 3 } // Sample category IDs
            };

            var categories = new List<Category>
            {
                new Category { CategoryId = 1, CategoryName = "Category 1" },
                new Category { CategoryId = 2, CategoryName = "Category 2" },
                new Category { CategoryId = 3, CategoryName = "Category 3" }
            };

            var mockDbSet = new Mock<DbSet<Category>>();
            mockDbSet.As<IQueryable<Category>>().Setup(m => m.Provider).Returns(categories.AsQueryable().Provider);
            mockDbSet.As<IQueryable<Category>>().Setup(m => m.Expression).Returns(categories.AsQueryable().Expression);
            mockDbSet.As<IQueryable<Category>>().Setup(m => m.ElementType).Returns(categories.AsQueryable().ElementType);
            mockDbSet.As<IQueryable<Category>>().Setup(m => m.GetEnumerator()).Returns(categories.AsQueryable().GetEnumerator());

            mockContext.Setup(m => m.Categories).Returns(mockDbSet.Object);

            // Act
            var result = await controller.SaveStory(addStoryForm);

            // Assert
           
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Lưu truyện thành công!"
            });
        }
        [Fact]
        public async Task EditStory_ReturnsSuccess_WhenStoryIsUpdated()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var controller = new StoriesController(mockContext.Object);
            var saveStoryForm = new SaveStoryForm
            {
                StoryId = 1,
                StoryTitle = "Updated Story Title",
                StoryPrice = 9.99m,
                StorySale = 5.99m,
                StoryImage = "updated_image.jpg",
                StoryDescription = "Updated story description",
                StoryDescriptionMarkdown = "Updated story description in Markdown",
                StoryDescriptionHtml = "<p>Updated story description in HTML</p>",
                Status = 1, // Set the status as needed
                CategoryIds = new List<int> { 1, 2, 3 } // Sample category IDs
            };

            var userId = 1; // Set the user ID as needed

            var existingStory = new Story
            {
                StoryId = 1,
                AuthorId = userId,
                StoryTitle = "Initial Story Title",
                StoryPrice = 5.99m,
                StorySale = 3.99m,
                StoryImage = "initial_image.jpg",
                StoryDescription = "Initial story description",
                StoryDescriptionMarkdown = "Initial story description in Markdown",
                StoryDescriptionHtml = "<p>Initial story description in HTML</p>",
                Status = 0,
                Categories = new List<Category>
                {
                    new Category { CategoryId = 1, CategoryName = "Category 1" },
                    new Category { CategoryId = 2, CategoryName = "Category 2" }
                }
            };

            var mockDbSet = new Mock<DbSet<Story>>();
            mockDbSet.Setup(m => m.FirstOrDefault(s => s.StoryId == saveStoryForm.StoryId && s.AuthorId == userId)).Returns(existingStory);

            mockContext.Setup(m => m.Stories).Returns(mockDbSet.Object);
            mockContext.Setup(m => m.Categories.FindAsync(It.IsAny<int>())).ReturnsAsync(new Category { CategoryId = 3, CategoryName = "Category 3" });

            // Act
            var result = await controller.EditStory(saveStoryForm);

            // Assert
      
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Cập nhật truyện thành công!"
            });
        }
        [Fact]
        public async Task DeleteStory_ReturnsSuccess_WhenStoryIsDeleted()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var controller = new StoriesController(mockContext.Object);
            var storyId = 1;
            var userId = 1; // Set the user ID as needed

            var existingStory = new Story
            {
                StoryId = storyId,
                AuthorId = userId,
                Status = 0
            };

            var mockDbSet = new Mock<DbSet<Story>>();
            mockDbSet.Setup(m => m.FirstOrDefault(s => s.StoryId == storyId && s.AuthorId == userId)).Returns(existingStory);

            mockContext.Setup(m => m.Stories).Returns(mockDbSet.Object);

            // Act
            var result = await controller.DeleteStory(storyId);

            // Assert
          
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Xóa truyện thành công"
            });
        }

        [Fact]
        public async Task DeleteStory_ReturnsError_WhenStoryIsNotFound()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var controller = new StoriesController(mockContext.Object);
            var storyId = 1;
            var userId = 1; // Set the user ID as needed

            var mockDbSet = new Mock<DbSet<Story>>();
            mockDbSet.Setup(m => m.FirstOrDefault(s => s.StoryId == storyId && s.AuthorId == userId)).Returns((Story)null);

            mockContext.Setup(m => m.Stories).Returns(mockDbSet.Object);

            // Act
            var result = await controller.DeleteStory(storyId);

            // Assert

            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Bạn không có quyền dùng chức năng này"
            });
        }
    }
}
