using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using app.Models;
using app.Service;
using System.Security.Policy;
using System.IdentityModel.Tokens.Jwt;
using System.Drawing.Printing;
using Microsoft.VisualBasic;
using static app.Controllers.StoriesController;

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

        private JwtSecurityToken VerifyToken()
        {
            var tokenCookie = Request.Cookies["access_token"];
            var tokenBearer = extractToken();
            var handler = new JwtSecurityTokenHandler();
            var jwtSecurityToken = handler.ReadJwtToken(!String.IsNullOrEmpty(tokenBearer) ? tokenBearer : tokenCookie);
            return jwtSecurityToken;
        }

        private string extractToken()
        {
            if (!String.IsNullOrEmpty(Request.Headers.Authorization) &&
                Request.Headers.Authorization.ToString().Split(' ')[0] == "Bearer" &&
                !String.IsNullOrEmpty(Request.Headers.Authorization.ToString().Split(' ')[1]))
            {
                return Request.Headers.Authorization.ToString().Split(' ')[1];
            }
            return null;
        }

        /// GET: api/Stories
        [HttpGet("get_all_stories")]
        public async Task<ActionResult> GetStories()
        {
            if (_context.Stories == null)
            {
                return NotFound();
            }
            var stories = await _context.Stories
                .Include(s => s.Author)
                .Include(s => s.Comments)
                .Include(s => s.ReportContents)
                .Include(s => s.StoryFollowLikes)
                .Include(s => s.Volumes)
                .Include(s => s.Chapters)
                .Include(s => s.StoryInteraction)
                .Include(s => s.StoryReads)
                .Include(s => s.Categories)
                .Select(c => new
                {
                    StoryId = c.StoryId,
                    StoryTitle = c.StoryTitle,
                    StoryImage = c.StoryImage,
                    StoryDescription = c.StoryDescriptionHtml,
                    StoryPrice = c.StoryPrice,
                    StorySale = c.StorySale,
                    CreateTime = c.CreateTime,
                    StoryCategories = string.Join(",", c.Categories.Select(c => c.CategoryName).ToList()),
                    StoryAuthor = c.Author.UserFullname,
                    StoryChapterNumber = c.Chapters.Count,
                    StoryChapters = c.Chapters.Where(c => c.Status > 0).Count(),
                    StoryReads = c.StoryReads.Count(),
                    Volumes = c.Volumes.Count(),
                    UserOwned = c.Users.Count(),
                    UserFollow = c.StoryFollowLikes.Where(c => c.Follow == true).Count(),
                    UserLike = c.StoryFollowLikes.Where(c => c.Like == true).Count()
                })
                .ToListAsync();
            return _msgService.MsgReturn(0, "Thông tin truyện", stories);
        }

        // GET: api/Stories/5
        [HttpGet("story_detail")]
        public async Task<ActionResult> GetStoryDetail(int storyId)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }

            var stories = await _context.Stories.Where(c => c.StoryId == storyId && c.Status > 0)
                        .Include(c => c.Author).Include(c => c.StoryInteraction)
                        .Include(c => c.Categories)
                        .Include(c => c.Users) // luot mua truyen
                        .Include(c => c.Chapters).ThenInclude(c => c.Users)
                        .Include(c => c.StoryFollowLikes)
                        .Select(c => new
                        {
                            StoryId = c.StoryId,
                            StoryTitle = c.StoryTitle,
                            StoryImage = c.StoryImage,
                            StoryDescription = c.StoryDescriptionHtml,
                            StoryPrice = c.StoryPrice,
                            StorySale = c.StorySale,
                            CreateTime = c.CreateTime,
                            StoryCategories = c.Categories.ToList(),
                            StoryAuthor = new { c.Author.UserId, c.Author.UserFullname },
                            StoryChapterNumber = c.Chapters.Count,
                            StoryChapters = c.Chapters.Where(c => c.Status > 0).Select(c => new
                            {
                                c.ChapterId,
                                c.ChapterNumber,
                                c.ChapterTitle,
                                c.ChapterPrice,
                                c.CreateTime

                            }).OrderByDescending(c => c.ChapterNumber)
                            .Take(3).ToList(),
                            UserPurchaseStory = c.Users.Count,
                            StoryInteraction = c.StoryInteraction,
                            AuthorOwned = userId == c.AuthorId ? true : false,
                            UserOwned = c.Users.Any(c => c.UserId == userId),
                            UserFollow = c.StoryFollowLikes.Any(c => c.UserId == userId && c.Follow == true),
                            UserLike = c.StoryFollowLikes.Any(c => c.UserId == userId && c.Like == true),
                        })
                        .ToListAsync();

            var story_interaction = await _context.StoryInteractions.FirstOrDefaultAsync(c => c.StoryId == storyId);
            story_interaction.View += 1;
            _context.Entry(story_interaction).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return _msgService.MsgReturn(0, "Thông tin truyện", stories.FirstOrDefault());
        }

        [HttpGet("story_detail/related")]
        public async Task<ActionResult> GetStoryDetailRelate(int storyId)
        {
            var story = await _context.Stories.Include(c => c.Categories).FirstOrDefaultAsync(c => c.StoryId == storyId);
            var cates = story.Categories.Select(c => c.CategoryId).ToList();
            var stories = await _context.Stories.Where(c => c.StoryId != storyId && c.Status > 0)
                .Include(c => c.Categories)
                .Include(c => c.Chapters)
                .Select(c => new
                {
                    StoryId = c.StoryId,
                    StoryTitle = c.StoryTitle,
                    StoryImage = c.StoryImage,
                    StoryPrice = c.StoryPrice,
                    StorySale = c.StorySale,
                    StoryCategories = c.Categories.Select(c => new { c.CategoryId, c.CategoryName }).ToList(),
                    StoryAuthor = new { c.Author.UserId, c.Author.UserFullname },
                    StoryCreateTime = c.CreateTime,
                    StoryChapterNumber = c.Chapters.Count,
                    StoryLatestChapter = c.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault() == null ? null :
                    new
                    {
                        c.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterId,
                        c.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterNumber,
                        c.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterTitle,
                        c.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().CreateTime
                    }
                })
                .OrderByDescending(c => c.StoryId)
                .ToListAsync();
            var verified = stories.Where(c => c.StoryCategories.Any(cat => cates.Contains(cat.CategoryId))).ToList();
            return _msgService.MsgReturn(0, "Truyện liên quan", verified.Take(3));
        }


        [HttpGet("GetDataForChart")]
        public async Task<ActionResult> GetDataForChart(int storyId)
        {
            var data = await _context.Stories.Where(s => s.StoryId == storyId)
                    .Include(s => s.StoryInteraction)
                    .Select(s => new
                    {
                        StoryId = s.StoryId,
                        StoryTitle = s.StoryTitle,
                        Like = s.StoryInteraction.Like,
                        Follow = s.StoryInteraction.Follow,
                    }).FirstOrDefaultAsync();
            return _msgService.MsgReturn(0, "List Story", data);
        }

        [HttpGet("story_information")]
        public async Task<ActionResult> GetStoryInfor(int storyId)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }
            var story = await _context.Stories.Where(s => s.StoryId == storyId && s.AuthorId == userId)
                .Select(s => new
                {
                    storyId = s.StoryId,
                    storyTitle = s.StoryTitle,
                    storyDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    storyCategories = s.Categories.ToList(),
                    storyImage = s.StoryImage,
                    storyPrice = s.StoryPrice,
                    storySale = s.StorySale,
                    status = s.Status
                }).FirstOrDefaultAsync();
            if(story == null)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "You can't get this page"
                });
            }
            return _msgService.MsgReturn(0, "Story Detail", story);
        }

        public class AddStoryForm
        {
            public string StoryTitle { get; set; } = null!;
            public int AuthorId { get; set; }
            public string? StoryDescriptionMarkdown { get; set; }
            public string? StoryDescriptionHtml { get; set; }
            public List<int> CategoryIds { get; set; }
        }

        [HttpPost("save_story")]
        public async Task<ActionResult> SaveStory(AddStoryForm addStoryForm)
        {
            try
            {
                _context.Stories.Add(new Story
                {
                    StoryTitle = addStoryForm.StoryTitle,
                    AuthorId = addStoryForm.AuthorId,
                    StoryDescriptionHtml = addStoryForm.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = addStoryForm.StoryDescriptionMarkdown,
                    CreateTime = DateTime.Now,
                    Status = 0,
                    StoryPrice = 0,
                    Categories = await _context.Categories.Where(c => addStoryForm.CategoryIds.Contains(c.CategoryId)).ToListAsync()
                });
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
                EM = "Save story successfully"
            });
        }

        public class SaveStoryForm
        {
            public int StoryId { get; set; }
            public string StoryTitle { get; set; } = null!;
            public decimal StoryPrice { get; set; }

            public decimal? StorySale { get; set; }

            public string? StoryImage { get; set; }

            public string? StoryDescriptionMarkdown { get; set; }

            public string? StoryDescriptionHtml { get; set; }
            public int Status { get; set; }
            public List<int> CategoryIds { get; set; }

        }

        [HttpPut("update_story")]
        public async Task<ActionResult> EditStory(SaveStoryForm story)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }

            var currentStory = _context.Stories.FirstOrDefault(s => s.StoryId == story.StoryId && s.AuthorId == userId);
            if(currentStory == null)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "You can't edit this page"
                });
            }
            try
            {
                if (currentStory != null)
                {
                    currentStory.StoryTitle = story.StoryTitle;
                    currentStory.StoryDescriptionHtml = story.StoryDescriptionHtml;
                    currentStory.StoryDescriptionMarkdown = story.StoryDescriptionMarkdown;
                    currentStory.UpdateTime = DateTime.Now;
                    currentStory.Status = story.Status;
                    currentStory.StoryPrice = story.StoryPrice;
                    currentStory.StorySale = story.StorySale;
                    currentStory.StoryImage = story.StoryImage;
                }
                    _context.Entry<Story>(currentStory).State = EntityState.Modified;
                    _context.SaveChanges();
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Edit Fail"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Update story successfully"
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
