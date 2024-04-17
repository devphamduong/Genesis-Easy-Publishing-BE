using app.Controllers;
using app.Models;
using app.Service;
using FakeItEasy;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using Microsoft.IdentityModel;

using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static app.Controllers.AuthController;
using Moq;
using Microsoft.EntityFrameworkCore;

namespace Genesis_Easy_Publishing_BE.Tests.Controllers
{

    public class AuthControllerTests 
    {
        private readonly EasyPublishingContext _context;
        private readonly IConfiguration _configuration;
        private readonly Mock<IConfiguration> _configurationMock;
        private readonly Mock<app.Service.HashService> _hashServiceMock;
        private readonly AuthController _controller;

        public AuthControllerTests()
        {
            _context = new  EasyPublishingContext();
            _configuration = A.Fake<IConfiguration>();
            _configurationMock = new Mock<IConfiguration>();
            _hashServiceMock = new Mock<app.Service.HashService>();
            _controller = new AuthController(_context, _configuration);
        }


        [Fact]
        public void Login_MissingParameters_ReturnsBadRequest()
        {
            // Arrange
            var controller = new AuthController(_context, _configuration);
            var data = new LoginForm();

            // Act
            var result =  controller.Login(data);

            // Assert
            result.Should().BeOfType<JsonResult>();
            var jsonResult = (JsonResult)result;
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 1,
                EM = "Vui lòng nhập đủ thông tin yêu cầu",
            });
        }
        [Fact]
        public void AuthController_Login_Missing_Parameter()
        {
            // Arrange
            var controller = new AuthController(_context, _configuration);
            var data = new LoginForm
            {
                EmailOrUsername = "namnnd@gmial.com",
                Password = "123456",
                Remember = true
            };
            // Act
            var result = controller.Login(data);

            // Assert
            result.Should().BeOfType<JsonResult>();
            var jsonResult = (JsonResult)result;
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 2,
                EM = "Thông tin đăng nhập không đúng",
            });
        }
        [Fact]
        public void AuthController_Login_Password_Wrong()
        {
            // Arrange
            var controller = new AuthController(_context, _configuration);
            var data = new LoginForm
            {
                EmailOrUsername = "namnnd@gmial.com",
                Password = "1234567",
                Remember = true
            };

            // Act
            var result = controller.Login(data);

            // Assert
            result.Should().BeOfType<JsonResult>();
            var jsonResult = (JsonResult)result;
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 2,
                EM = "Thông tin đăng nhập không đúng",
            });
        }

        [Fact]
        public void AuthController_Login_Login_Success()
        {
            // Arrange
            var data_test = new JsonResult(new
            {
                EC = 0,
                EM = "Login successfully",
                DT = new
                {
                    user = new
                    {
                        UserId = 4,
                        Email = "Bookie_User2@qa.team",
                        Username = "namnd",
                        UserFullname = "Mary Barisol",
                        Gender = "Male",
                        Dob = "1970-02-16T00:00:00",
                        Address = "F012R",
                        Phone = "7134690959",
                        Status = "Active",
                        UserImage = "eGw6JHeSV2aWhoFS1ZpEWg==;jzeo0Bn2BI78YNzUyLGjDkNoqzW22H9fquxA/86oclA=",
                        DescriptionMarkdown = "Chào mừng bạn đến với *The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo*. The Genesis (hay gọi tắt \\\"EP\\\") là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho *Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online* Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất.",
                        DescriptionHTML = "<p>Chào mừng bạn đến với <strong>The Genesis - Thế Giới Truyện Tiên Hiệp Huyền Ảo</strong>. The Genesis (hay gọi tắt &quot;EP&quot;) là một nền tảng nội dung số trên internet, nơi thành viên có thể tự do xuất bản những nội dung tiếng Việt như: Tiểu thuyết, light novel, truyện ngắn hoặc thơ văn khác. Với những chức năng được cải tiến liên tục, The Genesis sẽ mang lại cho Genesis sẽ mang lại cho <strong>Tác giả sáng tác truyện, Dịch giả đăng truyện và Người đọc truyện online</strong> Genesis sẽ mang lại cho những trải nghiệm tuyệt vời nhất."
                    },
                    access_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI0IiwiZW1haWwiOiJCb29raWVfVXNlcjJAcWEudGVhbSIsInVzZXJuYW1lIjoibmFtbmQiLCJuYmYiOjE3MTI0ODk2NDAsImV4cCI6MTcxMjU3NjA0MCwiaWF0IjoxNzEyNDg5NjQwLCJpc3MiOiJhZG1pbiIsImF1ZCI6InVzZXIifQ.QZMfWqafNNdVA6M2RzKhevUf1he-uiuPVQGq4zqjBlI"
                }

            });

            var controller = new AuthController(_context, _configuration);
            var data = new LoginForm
            {
                EmailOrUsername = "Bookie_User2@qa.team",
                Password = "654321",
                Remember = true
            };
           
            // Act
            var result = controller.Login(data);

            // Assert
            result.Should().BeOfType<JsonResult>();
            var jsonResult = (JsonResult)result;
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Đăng nhập thành công",
                DT = It.IsAny<object>() // You may want to check this more specifically
            });
        }

        [Fact]
        public void AuthController_Login_Acount_Isactive()
        {
            // Arrange
            var controller = new AuthController(_context, _configuration);
            var data = new LoginForm
            {
                EmailOrUsername = "huynq",
                Password = "123456",
                Remember = true
            };

            // Act
            var result = controller.Login(data);

            // Assert
            result.Should().BeOfType<JsonResult>();
            var jsonResult = (JsonResult)result;
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 3,
                EM = "Tài khoản không khả dụng",
            });
        }

        [Fact]
        public void Register_Register_Success()
        {
            // Arrange
            var mockContext = new EasyPublishingContext(); // Replace YourDbContext with the actual name of your DbContext
            var hashService = new Mock<IConfiguration>(); // Replace IHashService with the actual name of your hash service interface
            var controller = new AuthController(_context, _configuration);
           
            var formdata = new RegisterForm
            {
                Email = "nguyennq260620012@gmail.com",
                Username = "nguyennq26",
                Password = "123456",
                ConfirmPassword = "123456"
            };
            // Act
            var result = controller.Register(formdata);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);

            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Đăng ký tài khoản thành công",
            });
        }
        [Fact]
        public void SendMailConfirm_ReturnsSuccess_WhenEmailIsSent()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var mockMailService = new Mock<MailService>();
            var data = new ForgotPasswordForm
            {
                Email = "test@example.com" // Replace with a valid email address
            };

            var user = new User
            {
                Email = data.Email,
                Username = "TestUser" // Replace with a valid username
            };

            mockContext.Setup(m => m.Users.Where(u => u.Email.Equals(data.Email))).Returns(new List<User> { user }.AsQueryable());

            // Act
            var result = _controller.SendMailConfirm(data);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            dynamic jsonData = jsonResult.Value;
            Assert.Equal(0, (int)jsonData.EC);
            Assert.Equal("Chúng tôi đã gửi mail đến tài khoản email đã đăng ký của bạn, vui lòng làm theo hướng dẫn để đặt lại mật khẩu", (string)jsonData.EM);
            mockMailService.Verify(m => m.Send(data.Email, "Easy Publishing: Đặt lại mật khẩu", It.IsAny<string>()), Times.Once);
        }
        [Fact]
        public void ResetPassword_ReturnsSuccess_WhenPasswordIsReset()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var mockMailService = new Mock<MailService>();
            var mockHashService = new Mock<HashService>();
            var data = new ResetPasswordForm
            {
                Token = "sampleJwtToken", // Replace with a valid JWT token
                Password = "newPassword",
                ConfirmPassword = "newPassword"
            };

            var user = new User
            {
                Email = "test@example.com", // Replace with a valid email address
                Username = "TestUser" // Replace with a valid username
            };

            mockContext.Setup(m => m.Users.FirstOrDefault(u => u.Email.Equals(user.Email))).Returns(user);
            mockHashService.Setup(m => m.Hash(data.Password)).Returns("hashedPassword");

            // Act
            var result = _controller.ResetPassword(data);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            dynamic jsonData = jsonResult.Value;
            Assert.Equal(0, (int)jsonData.EC);
            Assert.Equal("Đặt lại mật khẩu thành công", (string)jsonData.EM);
         
        }
        [Fact]
        public void ChangePassword_ReturnsSuccess_WhenPasswordIsChanged()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var mockHashService = new Mock<HashService>();
            var data = new ChangePasswordForm
            {
                OldPassword = "oldPassword",
                Password = "newPassword",
                ConfirmPassword = "newPassword"
            };

            var userId = "1"; // Replace with a valid user ID
            var user = new User
            {
                UserId = int.Parse(userId),
                Password = "oldPasswordHash" // Replace with the hashed old password
            };

            mockContext.Setup(m => m.Users.FirstOrDefault(u => u.UserId == user.UserId)).Returns(user);
            mockHashService.Setup(m => m.Verify(user.Password, data.OldPassword)).Returns(true);
            mockHashService.Setup(m => m.Hash(data.Password)).Returns("newPasswordHash");

            // Act
            var result = _controller.ChangePassword(data);

            // Assert
            var jsonResult = Assert.IsType<JsonResult>(result);
            dynamic jsonData = jsonResult.Value;
            Assert.Equal(0, (int)jsonData.EC);
            Assert.Equal("Đổi mật khẩu thành công", (string)jsonData.EM);
        }
    }
}
