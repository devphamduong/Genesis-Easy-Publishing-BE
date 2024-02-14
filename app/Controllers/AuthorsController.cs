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

        [HttpGet("story_detail/{authorid}")]
        public async Task<ActionResult> GetStoryRelateAuthor(int authorid)
        {

            var author = await _context.Users.Where(c => c.UserId == authorid)
                .Include(c => c.Stories)
                .Select(c => new
                {
                    AuthorId = c.UserId,
                    AuthorName = c.UserFullname,
                    AuthorImage = c.UserImage,
                    AuthorStories = c.Stories.Count,
                    AuthorNewestStory = c.Stories.Where(c => c.AuthorId == authorid).OrderByDescending(c => c.StoryId)
                    .Select(s => new { s.StoryId, s.StoryTitle, s.StoryImage, s.StoryDescription })
                    .FirstOrDefault()
                })
                .ToListAsync();
            return _msgService.MsgReturn("Story Detail Author Relate", author.FirstOrDefault());
        }
    }
}
