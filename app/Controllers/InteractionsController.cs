using app.Models;
using app.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Drawing.Printing;
using System.IdentityModel.Tokens.Jwt;

namespace app.Controllers
{
    [Route("api/v1/interaction")]
    [ApiController]
    public class InteractionsController : ControllerBase
    {
        private readonly EasyPublishingContext _context;
        private MsgService _msgService = new MsgService();

        public InteractionsController(EasyPublishingContext context)
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

        [HttpPut("story_like")]
        public async Task<ActionResult> LikeStory(int storyId)
        {
            int userId = GetUserId();

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Đăng nhập trước");

            var interaction = await _context.StoryFollowLikes.FirstOrDefaultAsync(c => c.StoryId == storyId && c.UserId == userId);
            var story_interaction = await _context.StoryInteractions.FirstOrDefaultAsync(c => c.StoryId == storyId);

            if (interaction != null)
            {
                story_interaction.Like = interaction.Like == true ? story_interaction.Like - 1 : story_interaction.Like + 1;
                interaction.Like = !interaction.Like;
                _context.Entry(interaction).State = EntityState.Modified;

            }
            else
            {
                story_interaction.Like += 1;
                StoryFollowLike storyFollowLike = new StoryFollowLike { UserId = userId, StoryId = storyId, Follow = false, Like = true };
                _context.StoryFollowLikes.Add(storyFollowLike);

            }

            _context.Entry(story_interaction).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return _msgService.MsgActionReturn(0, "Bạn đã thích truyện");
        }


        [HttpPut("story_follow")]
        public async Task<ActionResult> FollowStory(int storyId)
        {
            int userId = GetUserId();

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Đăng nhập trước");

            var interaction = await _context.StoryFollowLikes.FirstOrDefaultAsync(c => c.StoryId == storyId && c.UserId == userId);
            var story_interaction = await _context.StoryInteractions.FirstOrDefaultAsync(c => c.StoryId == storyId);

            if (interaction != null)
            {
                story_interaction.Follow = interaction.Follow == true ? story_interaction.Follow - 1 : story_interaction.Follow + 1;
                interaction.Follow = !interaction.Follow;
                _context.Entry(interaction).State = EntityState.Modified;
            }
            else
            {
                story_interaction.Follow += 1;
                StoryFollowLike storyFollowLike = new StoryFollowLike { UserId = userId, StoryId = storyId, Follow = true, Like = false };
                _context.StoryFollowLikes.Add(storyFollowLike);
            }
            _context.Entry(story_interaction).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return _msgService.MsgActionReturn(0, "Bạn đã theo dõi truyện");
        }

        [HttpPut("chapter_like")]
        public async Task<ActionResult> LikeChapter(int storyId, int chapterNum)
        {
            int userId = GetUserId();

            if (userId == 0) return _msgService.MsgActionReturn(-1, "Đăng nhập trước");
            var chapter = await _context.Chapters.FirstOrDefaultAsync(c => c.StoryId == storyId && c.ChapterNumber == chapterNum);
            var interaction = await _context.ChapterLikeds.FirstOrDefaultAsync(c => c.ChapterId == chapter.ChapterId && c.UserId == userId);
            var story_interaction = await _context.StoryInteractions.FirstOrDefaultAsync(c => c.StoryId == storyId);

            if (interaction != null)
            {
                story_interaction.Like -= 1;
                _context.ChapterLikeds.Remove(interaction);
            }
            else
            {
                story_interaction.Like += 1;
                ChapterLiked chapterLiked = new ChapterLiked { UserId = userId, ChapterId = chapter.ChapterId, Status = null };
                _context.ChapterLikeds.Add(chapterLiked);
            }

            _context.Entry(story_interaction).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return _msgService.MsgActionReturn(0, "Bạn đã thích chương");
        }

        [HttpGet("author_manage/story")]
        public async Task<ActionResult> GetStoryData(int storyId)
        {

            var interaction = await _context.Stories.Where(c => c.StoryId == storyId)
               .Include(c => c.Users).Include(c => c.StoryInteraction)
               .Include(c => c.Chapters).ThenInclude(c => c.Users).ThenInclude(c => c.Comments).ThenInclude(c => c.ReportContents)
               .Include(c => c.Comments)
               .Include(c => c.ReportContents)
               .Select(s => new
               {
                   s.StoryId,
                   s.StoryTitle,
                   s.StoryInteraction.Like,
                   s.StoryInteraction.Follow,
                   s.StoryInteraction.View,
                   s.StoryInteraction.Read,
                   PurchaseStory = s.Users.Count,
                   PurchaseChapter = s.Chapters.SelectMany(c => c.Users).Count(),
                   CommentStory = s.Comments.Count,
                   CommentChapter = s.Chapters.SelectMany(c => c.Comments).Count(),
                   ReportStory = s.ReportContents.Count,
                   ReportChapter = s.Chapters.SelectMany(c => c.ReportContents).Count(),
               }).ToListAsync();

            return _msgService.MsgReturn(0, "Truyện của tác giả", interaction.FirstOrDefault());
        }

        [HttpGet("author_manage/chapter")]
        public async Task<ActionResult> GetStoryChaptersData(int storyId, int from, int to)
        {

            var interaction = await _context.Chapters.Where(c => c.StoryId == storyId)
               .OrderBy(c => c.ChapterId)
               .Include(c => c.Users)
               .Include(c => c.Comments)
               .Include(c => c.ReportContents)
               .Select(s => new
               {
                   s.ChapterId,
                   s.ChapterNumber,
                   s.ChapterTitle,
                   PurchaseChapter = s.Users.Count,
                   CommentChapter = s.Comments.Count,
                   ReportChapter = s.ReportContents.Count,
               }).ToListAsync();
            if (interaction.Count < 1) return _msgService.MsgReturn(-1, "Truyện chưa có chương", new { interaction });
            if (interaction.Count == 1) return _msgService.MsgReturn(0, "Truyện có 1 chương", new { interaction });
            var min = interaction.First().ChapterNumber;
            var max = interaction.Last().ChapterNumber;
            if (from != null && to != null && from < to) interaction = interaction.Where(c => c.ChapterNumber >= from && c.ChapterNumber <= to).ToList();

            return _msgService.MsgReturn(0, "Truyện của tác giả", new { interaction, min, max });
        }

    }
}
