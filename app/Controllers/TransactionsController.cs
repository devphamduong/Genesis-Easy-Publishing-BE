using app.Models;
using app.Service;
using app.Service.MomoService;
using app.Service.VNPayService;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using OfficeOpenXml;
using System.IdentityModel.Tokens.Jwt;

namespace app.Controllers
{
    [Route("api/v1/transaction")]
    [ApiController]
    public class TransactionsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private string ErrorAuthenMessage = "Yều cầu đăng nhập";
        private string ErrorAuthorMessage = "Bạn đã có truyện(chương) này!";
        private string NotEnoughMoney = "Bạn không đủ TLT! Hãy nạp tiền";
        private string BuyStory(string story) => $"Mua truyện {story}";
        private string BuyChapter(long chapter, string story) => $"Mua chương {chapter} của truyện {story}";
        private string BuyManyChapter(long chapter, string story) => $"Mua {chapter} chương của truyện {story}";
        private string RecieveMoney(string story) => $"Nhận TLT từ truyện {story}";


        public TransactionsController(EasyPublishingContext context, IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _context = context;
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor;
        }

        public class PaymentRequestForm
        {
            public string PaymentContent { get; set; } = "Thanh toan hoa don";
            public string PaymentCurrency { get; set; } = "VND";
            public string PaymentRefId { get; set; } = "ORD0001";
            public decimal RequiredAmount { get; set; }
            public DateTime PaymentDate { get; set; } = DateTime.Now;
            public DateTime ExpireDate { get; set; } = DateTime.Now.AddMinutes(30);
            public string PaymentLanguage { get; set; } = "vn";
            public string MerchantId { get; set; } = "MER0001";
            public string Signature { get; set; } = "EP";
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
            catch (Exception)
            {

            }
            return userId;
        }

        [HttpGet("getTodayRevenue")]
        public async Task<ActionResult> getTodayRevenue()
        {
            var today = DateTime.Today;
            var todaySale = GetTotalAmountForDay(today);
            return new JsonResult(new
            {
                EC = 0,
                EM = "Doanh thu hôm nay",
                DT = todaySale
            });
        }

        [HttpGet("getOverallRevenue")]
        public async Task<ActionResult> getOverallRevenue()
        {
            try
            {
                var sum = await _context.Transactions
                .Where(t => t.FundAfter > t.FundBefore)
                .SumAsync(t => t.Amount) * 1000;
                return _msgService.MsgReturn(0, "Danh thu tổng", sum);
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }

        }

        [HttpGet("getRevenue")]
        public async Task<ActionResult> GetWeekRevenue()
        {
            var today = DateTime.Today;


            var Labels = new[]
               {
                today.AddDays(-6).ToString("dd/MM"),
                today.AddDays(-5).ToString("dd/MM"),
                today.AddDays(-4).ToString("dd/MM"),
                today.AddDays(-3).ToString("dd/MM"),
                today.AddDays(-2).ToString("dd/MM"),
                today.AddDays(-1).ToString("dd/MM"),
                today.ToString("dd/MM")
                };
            var Data = new[]
                {
                GetTotalAmountForDay(today.AddDays(-6)),
                GetTotalAmountForDay(today.AddDays(-5)),
                GetTotalAmountForDay(today.AddDays(-4)),
                GetTotalAmountForDay(today.AddDays(-3)),
                GetTotalAmountForDay(today.AddDays(-2)),
                GetTotalAmountForDay(today.AddDays(-1)),
                GetTotalAmountForDay(today)
                };


            return new JsonResult(new
            {
                EC = 0,
                EM = "Doanh thu trong 7 ngày",
                DT = new { labels = Labels, data = Data }
            });
        }

        private decimal GetTotalAmountForDay(DateTime date)
        {
            var startOfDay = date.Date;
            var endOfDay = date.Date.AddDays(1).AddTicks(-1);

            return _context.Transactions
                .Where(t => t.TransactionTime >= startOfDay && t.TransactionTime <= endOfDay && t.FundAfter > t.FundBefore)
                .Sum(t => t.Amount) * 1000;
        }

