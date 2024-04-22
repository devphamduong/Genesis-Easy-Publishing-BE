using app.DTOs;
using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.Globalization;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.RegularExpressions;

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

        [HttpGet("options")]
        public async Task<ActionResult> GetReportType()
        {
            var types = await _context.ReportTypes.Select(c => new { c.ReportTypeId, c.ReportTypeContent }).ToListAsync();
            return _msgService.MsgReturn(0, "Các loại báo cáo", types);
        }

        [HttpGet("all_report")]
        public async Task<ActionResult> GetAllReports()
        {
            var reports = await _context.ReportContents
                .Include(r => r.ReportType)
                .Include(r=>r.Chapter)
                .Include(r=>r.Story)
                .Include(r=>r.Comment)
                .Include(r=>r.User)
                .Select(r=> new
                {
                    ReportId = r.ReportId,
                    UserName = r.User.Username,
                    ReportTypeContent = r.ReportType.ReportTypeContent,
                    ChapterTitle = r.Chapter.ChapterTitle,
                    Link = FormatLink(r.Story.StoryId, r.Story.StoryTitle != null ? r.Story.StoryTitle : null, r.Chapter != null ? r.Chapter.ChapterNumber : 0),
                    StoryTitle = r.Story.StoryTitle,
                    CommentContent = r.Comment.CommentContent,
                    CommentId = r.CommentId,
                    ReportContent1 = r.ReportContent1,
                    ReportDate = r.ReportDate,
                    Status = (r.Status == null || r.Status == false) ? "Unsolved": "Resolved"
                })
                .ToListAsync();
            return _msgService.MsgReturn(0, "Thể loại tố cáo", reports);
        }

        private static string FormatLink(int? storyId, string storyTitle, long chapterNumber)
        {
            if(storyTitle == null)
            {
                return null;
            }
            storyTitle = Regex.Replace(storyTitle, @"\s+", " ").Trim();

            string cleanedName = string.Concat(storyTitle.Where(c => char.IsLetterOrDigit(c) || char.IsWhiteSpace(c)));

            cleanedName = cleanedName.ToLower();

            cleanedName = cleanedName.Replace(" ", "-");
            cleanedName = RemoveDiacritics(cleanedName);
            if(chapterNumber != 0)
            {
                return "https://genesis-easy-publishing.vercel.app/story/read/"+storyId+"/" + cleanedName+".chapter-"+chapterNumber;
            }
            else
            {
                return "https://genesis-easy-publishing.vercel.app/story/detail/" + storyId + "/" + cleanedName;
            }
        }

        private static string RemoveDiacritics(string input)
        {
            string normalizedString = input.Normalize(NormalizationForm.FormD);
            StringBuilder stringBuilder = new StringBuilder();

            foreach (char c in normalizedString)
            {
                if (CharUnicodeInfo.GetUnicodeCategory(c) != UnicodeCategory.NonSpacingMark)
                {
                    stringBuilder.Append(c);
                }
            }

            return stringBuilder.ToString().Normalize(NormalizationForm.FormC);
        }

        [HttpGet("report/{id}")]
        public async Task<ActionResult> GetReport(int id)
        {
            var reports = await _context.ReportContents.Where(r=>r.ReportId == id)
                .Include(r => r.ReportType)
                .Include(r => r.Chapter)
                .Include(r => r.Story)
                .Include(r => r.Comment)
                .Include(r => r.User)
                .Select(r => new
                {
                    ReportId = r.ReportId,
                    UserName = r.User.Username,
                    ReportTypeContent = r.ReportType.ReportTypeContent,
                    ChapterTitle = r.Chapter.ChapterTitle,
                    StoryTitle = r.Story.StoryTitle,
                    CommentContent = r.Comment.CommentContent,
                    ReportContent1 = r.ReportContent1,
                    ReportDate = r.ReportDate,
                    Status = r.Status
                })
                .FirstOrDefaultAsync();
            return _msgService.MsgReturn(0, "Get Report", reports);
        }

        [HttpPost("send")]
        public async Task<ActionResult> SendReport(ReportDTO reportDTO)
        {
            int userId = GetUserId();

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");

            if (!ModelState.IsValid) return _msgService.MsgActionReturn(-1, "Thiếu điều kiện");
            try
            {
                ReportContent report = new ReportContent()
                {
                    UserId = userId,
                    ReportTypeId = reportDTO.ReportTypeId,
                    StoryId = reportDTO.StoryId,
                    ChapterId = reportDTO.ChapterId,
                    CommentId = reportDTO.CommentId,
                    ReportContent1 = reportDTO.ReportContent,
                    ReportDate = DateTime.Now,
                    Status = false,
                };
                _context.ReportContents.Add(report);
                await _context.SaveChangesAsync();
            }
            catch(Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
            
            return _msgService.MsgActionReturn(0, "Báo cáo thành công");
        }

        [HttpPut("resolveReport")]
        public async Task<ActionResult> SwitchStatus(int id)
        {
            var report = await _context.ReportContents.FirstOrDefaultAsync(r => r.ReportId == id);
            string msg = "Resolved report successfully!";
            try
            {
                if(report.Status == null || report.Status == false)
                {
                    report.Status = true;
                }
                else
                {
                    msg = "Unsolved report successfully!";
                    report.Status = false;
                }
                _context.Entry(report).State = EntityState.Modified;
                await _context.SaveChangesAsync();
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = msg
            });
        }
    }
}
