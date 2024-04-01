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

        public class ReviewForm
        {
            public int ChapterId { get; set; }

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
        public async Task<ActionResult> SendReview([FromBody] ReviewForm data)
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
            var chapter = _context.Chapters.Where(c => c.ChapterId == data.ChapterId).FirstOrDefault();
            if (chapter == null)
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "Chương không tồn tại"
                });
            }
            var story = _context.Stories.Include(s => s.Author).Where(r => r.StoryId == chapter.StoryId).FirstOrDefault();
            if (story == null)
            {
                return new JsonResult(new
                {
                    EC = 3,
                    EM = "Truyện của chương không tồn tại"
                });
            }
            var review = _context.Reviews.Where(r => r.ChapterId == data.ChapterId).FirstOrDefault();
            if (review != null)
            {
                return new JsonResult(new
                {
                    EC = 4,
                    EM = "Chương này đã được review"
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
                    EC = 5,
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
                ChapterId = data.ChapterId,
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
                        "<p>Xin chào <b>" + story.Author.Username + "</b>,</p>" +
                        "<p>Chương <b>" + chapter.ChapterTitle + "</b> của Truyện <b>" + story.StoryTitle + "</b> của bạn đã được review.</p> " +
                        "<p>Chi tiết vui lòng truy cập:</p> " +
                        "<a href =\"http://localhost:3000\">Xem bản review</a>");
            }
            catch (Exception ex)
            {
                return new JsonResult(new
                {
                    EC = 6,
                    EM = "Error: " + ex.Message
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Gửi review thành công"
            });
        }

        [HttpGet("review_detail")]
        public async Task<ActionResult> getReviewDetail(int chapterId)
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
            var chapter = _context.Chapters.Where(c => c.ChapterId == chapterId).FirstOrDefault();
            if (chapter == null)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Chương không tồn tại"
                });
            }
            var story = _context.Stories.Include(s => s.Author).Where(r => r.StoryId == chapter.StoryId).FirstOrDefault();
            if (story == null)
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "Truyện của chương không tồn tại"
                });
            }
            var review = _context.Reviews.Where(r => r.ChapterId == chapterId)
                .Include(r => r.User)
                .Include(r => r.Chapter)
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
                    Chapters = new
                    {
                        r.Chapter.ChapterId,
                        r.Chapter.ChapterNumber,
                        r.Chapter.ChapterTitle,
                        r.Chapter.ChapterPrice,
                        r.Chapter.CreateTime,
                        r.Chapter.ChapterContentMarkdown,
                        r.Chapter.ChapterContentHtml
                    },
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
                    EC = 3,
                    EM = "Chương chưa được review"
                });
            }
            if (story.AuthorId != userId && review.Reviewer.UserId != userId)
            {
                return new JsonResult(new
                {
                    EC = 4,
                    EM = "Bạn không có quyền truy cập"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Thông tin review của chương",
                DT = new
                {
                    review = review
                }
            });
        }

        [HttpGet("story_list")]
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
            var stories = await _context.Stories
                .Include(s => s.Categories)
                .Include(s => s.Users)
                .Include(s => s.Chapters).ThenInclude(c => c.Users)
                .Include(s => s.StoryInteraction)
                .Where(s => s.Chapters.Any(c => c.Status == 0))
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryCreateTime = s.CreateTime,
                    StoryStatus = s.Status,
                    StoryInteraction = new
                    {
                        s.StoryInteraction.Like,
                        s.StoryInteraction.Follow,
                        s.StoryInteraction.View,
                        s.StoryInteraction.Read,
                    },
                    UserPurchaseStory = s.Users.Count,
                    UserPurchaseChapter = s.Chapters.SelectMany(c => c.Users).Count(),
                })
                .ToListAsync();
            page = page == null || page == 0 ? 1 : page;
            pageSize = pageSize == null || pageSize == 0 ? pagesize : pageSize;
            return msgService.MsgPagingReturn("Danh sách truyện có chương cần review",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, stories.Count);
        }

        [HttpGet("volume_list")]
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
            var volumes = await _context.Volumes.Where(v => v.StoryId == storyid && v.Chapters.Any(c => c.Status == 0))
                .Include(v => v.Chapters)
                .Select(v => new
                {
                    volumeId = v.VolumeId,
                    volumeNumber = v.VolumeNumber,
                    VolumeTitle = v.VolumeTitle,
                    StoryId = v.StoryId,
                    CreateTime = v.CreateTime,
                    Chapters = v.Chapters.Where(c => c.Status == 0).Select(c => new
                    {
                        c.ChapterId,
                        c.Status,
                        c.ChapterNumber,
                        c.ChapterTitle,
                        c.ChapterPrice,
                        c.CreateTime,
                    }).OrderBy(c => c.ChapterNumber).ToList()
                }).OrderBy(v => v.volumeNumber)
                .ToListAsync();
            if (volumes.Count() == 0)
            {
                return msgService.MsgActionReturn(2, "Không có tập chứa chương cần review");
            }
            return msgService.MsgReturn(0, "Danh sách các tập của truyện", volumes);
        }

        [HttpGet("chapter_information")]
        public async Task<ActionResult> GetChapterInfor(int chapterId)
        {
            int userId = GetUserId();
            if (userId == 0)
            {
                return msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
            }
            var user = _context.Users.Include(u => u.Chapters).Include(u => u.Stories).FirstOrDefault(u => u.UserId == userId);
            if (user.RoleId == 2)
            {
                return msgService.MsgActionReturn(1, "Không có quyền Reviewer");
            }

            var chapter = _context.Chapters.Where(c => c.ChapterId == chapterId).Select(c => new
            {
                chapterId = c.ChapterId,
                chapterStatus = c.Status,
                storyId = c.Story.StoryId,
                storyTitle = c.Story.StoryTitle,
                ChapterTitle = c.ChapterTitle,
                chapterContentHtml = c.ChapterContentHtml,
                ChapterContentMarkdown = c.ChapterContentMarkdown,
                ChapterNumber = c.ChapterNumber,
                volumeId = c.VolumeId,
                chapterPrice = c.ChapterPrice,

            }).FirstOrDefault();
            if (chapter == null)
            {
                return msgService.MsgActionReturn(3, "Chương không tồn tại");
            }
            if (chapter.chapterStatus != 0)
            {
                return msgService.MsgActionReturn(4, "Chương đã được review");
            }
            return msgService.MsgReturn(0, "Thông tin chương", chapter);
        }
    }
}