        [HttpGet("wallet")]
        public async Task<ActionResult> GetUserWallet()
        {
            try
            {
                int userId = GetUserId();
                if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
                var wallet = await _context.Wallets.Where(w => w.UserId == userId)
                    .Include(w => w.Transactions)
                    .Select(w => new
                    {
                        WalletId = w.WalletId,
                        UserId = w.UserId,
                        Fund = w.Fund,
                        Refund = w.Refund,
                        amount_received = _context.Transactions.Where(t => t.WalletId == w.WalletId && t.RefundAfter > t.RefundBefore).Sum(t => t.Amount),
                        amount_spent = _context.Transactions.Where(t => t.WalletId == w.WalletId && t.FundAfter < t.FundBefore).Sum(t => t.Amount),
                        amount_top_up = _context.Transactions.Where(t => t.WalletId == w.WalletId && t.FundAfter > t.FundBefore).Sum(t => t.Amount),
                        amount_withdrawn = _context.Transactions.Where(t => t.WalletId == w.WalletId && t.RefundAfter < t.RefundBefore).Sum(t => t.Amount)
                    })
                    .FirstOrDefaultAsync();
                return _msgService.MsgReturn(0, "Ví người dùng", wallet);
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
        }

        [HttpPost("purchase_story")]
        public async Task<ActionResult> AddTransactionBuyStory(int storyId)
        {
            try
            {
                int userId = GetUserId();
                if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
                var user = await _context.Users.Where(u => u.UserId == userId).FirstOrDefaultAsync();
                var story = await _context.Stories.Where(s => s.StoryId == storyId).FirstOrDefaultAsync();
                var user_wallet = await _context.Wallets.Where(w => w.UserId == userId).FirstOrDefaultAsync();
                var author_wallet = await _context.Wallets.Where(w => w.UserId == story.AuthorId).FirstOrDefaultAsync();
                var user_story = await _context.Users.Where(u => u.UserId == userId)
                    .Include(u => u.StoriesNavigation)
                    .Select(u => new
                    {
                        StoriesNavigation = u.StoriesNavigation
                    })
                    .FirstOrDefaultAsync();
                var chapter_story = await _context.Chapters.Where(ch => ch.StoryId == storyId).ToListAsync();
                if (user_wallet.Fund < story.StoryPrice)
                    return _msgService.MsgActionReturn(-2, NotEnoughMoney);

                if (userId == story.AuthorId || user_story.StoriesNavigation.Contains(story))
                    return _msgService.MsgActionReturn(-3, ErrorAuthorMessage);

                var user_chapter = await _context.Users.Where(u => u.UserId == userId)
                  .Include(u => u.Chapters)
                  .Select(u => new
                  {
                      Chapter = u.Chapters.Where(ch => ch.StoryId == storyId)
                  })
                  .FirstOrDefaultAsync();

                var chapter_remain = chapter_story.Except(user_chapter.Chapter);
                if (chapter_remain.Count() == 0)
                    return _msgService.MsgActionReturn(-1, "Bạn đã sở hữu hết các chương của truyện này");

                decimal amount = (decimal)(story.StoryPrice - (story.StoryPrice * story.StorySale / 100));

                var user_transaction = new Transaction
                {
                    WalletId = user_wallet.WalletId,
                    Amount = amount,
                    StoryId = story.StoryId,
                    FundBefore = user_wallet.Fund,
                    FundAfter = user_wallet.Fund - amount,
                    RefundAfter = 0,
                    RefundBefore = 0,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = BuyStory(story.StoryTitle)
                };

                var author_transaction = new Transaction
                {
                    WalletId = author_wallet.WalletId,
                    Amount = amount,
                    StoryId = story.StoryId,
                    FundBefore = 0,
                    FundAfter = 0,
                    RefundBefore = author_wallet.Refund,
                    RefundAfter = author_wallet.Refund + amount,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = RecieveMoney(story.StoryTitle)
                };

                foreach (var chapter in chapter_remain)
                {
                    user.Chapters.Add(chapter);
                    chapter.Users.Add(user);
                    _context.Entry<Chapter>(chapter).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                }

                user_wallet.Fund = user_wallet.Fund - amount;
                author_wallet.Refund = author_wallet.Refund + amount;

                user.StoriesNavigation.Add(story);
                story.Users.Add(user);

                _context.Entry<Wallet>(user_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<Wallet>(author_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<User>(user).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<Story>(story).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Transactions.Add(author_transaction);
                _context.Transactions.Add(user_transaction);
                _context.SaveChangesAsync();

                return _msgService.MsgActionReturn(0, BuyStory(story.StoryTitle) + " thành công");
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
        }

        [HttpPost("purchase_chapter")]
        public async Task<ActionResult> AddTransactionBuyChapter(int chapterId)
        {
            try
            {
                int userId = GetUserId();
                if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
                var user = await _context.Users.Where(u => u.UserId == userId).FirstOrDefaultAsync();
                var chapter = await _context.Chapters.Where(ch => ch.ChapterId == chapterId).FirstOrDefaultAsync();
                var story = await _context.Stories.Where(s => s.StoryId == chapter.StoryId).FirstOrDefaultAsync();
                var user_wallet = await _context.Wallets.Where(w => w.UserId == userId).FirstOrDefaultAsync();
                var author_wallet = await _context.Wallets.Where(w => w.UserId == story.AuthorId).FirstOrDefaultAsync();
                var user_chapter = await _context.Users.Where(u => u.UserId == userId)
                    .Include(u => u.Chapters)
                    .Select(u => new
                    {
                        Chapter = u.Chapters
                    })
                    .FirstOrDefaultAsync();

                if (user_wallet.Fund < chapter.ChapterPrice)
                    return _msgService.MsgActionReturn(-2, NotEnoughMoney);

                if (userId == story.AuthorId || user_chapter.Chapter.Contains(chapter))
                    return _msgService.MsgActionReturn(-3, ErrorAuthorMessage);

                var user_transaction = new Transaction
                {
                    WalletId = user_wallet.WalletId,
                    Amount = (decimal)chapter.ChapterPrice,
                    StoryId = story.StoryId,
                    ChapterId = chapter.ChapterId,
                    FundBefore = user_wallet.Fund,
                    FundAfter = user_wallet.Fund - (decimal)chapter.ChapterPrice,
                    RefundAfter = 0,
                    RefundBefore = 0,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = BuyChapter(chapter.ChapterNumber, story.StoryTitle)
                };
                var author_transaction = new Transaction
                {
                    WalletId = author_wallet.WalletId,
                    Amount = (decimal)chapter.ChapterPrice,
                    StoryId = story.StoryId,
                    ChapterId = chapter.ChapterId,
                    FundBefore = 0,
                    FundAfter = 0,
                    RefundAfter = author_wallet.Refund + (decimal)chapter.ChapterPrice,
                    RefundBefore = author_wallet.Refund,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = RecieveMoney(story.StoryTitle)
                };

                user_wallet.Fund = user_wallet.Fund - (decimal)chapter.ChapterPrice;
                author_wallet.Refund = author_wallet.Refund + (decimal)chapter.ChapterPrice;
                user.Chapters.Add(chapter);
                chapter.Users.Add(user);

                _context.Entry<Wallet>(user_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<Wallet>(author_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<User>(user).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<Chapter>(chapter).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Transactions.Add(author_transaction);
                _context.Transactions.Add(user_transaction);
                await _context.SaveChangesAsync();
                return _msgService.MsgActionReturn(0, $"Buy chapter {chapter.ChapterNumber} {chapter.ChapterTitle} in story {story.StoryTitle} successful");
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
        }

        [HttpPost("purchase_many_chapters")]
        public async Task<ActionResult> AddTransactionBuyManyChapters(int chapterStart, int chapterEnd, int storyId)
        {
            try
            {
                int userId = GetUserId();
                if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
                var user = await _context.Users.Where(u => u.UserId == userId).FirstOrDefaultAsync();
                if (chapterStart > chapterEnd)
                    return _msgService.MsgActionReturn(-3, "Chương bắt đầu cần lớn hơn chương cuối bạn muốn mua");

                var chapter_total = await _context.Chapters.Where(ch => ch.ChapterNumber >= chapterStart && ch.ChapterNumber <= chapterEnd && ch.StoryId == storyId).ToListAsync();

                if (!_context.Chapters.Any(ch => ch.StoryId == storyId && ch.ChapterNumber == chapterEnd))
                    return _msgService.MsgActionReturn(-3, "Chương bạn mua chưa có");

                var user_chapter = await _context.Users.Where(u => u.UserId == userId)
                     .Include(u => u.Chapters)
                     .Select(u => new
                     {
                         Chapter = u.Chapters.Where(ch => ch.StoryId == storyId)
                     })
                     .FirstOrDefaultAsync();
                var chapter_buy = chapter_total.Except(user_chapter.Chapter);
                if (chapter_buy.Count() == 0)
                    return _msgService.MsgActionReturn(-3, "Bạn đã mua hết các chương bạn muốn mua");

                decimal Amount = (decimal)chapter_buy.Select(c => c.ChapterPrice).Sum();

                var story = await _context.Stories.Where(s => s.StoryId == storyId).FirstOrDefaultAsync();
                var user_wallet = await _context.Wallets.Where(w => w.UserId == userId).FirstOrDefaultAsync();
                var author_wallet = await _context.Wallets.Where(w => w.UserId == story.AuthorId).FirstOrDefaultAsync();
                var user_story = await _context.Users.Where(u => u.UserId == userId)
                     .Include(u => u.StoriesNavigation)
                     .Select(u => new
                     {
                         StoriesNavigation = u.StoriesNavigation
                     })
                     .FirstOrDefaultAsync();
                if (user_wallet.Fund < Amount)
                    return _msgService.MsgActionReturn(-2, NotEnoughMoney);

                if (userId == story.AuthorId || user_story.StoriesNavigation.Contains(story))
                    return _msgService.MsgActionReturn(-3, ErrorAuthorMessage);


                user_wallet.Fund = user_wallet.Fund - Amount;
                author_wallet.Refund = author_wallet.Refund + Amount;



                foreach (var chapter in chapter_buy)
                {
                    user.Chapters.Add(chapter);
                    chapter.Users.Add(user);
                    _context.Entry<Chapter>(chapter).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                }
                var user_transaction = new Transaction
                {
                    WalletId = user_wallet.WalletId,
                    Amount = Amount,
                    StoryId = story.StoryId,
                    ChapterId = null,
                    FundBefore = user_wallet.Fund,
                    FundAfter = user_wallet.Fund - Amount,
                    RefundAfter = 0,
                    RefundBefore = 0,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = BuyManyChapter(chapter_buy.Count(), story.StoryTitle)
                };
                var author_transaction = new Transaction
                {
                    WalletId = author_wallet.WalletId,
                    Amount = Amount,
                    StoryId = story.StoryId,
                    ChapterId = null,
                    FundBefore = 0,
                    FundAfter = 0,
                    RefundBefore = author_wallet.Refund,
                    RefundAfter = author_wallet.Refund + Amount,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = RecieveMoney(story.StoryTitle)
                };

                _context.Entry<Wallet>(user_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<Wallet>(author_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<User>(user).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Transactions.Add(author_transaction);
                _context.Transactions.Add(user_transaction);
                await _context.SaveChangesAsync();
                return _msgService.MsgReturn(0, "Bạn đã mua thành công", new
                {
                    chapter_buy = chapter_buy.Count(),
                    Amount = Amount,
                    fund = user_wallet.Fund,
                    user_chapter = user_chapter.Chapter.Count()
                });
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
        }

        [HttpGet("get_information_to_buy_chapters")]
        public async Task<ActionResult> GetInformationToBuyChapter(int storyId)
        {
            try
            {
                int userId = GetUserId();
                if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
                var user_chapter = await _context.Users.Where(u => u.UserId == userId)
                     .Include(u => u.Chapters)
                     .Select(u => new
                     {
                         Chapter = u.Chapters.Where(ch => ch.StoryId == storyId)
                     })
                     .FirstOrDefaultAsync();
                var chapter_story = await _context.Chapters.Where(ch => ch.StoryId == storyId).OrderByDescending(c => c.ChapterNumber).ToListAsync();
                return _msgService.MsgReturn(0, "Thông tin để mua chương", new
                {
                    chapter_story_max = chapter_story.FirstOrDefault().ChapterNumber,
                    user_chapter = user_chapter.Chapter.Count(),
                });
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
        }

        [HttpGet("get_transaction_buy_many_chapters")]
        public async Task<ActionResult> GetTransactionBuyManyChapters(int chapterStart, int chapterEnd, int storyId)
        {
            try
            {
                int userId = GetUserId();
                if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
                if (chapterStart > chapterEnd)
                    return _msgService.MsgActionReturn(-3, "Chương bắt đầu cần lớn hơn chương cuối bạn muốn mua");

                var chapter_total = await _context.Chapters.Where(ch => ch.ChapterNumber >= chapterStart && ch.ChapterNumber <= chapterEnd && ch.StoryId == storyId).ToListAsync();
                if (!_context.Chapters.Any(ch => ch.StoryId == storyId && ch.ChapterNumber == chapterEnd))
                    return _msgService.MsgActionReturn(-3, "Chương bạn mua chưa có");

                var user_chapter = await _context.Users.Where(u => u.UserId == userId)
                     .Include(u => u.Chapters)
                     .Select(u => new
                     {
                         Chapter = u.Chapters.Where(ch => ch.StoryId == storyId)
                     })
                     .FirstOrDefaultAsync();
                var chapter_buy = chapter_total.Except(user_chapter.Chapter);
                if (chapter_buy.Count() == 0)
                    return _msgService.MsgActionReturn(-3, "Bạn đã mua hết các chương bạn muốn mua");

                decimal Amount = (decimal)chapter_buy.Select(c => c.ChapterPrice).Sum();

                var user_wallet = await _context.Wallets.Where(w => w.UserId == userId).FirstOrDefaultAsync();

                return _msgService.MsgReturn(0, "Thông tin giao dịch mua nhiều chương", new
                {
                    number_chapter_buy = chapter_buy.Count(),
                    amount = Amount,
                    balance = user_wallet.Fund
                });
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
        }

        [HttpPost("top_up")]
        public async Task<ActionResult> AddTransactionTopUp(int amount)
        {
            try
            {
                int userId = GetUserId();
                if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
                var user = await _context.Users.Where(u => u.UserId == userId).FirstOrDefaultAsync();
                var user_wallet = await _context.Wallets.Where(w => w.UserId == user.UserId).FirstOrDefaultAsync();
                var user_transaction = new Transaction
                {
                    WalletId = user_wallet.WalletId,
                    Amount = amount,
                    FundBefore = user_wallet.Fund,
                    FundAfter = user_wallet.Fund + amount,
                    RefundBefore = 0,
                    RefundAfter = 0,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Nạp {amount}000 VND"
                };
                user_wallet.Fund = user_wallet.Fund + amount;

                var admin_wallet = await _context.Wallets.FirstOrDefaultAsync();
                var admin_transaction = new Transaction
                {
                    WalletId = admin_wallet.WalletId,
                    Amount = amount,
                    FundBefore = 0,
                    FundAfter = 0,
                    RefundBefore = admin_wallet.Refund,
                    RefundAfter = admin_wallet.Refund + amount,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Nạp {amount}000 VND vào hệ thống"
                };
                admin_wallet.Fund = admin_wallet.Fund + amount;

                _context.Entry<Wallet>(user_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<Wallet>(admin_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Transactions.Add(user_transaction);
                _context.Transactions.Add(admin_transaction);
                await _context.SaveChangesAsync();

                return _msgService.MsgReturn(0, $"Nạp {amount}000 VND thành  {amount} TLT : {user.UserFullname} thành công", new { amount });
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
        }

        [HttpGet("history")]
        public async Task<ActionResult> GetUserTransactionHistory(int page, int pageSize)
        {
            try
            {
                int userId = GetUserId();
                if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
                var transactions = await _context.Transactions
                .Where(c => c.Wallet.UserId == userId)
                .Include(t => t.Wallet)
                .Include(t => t.Story)
                .Include(t => t.Chapter)
                .Select(t => new
                {
                    TransactionId = t.TransactionId,
                    Amount = (int)t.Amount,
                    StoryTitile = t.Story.StoryTitle,
                    ChapterTitle = t.Chapter.ChapterTitle,
                    FundBefore = (int)t.FundBefore,
                    FundAfter = (int)t.FundAfter,
                    RefundAfter = (int)t.RefundAfter,
                    RefundBefore = (int)t.RefundBefore,
                    TransactionTime = t.TransactionTime,
                    Status = t.Status,
                    Description = t.Description
                })
                .OrderByDescending(c => c.TransactionId).ThenByDescending(c => c.TransactionTime)
                .ToListAsync();
                page = page == null ? 1 : page;
                pageSize = pageSize == null ? 10 : pageSize;
                return _msgService.MsgPagingReturn("User transaction history",
                    transactions.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, transactions.Count);
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
        }

        [HttpGet("user_story_transaction_history")]
        public async Task<ActionResult> GetUserStoryTransactionHistory(int page, int pageSize, int storyId)
        {
            try
            {
                int userId = GetUserId();
                if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
                var transactions = await _context.Transactions
                .Where(c => c.Wallet.UserId == userId && c.StoryId == storyId)
                 .Include(t => t.Story)
                .Include(t => t.Chapter)
                .Select(t => new
                {
                    TransactionId = t.TransactionId,
                    Amount = t.Amount,
                    StoryTitile = t.Story.StoryTitle,
                    ChapterTitle = t.Chapter.ChapterTitle,
                    FundBefore = t.FundBefore,
                    FundAfter = t.FundAfter,
                    RefundAfter = t.RefundAfter,
                    RefundBefore = t.RefundBefore,
                    TransactionTime = t.TransactionTime,
                    Status = t.Status,
                    Description = t.Description
                })
                .OrderByDescending(c => c.TransactionTime)
                .ToListAsync();
                pageSize = pageSize == null ? 10 : pageSize;
                return _msgService.MsgPagingReturn("User transaction history",
                    transactions.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, transactions.Count);
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
        }
        [HttpGet("get_transaction_top_up")]
        public async Task<ActionResult> GetTransactionTopUp(int page, int pageSize)
        {
            try
            {
                int userId = GetUserId();
                if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
                var transactions = await _context.Transactions
                .Where(c => c.Wallet.UserId == userId && c.Description.StartsWith("Nạp"))
                 .Include(t => t.Story)
                .Include(t => t.Chapter)
                .Select(t => new
                {
                    TransactionId = t.TransactionId,
                    Amount = t.Amount,
                    StoryTitile = t.Story.StoryTitle,
                    ChapterTitle = t.Chapter.ChapterTitle,
                    FundBefore = t.FundBefore,
                    FundAfter = t.FundAfter,
                    RefundAfter = t.RefundAfter,
                    RefundBefore = t.RefundBefore,
                    TransactionTime = t.TransactionTime,
                    Status = t.Status,
                    Description = t.Description
                })
                .OrderByDescending(c => c.TransactionTime)
                .ToListAsync();
                pageSize = pageSize == null ? 10 : pageSize;
                return _msgService.MsgPagingReturn("User transaction history",
                   transactions.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, transactions.Count);
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
        }

        [HttpGet("get_buy_transaction")]
        public async Task<ActionResult> GetBuyTransaction(int page, int pageSize)
        {
            try
            {
                int userId = GetUserId();
                if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");
                var transactions = await _context.Transactions
                .Where(c => c.Wallet.UserId == userId && c.Description.StartsWith("Mua"))
                .Include(t => t.Story)
                .Include(t => t.Chapter)
                .Select(t => new
                {
                    TransactionId = t.TransactionId,
                    Amount = t.Amount,
                    StoryTitile = t.Story.StoryTitle,
                    ChapterTitle = t.Chapter.ChapterTitle,
                    FundBefore = t.FundBefore,
                    FundAfter = t.FundAfter,
                    RefundAfter = t.RefundAfter,
                    RefundBefore = t.RefundBefore,
                    TransactionTime = t.TransactionTime,
                    Status = t.Status,
                    Description = t.Description
                })
                .OrderByDescending(c => c.TransactionTime)
                .ToListAsync();
                pageSize = pageSize == null ? 10 : pageSize;
                return _msgService.MsgPagingReturn("Lịch sử giao dịch",
                   transactions.Skip(pageSize * (page - 1)).Take(pageSize), page, pageSize, transactions.Count);
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
        }

        [HttpGet("admin_history")]
        public async Task<ActionResult> GetAdminTransactionHistory()
        {
            int userId = GetUserId();
            if (userId == 0) return _msgService.MsgActionReturn(-1, "Yêu cầu đăng nhập");

            var admin = _context.Users.Where(u => u.UserId == userId).FirstOrDefault();
            if (admin.RoleId != 1) return _msgService.MsgActionReturn(-1, "Không có quyền quản trị viên");

            var idList = await _context.Transactions.Include(c => c.Wallet).Select(t => new { TransactionId = t.TransactionId, UserId = t.Wallet.UserId, })
            .OrderByDescending(c => c.TransactionId).ToListAsync();

            var transactions = await _context.Transactions
            .Include(c => c.Wallet).Where(c => c.Wallet.UserId == 1)
            .OrderByDescending(c => c.TransactionId)
            .Select(t => new
            {
                Username = _context.Transactions
                    .OrderByDescending(prev => prev.TransactionId)
                    .Where(prev => prev.TransactionId < t.TransactionId)
                    .Select(prev => prev.Wallet.User.Username)
                    .FirstOrDefault(),
                TransactionId = t.TransactionId,
                Amount = t.Amount * 1000,
                RefundBefore = t.RefundBefore,
                RefundAfter = t.RefundAfter,
                TransactionTime = t.TransactionTime.ToString("yyyy-MM-dd HH:mm:ss"),
                Status = t.Status == true ? "Sucess" : "False",
                Description = t.Description
            })
            .ToListAsync();
            return _msgService.MsgReturn(0, "Tiền ra vào hệ thống", transactions);
        }

        [HttpGet("export")]
        public async Task<ActionResult> ExportOrdersToExcel(DateTime? fromDate, DateTime? toDate)
        {
            try
            {
                var transaction = await _context.Transactions.Where(o => (!fromDate.HasValue || o.TransactionTime >= fromDate) && (!toDate.HasValue || o.TransactionTime <= toDate))
                .Include(t => t.Story)
                .Include(t => t.Chapter)
                .Select(t => new
                {
                    TransactionId = t.TransactionId,
                    Amount = t.Amount,
                    StoryTitile = t.Story.StoryTitle,
                    ChapterTitle = t.Chapter.ChapterTitle,
                    FundBefore = t.FundBefore,
                    FundAfter = t.FundAfter,
                    RefundAfter = t.RefundAfter,
                    RefundBefore = t.RefundBefore,
                    TransactionTime = t.TransactionTime.ToString("dd/MM/yyyy"),
                    Status = t.Status,
                    Description = t.Description

                })
                .ToListAsync();

                var stream = new MemoryStream();

                using (var package = new ExcelPackage(stream))
                {
                    var worksheet = package.Workbook.Worksheets.Add("Transactions");

                    // Headers
                    worksheet.Cells[1, 1].Value = "TransactionId";
                    worksheet.Cells[1, 2].Value = "Amount";
                    worksheet.Cells[1, 3].Value = "StoryTitile";
                    worksheet.Cells[1, 4].Value = "ChapterTitle";
                    worksheet.Cells[1, 5].Value = "FundBefore";
                    worksheet.Cells[1, 6].Value = "FundAfter";
                    worksheet.Cells[1, 7].Value = "RefundAfter";
                    worksheet.Cells[1, 8].Value = "RefundBefore";
                    worksheet.Cells[1, 9].Value = "TransactionTime";
                    worksheet.Cells[1, 10].Value = "Status";
                    worksheet.Cells[1, 11].Value = "Description";

                    // Data
                    for (int i = 0; i < transaction.Count; i++)
                    {
                        worksheet.Cells[i + 2, 1].Value = transaction[i].TransactionId;
                        worksheet.Cells[i + 2, 2].Value = transaction[i].Amount;
                        worksheet.Cells[i + 2, 3].Value = transaction[i].StoryTitile;
                        worksheet.Cells[i + 2, 4].Value = transaction[i].ChapterTitle;
                        worksheet.Cells[i + 2, 5].Value = transaction[i].FundBefore;
                        worksheet.Cells[i + 2, 6].Value = transaction[i].FundAfter;
                        worksheet.Cells[i + 2, 7].Value = transaction[i].RefundAfter;
                        worksheet.Cells[i + 2, 8].Value = transaction[i].RefundBefore;
                        worksheet.Cells[i + 2, 9].Value = transaction[i].TransactionTime;
                        worksheet.Cells[i + 2, 10].Value = transaction[i].Status;
                        worksheet.Cells[i + 2, 11].Value = transaction[i].Description;
                    }
                    package.Save();
                }

                stream.Position = 0;
                return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "Transaction.xlsx");

            }
            catch (Exception ex)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Hệ thống xảy ra lỗi!"
                });
            }
        }


        [HttpPost("vnpay_request")]
        public IActionResult SendVNPayRequest([FromBody] PaymentRequestForm data)
        {
            string version = _configuration.GetSection("VNPayConfig:Version").Value;
            string tmnCode = _configuration.GetSection("VNPayConfig:TmnCode").Value;
            string hashSecret = _configuration.GetSection("VNPayConfig:HashSecret").Value;
            string paymentUrl = _configuration.GetSection("VNPayConfig:PaymentUrl").Value;
            string returnUrl = _configuration.GetSection("VNPayConfig:ReturnUrl").Value;

            var vnpayRequest = new VNPayRequest(version,
            tmnCode, data.PaymentDate, data.ExpireDate, _httpContextAccessor?.HttpContext?.Connection?.LocalIpAddress?.ToString() ?? string.Empty, data.RequiredAmount, data.PaymentCurrency ?? string.Empty,
                              "other", data.PaymentContent ?? string.Empty, returnUrl, DateTime.Now.Ticks.ToString());
            paymentUrl = vnpayRequest.GetLink(paymentUrl, hashSecret);
            return new JsonResult(new
            {
                EC = 0,
                EM = "Gửi request VNPay thành công",
                DT = new
                {
                    paymentUrl = paymentUrl
                }
            });
        }

        [HttpPost("momo_request")]
        public IActionResult SendMomoRequest([FromBody] PaymentRequestForm data)
        {
            string partnerCode = _configuration.GetSection("MomoConfig:PartnerCode").Value;
            string returnUrl = _configuration.GetSection("MomoConfig:ReturnUrl").Value;
            string ipnUrl = _configuration.GetSection("MomoConfig:IpnUrl").Value;
            string paymentUrl = _configuration.GetSection("MomoConfig:PaymentUrl").Value;
            string accessKey = _configuration.GetSection("MomoConfig:AccessKey").Value;
            string secretKey = _configuration.GetSection("MomoConfig:SecretKey").Value;

            var momoOneTimePayRequest = new MomoRequest(partnerCode, DateTime.Now.Ticks.ToString(), (long)data.RequiredAmount!, DateTime.Now.Ticks.ToString(),
                                 data.PaymentContent ?? string.Empty, returnUrl, ipnUrl, "captureWallet", string.Empty);
            momoOneTimePayRequest.MakeSignature(accessKey, secretKey);
            (bool createMomoLinkResult, string? createMessage) = momoOneTimePayRequest.GetLink(paymentUrl);
            if (createMomoLinkResult)
            {
                paymentUrl = createMessage;
            }
            else
            {
                return new JsonResult(new
                {
                    EC = 1,
                    EM = "Gửi request Momo không thành công"
                });
            }
            return new JsonResult(new
            {
                EC = 0,
                EM = "Gửi request Momo thành công",
                DT = new
                {
                    paymentUrl = paymentUrl
                }
            });
        }
    }
}
