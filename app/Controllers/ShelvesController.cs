using app.DTOs;
using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Routing;
using Microsoft.AspNetCore.OData.Query;
using Microsoft.EntityFrameworkCore;
using System.Drawing.Printing;
using System.Linq;

namespace app.Controllers
{
    [Route("api/v1/shelves")]
    [ApiController]
    public class ShelvesController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        private int pagesize = 10;

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
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterNumber,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().CreateTime
                    },
                    StoryInteraction = new
                    {
                        s.StoryInteraction.Like,
                        s.StoryInteraction.Follow,
                        s.StoryInteraction.View,
                        s.StoryInteraction.Read,
                    },
                    UserPurchaseStory = s.Users.Count,
                    UserPurchaseChapter = s.Chapters.SelectMany(c => c.Users).Count(),
                })
                .OrderByDescending(s => s.UserPurchaseStory) // top famous compare
                .ThenByDescending(s => s.UserPurchaseChapter)
                .ThenByDescending(s => s.StoryInteraction.Read).ThenByDescending(s => s.StoryInteraction.Follow)
                .ThenByDescending(s => s.StoryInteraction.Like)
                .ToListAsync();
            return _msgService.MsgPagingReturn("Stories successfully",
                stories.Skip(pagesize * (page - 1)).Take(pagesize), page, pagesize, stories.Count);
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
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterNumber,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().CreateTime
                    },
                })
                .OrderByDescending(c => c.StoryLatestChapter.ChapterId) // latest by chapters
                .ToListAsync();
            return _msgService.MsgPagingReturn("Stories successfully",
                stories.Skip(pagesize * (page - 1)).Take(pagesize), page, pagesize, stories.Count);
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
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryInteraction = new
                    {
                        s.StoryInteraction.Like,
                        s.StoryInteraction.Follow,
                        s.StoryInteraction.View,
                        s.StoryInteraction.Read,
                    },
                    UserCount = s.Users.Count,
                    UserPurchaseChapter = s.Chapters.SelectMany(c => c.Users).Count(),
                })
                .OrderByDescending(s => s.UserCount)
                .ThenByDescending(s => s.UserPurchaseChapter).Take(6).ToListAsync();
            return _msgService.MsgReturn(0, "Stories successfully", stories);
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
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterNumber,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().CreateTime
                    },
                    StoryInteraction = new
                    {
                        s.StoryInteraction.Like,
                        s.StoryInteraction.Follow,
                        s.StoryInteraction.View,
                        s.StoryInteraction.Read,
                    },
                })
                .OrderByDescending(c => c.StoryInteraction.Read).ToListAsync(); // top by read
            return _msgService.MsgPagingReturn("Stories successfully",
                stories.Skip(pagesize * (page - 1)).Take(pagesize), page, pagesize, stories.Count);
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
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterNumber,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().CreateTime
                    },
                    StoryPrice = s.StoryPrice,
                    ChaptersPrice = s.Chapters.Select(c => c.ChapterPrice).Sum(),
                }).OrderBy(c => c.StoryPrice)       // price accending
                .ThenBy(c => c.ChaptersPrice).ToListAsync();
            return _msgService.MsgPagingReturn("Stories successfully",
               stories.Skip(pagesize * (page - 1)).Take(pagesize), page, pagesize, stories.Count);
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
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterNumber,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().CreateTime
                    },
                }).ToListAsync();
            return _msgService.MsgPagingReturn("Stories successfully",
               stories.Skip(pagesize * (page - 1)).Take(pagesize), page, pagesize, stories.Count);
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
                        StoryInteraction = new
                        {
                            s.StoryInteraction.Like,
                            s.StoryInteraction.Follow,
                            s.StoryInteraction.View,
                            s.StoryInteraction.Read,
                        },
                    }).OrderByDescending(s => s.StoryInteraction.Read).ToList(),
                })
                .ToListAsync();
            return _msgService.MsgReturn(0, "Stories successfully", stories);
        }


        // GET: api/Stories : top read shelves cate
        [HttpGet("topcate_read")]
        [EnableQuery]
        public async Task<ActionResult> GetTopStoriesReadShelves(int cateid)
        {
            var stories = await _context.Stories.Where(c => c.Categories.Any(u => u.CategoryId == cateid) && c.Status > 0)
                .Include(c => c.StoryInteraction)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    //StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
                    //new
                    //{
                    //    s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterId,
                    //    s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().ChapterTitle,
                    //    s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault().CreateTime
                    //},
                    StoryInteraction = new
                    {
                        s.StoryInteraction.Like,
                        s.StoryInteraction.Follow,
                        s.StoryInteraction.View,
                        s.StoryInteraction.Read,
                    },
                })
                .OrderByDescending(c => c.StoryInteraction.Read).Take(10).ToListAsync(); // top by read
            return _msgService.MsgReturn(0, "Stories successfully", stories);
        }

        // get stories each cate
        [HttpGet("topcate_shelves")]
        [EnableQuery]
        public async Task<ActionResult> GetStoriesTopCate(int cateid)
        {
            var stories = await _context.Stories.Where(c => c.Categories.Any(u => u.CategoryId == cateid) && c.Status > 0)
                .Include(c => c.Users)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterNumber,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().CreateTime
                    },
                    StoryPrice = s.StoryPrice,
                    StoryInteraction = new
                    {
                        s.StoryInteraction.Like,
                        s.StoryInteraction.Follow,
                        s.StoryInteraction.View,
                        s.StoryInteraction.Read,
                    },
                })
                .OrderByDescending(s => s.StoryLatestChapter.ChapterId)
                .ThenByDescending(s => s.StoryId)
                .ThenByDescending(s => s.StoryInteraction.Read).ThenByDescending(s => s.StoryInteraction.Follow)
                .ThenByDescending(s => s.StoryInteraction.Like).Take(5)
                .ToListAsync();

            return _msgService.MsgReturn(0, "Stories successfully", stories);
        }

        // get stories each cate
        [HttpGet("cate_shelves")]
        [EnableQuery]
        public async Task<ActionResult> GetStoriesEachCate(int cateid, int page, int pageSize)
        {
            var stories = await _context.Stories.Where(c => c.Categories.Any(u => u.CategoryId == cateid) && c.Status > 0)
                .Include(c => c.Users)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters)
                .Include(c => c.StoryInteraction)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterNumber,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().CreateTime
                    },
                    StoryPrice = s.StoryPrice,
                    StoryInteraction = new
                    {
                        s.StoryInteraction.Like,
                        s.StoryInteraction.Follow,
                        s.StoryInteraction.View,
                        s.StoryInteraction.Read,
                    },
                })
                .OrderByDescending(s => s.StoryLatestChapter.ChapterId)
                .ThenByDescending(s => s.StoryId)
                .ThenByDescending(s => s.StoryInteraction.Read).ThenByDescending(s => s.StoryInteraction.Follow)
                .ThenByDescending(s => s.StoryInteraction.Like)
                .ToListAsync();
            pageSize = pageSize == null || pageSize == 0 ? pagesize : pageSize;
            return _msgService.MsgPagingReturn("Stories successfully",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, stories.Count);
        }

        // get stories each cate
        [HttpGet("cate_shelves_done")]
        [EnableQuery]
        public async Task<ActionResult> GetStoriesDoneEachCate(int cateid, int page, int pageSize)
        {
            var stories = await _context.Stories.Where(c => c.Status == 2 && c.Categories.Any(u => u.CategoryId == cateid))
                .Include(c => c.Users)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters)
                .Include(c => c.StoryInteraction)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterNumber,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().CreateTime
                    },
                    StoryPrice = s.StoryPrice,
                    StoryInteraction = new
                    {
                        s.StoryInteraction.Like,
                        s.StoryInteraction.Follow,
                        s.StoryInteraction.View,
                        s.StoryInteraction.Read,
                    },
                })
                .OrderByDescending(s => s.StoryLatestChapter.ChapterId)
                .ThenByDescending(s => s.StoryId)
                .ThenByDescending(s => s.StoryInteraction.Read).ThenByDescending(s => s.StoryInteraction.Follow)
                .ThenByDescending(s => s.StoryInteraction.Like)
                .ToListAsync();

            pageSize = pageSize == null || pageSize == 0 ? pagesize : pageSize;
            return _msgService.MsgPagingReturn("Stories successfully",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, stories.Count);
        }

        // get stories by filter
        [HttpGet("filter")]
        [EnableQuery]
        public async Task<ActionResult> GetFilter(string? title, int? to, int? from, string? sort, [FromQuery] List<int> cates,
            int? status, int page, int pageSize)
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
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterNumber,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().CreateTime
                    },
                    StoryPrice = s.StoryPrice,
                    ChaptersPrice = s.Chapters.Select(c => c.ChapterPrice).Sum(),
                    Status = s.Status
                })
                .OrderByDescending(c => c.StoryLatestChapter.ChapterId).ThenByDescending(c => c.StoryId)
                .ToListAsync();


            // name matching
            stories = String.IsNullOrEmpty(title) ? stories : stories.Where(c => c.StoryTitle.ToLower().Contains(title.ToLower())).ToList();

            // purchase story
            stories = to == null && from == null ? stories : stories.Where(c => c.StoryPrice >= from && c.StoryPrice <= to).ToList();
            stories = sort == null ? stories : stories.OrderBy(c => sort == "sort" ? c.StoryPrice : -c.StoryPrice).ToList();

            // categories matching
            stories = cates == null || cates.Count == 0 ? stories :
                stories.Where(c => cates.All(categoryId => c.StoryCategories.Select(sc => sc.CategoryId).Contains(categoryId))).ToList();

            stories = status == null ? stories : stories.Where(c => c.Status == status).ToList();
            //stories = stories.OrderByDescending(c => c.StoryLatestChapter.ChapterId).ThenByDescending(c => c.StoryId).ToList();
            page = page == null || page == 0 ? 1 : page;
            pageSize = pageSize == null || pageSize == 0 ? pagesize : pageSize;
            return _msgService.MsgPagingReturn("Stories successfully",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, stories.Count);
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
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterNumber,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().CreateTime
                    },
                    StoryPrice = s.StoryPrice,
                })
                .ToListAsync();

            return _msgService.MsgPagingReturn("Stories Owned successfully",
                stories.Skip(pagesize * (page - 1)).Take(pagesize), page, pagesize, stories.Count);
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
                    StoryDescription = s.StoryDescriptionHtml,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
                    new
                    {
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterId,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterNumber,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().ChapterTitle,
                        s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterNumber).FirstOrDefault().CreateTime
                    },
                    StoryPrice = s.StoryPrice,
                })
                .ToListAsync();

            return _msgService.MsgPagingReturn("Stories Follow successfully",
                stories.Skip(pagesize * (page - 1)).Take(pagesize), page, pagesize, stories.Count);
        }
    }
}
