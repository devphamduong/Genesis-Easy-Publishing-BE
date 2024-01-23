using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace app.Controllers
{
    [Route("api/v1/story")]
    [ApiController]
    public class StoriesController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();

        public StoriesController(EasyPublishingContext context)
        {
            _context = context;
        }

        // GET: api/Stories : top 3 sale story
        [HttpGet("top3")]
        public async Task<ActionResult> GetTop3Stories()
        {
            var stories = await _context.StoryInteractions.OrderByDescending(c => c.View + c.Follow + c.Like)
                .Take(3).Include(c => c.Story)
                .Select(s => new
                {
                    s.StoryId,
                    s.Story.StoryTitle,
                }).ToListAsync();
            return _msgService.MsgReturn("Stories successfully", new { stories_list = stories });
        }

        // GET: api/Stories : top 10 latest story by chapter
        [HttpGet("top10_latest_by_chapter")]
        public async Task<ActionResult> GetTop10LatesttoriesByChapter()
        {
            var stories = await _context.Chapters.Include(c => c.Story)
                .OrderByDescending(c => c.ChapterId).GroupBy(c => c.StoryId)
                .Select(group => new
                {
                    group.First().ChapterId,
                    group.First().StoryId,
                    group.First().Story.StoryTitle
                }).ToListAsync();
            return _msgService.MsgReturn("Stories successfully", new { stories_list = stories.TakeLast(10) });
        }



        // GET: api/Stories : top 8 read story
        [HttpGet("top8_read")]
        public async Task<ActionResult> GetTop8StoriesRead()
        {
            var stories = await _context.StoryInteractions.OrderByDescending(c => c.Read)
                .Take(8).Include(c => c.Story)
                .Select(s => new
                {
                    s.StoryId,
                    s.Story.StoryTitle,
                    s.Story.StoryDescription,
                    s.Read
                }).ToListAsync();
            return _msgService.MsgReturn("Stories successfully", new { stories_list = stories });
        }


        // GET: api/Stories : top 10 latest story
        [HttpGet("top10_latest")]
        public async Task<ActionResult> GetTop10Latesttories()
        {
            var stories = await _context.Stories.Where(c => c.Status == true)
                .OrderByDescending(c => c.StoryId).Take(10).Include(c => c.Chapters)
                .Select(c => new
                {
                    c.StoryId,
                    c.StoryTitle,
                    c.StoryImage,
                    ChapterNumber = c.Chapters.Count
                }).ToListAsync();
            return _msgService.MsgReturn("Stories successfully", new { stories_list = stories });
        }

        // GET: api/Stories : stories of each cate
        [HttpGet("cate_stories")]
        public async Task<ActionResult> GetStoriesFollowCategories()
        {
            var stories = await _context.Categories.Include(c => c.Stories)
                //.ThenInclude(c => c.StoryInteraction)
                .ToListAsync();
            return _msgService.MsgReturn("Stories successfully", new { stories_list = stories });
        }
    }
}
