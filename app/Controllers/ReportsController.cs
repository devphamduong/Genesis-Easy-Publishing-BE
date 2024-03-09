using app.DTOs;
using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.IdentityModel.Tokens.Jwt;

namespace app.Controllers
{
    [Route("api/v1/reports")]
    [ApiController]
    public class ReportsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        public ReportsController(EasyPublishingContext context)
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

        [HttpGet("options")]
        public async Task<ActionResult> GetReportType()
        {
            var types = await _context.ReportTypes.Select(c => new { c.ReportTypeId, c.ReportTypeContent }).ToListAsync();
            return _msgService.MsgReturn(0, "Report Option", types);
        }

        [HttpPost("send")]
        public async Task<ActionResult> SendReport(ReportDTO reportDTO)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Login first");

            if (!ModelState.IsValid) return _msgService.MsgActionReturn(-1, "Lack param");
            ReportContent report = new ReportContent()
            {
                UserId = userId,
                ReportTypeId = reportDTO.ReportTypeId,
                StoryId = reportDTO.StoryId,
                ChapterId = reportDTO.ChapterId,
                CommentId = reportDTO.CommentId,
                ReportContent1 = reportDTO.ReportContent,
                ReportDate = DateTime.UtcNow,
                Status = null,
            };
            _context.ReportContents.Add(report);
            await _context.SaveChangesAsync();
            return _msgService.MsgActionReturn(0, "Report Succes");
        }
    }
}
