﻿using app.DTOs;
using app.Models;
using app.Service;
using Azure.Core;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using OfficeOpenXml;
using System.Drawing.Printing;
using System.IdentityModel.Tokens.Jwt;

namespace app.Controllers
{
    [Route("api/v1/tickets")]
    [ApiController]
    public class TicketsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MailService mailService = new MailService();
        private MsgService _msgService = new MsgService();
        public TicketsController(EasyPublishingContext context, IConfiguration configuration)
        {
            _context = context;
        }

        public class ApproveForm
        {
            public int TicketId { get; set; }
        }

        private JwtSecurityToken VerifyToken()
        {
            var tokenCookie = Request.Cookies["access_token"];
            var tokenBearer = extractToken();
            var handler = new JwtSecurityTokenHandler();
            var jwtSecurityToken = handler.ReadJwtToken(!String.IsNullOrEmpty(tokenBearer) ? tokenBearer : tokenCookie);
            return jwtSecurityToken;
        }

        private string extractToken()
        {
            if (!String.IsNullOrEmpty(Request.Headers.Authorization) &&
                Request.Headers.Authorization.ToString().Split(' ')[0] == "Bearer" &&
                !String.IsNullOrEmpty(Request.Headers.Authorization.ToString().Split(' ')[1]))
            {
                return Request.Headers.Authorization.ToString().Split(' ')[1];
            }
            return null;
        }
        private int GetUserId()
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }
            return userId;
        }

        [HttpGet("all_ticket")]
        public async Task<ActionResult> GetAllTickets()
        {
            int userId = GetUserId();
            if (userId == 0)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Yêu cầu đăng nhập"
                });
            };
            var user = _context.Users.Where(u => u.UserId == userId).FirstOrDefault();
            if (user.RoleId != 1)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Không có quyền quản trị viên"
                });
            }
            var tickets = await _context.Tickets.Where(t => t.UserId > 0)
           .Include(t => t.User)
           .Select(t => new
           {
               TicketId = t.TicketId,
               Status = t.Status,
               Seen = t.Seen,
               TicketDate = t.TicketDate,
               User = new
               {
                   UserId = t.UserId,
                   Role = t.User.Role.RoleName,
                   Email = t.User.Email,
                   Username = t.User.Username,
                   UserFullname = t.User.UserFullname,
                   Gender = t.User.Gender == true ? "Male" : "Female",
                   Dob = t.User.Dob,
                   Address = t.User.Address,
                   Phone = t.User.Phone,
                   Status = t.User.Status == true ? "Active" : "Inactive",
                   UserImage = t.User.UserImage,
                   DescriptionMarkdown = t.User.DescriptionMarkdown,
                   DescriptionHTML = t.User.DescriptionHtml,
               }
           })
           .OrderByDescending(t => t.TicketDate)
           .ToListAsync();
            return new JsonResult(new
            {
                EC = 0,
                EM = "Tất cả ticket",
                DT = new
                {
                    tickets = tickets
                }
            });
        }

        [HttpPost("send")]
        public async Task<ActionResult> SendRequest()
        {

            int userId = GetUserId();
            if (userId == 0)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Yêu cầu đăng nhập"
                });
            };
            var user = _context.Users.Include(u => u.Role).Where(u => u.UserId == userId).FirstOrDefault();
            if (user.RoleId == 3)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Bạn hiện đã là Reviewer"
                });
            }
            var ticket = _context.Tickets.Where(t => t.UserId == userId).FirstOrDefault();
            if (ticket != null)
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "Hiện đã có 1 yêu cầu của bạn đang chờ xử lý, vui lòng đợi phản hồi từ chúng tôi"
                });
            }
            Ticket newTicket = new Ticket()
            {
                UserId = userId,
                Status = false,
                Seen = false,
                TicketDate = DateTime.Now,
            };
            _context.Tickets.Add(newTicket);
            await _context.SaveChangesAsync();
            return new JsonResult(new
            {
                EC = 0,
                EM = "Gửi yêu cầu trờ thành reviewer thành công, vui lòng chờ phản hồi từ chúng tôi"
            });
        }

        [HttpPost("approve")]
        public async Task<ActionResult> ApproveRequest([FromBody] ApproveForm data)
        {

            int userId = GetUserId();
            if (userId == 0)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Yêu cầu đăng nhập"
                });
            };
            var user = _context.Users.Where(u => u.UserId == userId).FirstOrDefault();
            if (user.RoleId != 1)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Không có quyền quản trị viên"
                });
            }
            var ticket = _context.Tickets.Where(t => t.TicketId == data.TicketId).FirstOrDefault();
            if (ticket.Status == true)
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "Yêu cầu đã được phê duyệt rồi"
                });
            }
            ticket.Status = true;
            var ticketUser = _context.Users.Where(u => u.UserId == ticket.UserId).FirstOrDefault();
            if (ticketUser.RoleId == 3)
            {
                return new JsonResult(new
                {
                    EC = 3,
                    EM = "Người dùng hiện đã là reviewer"
                });
            }
            ticketUser.RoleId = 3;
            try
            {
                mailService.Send(ticketUser.Email,
                        "Easy Publishing: Yêu cầu trở thành reviewer đã được phê duyệt",
                        "<b>Chúc mừng " + ticketUser.Username + ",</b>" +
                        "<p>Bạn đã được phê duyệt trở thành reviewer.</p>");
            }
            catch (Exception ex)
            {
                return new JsonResult(new
                {
                    EC = 4,
                    EM = "Error: " + ex.Message
                });
            }
            await _context.SaveChangesAsync();
            return new JsonResult(new
            {
                EC = 0,
                EM = "Phê duyệt yêu cầu trờ thành reviewer thành công"
            });
        }

        public class Refund
        {
            public string BankId { get; set; }
            public string BankAccount { get; set; }
            public decimal Amount { get; set; }
        }

        [HttpPost("refund_send")]
        public async Task<ActionResult> SendRefund([FromBody] Refund refund)
        {
            int userId = GetUserId();
            if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");

            var user_wallet = await _context.Wallets.Where(w => w.UserId == userId).FirstOrDefaultAsync();
            if (refund.Amount > user_wallet.Refund) return _msgService.MsgActionReturn(-2, "Bạn không đủ số dư!");
            var request_exist = await _context.RefundRequests.Where(w => w.WalletId == user_wallet.WalletId && w.Status == null).FirstOrDefaultAsync();
            if (request_exist != null) return _msgService.MsgActionReturn(-2, "Yêu cầu trước đó của bạn vẫn đang xử lý!");

            _context.Entry<Wallet>(user_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
            RefundRequest request = new RefundRequest()
            {
                WalletId = user_wallet.WalletId,
                BankId = refund.BankId,
                BankAccount = refund.BankAccount,
                Amount = refund.Amount,
                RequestTime = DateTime.Now,
                ResponseTime = null,
                Status = null,
            };
            _context.RefundRequests.Add(request);
            await _context.SaveChangesAsync();
            return _msgService.MsgActionReturn(0, "Yêu cầu rút tiền của bạn đã được gửi đi!");
        }

        [HttpGet("refunds")]
        public async Task<ActionResult> GetAllRefund()
        {
            int userId = GetUserId();
            //if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
            //var admin = _context.Users.Where(u => u.UserId == userId).FirstOrDefault();
            //if (admin.RoleId != 1) return _msgService.MsgActionReturn(-1, "Không có quyền quản trị viên");

            var requests = await _context.RefundRequests.Where(c => c.Status == null)
           .Include(c => c.Wallet).ThenInclude(c => c.User)
           .Select(c => new
           {
               RequestId = c.RequestId,
               UserFullname = c.Wallet.User.UserFullname,
               WalletId = c.WalletId,
               BankId = c.BankId,
               BankAccount = c.BankAccount,
               Amount = c.Amount * 1000,
               RequestTime = c.RequestTime.ToString("yyyy-MM-dd HH:mm:ss"),
               ResponseTime = c.ResponseTime,
           })
           .OrderByDescending(c => c.RequestId).ToListAsync();
            return _msgService.MsgReturn(0, "Yêu cầu rút tiền", requests);
        }

        [HttpGet("refund_export")]
        public async Task<ActionResult> ExportRefunds()
        {
            int userId = GetUserId();
            //if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
            //var admin = _context.Users.Where(u => u.UserId == userId).FirstOrDefault();
            //if (admin.RoleId != 1) return _msgService.MsgActionReturn(-1, "Không có quyền quản trị viên");

            var requests = await _context.RefundRequests
               .Where(c => c.ResponseTime == null && c.Status == null)
               .Include(c => c.Wallet).ThenInclude(c => c.User)
               .OrderByDescending(c => c.RequestId)
               .ToListAsync();

            if (requests.Count() == 0) return _msgService.MsgActionReturn(-2, "Yêu cầu đã được phê duyệt rồi");
            requests.ForEach(request => request.ResponseTime = DateTime.Now);
            _context.RefundRequests.UpdateRange(requests);
            await _context.SaveChangesAsync();

            var ret = requests.Select(c => new
            {
                UserFullname = c.Wallet.User.UserFullname,
                BankId = c.BankId,
                BankAccount = c.BankAccount,
                Amount = ((int)c.Amount * 1000).ToString(),
                RequestTime = c.RequestTime.ToString("yyyy-MM-dd HH:mm:ss"),
                ResponseTime = c.ResponseTime?.ToString("yyyy-MM-dd HH:mm:ss") ?? ""
            }).ToList();

            return _msgService.MsgReturn(0, "Yêu cầu phê duyệt", ret);
        }

        [HttpGet("refund_export2")]
        public async Task<ActionResult> ExportRefunds2()
        {
            int userId = GetUserId();
            //if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
            //var admin = _context.Users.Where(u => u.UserId == userId).FirstOrDefault();
            //if (admin.RoleId != 1) return _msgService.MsgActionReturn(-1, "Không có quyền quản trị viên");

            var requests = await _context.RefundRequests
               .Where(c => c.ResponseTime == null && c.Status == null)
               .Include(c => c.Wallet).ThenInclude(c => c.User)
               .OrderByDescending(c => c.RequestId)
               .ToListAsync();

            if (requests.Count() == 0) return _msgService.MsgActionReturn(-2, "Yêu cầu đã được phê duyệt rồi");
            requests.ForEach(request => request.ResponseTime = DateTime.Now);
            _context.RefundRequests.UpdateRange(requests);
            await _context.SaveChangesAsync();

            var stream = new MemoryStream();

            using (var package = new ExcelPackage(stream))
            {
                var worksheet = package.Workbook.Worksheets.Add("Refund_Request");

                // Headers
                worksheet.Cells[1, 1].Value = "UserFullname";
                worksheet.Cells[1, 2].Value = "BankId";
                worksheet.Cells[1, 3].Value = "BankAccount";
                worksheet.Cells[1, 4].Value = "Amount";
                worksheet.Cells[1, 5].Value = "RequestTime";


                // Data
                for (int i = 0; i < requests.Count; i++)
                {
                    worksheet.Cells[i + 2, 1].Value = requests[i].Wallet.User.UserFullname;
                    worksheet.Cells[i + 2, 2].Value = requests[i].BankId;
                    worksheet.Cells[i + 2, 3].Value = requests[i].BankAccount;
                    worksheet.Cells[i + 2, 4].Value = requests[i].Amount * 1000;
                    worksheet.Cells[i + 2, 5].Value = requests[i].RequestTime.ToString("yyyy-MM-dd HH:mm:ss");
                }
                package.Save();
            }

            stream.Position = 0;
            return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "Refund_Request.xlsx");
        }


        [HttpPut("refund_approve")]
        public async Task<ActionResult> ApproveRefund()
        {

            int userId = GetUserId();
            var admin = _context.Users.Where(u => u.UserId == userId).FirstOrDefault();
            if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
            if (admin.RoleId != 1) return _msgService.MsgActionReturn(-1, "Không có quyền quản trị viên");

            var requests = await _context.RefundRequests.Where(c => c.ResponseTime != null && c.Status == null).ToListAsync();
            if (requests.Count() == 0) return _msgService.MsgActionReturn(-2, "Yêu cầu đã được phê duyệt rồi");

            foreach (var request in requests)
            {
                request.Status = true;
                request.ResponseTime = DateTime.Now;

                var user_wallet = await _context.Wallets.Where(w => w.WalletId == request.WalletId).FirstOrDefaultAsync();
                var user = await _context.Users.Where(c => c.UserId == user_wallet.UserId).FirstOrDefaultAsync();
                var user_transaction = new Transaction
                {
                    WalletId = user_wallet.WalletId,
                    Amount = request.Amount,
                    FundBefore = 0,
                    FundAfter = 0,
                    RefundBefore = user_wallet.Refund,
                    RefundAfter = user_wallet.Refund - request.Amount,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Rút {request.Amount}"
                };
                user_wallet.Refund = user_wallet.Refund - request.Amount;

                var admin_wallet = await _context.Wallets.FirstOrDefaultAsync();
                var admin_transaction = new Transaction
                {
                    WalletId = admin_wallet.WalletId,
                    Amount = request.Amount,
                    FundBefore = 0,
                    FundAfter = 0,
                    RefundBefore = admin_wallet.Refund,
                    RefundAfter = admin_wallet.Refund - request.Amount,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Rút {request.Amount} khỏi hệ thống"
                };
                admin_wallet.Refund = admin_wallet.Refund - request.Amount;

                var name = user.UserFullname == null ? user.Email : user.UserFullname;
                try
                {
                    mailService.Send(user.Email,
                            "Yêu cầu rút tiền của bạn đã được phê duyệt",
                            "<p>Easy Publishing Xin chào <b> " + name + "</b>,</p>" +
                            "<b>Thông tin giao dịch Quý khách vừa thực hiện như sau:</b>" +
                            "<p>Ngân hàng: <b>" + request.BankId + "</b></p>" +
                            "<p>Số thẻ: <b>" + request.BankAccount + "</b></p>" +
                            "<p>Giao dịch: <b>Rút tiền khỏi hệ thống</b> </p>" +
                            "<p>Trạng thái giao dịch: <b>Thành công</b> </p>" +
                            "<p>Số tiền giao dịch: <b>" + (int)request.Amount + " TLT</b></p>" +
                            "<p>Số tiền sau quy đổi: <b>" + (int)request.Amount + ".000đ</b></p>" +
                            "<p>Số tiền giao dịch nhận được: <b>" + (int)(request.Amount * (decimal)0.85) + ".000đ</b></p>" +
                            "<p>Vào lúc: <b>" + DateTime.Now + "</b></p>" +
                            "<p>Cảm ơn bạn đã tin tưởng.</p>");
                }
                catch (Exception ex)
                {
                    return _msgService.MsgActionReturn(-4, "Error: " + ex.Message);
                }

                _context.Entry<RefundRequest>(request).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<Wallet>(user_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<Wallet>(admin_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Transactions.Add(user_transaction);
                _context.Transactions.Add(admin_transaction);
            }

            await _context.SaveChangesAsync();
            return _msgService.MsgActionReturn(0, "Phê duyệt rút tiền");
        }
    }
}
