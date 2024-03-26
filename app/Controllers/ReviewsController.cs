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
        private TokenService tokenService = new TokenService();

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

        [HttpPost("send")]
        public async Task<ActionResult> SendReview([FromBody] ReviewFrom data)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            try
            {
                jwtSecurityToken = tokenService.VerifyToken();
                int userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
                var user = _context.Users.Where(u => u.UserId == userId).FirstOrDefault();
                if (user.Role.RoleId != 2)
                {
                    return new JsonResult(new
                    {
                        EC = 1,
                        EM = "Không có quyền Reviewer"
                    });
                }
                var review = _context.Reviews.Where(r => r.UserId == userId && r.StoryId == data.StoryId).FirstOrDefault();
                if (review != null)
                {
                    return new JsonResult(new
                    {
                        EC = 2,
                        EM = "Bạn đã review truyện này rồi"
                    });
                }
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
                return new JsonResult(new
                {
                    EC = 0,
                    EM = "Gửi review thành công"
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

        [HttpGet("story_review")]
        public async Task<ActionResult> getStoryReview(int storyId)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            try
            {
                jwtSecurityToken = tokenService.VerifyToken();
                int userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
                var user = _context.Users.Where(u => u.UserId == userId).FirstOrDefault();
                var review = _context.Reviews.Where(r => r.StoryId == storyId && r.Story.AuthorId == userId)
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
                        EM = "Không thể truy cập"
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
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Yêu cầu đăng nhập"
                });
            }
        }
    }
}