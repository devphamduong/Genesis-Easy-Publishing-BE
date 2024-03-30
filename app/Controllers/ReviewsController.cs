﻿using app.Models;
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
        private MsgService msgService = new MsgService();
        private int pagesize = 10;

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
            if (user.RoleId == 2)
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
            bool hasError = false;
            foreach (var item in errorList)
            {
                if (item)
                {
                    hasError = true;
                    break;
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
            if (hasError)
            {
                story.Status = null;
            }
            story.Status = 1;
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

        [HttpGet("stories_review")]
        public async Task<ActionResult> GetStoriesReview(int page, int pageSize)
        {
            int userId = GetUserId();
            if (userId == 0)
            {
                return msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
            }
            var user = _context.Users.Where(u => u.UserId == userId).FirstOrDefault();
            if (user.RoleId == 2)
            {
                return msgService.MsgActionReturn(1, "Không có quyền Reviewer");
            }
            var stories = await _context.Stories.Where(c => c.Status == 0)
                .Include(c => c.Categories)
                .Include(c => c.Users)
                .Include(c => c.Chapters).ThenInclude(c => c.Users)
                .Include(c => c.StoryInteraction)
                .Select(c => new
                {
                    StoryId = c.StoryId,
                    StoryTitle = c.StoryTitle,
                    StoryImage = c.StoryImage,
                    StoryCreateTime = c.CreateTime,
                    StoryStatus = c.Status,
                    StoryInteraction = new
                    {
                        c.StoryInteraction.Like,
                        c.StoryInteraction.Follow,
                        c.StoryInteraction.View,
                        c.StoryInteraction.Read,
                    },
                    UserPurchaseStory = c.Users.Count,
                    UserPurchaseChapter = c.Chapters.SelectMany(c => c.Users).Count(),
                })
                .ToListAsync();
            page = page == null || page == 0 ? 1 : page;
            pageSize = pageSize == null || pageSize == 0 ? pagesize : pageSize;
            return msgService.MsgPagingReturn("Danh sách truyện cần review",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, stories.Count);
        }

        [HttpGet("stories_review/detail")]
        public async Task<ActionResult> GetVolume(int storyid)
        {
            int userId = GetUserId();
            if (userId == 0)
            {
                return msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
            }
            var user = _context.Users.Where(u => u.UserId == userId).FirstOrDefault();
            if (user.RoleId == 2)
            {
                return msgService.MsgActionReturn(1, "Không có quyền Reviewer");
            }
            var volumes = await _context.Volumes.Where(v => v.StoryId == storyid)
                .Include(v => v.Chapters)
                .Select(v => new
                {
                    volumeId = v.VolumeId,
                    volumeNumber = v.VolumeNumber,
                    VolumeTitle = v.VolumeTitle,
                    StoryId = v.StoryId,
                    CreateTime = v.CreateTime,
                    Chapters = v.Chapters.Where(c => c.Status > 0).Select(c => new
                    {
                        c.ChapterId,
                        c.ChapterNumber,
                        c.ChapterTitle,
                        c.ChapterPrice,
                        c.CreateTime,
                        c.ChapterContentMarkdown,
                        c.ChapterContentHtml,
                    }).OrderBy(c => c.ChapterNumber).ToList()
                }).OrderBy(v => v.volumeNumber)
                .ToListAsync();
            return msgService.MsgReturn(0, "Danh sách các tập của truyện", volumes);
        }

        [HttpGet("review_detail")]
        public async Task<ActionResult> getReviewDetail(int storyId)
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