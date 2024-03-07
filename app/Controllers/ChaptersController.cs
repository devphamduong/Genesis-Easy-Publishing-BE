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
        private int pagesize = 10;
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
        public async Task<ActionResult> GetStoryChapters(int storyid, int page, int pageSize)
        {
            var chapters = await _context.Chapters.Where(c => c.StoryId == storyid && c.Status > 0)
                .Include(c => c.Comments)
                .Include(c => c.Users)
                .Select(c => new
                {
                    ChapterId = c.ChapterId,
                    ChapterNumber = c.ChapterNumber,
                    ChapterTitle = c.ChapterTitle,
                    ChapterPrice = c.ChapterPrice,
                    CreateTime = c.CreateTime,
                    Comment = c.Comments.Count,
                    UserPurchaseChapter = c.Users.Count,
                })
                .OrderByDescending(c => c.ChapterNumber)
                .ToListAsync();
            pageSize = pageSize == null || pageSize == 0 ? pagesize : pageSize;
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
                    ChapterNumber = c.ChapterNumber,
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
                        c.ChapterNumber,
                        c.ChapterTitle,
                        c.ChapterPrice,
                        c.CreateTime

                    }).OrderByDescending(c => c.ChapterNumber).ToList()
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
                long nextChapterNum = _context.Chapters.Where(c => c.StoryId == chapter.StoryId).Select(c=> c.ChapterNumber).DefaultIfEmpty(0).Max()+1;
                chapter.ChapterNumber = nextChapterNum;
                await _context.Chapters.AddAsync(chapter);
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
        private bool checkPurchase(int? userid, long chapterNum, int storyid)
        {
            if (userid == null)
            {
                return false;
            }
            var user = _context.Users.Include(u => u.Chapters).Include(u => u.Stories).FirstOrDefault(u => u.UserId == userid);
            if(user == null)
            {
                return false;
            }
            if (user.Chapters.Any(c => c.ChapterNumber == chapterNum && c.StoryId == storyid) || user.Stories.Any(s => s.StoryId == storyid))
            {
                return true;
            }
            return false;
        }

        [HttpGet("chapter_content/{storyid}/{chapterNumber}")]
        public async Task<ActionResult> GetChapterContent(long chapterNumber, int storyid)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }

            long nextChapterNum = NextChapter(chapterNumber, storyid);

            var chapter = _context.Chapters.Where(c => c.StoryId == storyid && c.ChapterNumber == chapterNumber && c.Status > 0)
                .Include(c => c.Story)
                .Include(c => c.Comments)
                .Select(c => new
                {
                    Story = new { c.StoryId, c.Story.StoryTitle, c.Story.StoryPrice },
                    Content = c.ChapterContent,
                    ChapterId = c.ChapterId,
                    ChapterNumber = c.ChapterNumber,
                    ChapterTitle = c.ChapterTitle,
                    ChapterPrice = c.ChapterPrice,
                    CreateTime = c.CreateTime,
                    UpdateTime = c.UpdateTime,
                    Comment = c.Comments.Count,
                    UserPurchaseChapter = c.Users.Count,
                    NextChapterNumber = nextChapterNum
                }).FirstOrDefault();

            if (chapter == null)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Chapter is not available"
                });
            }
            if (checkPurchase(userId, chapterNumber, storyid) || chapter.ChapterPrice == 0 || chapter.ChapterPrice == null)
            {
                return _msgService.MsgReturn(0, "Chapter content", chapter);
            }
            else
            {
                return new JsonResult(new
                {
                    EC = 2,
                    EM = "You have to Purchase this chapter first",
                    DT = new { chapter , Message = "You have to Purchase this chapter first" }
                });
            }
        }

        private long NextChapter(long currentChapterNumber, int storyid)
        {
            var nextChapter = _context.Chapters.Where(c => c.StoryId == storyid && c.ChapterNumber > currentChapterNumber && c.Status > 0)
                              .OrderBy(c => c.ChapterNumber)
                                .Select(c => new
                                {
                                    ChapterNumber = c.ChapterNumber
                                })
                              .FirstOrDefault();

            if (nextChapter == null)
            {
                return -1;
            }
            return nextChapter.ChapterNumber;
        }        
    }
}
