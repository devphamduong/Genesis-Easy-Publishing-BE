using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using app.Models;
using app.Service;

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

        //// GET: api/Stories
        //[HttpGet]
        //public async Task<ActionResult<IEnumerable<Story>>> GetStories()
        //{
        //  if (_context.Stories == null)
        //  {
        //      return NotFound();
        //  }
        //    return await _context.Stories.ToListAsync();
        //}

        // GET: api/Stories/5
        [HttpGet("story_detail/{storyid}")]
        public async Task<ActionResult> GetStory(int storyid, int page)
        {
            var stories = await _context.Stories.Where(c => c.StoryId == storyid && c.Status > 0)
                .Include(c => c.Author).Include(c => c.StoryInteraction)
                .Include(c => c.Categories)
                .Include(c => c.Users) // luot mua truyen
                .Include(c => c.Chapters).ThenInclude(c => c.Users)
                .Select(c => new
                {
                    StoryId = c.StoryId,
                    StoryTitle = c.StoryTitle,
                    StoryImage = c.StoryImage,
                    StoryDescription = c.StoryDescription,
                    StoryPrice = c.StoryPrice,
                    StorySale = c.StorySale,
                    CreateTime = c.CreateTime,
                    StoryCategories = c.Categories.ToList(),
                    StoryAuthor = new { c.Author.UserId, c.Author.UserFullname },
                    StoryChapterNumber = c.Chapters.Count,
                    StoryChapters = c.Chapters.Where(c => c.Status > 0).Select(c => new
                    {
                        c.ChapterId,
                        c.ChapterTitle,
                        c.ChapterPrice,
                        c.CreateTime

                    }).OrderByDescending(c => c.ChapterId)
                    .Take(3).ToList(),
                    UserPurchaseStory = c.Users.Count,
                    StoryInteraction = c.StoryInteraction
                })
                .ToListAsync();
            return _msgService.MsgReturn("Story Detail", stories.FirstOrDefault());
        }

        [HttpPost("publish_story")]
        public async Task<ActionResult> PublishStory(Story story)
        {
            story.CreateTime = DateTime.Now;
            try
            {
                _context.Stories.Add(story);
                _context.SaveChanges();
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Can't save story"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Publish story successfully"
            });
        }

        //// PUT: api/Stories/5
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPut("{id}")]
        //public async Task<IActionResult> PutStory(int id, Story story)
        //{
        //    if (id != story.StoryId)
        //    {
        //        return BadRequest();
        //    }

        //    _context.Entry(story).State = EntityState.Modified;

        //    try
        //    {
        //        await _context.SaveChangesAsync();
        //    }
        //    catch (DbUpdateConcurrencyException)
        //    {
        //        if (!StoryExists(id))
        //        {
        //            return NotFound();
        //        }
        //        else
        //        {
        //            throw;
        //        }
        //    }

        //    return NoContent();
        //}

        //// POST: api/Stories
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPost]
        //public async Task<ActionResult<Story>> PostStory(Story story)
        //{
        //  if (_context.Stories == null)
        //  {
        //      return Problem("Entity set 'EasyPublishingContext.Stories'  is null.");
        //  }
        //    _context.Stories.Add(story);
        //    await _context.SaveChangesAsync();

        //    return CreatedAtAction("GetStory", new { id = story.StoryId }, story);
        //}

        //// DELETE: api/Stories/5
        //[HttpDelete("{id}")]
        //public async Task<IActionResult> DeleteStory(int id)
        //{
        //    if (_context.Stories == null)
        //    {
        //        return NotFound();
        //    }
        //    var story = await _context.Stories.FindAsync(id);
        //    if (story == null)
        //    {
        //        return NotFound();
        //    }

        //    _context.Stories.Remove(story);
        //    await _context.SaveChangesAsync();

        //    return NoContent();
        //}

        //private bool StoryExists(int id)
        //{
        //    return (_context.Stories?.Any(e => e.StoryId == id)).GetValueOrDefault();
        //}
    }
}
