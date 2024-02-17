using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Drawing.Printing;

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

        [HttpGet("story_detail/{storyid}")]
        public async Task<ActionResult> GetStory(int storyid, int page)
        {
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
                .Skip(pageSize * (page - 1)).Take(pageSize)
                .ToListAsync();
            return _msgService.MsgReturn("Story Chapter Detail", chapters);
        }

        [HttpGet("story_volume/{storyid}")]
        public async Task<ActionResult> GetVolume(int storyid)
        {
            var volumes = await _context.Volumes.Where(v => v.StoryId == storyid).ToListAsync();
            return _msgService.MsgReturn("List volume", volumes);
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

        [HttpGet("chapter_content/{chapterid}")]
        public async Task<ActionResult> GetChapter(int chapterid)
        {
            var chapter = _context.Chapters.Where(c => c.ChapterId == chapterid && c.Status > 0)
                .Include(c => c.Story)
                .Select(c => new
                {
                    StoryId =c.Story.StoryId,
                    StoryTitle = c.Story.StoryTitle,
                    Content = c.ChapterContent,
                    ChapterId = c.ChapterId,
                    ChapterTitle = c.ChapterTitle,
                    ChapterPrice = c.ChapterPrice,
                    CreateTime = c.CreateTime
                }).FirstOrDefault();
            if(chapter == null)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Chapter is not available"
                });
            }
            return _msgService.MsgReturn("Chapter content", chapter);
        }

        [HttpGet("next_chapter/{storyId}/{currentChapterId}")]
        public IActionResult NextChapter(int currentChapterId, int storyId)
        {
            var nextChapter = _context.Chapters.Where(c => c.StoryId == storyId && c.ChapterId > currentChapterId && c.Status > 0)
                              .OrderBy(c => c.ChapterId)
                              .Select(c => new
                              {
                                  StoryId = c.Story.StoryId,
                                  StoryTitle = c.Story.StoryTitle,
                                  Content = c.ChapterContent,
                                  ChapterId = c.ChapterId,
                                  ChapterTitle = c.ChapterTitle,
                                  ChapterPrice = c.ChapterPrice,
                                  CreateTime = c.CreateTime
                              }).FirstOrDefault();
            if(nextChapter == null) {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Chapter is not available"
                });
            }
            return _msgService.MsgReturn("Chapter content", nextChapter);
        }

        [HttpGet("previous_chapter/{storyId}/{currentChapterId}")]
        public IActionResult PreviousChapter(int currentChapterId, int storyId)
        {
            var previousChapter = _context.Chapters.Where(c => c.StoryId == storyId && c.ChapterId < currentChapterId && c.Status > 0)
                              .OrderBy(c => c.ChapterId)
                              .Select(c => new
                              {
                                  StoryId = c.Story.StoryId,
                                  StoryTitle = c.Story.StoryTitle,
                                  Content = c.ChapterContent,
                                  ChapterId = c.ChapterId,
                                  ChapterTitle = c.ChapterTitle,
                                  ChapterPrice = c.ChapterPrice,
                                  CreateTime = c.CreateTime
                              }).FirstOrDefault();
            if (previousChapter == null)
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Chapter is not available"
                });
            }
            return _msgService.MsgReturn("Chapter content", previousChapter);
        }
    }
}
