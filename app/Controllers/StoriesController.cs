using app.Models;
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

        public StoriesController(EasyPublishingContext context)
        {
            _context = context;
        }


        // GET: api/Stories : top 3 sale story
        [HttpGet("top3")]
        public async Task<ActionResult> GetTop3Stories()
        {
            var stories = await _context.Stories
                .ToListAsync();
            return new JsonResult(new
            {
                EC = 0,
                EM = "Stories successfully",
                DT = new
                {
                    stories_list = stories
                },
            });
        }
    }
}
