﻿using app.DTOs;
using app.Models;
using app.Service;
using Azure.Core;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.IdentityModel.Tokens.Jwt;

namespace app.Controllers
{
    [Route("api/v1/tickets")]
    [ApiController]
    public class TicketsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;

        public TicketsController(EasyPublishingContext context, IConfiguration configuration)
        {
            _context = context;
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
            var jwtSecurityToken = new JwtSecurityToken();
            try
            {
                jwtSecurityToken = VerifyToken();
                int userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
                var user = _context.Users.Where(u => u.UserId == userId).FirstOrDefault();
                if (user.Role.RoleId != 0)
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
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Yêu cầu đăng nhập"
                });
            }
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
            if (user.Role.RoleId == 2)
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
    }
}
