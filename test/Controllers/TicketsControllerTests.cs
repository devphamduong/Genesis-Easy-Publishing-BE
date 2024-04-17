using app.Controllers;
using app.Models;
using app.Service;
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
using static app.Controllers.TicketsController;

namespace test.Controllers
{
    public class TicketsControllerTests
    {
        [Fact]
        public async Task ApproveRequest_ReturnsSuccess_WhenRequestIsApproved()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var mockMailService = new Mock<MailService>();
            var configuration = A.Fake<IConfiguration>();
            var controller = new TicketsController(mockContext.Object, configuration);
            var data = new InviteForm
            {
                Location = "Interview Location",
                Time = "2024-04-01 10:00:00", // Sample time
                TicketId = 1
            };

            var userId = 1; // Set the user ID as needed

            var user = new User
            {
                UserId = userId,
                RoleId = 1
            };

            var ticket = new Ticket
            {
                TicketId = 1,
                UserId = 2 // Sample user ID
            };

            mockContext.Setup(m => m.Users.Where(u => u.UserId == userId)).Returns(new List<User> { user }.AsQueryable());
            mockContext.Setup(m => m.Tickets.Where(t => t.TicketId == data.TicketId)).Returns(new List<Ticket> { ticket }.AsQueryable());
            mockContext.Setup(m => m.Users.Where(u => u.UserId == ticket.UserId)).Returns(new List<User> { new User { UserId = ticket.UserId, Username = "SampleUser", Email = "sample@example.com" } }.AsQueryable());

            // Act
            var result = await controller.ApproveRequest(data);

            // Assert
       
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Send interview invitations successfully"
            });
        }
        [Fact]
        public async Task ApproveRequest_ReturnsError_WhenUserIsNotAdministrator()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var mockMailService = new Mock<MailService>();
            var configuration = A.Fake<IConfiguration>();
            var controller = new TicketsController(mockContext.Object, configuration);
            var data = new InviteForm
            {
                Location = "Interview Location",
                Time = "2024-04-01 10:00:00", // Sample time
                TicketId = 1
            };

            var userId = 1; // Set the user ID as needed

            var user = new User
            {
                UserId = userId,
                RoleId = 2 // Assuming role ID 2 is not an administrator
            };

            mockContext.Setup(m => m.Users.Where(u => u.UserId == userId)).Returns(new List<User> { user }.AsQueryable());

            // Act
            var result = await controller.ApproveRequest(data);

            // Assert
    
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Not an administrator"
            });
        }
        [Fact]
        public async Task SendRefund_ReturnsSuccess_WhenRefundIsSent()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var mockMailService = new Mock<MailService>();
            var configuration = A.Fake<IConfiguration>();
            var controller = new TicketsController(mockContext.Object, configuration);
            var refund = new Refund
            {
                BankId = "SampleBankId",
                BankAccount = "SampleBankAccount",
                Amount = 150 // Sample refund amount
            };

            var userId = 1; // Set the user ID as needed

            var userWallet = new Wallet
            {
                UserId = userId,
                Refund = 200 // Sample refundable amount
            };

            var refundRequest = new RefundRequest
            {
                WalletId = 1, // Sample WalletId
                BankId = refund.BankId,
                BankAccount = refund.BankAccount,
                Amount = refund.Amount,
                RequestTime = DateTime.Now,
                ResponseTime = null,
                Status = null
            };

            mockContext.Setup(m => m.Wallets.Where(w => w.UserId == userId)).Returns(new List<Wallet> { userWallet }.AsQueryable());
            mockContext.Setup(m => m.RefundRequests.Where(w => w.WalletId == userWallet.WalletId && w.Status == null)).Returns((IQueryable<RefundRequest>)null);

            // Act
            var result = await controller.SendRefund(refund);

            // Assert
   
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Yêu cầu rút tiền của bạn đã được gửi đi!"
            });
        }
        [Fact]
        public async Task ApproveRefund_ReturnsSuccess_WhenRefundIsApproved()
        {
            // Arrange
            var mockContext = new Mock<EasyPublishingContext>();
            var mockMailService = new Mock<MailService>();
            var configuration = A.Fake<IConfiguration>();
            var controller = new TicketsController(mockContext.Object, configuration);

            var userId = 1; // Set the admin user ID as needed

            var admin = new User
            {
                UserId = userId,
                RoleId = 1 // Assuming role ID 1 is an administrator
            };

            var refundRequests = new List<RefundRequest>
            {
                new RefundRequest
                {
                    RequestId = 1,
                    WalletId = 1, // Sample WalletId
                    BankId = "SampleBankId",
                    BankAccount = "SampleBankAccount",
                    Amount = 150, // Sample refund amount
                    RequestTime = DateTime.Now,
                    ResponseTime = null,
                    Status = null
                }
            };

            var userWallet = new Wallet
            {
                WalletId = 1,
                UserId = 2, // Sample user ID
                Refund = 200 // Sample refundable amount
            };

            var adminWallet = new Wallet
            {
                WalletId = 2, // Sample admin WalletId
                Refund = 500 // Sample admin refundable amount
            };

            mockContext.Setup(m => m.Users.Where(u => u.UserId == userId)).Returns(new List<User> { admin }.AsQueryable());
            mockContext.Setup(m => m.RefundRequests.Where(c => c.ResponseTime != null && c.Status == null)).Returns(refundRequests.AsQueryable());

            // Act
            var result = await controller.ApproveRefund();

            // Assert
       
            var jsonResult = Assert.IsType<JsonResult>(result);
            jsonResult.Value.Should().BeEquivalentTo(new
            {
                EC = 0,
                EM = "Phê duyệt rút tiền"
            });
        }
    }
}
