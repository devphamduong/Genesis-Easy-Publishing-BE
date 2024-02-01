using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OData.Query;
using Microsoft.EntityFrameworkCore;

namespace app.Controllers
{
    [Route("api/v1/story")]
    [ApiController]
    public class StoriesController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        private int pageSize = 10;

        public StoriesController(EasyPublishingContext context)
        {
            _context = context;
        }

        // GET: api/Stories : top famous story
        [HttpGet("top_famous")]
        [EnableQuery]
        public async Task<ActionResult> GetTopFamousStories(int page)
        {
            var stories = await _context.Stories.Where(c => c.Status > 0)
                .Include(c => c.Author).Include(c => c.StoryInteraction)
                .Include(c => c.Categories)
                .Include(c => c.Users) // luot mua truyen
                .Include(c => c.Chapters).ThenInclude(c => c.Users) // luot mua chuong
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescription,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().CreateTime
                    },
                    s.StoryInteraction.Read,
                    s.StoryInteraction.Like,
                    s.StoryInteraction.Follow,
                    UserPurchaseStory = s.Users.Count,
                    UserPurchaseChapter = s.Chapters.SelectMany(c => c.Users).Count(),
                })
                .OrderByDescending(s => s.UserPurchaseStory)
                .ThenByDescending(s => s.UserPurchaseChapter)
                .ThenByDescending(s => s.Read).ThenByDescending(s => s.Follow).ThenByDescending(s => s.Like)
                .ToListAsync();
            return _msgService.MsgStoryReturn("Stories successfully",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, stories.Count);
        }

        // GET: api/Stories : top latest story by chapter
        //[HttpGet("top_latest_by_chapter")]
        //[EnableQuery]
        //public async Task<ActionResult> GetTopLatesttoriesByChapter()
        //{
        //    var stories = await _context.Chapters
        //        .Include(c => c.Story).ThenInclude(c => c.Author)
        //        .Include(c => c.Story).ThenInclude(c => c.Categories)
        //        .Where(c => c.Status == true).OrderByDescending(c => c.ChapterId).ToListAsync();
        //    var stories_list = stories.GroupBy(c => c.StoryId)
        //        .Select(group => new
        //        {
        //            StoryId = group.First().StoryId,
        //            StoryTitle = group.First().Story.StoryTitle,
        //            StoryImage = group.First().Story.StoryImage,
        //            StoryDescription = group.First().Story.StoryDescription,
        //            StoryCategories = group.First().Story.Categories.Select(c => new
        //            {
        //                c.CategoryId,
        //                c.CategoryName
        //            }).ToList(),
        //            StoryAuthor = new { group.First().Story.Author.UserId, group.First().Story.Author.UserFullname },
        //            StoryChapterNumber = group.Count(),
        //            StoryLatestChapter = new { group.First().ChapterId, group.First().ChapterTitle, }
        //        }).ToList();
        //    return _msgService.MsgReturn("Stories successfully", stories_list);
        //}
        [HttpGet("top_latest_by_chapter")]
        [EnableQuery]
        public async Task<ActionResult> GetTopLatesttoriesByChapter(int page)
        {
            var stories = await _context.Stories.Where(c => c.Status > 0)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescription,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().CreateTime
                    },
                })
                .OrderByDescending(c => c.StoryLatestChapter.ChapterId)
                .ToListAsync();
            return _msgService.MsgStoryReturn("Stories successfully",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, stories.Count);
        }
        // GET: api/Stories : top 6 purchase story
        [HttpGet("top6_purchase")]
        public async Task<ActionResult> GetTop6StoriesBuy()
        {
            var stories = await _context.Stories.Where(c => c.Status > 0)
                .Include(c => c.Author)
                .Include(c => c.Users).Include(c => c.StoryInteraction)
                .Include(c => c.Chapters).ThenInclude(c => c.Users)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescription,
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    s.StoryInteraction.Read,
                    UserCount = s.Users.Count,
                    UserPurchaseChapter = s.Chapters.SelectMany(c => c.Users).Count(),
                })
                .OrderByDescending(s => s.UserCount)
                .ThenByDescending(s => s.UserPurchaseChapter).Take(6).ToListAsync();
            return _msgService.MsgReturn("Stories successfully", stories);
        }

        //// GET: api/Stories : top read story
        //[HttpGet("top_read")]
        //[EnableQuery]
        //public async Task<ActionResult> GetTopStoriesRead()
        //{
        //    var stories = await _context.StoryInteractions.OrderByDescending(c => c.Read)
        //        .Include(c => c.Story).ThenInclude(c => c.Categories)
        //        .Include(c => c.Story).ThenInclude(c => c.Chapters)
        //        .Include(c => c.Story).ThenInclude(c => c.Author)
        //        .Select(s => new
        //        {
        //            StoryId = s.StoryId,
        //            StoryTitle = s.Story.StoryTitle,
        //            StoryImage = s.Story.StoryImage,
        //            StoryDescription = s.Story.StoryDescription,
        //            StoryCategories = s.Story.Categories.ToList(),
        //            StoryAuthor = new { s.Story.Author.UserId, s.Story.Author.UserFullname },
        //            StoryChapterNumber = s.Story.Chapters.Count,
        //            StoryLatestChapter = s.Story.Chapters.OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
        //            new
        //            {
        //                s.Story.Chapters.OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterId,
        //                s.Story.Chapters.OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterTitle
        //            },
        //            s.Read
        //        }).ToListAsync();
        //    return _msgService.MsgReturn("Stories successfully", stories);
        //}

        // GET: api/Stories : top read story
        [HttpGet("top_read")]
        [EnableQuery]
        public async Task<ActionResult> GetTopStoriesRead(int page)
        {
            var stories = await _context.Stories.Where(c => c.Status > 0)
                .Include(c => c.StoryInteraction)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescription,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().CreateTime
                    },
                    s.StoryInteraction.Read
                })
                .OrderByDescending(c => c.Read)
                .ToListAsync();
            return _msgService.MsgStoryReturn("Stories successfully",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, stories.Count);
        }

        // GET: api/Stories : top price accend story 
        [HttpGet("top_free")]
        [EnableQuery]
        public async Task<ActionResult> GetTopStoriesPrice(int page)
        {
            var stories = await _context.Stories.Where(c => c.Status > 0)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescription,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().CreateTime
                    },
                    StoryPrice = s.StoryPrice,
                    ChaptersPrice = s.Chapters.Select(c => c.ChapterPrice).Sum(),
                }).OrderBy(c => c.StoryPrice)
                .ThenBy(c => c.ChaptersPrice).ToListAsync();
            return _msgService.MsgStoryReturn("Stories successfully",
               stories.Skip(pageSize * (page - 1)).Take(pageSize), page, stories.Count);
        }

        // GET: api/Stories : top latest story
        [HttpGet("top_newest")]
        [EnableQuery]
        public async Task<ActionResult> GetTopLatesttories(int page)
        {
            var stories = await _context.Stories.Where(c => c.Status > 0)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters)
                .OrderByDescending(c => c.StoryId)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescription,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().CreateTime
                    },
                }).ToListAsync();
            return _msgService.MsgStoryReturn("Stories successfully",
               stories.Skip(pageSize * (page - 1)).Take(pageSize), page, stories.Count);
        }

        // GET: api/Stories : stories of each cate
        [HttpGet("cate_stories")]
        public async Task<ActionResult> GetStoriesFollowCategories()
        {
            var stories = await _context.Categories.Include(c => c.Stories)
                .ThenInclude(c => c.StoryInteraction)
                .Select(s => new
                {
                    s.CategoryId,
                    s.CategoryName,
                    Stories = s.Stories.Select(s => new
                    {
                        s.StoryId,
                        s.StoryTitle,
                        s.StoryInteraction.Read
                    }).OrderByDescending(s => s.Read).ToList(),
                })
                .ToListAsync();
            return _msgService.MsgReturn("Stories successfully", stories);
        }
    }
}
