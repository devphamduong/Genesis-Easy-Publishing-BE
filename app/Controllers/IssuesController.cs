using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace app.Controllers
{
    [Route("api/v1/issues")]
    [ApiController]
    public class IssuesController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        private int pageSize = 10;
        public IssuesController(EasyPublishingContext context)
        {
            _context = context;
        }

        [HttpGet("story_detail")]
        public async Task<ActionResult> GetStoryIssues(int storyid, int page)
        {
            var comments = await _context.StoryIssues.Where(c => c.StoryId == storyid)
                .Include(c => c.User)
                .Select(c => new
                {
                    IssueId = c.IssueId,
                    IssueTitle = c.IssueTitle,
                    IssueContent = c.IssueContent,
                    IssueDate = c.IssueDate,
                    UserComment = new { c.User.UserId, c.User.UserFullname, c.User.UserImage },
                })
                .OrderByDescending(c => c.IssueId)
                .ToListAsync();
            return _msgService.MsgPagingReturn("Story Detail Issue",
                comments.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, comments.Count);
        }
    }
}
