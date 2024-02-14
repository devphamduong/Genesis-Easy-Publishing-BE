using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Drawing.Printing;
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

        [HttpGet("story_detail/{storyid}")]
        public async Task<ActionResult> GetStoryChapters(int storyid, int page)
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
                .ToListAsync();
            return _msgService.MsgPagingReturn("Story Detail Chapter",
                chapters.Skip(pageSize * (page - 1)).Take(pageSize), page, chapters.Count);
        }

        [HttpGet("chapter_detail/{chapterid}")]
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
            return _msgService.MsgReturn("Story Chapter Detail", chapters.FirstOrDefault());
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
            return _msgService.MsgReturn("Story Chapter Relate", chapters);
        }

    }
}
