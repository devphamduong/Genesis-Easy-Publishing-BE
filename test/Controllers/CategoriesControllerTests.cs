using app.Controllers;
using app.Models;
using FakeItEasy;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static app.Controllers.AuthController;
using static app.Controllers.CategoriesController;

namespace test.Controllers
{
    public class CategoriesControllerTests
    {
        private readonly Mock<EasyPublishingContext> _contextMock = new Mock<EasyPublishingContext>();
        private readonly CategoriesController _controller;

        public CategoriesControllerTests()
        {
            _controller = new CategoriesController(_contextMock.Object);

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
        public async Task AddCategory_WhenCategoryNameIsEmpty_ShouldReturnError()
        {
            // Arrange
            var categoryForm = new addCategoryForm { CategoryName = "", CategoryBanner = "Banner", CategoryDescription = "Description" };

            // Act
            var result = await _controller.addCategory(categoryForm);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Tên thể loại không được để trống",
            });
        }

        [Fact]
        public async Task AddCategory_WhenCategoryAlreadyExists_ShouldReturnError()
        {
            // Arrange
            var categoryName = "mangua";
            var existingCategory = new Category { CategoryName = categoryName };

            var categoryForm = new addCategoryForm
            {
                CategoryName = categoryName,
                CategoryBanner = "banner.jpg",
                CategoryDescription = "This is a test category."
            };
            _contextMock.Setup(m => m.Categories)
                  .Returns(CreateMockDbSet(new List<Category> { existingCategory }));


            // Act
            var result = await _controller.addCategory(categoryForm);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = -1,
                EM = "Thể loại đã tồn tại",
            });
        }

        [Fact]
        public async Task AddCategory_WhenCategoryDoesNotExist_ShouldAddCategorySuccessfully()
        {
            // Arrange
            var category = new addCategoryForm
            {
                CategoryName = "Test Category",
                CategoryBanner = "banner.jpg",
                CategoryDescription = "This is a test category."
            };
            _contextMock.Setup(m => m.Categories)
                  .Returns(CreateMockDbSet(new List<Category> {  }));
            // Act
            var result = await _controller.addCategory(category);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Thêm thể loại thành công",
            });
        }

    }


}
