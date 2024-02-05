using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace app.Controllers
{
    [Route("api/v1/authors")]
    [ApiController]
    public class AuthorsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        private int pageSize = 10;
        public AuthorsController(EasyPublishingContext context)
        {
            _context = context;
        }

        //[HttpGet("story_detail/{storyid}")]
        //public async Task<ActionResult> GetStoryRelateAuthor(int storyid)
        //{
        //    var 

        //    var chapters = await _context.Stories.Where(c => c.StoryId == storyid && c.Status > 0)
        //        .Include(c => c.Author)
        //        .Include(c => c.Users)
        //        .Select(c => c.Author)
        //        .OrderByDescending(c => c.ChapterId)
        //        .Skip(pageSize * (page - 1)).Take(pageSize)
        //        .ToListAsync();
        //    return _msgService.MsgReturn("Story Chapter Detail", chapters);
        //}
    }
}
