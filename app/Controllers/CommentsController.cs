using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace app.Controllers
{
    [Route("api/v1/comments")]
    [ApiController]
    public class CommentsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        //private int pageSize = 10;
        public CommentsController(EasyPublishingContext context)
        {
            _context = context;
        }

        [HttpGet("story_detail")]
        public async Task<ActionResult> GetStoryComments(int storyid, int page, int pagesize)
        {
            var comments = await _context.Comments.Where(c => c.StoryId == storyid)
                .Include(c => c.User)
                .Select(c => new
                {
                    CommentId = c.CommentId,
                    CommentContent = c.CommentContent,
                    CommentDate = c.CommentDate,
                    UserComment = new { c.User.UserId, c.User.UserFullname, c.User.UserImage },
                })
                .OrderByDescending(c => c.CommentId)
                .ToListAsync();
            pagesize = pagesize == null ? 10 : pagesize;
            return _msgService.MsgPagingReturn("Story Detail Comments",
                comments.Skip(pagesize * (page - 1)).Take(pagesize), page, comments.Count);
        }
    }
}
