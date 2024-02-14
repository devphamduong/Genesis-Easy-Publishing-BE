using app.DTOs;
using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Routing;
using Microsoft.AspNetCore.OData.Query;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace app.Controllers
{
    [Route("api/v1/shelves")]
    [ApiController]
    public class ShelvesController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        private int pageSize = 10;

        public ShelvesController(EasyPublishingContext context)
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
                .OrderByDescending(s => s.UserPurchaseStory) // top famous compare
                .ThenByDescending(s => s.UserPurchaseChapter)
                .ThenByDescending(s => s.Read).ThenByDescending(s => s.Follow).ThenByDescending(s => s.Like)
                .ToListAsync();
            return _msgService.MsgPagingReturn("Stories successfully",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, stories.Count);
        }

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
                .OrderByDescending(c => c.StoryLatestChapter.ChapterId) // latest by chapters
                .ToListAsync();
            return _msgService.MsgPagingReturn("Stories successfully",
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
                .OrderByDescending(c => c.Read).ToListAsync(); // top by read
            return _msgService.MsgPagingReturn("Stories successfully",
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
                }).OrderBy(c => c.StoryPrice)       // price accending
                .ThenBy(c => c.ChaptersPrice).ToListAsync();
            return _msgService.MsgPagingReturn("Stories successfully",
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
                .OrderByDescending(c => c.StoryId) // newest by id
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
            return _msgService.MsgPagingReturn("Stories successfully",
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

        // get stories by filter
        [HttpPut("filter")]
        [EnableQuery]
        public async Task<ActionResult> GetFilter(FilterDTO filter)
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
                })
                .ToListAsync();

            // name matching
            stories = String.IsNullOrEmpty(filter.StoryTitle) ? stories : stories.Where(c => c.StoryTitle.ToLower().Contains(filter.StoryTitle.ToLower())).ToList();
            // purchase story
            if (filter.Purchase != null)
            {
                stories = stories.Where(c => c.StoryPrice >= filter.Purchase.DownLimit && c.StoryPrice <= filter.Purchase.UpLimit).ToList();
                stories = filter.OrderPriceAscend == null ? stories : stories.OrderBy(c => filter.OrderPriceAscend ?? true ? c.StoryPrice : -c.StoryPrice).ToList();
            }
            else stories = stories.Where(c => c.StoryPrice == 0).ToList();
            // categories matching
            stories = filter.Categories == null || filter.Categories.Count == 0 ? stories :
                stories.Where(c => filter.Categories.All(categoryId => c.StoryCategories.Select(sc => sc.CategoryId).Contains(categoryId))).ToList();

            stories = stories.OrderByDescending(c => c.StoryLatestChapter.ChapterId).ThenByDescending(c => c.StoryId).ToList();
            var page = filter.page == null ? 0 : 1;
            return _msgService.MsgPagingReturn("Stories successfully",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, stories.Count);
        }

        // get stories owned
        [HttpGet("my_owned")]
        [EnableQuery]
        public async Task<ActionResult> GetMyOwned(int userid, int page)
        {
            var stories = await _context.Stories.Where(c => c.Users.Any(u => u.UserId == userid) && c.Status > 0)
                .Include(c => c.Users)
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
                })
                .ToListAsync();

            return _msgService.MsgPagingReturn("Stories Owned successfully",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, stories.Count);
        }

        // get stories follow
        [HttpGet("my_follow")]
        [EnableQuery]
        public async Task<ActionResult> GetMyFollow(int userid, int page)
        {
            var stories = await _context.Stories.Where(c => c.StoryFollowLikes.Any(u => u.UserId == userid) && c.Status > 0)
                .Include(c => c.StoryFollowLikes)
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
                })
                .ToListAsync();

            return _msgService.MsgPagingReturn("Stories Follow successfully",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, stories.Count);
        }
    }
}
