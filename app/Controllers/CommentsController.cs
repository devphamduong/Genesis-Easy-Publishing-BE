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
        public async Task<ActionResult> GetStoryComments(int storyid, int page, int pageSize)
        {
            var comments = await _context.Comments.Where(c => c.StoryId == storyid)
                .Include(c => c.User)
                .Select(c => new
                {
                    UserComment = new { c.User.UserId, c.User.UserFullname, c.User.UserImage },
                    CommentId = c.CommentId,
                    CommentContent = c.CommentContent,
                    CommentDate = c.CommentDate,
                   
                })
                .OrderByDescending(c => c.CommentId)
                .ToListAsync();
            pageSize = pageSize == null ? 10 : pageSize;
            return _msgService.MsgPagingReturn("Bình luận của truyện",
                comments.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, comments.Count);
        }
    }
}
