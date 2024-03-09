using app.Models;
using app.Service;
using app.Service.VNPayService;
using Azure.Core;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Drawing.Printing;
using System.IdentityModel.Tokens.Jwt;
using static app.Controllers.AuthController;

namespace app.Controllers
{
    [Route("api/vi/transaction")]
    [ApiController]
    public class TransactionsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public TransactionsController(EasyPublishingContext context, IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
        {
            _context = context;
            _configuration = configuration;
            _httpContextAccessor = httpContextAccessor;
        }

        public class VNPayRequestForm
        {
            public string PaymentContent { get; set; } = string.Empty;
            public string PaymentCurrency { get; set; } = string.Empty;
            public string PaymentRefId { get; set; } = string.Empty;
            public decimal? RequiredAmount { get; set; }
            public DateTime? PaymentDate { get; set; } = DateTime.Now;
            public DateTime? ExpireDate { get; set; } = DateTime.Now.AddMinutes(15);
            public string? PaymentLanguage { get; set; } = string.Empty;
            public string? MerchantId { get; set; } = string.Empty;
            public string? PaymentDestinationId { get; set; } = string.Empty;
            public string? Signature { get; set; } = string.Empty;
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

        [HttpGet("get_user_wallet")]
        public async Task<ActionResult> GetUserWallet()
        {
            var jwtSecurityToken = new JwtSecurityToken();
            try
            {
                jwtSecurityToken = VerifyToken();
                int userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
                var wallet = await _context.Wallets.Where(w => w.UserId == userId)
                    .Include(w=> w.Transactions)
                    .Select(w => new
                    {
                        WalletId= w.WalletId,
                        UserId = w.UserId,
                        Fund = w.Fund,
                        Refund = w.Refund,
                        Transaction = w.Transactions
                    })
                    .FirstOrDefaultAsync();
                return _msgService.MsgReturn(0, "Get Transaction Buy Story Detail", wallet);
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Not authenticated"
                });
            }
        }

