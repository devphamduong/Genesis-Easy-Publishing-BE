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
                .Include(c => c.CommentResponses).ThenInclude(c => c.User)
                .Select(c => new
                {
                    UserComment = new { c.User.UserId, c.User.UserFullname, c.User.UserImage },
                    CommentId = c.CommentId,
                    CommentContent = c.CommentContent,
                    CommentDate = c.CommentDate,
                    CommentResponse = c.CommentResponses.Select(s => new
                    {
                        UserComment = new { s.User.UserId, s.User.UserFullname, s.User.UserImage },
                        s.CommentResponseId,
                        s.CommentId,
                        s.CommentContent,
                        s.CommentDate,
                    }).ToList()
                })
                .OrderByDescending(c => c.CommentId)
                .ToListAsync();
            pageSize = pageSize == null ? 10 : pageSize;
            return _msgService.MsgPagingReturn("Story Detail Comments",
                comments.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, comments.Count);
        }
    }
}
