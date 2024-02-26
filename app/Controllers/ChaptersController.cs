using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Drawing.Printing;
using System.IdentityModel.Tokens.Jwt;
using System.Xml.Linq;

namespace app.Controllers
{
    [Route("api/v1/chapters")]
    [ApiController]
    public class ChaptersController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        private int pageSize = 10;
        public ChaptersController(EasyPublishingContext context)
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

        [HttpGet("story_detail")]
        public async Task<ActionResult> GetStoryChapters(int storyid, int page)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }
            //if (userId==0) return 


            var chapters = await _context.Chapters.Where(c => c.StoryId == storyid && c.Status > 0)
                .Include(c => c.Comments)
                .Include(c => c.Users)
                .Select(c => new
                {
                    ChapterId = c.ChapterId,
                    ChapterTitle = c.ChapterTitle,
                    ChapterPrice = c.ChapterPrice,
                    CreateTime = c.CreateTime,
                    Comment = c.Comments.Count,
                    UserPurchaseChapter = c.Users.Count,
                })
                .OrderByDescending(c => c.ChapterId)
                .ToListAsync();
            return _msgService.MsgPagingReturn("Story Detail Chapter",
                chapters.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, chapters.Count);
        }

        [HttpGet("chapter_detail")]
        public async Task<ActionResult> GetChapter(int chapterid)
        {
            var chapters = await _context.Chapters.Where(c => c.ChapterId == chapterid && c.Status > 0)
                .Include(c => c.Story)
                .Include(c => c.Comments)
                .Select(c => new
                {
                    Story = new { c.StoryId, c.Story.StoryTitle },
                    ChapterId = c.ChapterId,
                    ChapterTitle = c.ChapterTitle,
                    ChapterPrice = c.ChapterPrice,
                    CreateTime = c.CreateTime,
                    UpdateTime = c.UpdateTime,
                    Comment = c.Comments.Count,
                    UserPurchaseChapter = c.Users.Count,
                })
                .ToListAsync();
            return _msgService.MsgReturn(0, "Story Chapter Detail", chapters.FirstOrDefault());
        }

        [HttpGet("chapter_detail/taskbar")]
        public async Task<ActionResult> GetChapterRelated(int chapterid, int storyid)
        {
            var chapters = await _context.Chapters.Where(c => c.ChapterId != chapterid && c.Status > 0 && c.StoryId == storyid)
                .Select(c => new
                {
                    ChapterId = c.ChapterId,
                    ChapterTitle = c.ChapterTitle,
                })
                .OrderBy(c => c.ChapterId).Take(2)
                .ToListAsync();
            return _msgService.MsgReturn(0, "Story Chapter Relate", chapters);
        }
        [HttpGet("story_volume/{storyid}")]
        public async Task<ActionResult> GetVolume(int storyid)
        {
            var volumes = await _context.Volumes.Where(v => v.StoryId == storyid)
                .Include(v => v.Chapters)
                .Select(v => new
                {
                    volumeId = v.VolumeId,
                    VolumeTitle = v.VolumeTitle,
                    StoryId = v.StoryId,
                    Chapters = v.Chapters.Where(c => c.Status > 0).Select(c => new
                    {
                        c.ChapterId,
                        c.ChapterTitle,
                        c.ChapterPrice,
                        c.CreateTime

                    }).OrderByDescending(c => c.ChapterId).ToList()
                })
                .ToListAsync();
            return _msgService.MsgReturn(0, "List volume", volumes);
        }

        [HttpPost("add_chapter")]
        public async Task<ActionResult> AddChapter(Chapter chapter)
        {
            chapter.CreateTime = DateTime.Now;
            chapter.Status = 1;
            try
            {
                _context.Chapters.Add(chapter);
                _context.SaveChanges();
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Can't add chapter"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Add chapter successfully"
            });
        }

        [HttpPut("edit_chapter")]
        public async Task<ActionResult> EditChapter(Chapter chapter)
        {
            chapter.UpdateTime = DateTime.Now;
            try
            {
                _context.Entry<Chapter>(chapter).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.SaveChanges();
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Edit Fail"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Save chapter successfully"
            });
        }
        private bool checkPurchase(int? userid, long chapterid, int storyid)
        {
            if (userid == null)
            {
                return false;
            }
            var user = _context.Users.Include(u => u.Chapters).Include(u => u.Stories).FirstOrDefault(u => u.UserId == userid);
            if (user.Chapters.Any(c => c.ChapterId == chapterid) || user.Stories.Any(s => s.StoryId == storyid))
            {
                return true;
            }
            return false;
        }

        [HttpGet("chapter_content/{storyid}/{chapterid}")]
        public async Task<ActionResult> GetChapterContent(long chapterid, int storyid)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }

            var chapter = _context.Chapters.Where(c => c.ChapterId == chapterid && c.Status > 0)
                .Include(c => c.Story)
                .Include(c => c.Comments)
                .Select(c => new
                {
                    Story = new { c.StoryId, c.Story.StoryTitle },
                    Content = c.ChapterContent,
                    ChapterId = c.ChapterId,
                    ChapterTitle = c.ChapterTitle,
                    ChapterPrice = c.ChapterPrice,
                    CreateTime = c.CreateTime,
                    UpdateTime = c.UpdateTime,
                    Comment = c.Comments.Count,
                    UserPurchaseChapter = c.Users.Count,
                }).FirstOrDefault();
            if (chapter == null)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Chapter is not available"
                });
            }
            if (checkPurchase(userId, chapterid, storyid) || chapter.ChapterPrice == 0 || chapter.ChapterPrice == null)
            {
                return _msgService.MsgReturn(0, "Chapter content", chapter);
            }
            else
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "You have to Purchase this chapter first",
                    DT = chapter
                });
            }
        }

        [HttpGet("next_chapter/{storyid}/{currentChapterId}")]
        public IActionResult NextChapter(long currentChapterId, int storyid, int? userid)
        {
            var nextChapter = _context.Chapters.Where(c => c.StoryId == storyid && c.ChapterId > currentChapterId && c.Status > 0)
                              .OrderBy(c => c.ChapterId)
                              .Include(c => c.Story)
                                .Select(c => new
                                {
                                    StoryId = c.Story.StoryId,
                                    StoryTitle = c.Story.StoryTitle,
                                    Content = c.ChapterContent,
                                    ChapterId = c.ChapterId,
                                    ChapterTitle = c.ChapterTitle,
                                    ChapterPrice = c.ChapterPrice,
                                    CreateTime = c.CreateTime
                                })
                              .FirstOrDefault();

            if (nextChapter == null)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Chapter is not available"
                });
            }
            if (checkPurchase(userid, nextChapter.ChapterId, storyid) || nextChapter.ChapterPrice == 0 || nextChapter.ChapterPrice == null)
            {
                return _msgService.MsgReturn(0, "Chapter content", nextChapter);
            }
            else
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "You have to Purchase this chapter first",
                    DT = nextChapter
                });
            }

        }

        [HttpGet("previous_chapter/{storyid}/{currentChapterId}")]
        public IActionResult PreviousChapter(int currentChapterId, int storyid, int userid)
        {
            var previousChapter = _context.Chapters.Where(c => c.StoryId == storyid && c.ChapterId < currentChapterId && c.Status > 0)
                              .OrderBy(c => c.ChapterId)
                              .Include(c => c.Story)
                                .Select(c => new
                                {
                                    StoryId = c.Story.StoryId,
                                    StoryTitle = c.Story.StoryTitle,
                                    Content = c.ChapterContent,
                                    ChapterId = c.ChapterId,
                                    ChapterTitle = c.ChapterTitle,
                                    ChapterPrice = c.ChapterPrice,
                                    CreateTime = c.CreateTime
                                })
                              .FirstOrDefault();

            if (previousChapter == null)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Chapter is not available"
                });
            }
            if (checkPurchase(userid, previousChapter.ChapterId, storyid) || previousChapter.ChapterPrice == 0 || previousChapter.ChapterPrice == null)
            {
                return _msgService.MsgReturn(0, "Chapter content", previousChapter);
            }
            else
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "You have to Purchase this chapter first",
                    DT = previousChapter
                });
            }
        }

    }
}
