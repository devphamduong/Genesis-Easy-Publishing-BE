using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.IdentityModel.Tokens.Jwt;

namespace app.Controllers
{
    [Route("api/v1/reviews")]
    [ApiController]
    public class ReviewsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MailService mailService = new MailService();

        public ReviewsController(EasyPublishingContext context, IConfiguration configuration)
        {
            _context = context;
        }

        public class ReviewFrom
        {
            public int StoryId { get; set; }

            public bool SpellingError { get; set; }

            public bool LengthError { get; set; }

            public bool PoliticalContentError { get; set; }

            public bool DistortHistoryError { get; set; }

            public bool SecretContentError { get; set; }

            public bool OffensiveContentError { get; set; }

            public bool UnhealthyContentError { get; set; }

            public string? ReviewContent { get; set; }
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

        [HttpPost("send")]
        public async Task<ActionResult> SendReview([FromBody] ReviewFrom data)
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
            if (user.RoleId != 3)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Không có quyền Reviewer"
                });
            }
            var story = _context.Stories.Include(s => s.Author).Where(r => r.StoryId == data.StoryId).FirstOrDefault();
            if (story == null)
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "Truyện không tồn tại"
                });
            }
            var review = _context.Reviews.Where(r => r.StoryId == data.StoryId).FirstOrDefault();
            if (review != null)
            {
                return new JsonResult(new
                {
                    EC = 3,
                    EM = "Truyện này đã được review"
                });
            }
            // story status
            bool[] errorList = {
                    data.SpellingError,
                    data.LengthError,
                    data.PoliticalContentError,
                    data.DistortHistoryError,
                    data.SecretContentError,
                    data.OffensiveContentError,
                    data.UnhealthyContentError,
             };
            int storyStatus = 1;
            bool hasError = false;
            foreach (var item in errorList)
            {
                if (item)
                {
                    hasError = true;
                    storyStatus = 0;
                }
            }
            if (hasError && string.IsNullOrEmpty(data.ReviewContent))
            {
                return new JsonResult(new
                {
                    EC = 4,
                    EM = "Yêu cầu nhập nội dung review"
                });
            }
            story.Status = storyStatus;
            // new review
            Review newReview = new Review()
            {
                UserId = userId,
                StoryId = data.StoryId,
                ReviewDate = DateTime.Now,
                SpellingError = data.SpellingError,
                LengthError = data.LengthError,
                PoliticalContentError = data.PoliticalContentError,
                DistortHistoryError = data.DistortHistoryError,
                SecretContentError = data.SecretContentError,
                OffensiveContentError = data.OffensiveContentError,
                UnhealthyContentError = data.UnhealthyContentError,
                ReviewContent = data.ReviewContent
            };
            _context.Reviews.Add(newReview);
            await _context.SaveChangesAsync();
            // send mail
            try
            {
                mailService.Send(story.Author.Email,
                        "Easy Publishing: Truyện của bạn đã được review",
                        "<b>Xin chào " + story.Author.Username + ",</b>" +
                        "<p>Truyện '" + story.StoryTitle + "' của bạn đã được review.</p> " +
                        "<p>Chi tiết vui lòng truy cập:</p> " +
                        "<a href =\"http://localhost:3000\">Xem bản review</a>");
            }
            catch (Exception ex)
            {
                return new JsonResult(new
                {
                    EC = 5,
                    EM = "Error: " + ex.Message
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Gửi review thành công"
            });
        }

        [HttpGet("story_review")]
        public async Task<ActionResult> getStoryReview(int storyId)
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
            var story = _context.Stories.Where(s => s.StoryId == storyId).FirstOrDefault();
            var review = _context.Reviews.Where(r => r.StoryId == storyId)
                .Include(r => r.User)
                .Include(r => r.Story)
                .Select(r => new
                {
                    ReviewDate = r.ReviewDate,
                    SpellingError = r.SpellingError,
                    LengthError = r.LengthError,
                    PoliticalContentError = r.PoliticalContentError,
                    DistortHistoryError = r.DistortHistoryError,
                    SecretContentError = r.SecretContentError,
                    OffensiveContentError = r.OffensiveContentError,
                    UnhealthyContentError = r.UnhealthyContentError,
                    ReviewContent = r.ReviewContent,
                    Reviewer = new
                    {
                        UserId = r.UserId,
                        Email = r.User.Email,
                        Username = r.User.Username,
                        UserFullname = r.User.UserFullname,
                        Gender = r.User.Gender == true ? "Male" : "Female",
                        Dob = r.User.Dob,
                        Address = r.User.Address,
                        Phone = r.User.Phone,
                        Status = r.User.Status == true ? "Active" : "Inactive",
                        UserImage = r.User.UserImage,
                        DescriptionMarkdown = r.User.DescriptionMarkdown,
                        DescriptionHTML = r.User.DescriptionHtml,
                    }
                }).FirstOrDefault();
            if (review == null)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Truyện chưa được review"
                });
            }
            if (story.AuthorId != userId && review.Reviewer.UserId != userId)
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "Bạn không có quyền truy cập"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Thông tin review của truyện",
                DT = new
                {
                    review = review
                }
            });
        }
    }
}