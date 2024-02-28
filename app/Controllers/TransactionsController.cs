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
                    FundBefore = author_wallet.Fund,
                    FundAfter = author_wallet.Fund + story.StoryPrice,
                    RefundAfter = 0,
                    RefundBefore = 0,
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
                    FundBefore = author_wallet.Fund,
                    FundAfter = author_wallet.Fund + (decimal)chapter.ChapterPrice,
                    RefundAfter = 0,
                    RefundBefore = 0,
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
                    FundBefore = author_wallet.Fund,
                    FundAfter = author_wallet.Fund + story.StoryPrice,
                    RefundAfter = 0,
                    RefundBefore = 0,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Receive TLT from selling stories {story.StoryTitle}"
                };
                user_wallet.Fund = user_wallet.Fund - story.StoryPrice;
                author_wallet.Fund = author_wallet.Fund + story.StoryPrice;
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
                    FundBefore = author_wallet.Fund,
                    FundAfter = author_wallet.Fund + (decimal)chapter.ChapterPrice,
                    RefundAfter = 0,
                    RefundBefore = 0,
                    TransactionTime = DateTime.Now,
                    Status = true,
                    Description = $"Receive TLT from selling chapter {chapter.ChapterNumber} {chapter.ChapterTitle} in story {story.StoryTitle}"
                };
                user_wallet.Fund = user_wallet.Fund - (decimal)chapter.ChapterPrice;
                author_wallet.Fund = author_wallet.Fund + (decimal)chapter.ChapterPrice;
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
    }
}
