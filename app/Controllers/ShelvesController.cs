using app.DTOs;
using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Routing;
using Microsoft.AspNetCore.OData.Query;
using Microsoft.EntityFrameworkCore;
using System.Drawing.Printing;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

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
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Users) // luot mua truyen
                .Include(c => c.Chapters).ThenInclude(c => c.Users) // luot mua chuong
                .Include(c => c.StoryInteraction)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescription,
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
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
            return _msgService.MsgPagingReturn("Top nổi bật",
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
                    StoryDescription = s.StoryDescription,
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
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
            return _msgService.MsgPagingReturn("Truyện mới update",
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
                    StoryDescription = s.StoryDescription,
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
                    StoryChapterNumber = s.Chapters.Count(c=> c.Status>0),
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
            return _msgService.MsgReturn(0, "Top 6 lượt mua", stories);
        }

        [HttpGet("top6_sale")]
        public async Task<ActionResult> GetTop6StoriesSale()
        {
            var topStories = _context.Transactions
                                .Where(t => t.StoryId != null)
                                .GroupBy(t => t.StoryId)
                                .Select(g => new
                                {
                                    StoryId = g.Key.Value,
                                    Revenue = g.Sum(t => t.Amount)
                                })
                                .OrderByDescending(g => g.Revenue)
                                .Take(6)
                                .Select(g => new
                                {
                                    story = _context.Stories.Where(s => s.StoryId == g.StoryId).Select(s => new
                                    {
                                        storyId = s.StoryId,
                                        storyTitle = s.StoryTitle,
                                        storyImage = s.StoryImage,
                                        authorName = s.Author.UserFullname
                                    }).FirstOrDefault(),
                                    Revenue = g.Revenue*1000
                                })
                                .ToList();

            return _msgService.MsgReturn(0, "Top 6 truyện doanh thu cao nhất", topStories);
        }

        [HttpGet("top6_authorRevenue")]
        public async Task<ActionResult> GetTop6AuthorRevenue()
        {
            var topAuthors = await _context.Transactions
                                 .Where(t => t.WalletId != null)
                                 .GroupBy(t => t.WalletId)
                                 .Select(g => new
                                 {
                                     WalletId = g.Key,
                                     Revenue = g.Sum(t => t.Amount)
                                 })
                                 .OrderByDescending(g => g.Revenue)
                                 .Take(6)
                                 .Select(g => new
                                 {
                                     Author = _context.Wallets.Where(w => w.WalletId == g.WalletId).Select(a => new
                                     {
                                         AuthorFullname = a.User.UserFullname,
                                         AuthorEmail = a.User.Email,
                                         AuthorImage = a.User.UserImage
                                     }).FirstOrDefault(),
                                     Revenue = g.Revenue * 1000
                                 })
                                 .ToListAsync();

            return _msgService.MsgReturn(0, "Top 6 tác giả kiếm được nhiều tiền nhất", topAuthors);
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
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
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
            return _msgService.MsgPagingReturn("Top lượt đọc",
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
                    StoryDescription = s.StoryDescription,
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
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
            return _msgService.MsgPagingReturn("Truyện miễn phí",
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
                    StoryDescription = s.StoryDescription,
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
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
            return _msgService.MsgPagingReturn("Truyện mới thêm",
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
                        StoryCreateTime = s.CreateTime,
                    }).OrderByDescending(s => s.StoryInteraction.Read).ToList(),
                })
                .ToListAsync();
            return _msgService.MsgReturn(0, "Truyện theo thể loại", stories);
        }


        // GET: api/Stories : top read shelves cate
        [HttpGet("topcate_read")]
        [EnableQuery]
        public async Task<ActionResult> GetTopStoriesReadShelves(int cateId)
        {
            var stories = await _context.Stories.Where(c => c.Categories.Any(u => u.CategoryId == cateId) && c.Status > 0)
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
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
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
            return _msgService.MsgReturn(0, "Top lượt đọc theo thể loại", stories);
        }

        // get stories each cate
        [HttpGet("topcate_shelves")]
        [EnableQuery]
        public async Task<ActionResult> GetStoriesTopCate(int cateId)
        {
            var stories = await _context.Stories.Where(c => c.Categories.Any(u => u.CategoryId == cateId) && c.Status > 0)
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
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
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

            return _msgService.MsgReturn(0, "Top theo thể loại", stories);
        }

        // get stories each cate
        [HttpGet("cate_shelves")]
        [EnableQuery]
        public async Task<ActionResult> GetStoriesEachCate(int cateId, int page, int pageSize)
        {
            var stories = await _context.Stories.Where(c => c.Categories.Any(u => u.CategoryId == cateId) && c.Status > 0)
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
                    StoryDescription = s.StoryDescription,
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
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
            return _msgService.MsgPagingReturn("Truyện theo thể loại",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, stories.Count);
        }

        // get stories each cate
        [HttpGet("cate_shelves_done")]
        [EnableQuery]
        public async Task<ActionResult> GetStoriesDoneEachCate(int cateId, int page, int pageSize)
        {
            var stories = await _context.Stories.Where(c => c.Status == 2 && c.Categories.Any(u => u.CategoryId == cateId))
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
                    StoryDescription = s.StoryDescription,
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
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
            return _msgService.MsgPagingReturn("Truyện hoàn thành theo thể loại",
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
                    StoryDescription = s.StoryDescription,
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
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
            return _msgService.MsgPagingReturn("Tìm kiếm",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, stories.Count);
        }

        [HttpGet("author_detail/written")]
        public async Task<ActionResult> GetStoryByAuthorId(int authorId)
        {

            var stories = await _context.Stories.Where(s => s.AuthorId == authorId && s.Status > 0)
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
                    StoryDescription = s.StoryDescription,
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryCreateTime = s.CreateTime,
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
                }).OrderByDescending(c => c.StoryId).ToListAsync();
            return _msgService.MsgReturn(0, "Danh sách truyện của tác giả", stories);
        }

        [HttpGet("author_detail/top_famous")]
        public async Task<ActionResult> GetStoryFamousByAuthorId(int authorId)
        {

            var stories = await _context.Stories.Where(s => s.AuthorId == authorId && s.Status > 0)
                .Include(c => c.Users)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters).ThenInclude(c => c.Users)
                .Include(c => c.StoryInteraction)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescription,
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryCreateTime = s.CreateTime,
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
                    UserPurchaseStory = s.Users.Count,
                    UserPurchaseChapter = s.Chapters.SelectMany(c => c.Users).Count(),
                }).OrderByDescending(s => s.UserPurchaseStory) // top famous compare
                .ThenByDescending(s => s.UserPurchaseChapter)
                .ThenByDescending(s => s.StoryInteraction.Read).ThenByDescending(s => s.StoryInteraction.Follow)
                .ThenByDescending(s => s.StoryInteraction.Like)
                .ToListAsync();
            return _msgService.MsgReturn(0, "Danh sách truyện của tác giả", stories);
        }

        [HttpGet("author_detail/top_purchase")]
        public async Task<ActionResult> GetStoryPurchaseByAuthorId(int authorId)
        {

            var stories = await _context.Stories.Where(s => s.AuthorId == authorId && s.Status > 0)
                .Include(c => c.Users)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters).ThenInclude(c => c.Users)
                .Include(c => c.StoryInteraction)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescription,
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryCreateTime = s.CreateTime,
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
                    UserPurchaseStory = s.Users.Count,
                    UserPurchaseChapter = s.Chapters.SelectMany(c => c.Users).Count(),
                }).OrderByDescending(s => s.UserPurchaseStory) // top famous compare
                .ThenByDescending(s => s.UserPurchaseChapter)
                .ToListAsync();
            return _msgService.MsgReturn(0, "Danh sách truyện của tác giả", stories);
        }

        [HttpGet("author_detail/top_newest_by_chapter")]
        public async Task<ActionResult> GetStoryNewestByAuthorId(int authorId)
        {

            var stories = await _context.Stories.Where(s => s.AuthorId == authorId && s.Status > 0)
                .Include(c => c.Users)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters).ThenInclude(c => c.Users)
                .Include(c => c.StoryInteraction)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescription,
                    StoryDescriptionHtml = s.StoryDescriptionHtml,
                    StoryDescriptionMarkdown = s.StoryDescriptionMarkdown,
                    StoryCategories = s.Categories.ToList(),
                    StoryCreateTime = s.CreateTime,
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
                    UserPurchaseStory = s.Users.Count,
                    UserPurchaseChapter = s.Chapters.SelectMany(c => c.Users).Count(),
                }).OrderByDescending(s => s.StoryLatestChapter.ChapterId) // top famous compare
                .ThenByDescending(s => s.StoryId)
                .ToListAsync();
            return _msgService.MsgReturn(0, "Danh sách truyện của tác giả", stories);
        }

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
        private int GetUserId()
        {
            var jwtSecurityToken = new JwtSecurityToken();
            int userId = 0;
            try
            {
                jwtSecurityToken = VerifyToken();
                userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
            }
            catch (Exception) { }
            return userId;
        }

        [HttpGet("author_manage")]
        public async Task<ActionResult> GetStoryOfAuthor(string? title, [FromQuery] List<string> sort, int page, int pageSize)
        {
            int userId = GetUserId();

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");

            var stories = await _context.Stories.Where(c => c.AuthorId == userId && c.Status >= 0)
                .Include(c => c.Categories)
                .Include(c => c.Users)
                .Include(c => c.Chapters).ThenInclude(c => c.Users)
                .Include(c => c.StoryInteraction)
                .Select(c => new
                {
                    StoryId = c.StoryId,
                    StoryTitle = c.StoryTitle,
                    StoryImage = c.StoryImage,
                    StoryCreateTime = c.CreateTime,
                    StoryInteraction = new
                    {
                        c.StoryInteraction.Like,
                        c.StoryInteraction.Follow,
                        c.StoryInteraction.View,
                        c.StoryInteraction.Read,
                    },
                    StoryStatus = c.Status,
                    UserPurchaseStory = c.Users.Count + c.Chapters.SelectMany(c => c.Users).Count(),
                    UserPurchaseChapter = c.Chapters.SelectMany(c => c.Users).Count(),
                    ChapterNum = c.Chapters.Count,
                })
                //.OrderByDescending(c => c.StoryId)
                .ToListAsync();
            stories = String.IsNullOrEmpty(title) ? stories : stories.Where(c => c.StoryTitle.ToLower().Contains(title.ToLower())).ToList();

            if (sort != null && sort.Any())
            {
                if (sort.Any(c => c.Contains("storyTitle")))
                    stories = sort.Contains("-storyTitle") ? stories.OrderByDescending(c => c.StoryTitle).ToList()
                        : stories.OrderBy(c => c.StoryTitle).ToList();

                if (sort.Any(c => c.Contains("userPurchaseStory")))
                    stories = sort.Contains("-userPurchaseStory") ? stories.OrderByDescending(c => c.UserPurchaseStory).ToList()
                        : stories.OrderBy(c => c.UserPurchaseStory).ToList();

                if (sort.Any(c => c.Contains("storyCreateTime")))
                    stories = sort.Contains("-storyCreateTime") ? stories.OrderByDescending(c => c.StoryCreateTime).ToList()
                        : stories.OrderBy(c => c.StoryCreateTime).ToList();
            }

            page = page == null || page == 0 ? 1 : page;
            pageSize = pageSize == null || pageSize == 0 ? pagesize : pageSize;
            return _msgService.MsgPagingReturn("Truyện của tác giả",
            stories.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, stories.Count);
        }

        // get stories owned
        [HttpGet("my_owned")]
        [EnableQuery]
        public async Task<ActionResult> GetMyOwned(int page, int pageSize)
        {
            int userId = GetUserId();

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");

            var stories = await _context.Stories.Where(c => c.Users.Any(u => u.UserId == userId) && c.Status > 0)
                .Include(c => c.Users)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters)
                .Include(c => c.StoryReads).ThenInclude(c => c.Chapter)
                .Include(c => c.StoryInteraction)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
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
                    StoryReadChapter = s.StoryReads.Where(c => c.UserId == userId && s.StoryId == c.StoryId)
                    .Select(c => new { c.ChapterId, c.Chapter.ChapterNumber, c.Chapter.ChapterTitle, c.Chapter.CreateTime, c.ReadTime }).FirstOrDefault(),
                    StoryPrice = s.StoryPrice,
                })
                .ToListAsync();
            page = page == null || page == 0 ? 1 : page;
            pageSize = pageSize == null || pageSize == 0 ? pagesize : pageSize;
            return _msgService.MsgPagingReturn("Truyện đã mua",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, stories.Count);
        }

        // get stories follow
        [HttpGet("my_follow")]
        [EnableQuery]
        public async Task<ActionResult> GetMyFollow(int page, int pageSize)
        {
            int userId = GetUserId();

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");

            var stories = await _context.Stories.Where(c => c.StoryFollowLikes.Any(u => u.UserId == userId && u.Follow == true) && c.Status > 0)
                .Include(c => c.StoryFollowLikes)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters)
                .Include(c => c.StoryReads).ThenInclude(c => c.Chapter)
                .Include(c => c.StoryInteraction)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescription,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
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
                    StoryReadChapter = s.StoryReads.Where(c => c.UserId == userId && s.StoryId == c.StoryId)
                    .Select(c => new { c.ChapterId, c.Chapter.ChapterNumber, c.Chapter.ChapterTitle, c.Chapter.CreateTime, c.ReadTime }).FirstOrDefault(),
                    StoryPrice = s.StoryPrice,
                })
                .ToListAsync();

            page = page == null || page == 0 ? 1 : page;
            pageSize = pageSize == null || pageSize == 0 ? pagesize : pageSize;
            return _msgService.MsgPagingReturn("Truyện theo dõi",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, stories.Count);
        }

        [HttpGet("my_read")]
        [EnableQuery]
        public async Task<ActionResult> GetMyReadHistory(int page, int pageSize)
        {
            int userId = GetUserId();

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");

            var stories = await _context.Stories.Where(c => c.StoryReads.Any(u => u.UserId == userId) && c.Status > 0)
                .Include(c => c.Author)
                .Include(c => c.Categories)
                .Include(c => c.Chapters)
                .Include(c => c.StoryReads).ThenInclude(c => c.Chapter)
                .Include(c => c.StoryInteraction)
                .Select(s => new
                {
                    StoryId = s.StoryId,
                    StoryTitle = s.StoryTitle,
                    StoryImage = s.StoryImage,
                    StoryDescription = s.StoryDescription,
                    StoryCategories = s.Categories.ToList(),
                    StoryAuthor = new { s.Author.UserId, s.Author.UserFullname },
                    StoryCreateTime = s.CreateTime,
                    StoryChapterNumber = s.Chapters.Count,
                    StoryLatestChapter = s.Chapters.Where(c => c.Status > 0).OrderByDescending(c => c.ChapterId).FirstOrDefault() == null ? null :
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
                    StoryReadChapter = s.StoryReads.Where(c => c.UserId == userId && s.StoryId == c.StoryId)
                    .Select(c => new { c.ChapterId, c.Chapter.ChapterNumber, c.Chapter.ChapterTitle, c.Chapter.CreateTime, c.ReadTime }).FirstOrDefault(),
                    StoryPrice = s.StoryPrice,
                })
                .ToListAsync();

            page = page == null || page == 0 ? 1 : page;
            pageSize = pageSize == null || pageSize == 0 ? pagesize : pageSize;
            return _msgService.MsgPagingReturn("Truyện đã đọc",
                stories.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, stories.Count);
        }

    }
}
