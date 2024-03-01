using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.IdentityModel.Tokens.Jwt;

namespace app.Controllers
{
    [Route("api/vi/transaction")]
    [ApiController]
    public class TransactionsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();

        public TransactionsController(EasyPublishingContext context)
        {
            _context = context;
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
                if (user_wallet.Fund < story.StoryPrice)
                {
                    return new JsonResult(new
                    {
                        EC = -2,
                        EM = "Your's Wallet not enoung pay this chapter!Please Recharge!"
                    });
                }
                if (userId == author.UserId)
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
                if (user_wallet.Fund < story.StoryPrice)
                {
                    return new JsonResult(new
                    {
                        EC = -2,
                        EM = "Your's Wallet not enoung pay this chapter!Please Recharge!"
                    });
                }
                if (userId == author.UserId)
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
                if (user_wallet.Fund < story.StoryPrice)
                {
                    return new JsonResult(new
                    {
                        EC = -2,
                        EM = "Your's Wallet not enoung pay this chapter!Please Recharge!"
                    });
                }
                if (userId == author.UserId)
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
                user_wallet.Fund = user_wallet.Fund - story.StoryPrice;
                author_wallet.Refund = author_wallet.Refund + story.StoryPrice;
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
                if (user_wallet.Fund < story.StoryPrice)
                {
                    return new JsonResult(new
                    {
                        EC = -2,
                        EM = "Your's Wallet not enoung pay this chapter!Please Recharge!"
                    });
                }
                if (userId == author.UserId)
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
                _context.SaveChangesAsync();
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
    }
}
