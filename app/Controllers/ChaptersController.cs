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

    }
}