        [HttpGet("transaction_buy_story")]
        public async  Task<ActionResult> GetTransactionBuyStory(int storyId)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            try
            {
                jwtSecurityToken = VerifyToken();
                int userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
                var user =await _context.Users.Where(u => u.UserId == userId).FirstOrDefaultAsync();
                var story = await _context.Stories.Where(s=>s.StoryId == storyId).FirstOrDefaultAsync();
                var author = await _context.Users.Where(a=>a.UserId == story.AuthorId).FirstOrDefaultAsync();
                var user_wallet = await _context.Wallets.Where(w=>w.UserId == userId).FirstOrDefaultAsync();
                var author_wallet = await _context.Wallets.Where(w => w.UserId == author.UserId).FirstOrDefaultAsync();
                var user_story = await _context.Users.Where(u => u.UserId == userId)
                    .Include(u => u.Chapters)
                    .Select(u => new
                    {
                        Stories = u.Stories
                    })
                    .FirstOrDefaultAsync();
               if (user_wallet.Fund < story.StoryPrice)
               {
                   return new JsonResult(new
                   {
                       EC = -2,
                       EM = "Your's Wallet not enoung pay this chapter!Please Recharge!"
                   });
               }
               if (userId == author.UserId || user_story.Stories.Contains(story))
               {
                   return new JsonResult(new
                   {
                       EC = -3,
                       EM = "This story is yours!"
                   });
               }
                var user_transaction = new Transaction
                {
                    WalletId = user_wallet.WalletId,
                    Amount = story.StoryPrice,
                    FundBefore = user_wallet.Fund,
                    FundAfter = user_wallet.Fund - story.StoryPrice,
                    RefundAfter = 0,
                    RefundBefore = 0,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Buy story {story.StoryTitle}"
                };
                var author_transaction = new Transaction
                {
                    WalletId = author_wallet.WalletId,
                    Amount = story.StoryPrice,
                    FundBefore = 0,
                    FundAfter = 0,
                    RefundAfter = author_wallet.Refund,
                    RefundBefore = author_wallet.Refund + story.StoryPrice,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Receive TLT from selling stories {story.StoryTitle}"
                };
                return _msgService.MsgReturn(0, "Get Transaction Buy Story Detail", user_transaction);
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Not authenticated"
                });
            }
        }

        [HttpGet("transaction_buy_chapter")]
        public async Task<ActionResult> GetTransactionBuyChapter(int chapterId)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            try
            {
                jwtSecurityToken = VerifyToken();
                int userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
                var user = await _context.Users.Where(u => u.UserId == userId).FirstOrDefaultAsync();
                var chapter = await _context.Chapters.Where(ch => ch.ChapterId == chapterId).FirstOrDefaultAsync();
                var story = await _context.Stories.Where(s => s.StoryId == chapter.StoryId).FirstOrDefaultAsync();
                var author = await _context.Users.Where(a => a.UserId == story.AuthorId).FirstOrDefaultAsync();
                var user_wallet = await _context.Wallets.Where(w => w.UserId == userId).FirstOrDefaultAsync();
                var author_wallet = await _context.Wallets.Where(w => w.UserId == author.UserId).FirstOrDefaultAsync();
                var user_chapter = await _context.Users.Where(u => u.UserId == userId)
                    .Include(u => u.Chapters)
                    .Select(u => new
                    {
                        Chapter = u.Chapters
                    })
                    .FirstOrDefaultAsync();
                if (user_wallet.Fund < story.StoryPrice)
                {
                    return new JsonResult(new
                    {
                        EC = -2,
                        EM = "Your's Wallet not enoung pay this chapter!Please Recharge!"
                    });
                }
                if (userId == author.UserId|| user_chapter.Chapter.Contains(chapter))
                {
                    return new JsonResult(new
                    {
                        EC = -3,
                        EM = "This story is yours!"
                    });
                }
                var user_transaction = new Transaction
                {
                    WalletId = user_wallet.WalletId,
                    Amount = (decimal)chapter.ChapterPrice,
                    FundBefore = user_wallet.Fund,
                    FundAfter = user_wallet.Fund - (decimal)chapter.ChapterPrice,
                    RefundAfter = 0,
                    RefundBefore = 0,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Buy chapter {chapter.ChapterNumber} {chapter.ChapterTitle} in story {story.StoryTitle}"
                };
                var author_transaction = new Transaction
                {
                    WalletId = author_wallet.WalletId,
                    Amount = (decimal)chapter.ChapterPrice,
                    FundBefore = 0,
                    FundAfter = 0,
                    RefundAfter = author_wallet.Refund,
                    RefundBefore = author_wallet.Refund + (decimal)chapter.ChapterPrice,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Receive TLT from selling chapter {chapter.ChapterNumber} {chapter.ChapterTitle} in story {story.StoryTitle}"
                };
              
                return _msgService.MsgReturn(0, "Get Transaction Buy Chapter Detail", user_transaction);
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Not authenticated"
                });
            }
        }
        [HttpPost("add_transaction_buy_story")]
        public async Task<ActionResult> AddTransactionBuyStory(int storyId)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            try
            {
                jwtSecurityToken = VerifyToken();
                int userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
                var user = await _context.Users.Where(u => u.UserId == userId).FirstOrDefaultAsync();
                var story = await _context.Stories.Where(s => s.StoryId == storyId).FirstOrDefaultAsync();
                var author = await _context.Users.Where(a => a.UserId == story.AuthorId).FirstOrDefaultAsync();
                var user_wallet = await _context.Wallets.Where(w => w.UserId == userId).FirstOrDefaultAsync();
                var author_wallet = await _context.Wallets.Where(w => w.UserId == author.UserId).FirstOrDefaultAsync();
                var user_story = await _context.Users.Where(u => u.UserId == userId)
                     .Include(u => u.Chapters)
                     .Select(u => new
                     {
                         Stories = u.Stories
                     })
                     .FirstOrDefaultAsync();
                if (user_wallet.Fund < story.StoryPrice)
                {
                    return new JsonResult(new
                    {
                        EC = -2,
                        EM = "Your's Wallet not enoung pay this chapter!Please Recharge!"
                    });
                }
                if (userId == author.UserId || user_story.Stories.Contains(story))
                {
                    return new JsonResult(new
                    {
                        EC = -3,
                        EM = "This story is yours!"
                    });
                }
                decimal amount = (decimal)(story.StoryPrice - (story.StoryPrice * story.StorySale / 100));

                var user_transaction = new Transaction
                {
                    WalletId = user_wallet.WalletId,
                    Amount = amount,
                    FundBefore = user_wallet.Fund,
                    FundAfter = user_wallet.Fund - amount,
                    RefundAfter = 0,
                    RefundBefore = 0,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Buy story {story.StoryTitle}"
                };
                
                var author_transaction = new Transaction
                {
                    WalletId = author_wallet.WalletId,
                    Amount = amount,
                    FundBefore = 0,
                    FundAfter = 0,
                    RefundAfter = author_wallet.Refund,
                    RefundBefore = author_wallet.Refund + amount,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Receive TLT from selling stories {story.StoryTitle}"
                };
                user_wallet.Fund = user_wallet.Fund - amount;
                author_wallet.Refund = author_wallet.Refund + amount;
                user.Stories.Add(story);
                story.Users.Add(user);

                _context.Entry<Wallet>(user_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<Wallet>(author_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<User>(user).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Entry<Story>(story).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Transactions.Add(author_transaction);
                _context.Transactions.Add(user_transaction);
                _context.SaveChangesAsync();
                return new JsonResult(new
                {
                    EC = 0,
                    EM = $"Buy Story {story.StoryTitle} successful"
                });
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Not authenticated"
                });
            }
        }

        [HttpPost("add_transaction_buy_chapter")]
        public async Task<ActionResult> AddTransactionBuyChapter(int chapterId)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            try
            {
                jwtSecurityToken = VerifyToken();
                int userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
                var user = await _context.Users.Where(u => u.UserId == userId).FirstOrDefaultAsync();
                var chapter = await _context.Chapters.Where(ch=>ch.ChapterId == chapterId).FirstOrDefaultAsync();
                var story = await _context.Stories.Where(s => s.StoryId == chapter.StoryId).FirstOrDefaultAsync();
                var author = await _context.Users.Where(a => a.UserId == story.AuthorId).FirstOrDefaultAsync();
                var user_wallet = await _context.Wallets.Where(w => w.UserId == userId).FirstOrDefaultAsync();
                var author_wallet = await _context.Wallets.Where(w => w.UserId == author.UserId).FirstOrDefaultAsync();
                var user_chapter = await _context.Users.Where(u => u.UserId == userId)
                    .Include(u => u.Chapters)
                    .Select(u => new
                    {
                        Chapter = u.Chapters
                    })
                    .FirstOrDefaultAsync();
                if (user_wallet.Fund < story.StoryPrice)
                {
                    return new JsonResult(new
                    {
                        EC = -2,
                        EM = "Your's Wallet not enoung pay this chapter!Please Recharge!"
                    });
                }
                if (userId == author.UserId || user_chapter.Chapter.Contains(chapter))
                {
                    return new JsonResult(new
                    {
                        EC = -3,
                        EM = "This story is yours!"
                    });
                }
                var user_transaction = new Transaction
                {
                    WalletId = user_wallet.WalletId,
                    Amount = (decimal)chapter.ChapterPrice,
                    FundBefore = user_wallet.Fund,
                    FundAfter = user_wallet.Fund - (decimal)chapter.ChapterPrice,
                    RefundAfter = 0,
                    RefundBefore = 0,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Buy chapter {chapter.ChapterNumber} {chapter.ChapterTitle} in story {story.StoryTitle}"
                };
                var author_transaction = new Transaction
                {
                    WalletId = author_wallet.WalletId,
                    Amount = (decimal)chapter.ChapterPrice,
                    FundBefore = 0,
                    FundAfter = 0,
                    RefundAfter = author_wallet.Refund,
                    RefundBefore = author_wallet.Refund + (decimal)chapter.ChapterPrice,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Receive TLT from selling chapter {chapter.ChapterNumber} {chapter.ChapterTitle} in story {story.StoryTitle}"
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
                return new JsonResult(new
                {
                    EC = 0,
                    EM = $"Buy chapter {chapter.ChapterNumber} {chapter.ChapterTitle} in story {story.StoryTitle} successful"
                });
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Not authenticated"
                });
            }
        }

         [HttpPost("add_transaction_recharge")]
        public async Task<ActionResult> AddTransactionRecharge(string username,int number_recharge)
        {
            try
            {
                var user = await _context.Users.Where(u => u.Username == username).FirstOrDefaultAsync();
                var user_wallet = await _context.Wallets.Where(w => w.UserId == user.UserId).FirstOrDefaultAsync();
                var user_transaction = new Transaction
                {
                    WalletId = user_wallet.WalletId,
                    Amount = number_recharge,
                    FundBefore = user_wallet.Fund,
                    FundAfter = user_wallet.Fund + number_recharge,
                    RefundAfter = 0,
                    RefundBefore = 0,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Recharge {number_recharge}"
                };
                user_wallet.Fund = user_wallet.Fund + number_recharge;
                _context.Entry<Wallet>(user_wallet).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
                _context.Transactions.Add(user_transaction);
                await _context.SaveChangesAsync();
                return new JsonResult(new
                {
                    EC = 0,
                    EM = $"Recharge {number_recharge} : {user.UserFullname} successfull"
                });
            }
            catch (Exception)
            {
                return new JsonResult(new
                {
                    EC = -1,
                    EM = "Recharge fail"
                });
            }
        }

        [HttpGet("transaction_history")]
        public async Task<ActionResult> GetUserTransactionHistory(int page, int pageSize)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            try
            {
                jwtSecurityToken = VerifyToken();
                int userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
                var transactions = await _context.Transactions
                .Where(c => c.Wallet.UserId == userId)
                .Select(c => new
                {
                    TransactionId = c.TransactionId,
                    Amount = c.Amount,
                    FundBefore = c.FundBefore,
                    FundAfter = c.FundAfter,
                    RefundBefore = c.RefundBefore,
                    RefundAfter = c.RefundAfter,
                    TransactionTime = c.TransactionTime,
                    Status = c.Status,
                    Description = c.Description,
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
                    EM = "Not authenticated"
                });
            }
        }
        [HttpGet("get_transaction_recharge")]
        public async Task<ActionResult> GetTransactionRecharge(int page, int pageSize)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            try
            {
                jwtSecurityToken = VerifyToken();
                int userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
                var transactions = await _context.Transactions
                .Where(c => c.Wallet.UserId == userId && c.Description.StartsWith("Recharge"))
                .Select(c => new
                {
                    TransactionId = c.TransactionId,
                    Amount = c.Amount,
                    FundBefore = c.FundBefore,
                    FundAfter = c.FundAfter,
                    RefundBefore = c.RefundBefore,
                    RefundAfter = c.RefundAfter,
                    TransactionTime = c.TransactionTime,
                    Status = c.Status,
                    Description = c.Description,
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
                    EM = "Not authenticated"
                });
            }
        }

        [HttpGet("get_buy_transaction")]
        public async Task<ActionResult> GetBuyTransaction(int page, int pageSize)
        {
            var jwtSecurityToken = new JwtSecurityToken();
            try
            {
                jwtSecurityToken = VerifyToken();
                int userId = Int32.Parse(jwtSecurityToken.Claims.First(c => c.Type == "userId").Value);
                var transactions = await _context.Transactions
                .Where(c => c.Wallet.UserId == userId && c.Description.StartsWith("Buy"))
                .Select(c => new
                {
                    TransactionId = c.TransactionId,
                    Amount = c.Amount,
                    FundBefore = c.FundBefore,
                    FundAfter = c.FundAfter,
                    RefundBefore = c.RefundBefore,
                    RefundAfter = c.RefundAfter,
                    TransactionTime = c.TransactionTime,
                    Status = c.Status,
                    Description = c.Description,
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
                    EM = "Not authenticated"
                });
            }
        }

        [HttpPost("vnpay_request")]
        public IActionResult SendVNPayRequest([FromBody] VNPayRequestForm data)
        {
            string version = _configuration.GetSection("VNPayConfig:Version").Value;
            string tmnCode = _configuration.GetSection("VNPayConfig:TmnCode").Value;
            string hashSecret = _configuration.GetSection("VNPayConfig:HashSecret").Value;
            string paymentUrl = _configuration.GetSection("VNPayConfig:PaymentUrl").Value;

            var vnpayRequest = new VNPayRequest(version,
            tmnCode, DateTime.Now, _httpContextAccessor?.HttpContext?.Connection?.LocalIpAddress?.ToString() ?? string.Empty, data.RequiredAmount ?? 0, data.PaymentCurrency ?? string.Empty,
                              "other", data.PaymentContent ?? string.Empty, "https://localhost:44393/PaymentConfirm", DateTime.Now.Ticks.ToString());
            paymentUrl = vnpayRequest.GetLink(paymentUrl, hashSecret);
            return new JsonResult(new
            {
                EC = 0,
                EM = "Send vnpay request successfully",
                DT = new
                {
                    paymentUrl = paymentUrl
                }
            });
        }
    }
}
